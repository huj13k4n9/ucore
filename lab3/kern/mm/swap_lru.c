#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_lru.h>
#include <list.h>

/* 
 * [wikipedia]The least recently used (LRU) page replacement algorithm, though similar
 * in name to NRU, differs in the fact that LRU keeps track of page usage over a short 
 * period of time, while NRU just looks at the usage in the last clock interval. LRU 
 * works on the idea that pages that have been most heavily used in the past few instructions 
 * are most likely to be used heavily in the next few instructions too. While LRU can 
 * provide near-optimal performance in theory (almost as good as adaptive replacement cache), 
 * it is rather expensive to implement in practice. There are a few implementation methods 
 * for this algorithm that try to reduce the cost yet keep as much of the performance as possible.
 * 
 * The most expensive method is the linked list method, which uses a linked list 
 * containing all the pages in memory. At the back of this list is the least recently 
 * used page, and at the front is the most recently used page. The cost of this implementation 
 * lies in the fact that items in the list will have to be moved about every memory 
 * reference, which is a very time-consuming process.
 * 
 * Another method that requires hardware support is as follows: suppose the hardware has 
 * a 64-bit counter that is incremented at every instruction. Whenever a page is accessed, 
 * it acquires the value equal to the counter at the time of page access. Whenever a page 
 * needs to be replaced, the operating system selects the page with the lowest counter 
 * and swaps it out.
 * 
 * Because of implementation costs, one may consider algorithms (like those that follow) 
 * that are similar to LRU, but which offer cheaper implementations.
 * 
 * One important advantage of the LRU algorithm is that it is amenable to full 
 * statistical analysis. It has been proven, for example, that LRU can never result 
 * in more than N-times more page faults than OPT algorithm, where N is proportional 
 * to the number of pages in the managed pool.
 */

/* Not Implemented */

list_entry_t pra_list_head;

static void output_pra_list(const char *str) {
    list_entry_t *tmp = &pra_list_head;
    cprintf("%s: head ", str);
    while ((tmp = list_next(tmp)) != &pra_list_head) {
        struct Page *p = le2page(tmp, pra_page_link);
        cprintf("-> 0x%x ", p->pra_vaddr);
    }
    cprintf("\n");
}


static int
_lru_init_mm(struct mm_struct *mm)
{     
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
    return 0;
}


static int
_lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    list_add_after(head, entry);
    return 0;
}


static int
_lru_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
    assert(head->next != head);
    struct Page *p = le2page(list_prev(head), pra_page_link);
    *ptr_page = p;
    list_del(list_prev(head));
    return 0;
}

static int
_lru_check_swap(void) {
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
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}


static int
_lru_init(void)
{
    return 0;
}

static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_lru_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_lru =
{
    .name            = "LRU Swap Manager",
    .init            = &_lru_init,
    .init_mm         = &_lru_init_mm,
    .tick_event      = &_lru_tick_event,
    .map_swappable   = &_lru_map_swappable,
    .set_unswappable = &_lru_set_unswappable,
    .swap_out_victim = &_lru_swap_out_victim,
    .check_swap      = &_lru_check_swap,
};
