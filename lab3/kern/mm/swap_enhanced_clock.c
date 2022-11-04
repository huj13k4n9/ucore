#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_enhanced_clock.h>
#include <list.h>

/* [wikipedia]The not recently used (NRU) page replacement algorithm is an algorithm that
 * favours keeping pages in memory that have been recently used. This algorithm works on
 * the following principle: when a page is referenced, a referenced bit is set for that page,
 * marking it as referenced. Similarly, when a page is modified (written to), a modified
 * bit is set. The setting of the bits is usually done by the hardware, although it is
 * possible to do so on the software level as well.
 * 
 * At a certain fixed time interval, a timer interrupt triggers and clears the referenced
 * bit of all the pages, so only pages referenced within the current timer interval are
 * marked with a referenced bit. When a page needs to be replaced, the operating system
 * divides the pages into four classes:
 * 
 *   [3] referenced, modified
 *   [2] referenced, not modified
 *   [1] not referenced, modified
 *   [0] not referenced, not modified
 */

list_entry_t pra_list_head, *ptr;

static void output_pra_list(struct mm_struct *mm, const char *str) {
    list_entry_t *tmp = &pra_list_head;
    cprintf("%s: head ", str);
    while ((tmp = list_next(tmp)) != &pra_list_head) {
        struct Page *p = le2page(tmp, pra_page_link);
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
        cprintf("-> 0x%x(%c%c) ", p->pra_vaddr, (*ptep & PTE_A)?'U':'-', (*ptep & PTE_D)?'D':'-');
    }
    cprintf(", ptr: 0x%x\n", le2page(ptr, pra_page_link)->pra_vaddr);
}


static int
_enhanced_clock_init_mm(struct mm_struct *mm)
{     
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
    // Also init the pointer
    ptr = &pra_list_head;
    return 0;
}


static int
_enhanced_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);

    assert(entry != NULL && head != NULL);

    // Append to the tail of pointer
    list_add_after(ptr, entry);
    // And then move the pointer forward
    ptr = entry;
    return 0;
}


static int
_enhanced_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *tmp = ptr;
    struct Page *p;
    assert(head != NULL && ptr != NULL);
    assert(in_tick==0);
    assert(head->next != head);

    // First loop, check the Accessed Bit (whether the page is used)
    while (1) {
        tmp = list_next(tmp);
        if (tmp == &pra_list_head) continue; // Need to skip the head node
        p = le2page(tmp, pra_page_link);
        // Check page attr
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
        if (*ptep & PTE_A) { // If accessed, clear it.
            *ptep &= ~PTE_A;
            tlb_invalidate(mm->pgdir, p->pra_vaddr);
            continue;
        }
        // We got the best fit page!
        if (!(*ptep & PTE_A) && !(*ptep & PTE_D)) {
            goto ok;
        }
        if (tmp == ptr) break; // Need this to also traverse ptr itself
    }

    // Second loop, check the Dirty Bit (whether the page is modified)
    while (1) {
        tmp = list_next(tmp);
        if (tmp == &pra_list_head) continue;
        p = le2page(tmp, pra_page_link);
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
        if (*ptep & PTE_D) { // If modified, clear it.
            *ptep &= ~PTE_D;
            tlb_invalidate(mm->pgdir, p->pra_vaddr);
            continue;
        }
        if (!(*ptep & PTE_A) && !(*ptep & PTE_D)) {
            goto ok;
        }
        if (tmp == ptr) break;
    }

    // The worst situation... (all pages are both used and modified)
    // Just use next node of ptr
    if (list_next(ptr) == &pra_list_head) {  // Needs to take care of head node yet
        p = le2page(list_next(&pra_list_head), pra_page_link);
        tmp = list_next(&pra_list_head);
    } else {
        p = le2page(list_next(ptr), pra_page_link);
        tmp = list_next(ptr);
    }
    
ok: // Delete the victim page from linklist and reset ptr location.
    *ptr_page = p;
    ptr = list_prev(tmp);
    list_del(tmp);
    return 0;
}

static int
_enhanced_clock_check_swap(void) {
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==6);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==7);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==8);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==9);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==9);
    return 0;
}


static int
_enhanced_clock_init(void)
{
    return 0;
}

static int
_enhanced_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_enhanced_clock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_enhanced_clock =
{
    .name            = "Enhanced Clock Swap Manager",
    .init            = &_enhanced_clock_init,
    .init_mm         = &_enhanced_clock_init_mm,
    .tick_event      = &_enhanced_clock_tick_event,
    .map_swappable   = &_enhanced_clock_map_swappable,
    .set_unswappable = &_enhanced_clock_set_unswappable,
    .swap_out_victim = &_enhanced_clock_swap_out_victim,
    .check_swap      = &_enhanced_clock_check_swap,
};
