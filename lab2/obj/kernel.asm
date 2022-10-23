
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 11 00 	lgdtl  0x11a018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba c4 b9 11 c0       	mov    $0xc011b9c4,%edx
c0100035:	b8 36 aa 11 c0       	mov    $0xc011aa36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 aa 11 c0 	movl   $0xc011aa36,(%esp)
c0100051:	e8 3c 71 00 00       	call   c0107192 <memset>

    cons_init();                // init the console
c0100056:	e8 7a 15 00 00       	call   c01015d5 <cons_init>

    const char *message = "(LITANG.DINGZHEN) OS is loading ...";
c010005b:	c7 45 f4 20 73 10 c0 	movl   $0xc0107320,-0xc(%ebp)
    cprintf("\n%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 44 73 10 c0 	movl   $0xc0107344,(%esp)
c0100070:	e8 ce 02 00 00       	call   c0100343 <cprintf>

    print_kerninfo();
c0100075:	e8 fd 07 00 00       	call   c0100877 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 20 56 00 00       	call   c01056a4 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b5 16 00 00       	call   c010173e <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 07 18 00 00       	call   c0101895 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f8 0c 00 00       	call   c0100d8b <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 14 16 00 00       	call   c01016ac <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 01 0c 00 00       	call   c0100cbd <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 4a 73 10 c0 	movl   $0xc010734a,(%esp)
c010015c:	e8 e2 01 00 00       	call   c0100343 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 58 73 10 c0 	movl   $0xc0107358,(%esp)
c010017c:	e8 c2 01 00 00       	call   c0100343 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 66 73 10 c0 	movl   $0xc0107366,(%esp)
c010019c:	e8 a2 01 00 00       	call   c0100343 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 74 73 10 c0 	movl   $0xc0107374,(%esp)
c01001bc:	e8 82 01 00 00       	call   c0100343 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 82 73 10 c0 	movl   $0xc0107382,(%esp)
c01001dc:	e8 62 01 00 00       	call   c0100343 <cprintf>
    round ++;
c01001e1:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 aa 11 c0       	mov    %eax,0xc011aa40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    asm volatile (
c01001f3:	cd 78                	int    $0x78
c01001f5:	89 ec                	mov    %ebp,%esp
        "int %0\n\t"
        "mov %%ebp, %%esp" :: "i"(T_SWITCH_TOU)
    );
}
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    asm volatile (
c01001fc:	cd 79                	int    $0x79
c01001fe:	5c                   	pop    %esp
        "int %0\n\t"
        "pop %%esp" :: "i"(T_SWITCH_TOK)
    );
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
c0100204:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100207:	e8 1e ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020c:	c7 04 24 90 73 10 c0 	movl   $0xc0107390,(%esp)
c0100213:	e8 2b 01 00 00       	call   c0100343 <cprintf>
    lab1_switch_to_user();
c0100218:	e8 d3 ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021d:	e8 08 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100222:	c7 04 24 b0 73 10 c0 	movl   $0xc01073b0,(%esp)
c0100229:	e8 15 01 00 00       	call   c0100343 <cprintf>
    lab1_switch_to_kernel();
c010022e:	e8 c6 ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100233:	e8 f2 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100238:	c9                   	leave  
c0100239:	c3                   	ret    

c010023a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023a:	55                   	push   %ebp
c010023b:	89 e5                	mov    %esp,%ebp
c010023d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100244:	74 13                	je     c0100259 <readline+0x1f>
        cprintf("%s", prompt);
c0100246:	8b 45 08             	mov    0x8(%ebp),%eax
c0100249:	89 44 24 04          	mov    %eax,0x4(%esp)
c010024d:	c7 04 24 cf 73 10 c0 	movl   $0xc01073cf,(%esp)
c0100254:	e8 ea 00 00 00       	call   c0100343 <cprintf>
    }
    int i = 0, c;
c0100259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100260:	e8 66 01 00 00       	call   c01003cb <getchar>
c0100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010026c:	79 07                	jns    c0100275 <readline+0x3b>
            return NULL;
c010026e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100273:	eb 79                	jmp    c01002ee <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100275:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100279:	7e 28                	jle    c01002a3 <readline+0x69>
c010027b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100282:	7f 1f                	jg     c01002a3 <readline+0x69>
            cputchar(c);
c0100284:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100287:	89 04 24             	mov    %eax,(%esp)
c010028a:	e8 da 00 00 00       	call   c0100369 <cputchar>
            buf[i ++] = c;
c010028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100292:	8d 50 01             	lea    0x1(%eax),%edx
c0100295:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100298:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010029b:	88 90 60 aa 11 c0    	mov    %dl,-0x3fee55a0(%eax)
c01002a1:	eb 46                	jmp    c01002e9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a7:	75 17                	jne    c01002c0 <readline+0x86>
c01002a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ad:	7e 11                	jle    c01002c0 <readline+0x86>
            cputchar(c);
c01002af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b2:	89 04 24             	mov    %eax,(%esp)
c01002b5:	e8 af 00 00 00       	call   c0100369 <cputchar>
            i --;
c01002ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002be:	eb 29                	jmp    c01002e9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c4:	74 06                	je     c01002cc <readline+0x92>
c01002c6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002ca:	75 1d                	jne    c01002e9 <readline+0xaf>
            cputchar(c);
c01002cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002cf:	89 04 24             	mov    %eax,(%esp)
c01002d2:	e8 92 00 00 00       	call   c0100369 <cputchar>
            buf[i] = '\0';
c01002d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002da:	05 60 aa 11 c0       	add    $0xc011aa60,%eax
c01002df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e2:	b8 60 aa 11 c0       	mov    $0xc011aa60,%eax
c01002e7:	eb 05                	jmp    c01002ee <readline+0xb4>
        }
    }
c01002e9:	e9 72 ff ff ff       	jmp    c0100260 <readline+0x26>
}
c01002ee:	c9                   	leave  
c01002ef:	c3                   	ret    

c01002f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f0:	55                   	push   %ebp
c01002f1:	89 e5                	mov    %esp,%ebp
c01002f3:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f9:	89 04 24             	mov    %eax,(%esp)
c01002fc:	e8 00 13 00 00       	call   c0101601 <cons_putc>
    (*cnt) ++;
c0100301:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100304:	8b 00                	mov    (%eax),%eax
c0100306:	8d 50 01             	lea    0x1(%eax),%edx
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	89 10                	mov    %edx,(%eax)
}
c010030e:	c9                   	leave  
c010030f:	c3                   	ret    

c0100310 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100310:	55                   	push   %ebp
c0100311:	89 e5                	mov    %esp,%ebp
c0100313:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010031d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100320:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100324:	8b 45 08             	mov    0x8(%ebp),%eax
c0100327:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010032e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100332:	c7 04 24 f0 02 10 c0 	movl   $0xc01002f0,(%esp)
c0100339:	e8 6d 66 00 00       	call   c01069ab <vprintfmt>
    return cnt;
c010033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100341:	c9                   	leave  
c0100342:	c3                   	ret    

c0100343 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100343:	55                   	push   %ebp
c0100344:	89 e5                	mov    %esp,%ebp
c0100346:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100349:	8d 45 0c             	lea    0xc(%ebp),%eax
c010034c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010034f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100352:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100356:	8b 45 08             	mov    0x8(%ebp),%eax
c0100359:	89 04 24             	mov    %eax,(%esp)
c010035c:	e8 af ff ff ff       	call   c0100310 <vcprintf>
c0100361:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100364:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100367:	c9                   	leave  
c0100368:	c3                   	ret    

c0100369 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100369:	55                   	push   %ebp
c010036a:	89 e5                	mov    %esp,%ebp
c010036c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010036f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100372:	89 04 24             	mov    %eax,(%esp)
c0100375:	e8 87 12 00 00       	call   c0101601 <cons_putc>
}
c010037a:	c9                   	leave  
c010037b:	c3                   	ret    

c010037c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010037c:	55                   	push   %ebp
c010037d:	89 e5                	mov    %esp,%ebp
c010037f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100382:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100389:	eb 13                	jmp    c010039e <cputs+0x22>
        cputch(c, &cnt);
c010038b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010038f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100392:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100396:	89 04 24             	mov    %eax,(%esp)
c0100399:	e8 52 ff ff ff       	call   c01002f0 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c010039e:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a1:	8d 50 01             	lea    0x1(%eax),%edx
c01003a4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a7:	0f b6 00             	movzbl (%eax),%eax
c01003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b1:	75 d8                	jne    c010038b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ba:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c1:	e8 2a ff ff ff       	call   c01002f0 <cputch>
    return cnt;
c01003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c9:	c9                   	leave  
c01003ca:	c3                   	ret    

c01003cb <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003cb:	55                   	push   %ebp
c01003cc:	89 e5                	mov    %esp,%ebp
c01003ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d1:	e8 67 12 00 00       	call   c010163d <cons_getc>
c01003d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003dd:	74 f2                	je     c01003d1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e2:	c9                   	leave  
c01003e3:	c3                   	ret    

c01003e4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e4:	55                   	push   %ebp
c01003e5:	89 e5                	mov    %esp,%ebp
c01003e7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003ed:	8b 00                	mov    (%eax),%eax
c01003ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100401:	e9 d2 00 00 00       	jmp    c01004d8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100406:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100409:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	89 c2                	mov    %eax,%edx
c0100410:	c1 ea 1f             	shr    $0x1f,%edx
c0100413:	01 d0                	add    %edx,%eax
c0100415:	d1 f8                	sar    %eax
c0100417:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010041d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100420:	eb 04                	jmp    c0100426 <stab_binsearch+0x42>
            m --;
c0100422:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100426:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100429:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010042c:	7c 1f                	jl     c010044d <stab_binsearch+0x69>
c010042e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100431:	89 d0                	mov    %edx,%eax
c0100433:	01 c0                	add    %eax,%eax
c0100435:	01 d0                	add    %edx,%eax
c0100437:	c1 e0 02             	shl    $0x2,%eax
c010043a:	89 c2                	mov    %eax,%edx
c010043c:	8b 45 08             	mov    0x8(%ebp),%eax
c010043f:	01 d0                	add    %edx,%eax
c0100441:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100445:	0f b6 c0             	movzbl %al,%eax
c0100448:	3b 45 14             	cmp    0x14(%ebp),%eax
c010044b:	75 d5                	jne    c0100422 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100453:	7d 0b                	jge    c0100460 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100455:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100458:	83 c0 01             	add    $0x1,%eax
c010045b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010045e:	eb 78                	jmp    c01004d8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100460:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100467:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046a:	89 d0                	mov    %edx,%eax
c010046c:	01 c0                	add    %eax,%eax
c010046e:	01 d0                	add    %edx,%eax
c0100470:	c1 e0 02             	shl    $0x2,%eax
c0100473:	89 c2                	mov    %eax,%edx
c0100475:	8b 45 08             	mov    0x8(%ebp),%eax
c0100478:	01 d0                	add    %edx,%eax
c010047a:	8b 40 08             	mov    0x8(%eax),%eax
c010047d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100480:	73 13                	jae    c0100495 <stab_binsearch+0xb1>
            *region_left = m;
c0100482:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100485:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100488:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010048d:	83 c0 01             	add    $0x1,%eax
c0100490:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100493:	eb 43                	jmp    c01004d8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 d0                	mov    %edx,%eax
c010049a:	01 c0                	add    %eax,%eax
c010049c:	01 d0                	add    %edx,%eax
c010049e:	c1 e0 02             	shl    $0x2,%eax
c01004a1:	89 c2                	mov    %eax,%edx
c01004a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a6:	01 d0                	add    %edx,%eax
c01004a8:	8b 40 08             	mov    0x8(%eax),%eax
c01004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004ae:	76 16                	jbe    c01004c6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004be:	83 e8 01             	sub    $0x1,%eax
c01004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c4:	eb 12                	jmp    c01004d8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004cc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004de:	0f 8e 22 ff ff ff    	jle    c0100406 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e8:	75 0f                	jne    c01004f9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ed:	8b 00                	mov    (%eax),%eax
c01004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	89 10                	mov    %edx,(%eax)
c01004f7:	eb 3f                	jmp    c0100538 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fc:	8b 00                	mov    (%eax),%eax
c01004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100501:	eb 04                	jmp    c0100507 <stab_binsearch+0x123>
c0100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050a:	8b 00                	mov    (%eax),%eax
c010050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050f:	7d 1f                	jge    c0100530 <stab_binsearch+0x14c>
c0100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100514:	89 d0                	mov    %edx,%eax
c0100516:	01 c0                	add    %eax,%eax
c0100518:	01 d0                	add    %edx,%eax
c010051a:	c1 e0 02             	shl    $0x2,%eax
c010051d:	89 c2                	mov    %eax,%edx
c010051f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100528:	0f b6 c0             	movzbl %al,%eax
c010052b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010052e:	75 d3                	jne    c0100503 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100530:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100533:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100536:	89 10                	mov    %edx,(%eax)
    }
}
c0100538:	c9                   	leave  
c0100539:	c3                   	ret    

c010053a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053a:	55                   	push   %ebp
c010053b:	89 e5                	mov    %esp,%ebp
c010053d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	c7 00 d4 73 10 c0    	movl   $0xc01073d4,(%eax)
    info->eip_line = 0;
c0100549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100553:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100556:	c7 40 08 d4 73 10 c0 	movl   $0xc01073d4,0x8(%eax)
    info->eip_fn_namelen = 9;
c010055d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100560:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100567:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056a:	8b 55 08             	mov    0x8(%ebp),%edx
c010056d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100570:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100573:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057a:	c7 45 f4 b4 8a 10 c0 	movl   $0xc0108ab4,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100581:	c7 45 f0 4c 4c 11 c0 	movl   $0xc0114c4c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100588:	c7 45 ec 4d 4c 11 c0 	movl   $0xc0114c4d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010058f:	c7 45 e8 9e 77 11 c0 	movl   $0xc011779e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100596:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100599:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010059c:	76 0d                	jbe    c01005ab <debuginfo_eip+0x71>
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	83 e8 01             	sub    $0x1,%eax
c01005a4:	0f b6 00             	movzbl (%eax),%eax
c01005a7:	84 c0                	test   %al,%al
c01005a9:	74 0a                	je     c01005b5 <debuginfo_eip+0x7b>
        return -1;
c01005ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b0:	e9 c0 02 00 00       	jmp    c0100875 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c2:	29 c2                	sub    %eax,%edx
c01005c4:	89 d0                	mov    %edx,%eax
c01005c6:	c1 f8 02             	sar    $0x2,%eax
c01005c9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005cf:	83 e8 01             	sub    $0x1,%eax
c01005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005dc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e3:	00 
c01005e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005f5:	89 04 24             	mov    %eax,(%esp)
c01005f8:	e8 e7 fd ff ff       	call   c01003e4 <stab_binsearch>
    if (lfile == 0)
c01005fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100600:	85 c0                	test   %eax,%eax
c0100602:	75 0a                	jne    c010060e <debuginfo_eip+0xd4>
        return -1;
c0100604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100609:	e9 67 02 00 00       	jmp    c0100875 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010060e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100611:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100614:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100617:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061a:	8b 45 08             	mov    0x8(%ebp),%eax
c010061d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100621:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100628:	00 
c0100629:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010062c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100630:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100633:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100637:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063a:	89 04 24             	mov    %eax,(%esp)
c010063d:	e8 a2 fd ff ff       	call   c01003e4 <stab_binsearch>

    if (lfun <= rfun) {
c0100642:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100645:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100648:	39 c2                	cmp    %eax,%edx
c010064a:	7f 7c                	jg     c01006c8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010064f:	89 c2                	mov    %eax,%edx
c0100651:	89 d0                	mov    %edx,%eax
c0100653:	01 c0                	add    %eax,%eax
c0100655:	01 d0                	add    %edx,%eax
c0100657:	c1 e0 02             	shl    $0x2,%eax
c010065a:	89 c2                	mov    %eax,%edx
c010065c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010065f:	01 d0                	add    %edx,%eax
c0100661:	8b 10                	mov    (%eax),%edx
c0100663:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100666:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100669:	29 c1                	sub    %eax,%ecx
c010066b:	89 c8                	mov    %ecx,%eax
c010066d:	39 c2                	cmp    %eax,%edx
c010066f:	73 22                	jae    c0100693 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100671:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100674:	89 c2                	mov    %eax,%edx
c0100676:	89 d0                	mov    %edx,%eax
c0100678:	01 c0                	add    %eax,%eax
c010067a:	01 d0                	add    %edx,%eax
c010067c:	c1 e0 02             	shl    $0x2,%eax
c010067f:	89 c2                	mov    %eax,%edx
c0100681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100684:	01 d0                	add    %edx,%eax
c0100686:	8b 10                	mov    (%eax),%edx
c0100688:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010068b:	01 c2                	add    %eax,%edx
c010068d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100690:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100693:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100696:	89 c2                	mov    %eax,%edx
c0100698:	89 d0                	mov    %edx,%eax
c010069a:	01 c0                	add    %eax,%eax
c010069c:	01 d0                	add    %edx,%eax
c010069e:	c1 e0 02             	shl    $0x2,%eax
c01006a1:	89 c2                	mov    %eax,%edx
c01006a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a6:	01 d0                	add    %edx,%eax
c01006a8:	8b 50 08             	mov    0x8(%eax),%edx
c01006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ae:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b4:	8b 40 10             	mov    0x10(%eax),%eax
c01006b7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006c6:	eb 15                	jmp    c01006dd <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01006ce:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006da:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e0:	8b 40 08             	mov    0x8(%eax),%eax
c01006e3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ea:	00 
c01006eb:	89 04 24             	mov    %eax,(%esp)
c01006ee:	e8 13 69 00 00       	call   c0107006 <strfind>
c01006f3:	89 c2                	mov    %eax,%edx
c01006f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f8:	8b 40 08             	mov    0x8(%eax),%eax
c01006fb:	29 c2                	sub    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100703:	8b 45 08             	mov    0x8(%ebp),%eax
c0100706:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100711:	00 
c0100712:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100715:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100719:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010071c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100720:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100723:	89 04 24             	mov    %eax,(%esp)
c0100726:	e8 b9 fc ff ff       	call   c01003e4 <stab_binsearch>
    if (lline <= rline) {
c010072b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	39 c2                	cmp    %eax,%edx
c0100733:	7f 24                	jg     c0100759 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100735:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100738:	89 c2                	mov    %eax,%edx
c010073a:	89 d0                	mov    %edx,%eax
c010073c:	01 c0                	add    %eax,%eax
c010073e:	01 d0                	add    %edx,%eax
c0100740:	c1 e0 02             	shl    $0x2,%eax
c0100743:	89 c2                	mov    %eax,%edx
c0100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100748:	01 d0                	add    %edx,%eax
c010074a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010074e:	0f b7 d0             	movzwl %ax,%edx
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100757:	eb 13                	jmp    c010076c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010075e:	e9 12 01 00 00       	jmp    c0100875 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100766:	83 e8 01             	sub    $0x1,%eax
c0100769:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100772:	39 c2                	cmp    %eax,%edx
c0100774:	7c 56                	jl     c01007cc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100776:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100779:	89 c2                	mov    %eax,%edx
c010077b:	89 d0                	mov    %edx,%eax
c010077d:	01 c0                	add    %eax,%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	c1 e0 02             	shl    $0x2,%eax
c0100784:	89 c2                	mov    %eax,%edx
c0100786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100789:	01 d0                	add    %edx,%eax
c010078b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010078f:	3c 84                	cmp    $0x84,%al
c0100791:	74 39                	je     c01007cc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100796:	89 c2                	mov    %eax,%edx
c0100798:	89 d0                	mov    %edx,%eax
c010079a:	01 c0                	add    %eax,%eax
c010079c:	01 d0                	add    %edx,%eax
c010079e:	c1 e0 02             	shl    $0x2,%eax
c01007a1:	89 c2                	mov    %eax,%edx
c01007a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a6:	01 d0                	add    %edx,%eax
c01007a8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007ac:	3c 64                	cmp    $0x64,%al
c01007ae:	75 b3                	jne    c0100763 <debuginfo_eip+0x229>
c01007b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b3:	89 c2                	mov    %eax,%edx
c01007b5:	89 d0                	mov    %edx,%eax
c01007b7:	01 c0                	add    %eax,%eax
c01007b9:	01 d0                	add    %edx,%eax
c01007bb:	c1 e0 02             	shl    $0x2,%eax
c01007be:	89 c2                	mov    %eax,%edx
c01007c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c3:	01 d0                	add    %edx,%eax
c01007c5:	8b 40 08             	mov    0x8(%eax),%eax
c01007c8:	85 c0                	test   %eax,%eax
c01007ca:	74 97                	je     c0100763 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d2:	39 c2                	cmp    %eax,%edx
c01007d4:	7c 46                	jl     c010081c <debuginfo_eip+0x2e2>
c01007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d9:	89 c2                	mov    %eax,%edx
c01007db:	89 d0                	mov    %edx,%eax
c01007dd:	01 c0                	add    %eax,%eax
c01007df:	01 d0                	add    %edx,%eax
c01007e1:	c1 e0 02             	shl    $0x2,%eax
c01007e4:	89 c2                	mov    %eax,%edx
c01007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e9:	01 d0                	add    %edx,%eax
c01007eb:	8b 10                	mov    (%eax),%edx
c01007ed:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f3:	29 c1                	sub    %eax,%ecx
c01007f5:	89 c8                	mov    %ecx,%eax
c01007f7:	39 c2                	cmp    %eax,%edx
c01007f9:	73 21                	jae    c010081c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	89 d0                	mov    %edx,%eax
c0100802:	01 c0                	add    %eax,%eax
c0100804:	01 d0                	add    %edx,%eax
c0100806:	c1 e0 02             	shl    $0x2,%eax
c0100809:	89 c2                	mov    %eax,%edx
c010080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010080e:	01 d0                	add    %edx,%eax
c0100810:	8b 10                	mov    (%eax),%edx
c0100812:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100815:	01 c2                	add    %eax,%edx
c0100817:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010081c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010081f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100822:	39 c2                	cmp    %eax,%edx
c0100824:	7d 4a                	jge    c0100870 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100826:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100829:	83 c0 01             	add    $0x1,%eax
c010082c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010082f:	eb 18                	jmp    c0100849 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100831:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100834:	8b 40 14             	mov    0x14(%eax),%eax
c0100837:	8d 50 01             	lea    0x1(%eax),%edx
c010083a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100843:	83 c0 01             	add    $0x1,%eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7d 1d                	jge    c0100870 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c a0                	cmp    $0xa0,%al
c010086e:	74 c1                	je     c0100831 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100875:	c9                   	leave  
c0100876:	c3                   	ret    

c0100877 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100877:	55                   	push   %ebp
c0100878:	89 e5                	mov    %esp,%ebp
c010087a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010087d:	c7 04 24 de 73 10 c0 	movl   $0xc01073de,(%esp)
c0100884:	e8 ba fa ff ff       	call   c0100343 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100889:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100890:	c0 
c0100891:	c7 04 24 f7 73 10 c0 	movl   $0xc01073f7,(%esp)
c0100898:	e8 a6 fa ff ff       	call   c0100343 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089d:	c7 44 24 04 1b 73 10 	movl   $0xc010731b,0x4(%esp)
c01008a4:	c0 
c01008a5:	c7 04 24 0f 74 10 c0 	movl   $0xc010740f,(%esp)
c01008ac:	e8 92 fa ff ff       	call   c0100343 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b1:	c7 44 24 04 36 aa 11 	movl   $0xc011aa36,0x4(%esp)
c01008b8:	c0 
c01008b9:	c7 04 24 27 74 10 c0 	movl   $0xc0107427,(%esp)
c01008c0:	e8 7e fa ff ff       	call   c0100343 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c5:	c7 44 24 04 c4 b9 11 	movl   $0xc011b9c4,0x4(%esp)
c01008cc:	c0 
c01008cd:	c7 04 24 3f 74 10 c0 	movl   $0xc010743f,(%esp)
c01008d4:	e8 6a fa ff ff       	call   c0100343 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d9:	b8 c4 b9 11 c0       	mov    $0xc011b9c4,%eax
c01008de:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e9:	29 c2                	sub    %eax,%edx
c01008eb:	89 d0                	mov    %edx,%eax
c01008ed:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f3:	85 c0                	test   %eax,%eax
c01008f5:	0f 48 c2             	cmovs  %edx,%eax
c01008f8:	c1 f8 0a             	sar    $0xa,%eax
c01008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008ff:	c7 04 24 58 74 10 c0 	movl   $0xc0107458,(%esp)
c0100906:	e8 38 fa ff ff       	call   c0100343 <cprintf>
}
c010090b:	c9                   	leave  
c010090c:	c3                   	ret    

c010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
int
print_debuginfo(uintptr_t eip) {
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 04 24             	mov    %eax,(%esp)
c0100923:	e8 12 fc ff ff       	call   c010053a <debuginfo_eip>
c0100928:	85 c0                	test   %eax,%eax
c010092a:	74 1a                	je     c0100946 <print_debuginfo+0x39>
        cprintf("    <UNKNOWN>: -- 0x%08x --\n", eip);
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100933:	c7 04 24 82 74 10 c0 	movl   $0xc0107482,(%esp)
c010093a:	e8 04 fa ff ff       	call   c0100343 <cprintf>
        return 1;
c010093f:	b8 01 00 00 00       	mov    $0x1,%eax
c0100944:	eb 72                	jmp    c01009b8 <print_debuginfo+0xab>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x5e>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        return 1;
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x42>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 9f 74 10 c0 	movl   $0xc010749f,(%esp)
c01009ae:	e8 90 f9 ff ff       	call   c0100343 <cprintf>
                fnname, eip - info.eip_fn_addr);
        return 0;
c01009b3:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c0:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c9:	c9                   	leave  
c01009ca:	c3                   	ret    

c01009cb <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009cb:	55                   	push   %ebp
c01009cc:	89 e5                	mov    %esp,%ebp
c01009ce:	53                   	push   %ebx
c01009cf:	83 ec 34             	sub    $0x34,%esp
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    int i;
    uintptr_t current_eip = read_eip();
c01009d2:	e8 e3 ff ff ff       	call   c01009ba <read_eip>
c01009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009da:	89 e8                	mov    %ebp,%eax
c01009dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c01009df:	8b 45 e8             	mov    -0x18(%ebp),%eax
    uintptr_t current_ebp = read_ebp();
c01009e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
c01009e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009ec:	e9 81 00 00 00       	jmp    c0100a72 <print_stackframe+0xa7>
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
c01009f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ff:	c7 04 24 b1 74 10 c0 	movl   $0xc01074b1,(%esp)
c0100a06:	e8 38 f9 ff ff       	call   c0100343 <cprintf>
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
            *((uintptr_t *)current_ebp + 5));
c0100a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a0e:	83 c0 14             	add    $0x14,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
c0100a11:	8b 18                	mov    (%eax),%ebx
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
c0100a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a16:	83 c0 10             	add    $0x10,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
c0100a19:	8b 08                	mov    (%eax),%ecx
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
c0100a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a1e:	83 c0 0c             	add    $0xc,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
c0100a21:	8b 10                	mov    (%eax),%edx
            *((uintptr_t *)current_ebp + 2),
c0100a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a26:	83 c0 08             	add    $0x8,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a33:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 c8 74 10 c0 	movl   $0xc01074c8,(%esp)
c0100a42:	e8 fc f8 ff ff       	call   c0100343 <cprintf>
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
            *((uintptr_t *)current_ebp + 5));
        if (print_debuginfo(current_eip - 1)) {
c0100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4a:	83 e8 01             	sub    $0x1,%eax
c0100a4d:	89 04 24             	mov    %eax,(%esp)
c0100a50:	e8 b8 fe ff ff       	call   c010090d <print_debuginfo>
c0100a55:	85 c0                	test   %eax,%eax
c0100a57:	74 02                	je     c0100a5b <print_stackframe+0x90>
            break;
c0100a59:	eb 21                	jmp    c0100a7c <print_stackframe+0xb1>
        }
        current_eip = *((uintptr_t *)current_ebp + 1);
c0100a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a5e:	83 c0 04             	add    $0x4,%eax
c0100a61:	8b 00                	mov    (%eax),%eax
c0100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
        current_ebp = *((uintptr_t *)current_ebp);
c0100a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a69:	8b 00                	mov    (%eax),%eax
c0100a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a72:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
c0100a76:	0f 8e 75 ff ff ff    	jle    c01009f1 <print_stackframe+0x26>
            break;
        }
        current_eip = *((uintptr_t *)current_ebp + 1);
        current_ebp = *((uintptr_t *)current_ebp);
    }
c0100a7c:	83 c4 34             	add    $0x34,%esp
c0100a7f:	5b                   	pop    %ebx
c0100a80:	5d                   	pop    %ebp
c0100a81:	c3                   	ret    

c0100a82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a82:	55                   	push   %ebp
c0100a83:	89 e5                	mov    %esp,%ebp
c0100a85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8f:	eb 0c                	jmp    c0100a9d <parse+0x1b>
            *buf ++ = '\0';
c0100a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a94:	8d 50 01             	lea    0x1(%eax),%edx
c0100a97:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa0:	0f b6 00             	movzbl (%eax),%eax
c0100aa3:	84 c0                	test   %al,%al
c0100aa5:	74 1d                	je     c0100ac4 <parse+0x42>
c0100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaa:	0f b6 00             	movzbl (%eax),%eax
c0100aad:	0f be c0             	movsbl %al,%eax
c0100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab4:	c7 04 24 6c 75 10 c0 	movl   $0xc010756c,(%esp)
c0100abb:	e8 13 65 00 00       	call   c0106fd3 <strchr>
c0100ac0:	85 c0                	test   %eax,%eax
c0100ac2:	75 cd                	jne    c0100a91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac7:	0f b6 00             	movzbl (%eax),%eax
c0100aca:	84 c0                	test   %al,%al
c0100acc:	75 02                	jne    c0100ad0 <parse+0x4e>
            break;
c0100ace:	eb 67                	jmp    c0100b37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad4:	75 14                	jne    c0100aea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100add:	00 
c0100ade:	c7 04 24 71 75 10 c0 	movl   $0xc0107571,(%esp)
c0100ae5:	e8 59 f8 ff ff       	call   c0100343 <cprintf>
        }
        argv[argc ++] = buf;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	8d 50 01             	lea    0x1(%eax),%edx
c0100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afd:	01 c2                	add    %eax,%edx
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b04:	eb 04                	jmp    c0100b0a <parse+0x88>
            buf ++;
c0100b06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0d:	0f b6 00             	movzbl (%eax),%eax
c0100b10:	84 c0                	test   %al,%al
c0100b12:	74 1d                	je     c0100b31 <parse+0xaf>
c0100b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b17:	0f b6 00             	movzbl (%eax),%eax
c0100b1a:	0f be c0             	movsbl %al,%eax
c0100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b21:	c7 04 24 6c 75 10 c0 	movl   $0xc010756c,(%esp)
c0100b28:	e8 a6 64 00 00       	call   c0106fd3 <strchr>
c0100b2d:	85 c0                	test   %eax,%eax
c0100b2f:	74 d5                	je     c0100b06 <parse+0x84>
            buf ++;
        }
    }
c0100b31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b32:	e9 66 ff ff ff       	jmp    c0100a9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3a:	c9                   	leave  
c0100b3b:	c3                   	ret    

c0100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b42:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4c:	89 04 24             	mov    %eax,(%esp)
c0100b4f:	e8 2e ff ff ff       	call   c0100a82 <parse>
c0100b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5b:	75 0a                	jne    c0100b67 <runcmd+0x2b>
        return 0;
c0100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b62:	e9 85 00 00 00       	jmp    c0100bec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6e:	eb 5c                	jmp    c0100bcc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b76:	89 d0                	mov    %edx,%eax
c0100b78:	01 c0                	add    %eax,%eax
c0100b7a:	01 d0                	add    %edx,%eax
c0100b7c:	c1 e0 02             	shl    $0x2,%eax
c0100b7f:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100b84:	8b 00                	mov    (%eax),%eax
c0100b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8a:	89 04 24             	mov    %eax,(%esp)
c0100b8d:	e8 a2 63 00 00       	call   c0106f34 <strcmp>
c0100b92:	85 c0                	test   %eax,%eax
c0100b94:	75 32                	jne    c0100bc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b99:	89 d0                	mov    %edx,%eax
c0100b9b:	01 c0                	add    %eax,%eax
c0100b9d:	01 d0                	add    %edx,%eax
c0100b9f:	c1 e0 02             	shl    $0x2,%eax
c0100ba2:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100ba7:	8b 40 08             	mov    0x8(%eax),%eax
c0100baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bad:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bba:	83 c2 04             	add    $0x4,%edx
c0100bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc1:	89 0c 24             	mov    %ecx,(%esp)
c0100bc4:	ff d0                	call   *%eax
c0100bc6:	eb 24                	jmp    c0100bec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcf:	83 f8 02             	cmp    $0x2,%eax
c0100bd2:	76 9c                	jbe    c0100b70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdb:	c7 04 24 8f 75 10 c0 	movl   $0xc010758f,(%esp)
c0100be2:	e8 5c f7 ff ff       	call   c0100343 <cprintf>
    return 0;
c0100be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bec:	c9                   	leave  
c0100bed:	c3                   	ret    

c0100bee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bee:	55                   	push   %ebp
c0100bef:	89 e5                	mov    %esp,%ebp
c0100bf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf4:	c7 04 24 a8 75 10 c0 	movl   $0xc01075a8,(%esp)
c0100bfb:	e8 43 f7 ff ff       	call   c0100343 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c00:	c7 04 24 d0 75 10 c0 	movl   $0xc01075d0,(%esp)
c0100c07:	e8 37 f7 ff ff       	call   c0100343 <cprintf>

    if (tf != NULL) {
c0100c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c10:	74 0b                	je     c0100c1d <kmonitor+0x2f>
        print_trapframe(tf);
c0100c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c15:	89 04 24             	mov    %eax,(%esp)
c0100c18:	e8 30 0e 00 00       	call   c0101a4d <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1d:	c7 04 24 f5 75 10 c0 	movl   $0xc01075f5,(%esp)
c0100c24:	e8 11 f6 ff ff       	call   c010023a <readline>
c0100c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c30:	74 18                	je     c0100c4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3c:	89 04 24             	mov    %eax,(%esp)
c0100c3f:	e8 f8 fe ff ff       	call   c0100b3c <runcmd>
c0100c44:	85 c0                	test   %eax,%eax
c0100c46:	79 02                	jns    c0100c4a <kmonitor+0x5c>
                break;
c0100c48:	eb 02                	jmp    c0100c4c <kmonitor+0x5e>
            }
        }
    }
c0100c4a:	eb d1                	jmp    c0100c1d <kmonitor+0x2f>
}
c0100c4c:	c9                   	leave  
c0100c4d:	c3                   	ret    

c0100c4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4e:	55                   	push   %ebp
c0100c4f:	89 e5                	mov    %esp,%ebp
c0100c51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5b:	eb 3f                	jmp    c0100c9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c60:	89 d0                	mov    %edx,%eax
c0100c62:	01 c0                	add    %eax,%eax
c0100c64:	01 d0                	add    %edx,%eax
c0100c66:	c1 e0 02             	shl    $0x2,%eax
c0100c69:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c6e:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c74:	89 d0                	mov    %edx,%eax
c0100c76:	01 c0                	add    %eax,%eax
c0100c78:	01 d0                	add    %edx,%eax
c0100c7a:	c1 e0 02             	shl    $0x2,%eax
c0100c7d:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c82:	8b 00                	mov    (%eax),%eax
c0100c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8c:	c7 04 24 f9 75 10 c0 	movl   $0xc01075f9,(%esp)
c0100c93:	e8 ab f6 ff ff       	call   c0100343 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9f:	83 f8 02             	cmp    $0x2,%eax
c0100ca2:	76 b9                	jbe    c0100c5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca9:	c9                   	leave  
c0100caa:	c3                   	ret    

c0100cab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cab:	55                   	push   %ebp
c0100cac:	89 e5                	mov    %esp,%ebp
c0100cae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb1:	e8 c1 fb ff ff       	call   c0100877 <print_kerninfo>
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc3:	e8 03 fd ff ff       	call   c01009cb <print_stackframe>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd5:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
c0100cda:	85 c0                	test   %eax,%eax
c0100cdc:	74 02                	je     c0100ce0 <__panic+0x11>
        goto panic_dead;
c0100cde:	eb 48                	jmp    c0100d28 <__panic+0x59>
    }
    is_panic = 1;
c0100ce0:	c7 05 60 ae 11 c0 01 	movl   $0x1,0xc011ae60
c0100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cea:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfe:	c7 04 24 02 76 10 c0 	movl   $0xc0107602,(%esp)
c0100d05:	e8 39 f6 ff ff       	call   c0100343 <cprintf>
    vcprintf(fmt, ap);
c0100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d14:	89 04 24             	mov    %eax,(%esp)
c0100d17:	e8 f4 f5 ff ff       	call   c0100310 <vcprintf>
    cprintf("\n");
c0100d1c:	c7 04 24 1e 76 10 c0 	movl   $0xc010761e,(%esp)
c0100d23:	e8 1b f6 ff ff       	call   c0100343 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d28:	e8 85 09 00 00       	call   c01016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d34:	e8 b5 fe ff ff       	call   c0100bee <kmonitor>
    }
c0100d39:	eb f2                	jmp    c0100d2d <__panic+0x5e>

c0100d3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d3b:	55                   	push   %ebp
c0100d3c:	89 e5                	mov    %esp,%ebp
c0100d3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d41:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d55:	c7 04 24 20 76 10 c0 	movl   $0xc0107620,(%esp)
c0100d5c:	e8 e2 f5 ff ff       	call   c0100343 <cprintf>
    vcprintf(fmt, ap);
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d68:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d6b:	89 04 24             	mov    %eax,(%esp)
c0100d6e:	e8 9d f5 ff ff       	call   c0100310 <vcprintf>
    cprintf("\n");
c0100d73:	c7 04 24 1e 76 10 c0 	movl   $0xc010761e,(%esp)
c0100d7a:	e8 c4 f5 ff ff       	call   c0100343 <cprintf>
    va_end(ap);
}
c0100d7f:	c9                   	leave  
c0100d80:	c3                   	ret    

c0100d81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d81:	55                   	push   %ebp
c0100d82:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d84:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
}
c0100d89:	5d                   	pop    %ebp
c0100d8a:	c3                   	ret    

c0100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8b:	55                   	push   %ebp
c0100d8c:	89 e5                	mov    %esp,%ebp
c0100d8e:	83 ec 28             	sub    $0x28,%esp
c0100d91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da3:	ee                   	out    %al,(%dx)
c0100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db6:	ee                   	out    %al,(%dx)
c0100db7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dca:	c7 05 4c b9 11 c0 00 	movl   $0x0,0xc011b94c
c0100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd4:	c7 04 24 3e 76 10 c0 	movl   $0xc010763e,(%esp)
c0100ddb:	e8 63 f5 ff ff       	call   c0100343 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de7:	e8 24 09 00 00       	call   c0101710 <pic_enable>
}
c0100dec:	c9                   	leave  
c0100ded:	c3                   	ret    

c0100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dee:	55                   	push   %ebp
c0100def:	89 e5                	mov    %esp,%ebp
c0100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df4:	9c                   	pushf  
c0100df5:	58                   	pop    %eax
c0100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfc:	25 00 02 00 00       	and    $0x200,%eax
c0100e01:	85 c0                	test   %eax,%eax
c0100e03:	74 0c                	je     c0100e11 <__intr_save+0x23>
        intr_disable();
c0100e05:	e8 a8 08 00 00       	call   c01016b2 <intr_disable>
        return 1;
c0100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0f:	eb 05                	jmp    c0100e16 <__intr_save+0x28>
    }
    return 0;
c0100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e16:	c9                   	leave  
c0100e17:	c3                   	ret    

c0100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e18:	55                   	push   %ebp
c0100e19:	89 e5                	mov    %esp,%ebp
c0100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e22:	74 05                	je     c0100e29 <__intr_restore+0x11>
        intr_enable();
c0100e24:	e8 83 08 00 00       	call   c01016ac <intr_enable>
    }
}
c0100e29:	c9                   	leave  
c0100e2a:	c3                   	ret    

c0100e2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2b:	55                   	push   %ebp
c0100e2c:	89 e5                	mov    %esp,%ebp
c0100e2e:	83 ec 10             	sub    $0x10,%esp
c0100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e3b:	89 c2                	mov    %eax,%edx
c0100e3d:	ec                   	in     (%dx),%al
c0100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4b:	89 c2                	mov    %eax,%edx
c0100e4d:	ec                   	in     (%dx),%al
c0100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5b:	89 c2                	mov    %eax,%edx
c0100e5d:	ec                   	in     (%dx),%al
c0100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e6b:	89 c2                	mov    %eax,%edx
c0100e6d:	ec                   	in     (%dx),%al
c0100e6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e71:	c9                   	leave  
c0100e72:	c3                   	ret    

c0100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e73:	55                   	push   %ebp
c0100e74:	89 e5                	mov    %esp,%ebp
c0100e76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e83:	0f b7 00             	movzwl (%eax),%eax
c0100e86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	0f b7 00             	movzwl (%eax),%eax
c0100e98:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9c:	74 12                	je     c0100eb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea5:	66 c7 05 86 ae 11 c0 	movw   $0x3b4,0xc011ae86
c0100eac:	b4 03 
c0100eae:	eb 13                	jmp    c0100ec3 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eba:	66 c7 05 86 ae 11 c0 	movw   $0x3d4,0xc011ae86
c0100ec1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec3:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100eca:	0f b7 c0             	movzwl %ax,%eax
c0100ecd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ede:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100ee5:	83 c0 01             	add    $0x1,%eax
c0100ee8:	0f b7 c0             	movzwl %ax,%eax
c0100eeb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef3:	89 c2                	mov    %eax,%edx
c0100ef5:	ec                   	in     (%dx),%al
c0100ef6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efd:	0f b6 c0             	movzbl %al,%eax
c0100f00:	c1 e0 08             	shl    $0x8,%eax
c0100f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f06:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f14:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f18:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f21:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f28:	83 c0 01             	add    $0x1,%eax
c0100f2b:	0f b7 c0             	movzwl %ax,%eax
c0100f2e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f32:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f36:	89 c2                	mov    %eax,%edx
c0100f38:	ec                   	in     (%dx),%al
c0100f39:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f40:	0f b6 c0             	movzbl %al,%eax
c0100f43:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f49:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    crt_pos = pos;
c0100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f51:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
}
c0100f57:	c9                   	leave  
c0100f58:	c3                   	ret    

c0100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f59:	55                   	push   %ebp
c0100f5a:	89 e5                	mov    %esp,%ebp
c0100f5c:	83 ec 48             	sub    $0x48,%esp
c0100f5f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f65:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f69:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f71:	ee                   	out    %al,(%dx)
c0100f72:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f78:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f84:	ee                   	out    %al,(%dx)
c0100f85:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f8b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f93:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f97:	ee                   	out    %al,(%dx)
c0100f98:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100faa:	ee                   	out    %al,(%dx)
c0100fab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbd:	ee                   	out    %al,(%dx)
c0100fbe:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
c0100fd1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fdb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
c0100fe4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fee:	89 c2                	mov    %eax,%edx
c0100ff0:	ec                   	in     (%dx),%al
c0100ff1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff8:	3c ff                	cmp    $0xff,%al
c0100ffa:	0f 95 c0             	setne  %al
c0100ffd:	0f b6 c0             	movzbl %al,%eax
c0101000:	a3 88 ae 11 c0       	mov    %eax,0xc011ae88
c0101005:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100f:	89 c2                	mov    %eax,%edx
c0101011:	ec                   	in     (%dx),%al
c0101012:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101015:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010101b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101f:	89 c2                	mov    %eax,%edx
c0101021:	ec                   	in     (%dx),%al
c0101022:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101025:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c010102a:	85 c0                	test   %eax,%eax
c010102c:	74 0c                	je     c010103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101035:	e8 d6 06 00 00       	call   c0101710 <pic_enable>
    }
}
c010103a:	c9                   	leave  
c010103b:	c3                   	ret    

c010103c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103c:	55                   	push   %ebp
c010103d:	89 e5                	mov    %esp,%ebp
c010103f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101049:	eb 09                	jmp    c0101054 <lpt_putc_sub+0x18>
        delay();
c010104b:	e8 db fd ff ff       	call   c0100e2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105e:	89 c2                	mov    %eax,%edx
c0101060:	ec                   	in     (%dx),%al
c0101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101068:	84 c0                	test   %al,%al
c010106a:	78 09                	js     c0101075 <lpt_putc_sub+0x39>
c010106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101073:	7e d6                	jle    c010104b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101075:	8b 45 08             	mov    0x8(%ebp),%eax
c0101078:	0f b6 c0             	movzbl %al,%eax
c010107b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101081:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101084:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101088:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108c:	ee                   	out    %al,(%dx)
c010108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
c01010a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b3:	c9                   	leave  
c01010b4:	c3                   	ret    

c01010b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b5:	55                   	push   %ebp
c01010b6:	89 e5                	mov    %esp,%ebp
c01010b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bf:	74 0d                	je     c01010ce <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c4:	89 04 24             	mov    %eax,(%esp)
c01010c7:	e8 70 ff ff ff       	call   c010103c <lpt_putc_sub>
c01010cc:	eb 24                	jmp    c01010f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d5:	e8 62 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e1:	e8 56 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ed:	e8 4a ff ff ff       	call   c010103c <lpt_putc_sub>
    }
}
c01010f2:	c9                   	leave  
c01010f3:	c3                   	ret    

c01010f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f4:	55                   	push   %ebp
c01010f5:	89 e5                	mov    %esp,%ebp
c01010f7:	53                   	push   %ebx
c01010f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fe:	b0 00                	mov    $0x0,%al
c0101100:	85 c0                	test   %eax,%eax
c0101102:	75 07                	jne    c010110b <cga_putc+0x17>
        c |= 0x0700;
c0101104:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010110b:	8b 45 08             	mov    0x8(%ebp),%eax
c010110e:	0f b6 c0             	movzbl %al,%eax
c0101111:	83 f8 0a             	cmp    $0xa,%eax
c0101114:	74 4c                	je     c0101162 <cga_putc+0x6e>
c0101116:	83 f8 0d             	cmp    $0xd,%eax
c0101119:	74 57                	je     c0101172 <cga_putc+0x7e>
c010111b:	83 f8 08             	cmp    $0x8,%eax
c010111e:	0f 85 88 00 00 00    	jne    c01011ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101124:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010112b:	66 85 c0             	test   %ax,%ax
c010112e:	74 30                	je     c0101160 <cga_putc+0x6c>
            crt_pos --;
c0101130:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101137:	83 e8 01             	sub    $0x1,%eax
c010113a:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101140:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101145:	0f b7 15 84 ae 11 c0 	movzwl 0xc011ae84,%edx
c010114c:	0f b7 d2             	movzwl %dx,%edx
c010114f:	01 d2                	add    %edx,%edx
c0101151:	01 c2                	add    %eax,%edx
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	b0 00                	mov    $0x0,%al
c0101158:	83 c8 20             	or     $0x20,%eax
c010115b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115e:	eb 72                	jmp    c01011d2 <cga_putc+0xde>
c0101160:	eb 70                	jmp    c01011d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101162:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101169:	83 c0 50             	add    $0x50,%eax
c010116c:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101172:	0f b7 1d 84 ae 11 c0 	movzwl 0xc011ae84,%ebx
c0101179:	0f b7 0d 84 ae 11 c0 	movzwl 0xc011ae84,%ecx
c0101180:	0f b7 c1             	movzwl %cx,%eax
c0101183:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101189:	c1 e8 10             	shr    $0x10,%eax
c010118c:	89 c2                	mov    %eax,%edx
c010118e:	66 c1 ea 06          	shr    $0x6,%dx
c0101192:	89 d0                	mov    %edx,%eax
c0101194:	c1 e0 02             	shl    $0x2,%eax
c0101197:	01 d0                	add    %edx,%eax
c0101199:	c1 e0 04             	shl    $0x4,%eax
c010119c:	29 c1                	sub    %eax,%ecx
c010119e:	89 ca                	mov    %ecx,%edx
c01011a0:	89 d8                	mov    %ebx,%eax
c01011a2:	29 d0                	sub    %edx,%eax
c01011a4:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
        break;
c01011aa:	eb 26                	jmp    c01011d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ac:	8b 0d 80 ae 11 c0    	mov    0xc011ae80,%ecx
c01011b2:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011b9:	8d 50 01             	lea    0x1(%eax),%edx
c01011bc:	66 89 15 84 ae 11 c0 	mov    %dx,0xc011ae84
c01011c3:	0f b7 c0             	movzwl %ax,%eax
c01011c6:	01 c0                	add    %eax,%eax
c01011c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ce:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d2:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011d9:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011dd:	76 5b                	jbe    c010123a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011df:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ea:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f6:	00 
c01011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fb:	89 04 24             	mov    %eax,(%esp)
c01011fe:	e8 ce 5f 00 00       	call   c01071d1 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101203:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120a:	eb 15                	jmp    c0101221 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120c:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101211:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101214:	01 d2                	add    %edx,%edx
c0101216:	01 d0                	add    %edx,%eax
c0101218:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101221:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101228:	7e e2                	jle    c010120c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122a:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101231:	83 e8 50             	sub    $0x50,%eax
c0101234:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123a:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0101241:	0f b7 c0             	movzwl %ax,%eax
c0101244:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101248:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101250:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101254:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101255:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010125c:	66 c1 e8 08          	shr    $0x8,%ax
c0101260:	0f b6 c0             	movzbl %al,%eax
c0101263:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c010126a:	83 c2 01             	add    $0x1,%edx
c010126d:	0f b7 d2             	movzwl %dx,%edx
c0101270:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101274:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101277:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101280:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0101287:	0f b7 c0             	movzwl %ax,%eax
c010128a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101292:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101296:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129b:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01012a2:	0f b6 c0             	movzbl %al,%eax
c01012a5:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c01012ac:	83 c2 01             	add    $0x1,%edx
c01012af:	0f b7 d2             	movzwl %dx,%edx
c01012b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c1:	ee                   	out    %al,(%dx)
}
c01012c2:	83 c4 34             	add    $0x34,%esp
c01012c5:	5b                   	pop    %ebx
c01012c6:	5d                   	pop    %ebp
c01012c7:	c3                   	ret    

c01012c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c8:	55                   	push   %ebp
c01012c9:	89 e5                	mov    %esp,%ebp
c01012cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d5:	eb 09                	jmp    c01012e0 <serial_putc_sub+0x18>
        delay();
c01012d7:	e8 4f fb ff ff       	call   c0100e2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ea:	89 c2                	mov    %eax,%edx
c01012ec:	ec                   	in     (%dx),%al
c01012ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f4:	0f b6 c0             	movzbl %al,%eax
c01012f7:	83 e0 20             	and    $0x20,%eax
c01012fa:	85 c0                	test   %eax,%eax
c01012fc:	75 09                	jne    c0101307 <serial_putc_sub+0x3f>
c01012fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101305:	7e d0                	jle    c01012d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101307:	8b 45 08             	mov    0x8(%ebp),%eax
c010130a:	0f b6 c0             	movzbl %al,%eax
c010130d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101313:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101316:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131e:	ee                   	out    %al,(%dx)
}
c010131f:	c9                   	leave  
c0101320:	c3                   	ret    

c0101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101321:	55                   	push   %ebp
c0101322:	89 e5                	mov    %esp,%ebp
c0101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010132b:	74 0d                	je     c010133a <serial_putc+0x19>
        serial_putc_sub(c);
c010132d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101330:	89 04 24             	mov    %eax,(%esp)
c0101333:	e8 90 ff ff ff       	call   c01012c8 <serial_putc_sub>
c0101338:	eb 24                	jmp    c010135e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101341:	e8 82 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub(' ');
c0101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134d:	e8 76 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub('\b');
c0101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101359:	e8 6a ff ff ff       	call   c01012c8 <serial_putc_sub>
    }
}
c010135e:	c9                   	leave  
c010135f:	c3                   	ret    

c0101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101360:	55                   	push   %ebp
c0101361:	89 e5                	mov    %esp,%ebp
c0101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101366:	eb 33                	jmp    c010139b <cons_intr+0x3b>
        if (c != 0) {
c0101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136c:	74 2d                	je     c010139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136e:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c0101373:	8d 50 01             	lea    0x1(%eax),%edx
c0101376:	89 15 a4 b0 11 c0    	mov    %edx,0xc011b0a4
c010137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137f:	88 90 a0 ae 11 c0    	mov    %dl,-0x3fee5160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101385:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c010138a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138f:	75 0a                	jne    c010139b <cons_intr+0x3b>
                cons.wpos = 0;
c0101391:	c7 05 a4 b0 11 c0 00 	movl   $0x0,0xc011b0a4
c0101398:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010139b:	8b 45 08             	mov    0x8(%ebp),%eax
c010139e:	ff d0                	call   *%eax
c01013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a7:	75 bf                	jne    c0101368 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a9:	c9                   	leave  
c01013aa:	c3                   	ret    

c01013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ab:	55                   	push   %ebp
c01013ac:	89 e5                	mov    %esp,%ebp
c01013ae:	83 ec 10             	sub    $0x10,%esp
c01013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	83 e0 01             	and    $0x1,%eax
c01013cb:	85 c0                	test   %eax,%eax
c01013cd:	75 07                	jne    c01013d6 <serial_proc_data+0x2b>
        return -1;
c01013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d4:	eb 2a                	jmp    c0101400 <serial_proc_data+0x55>
c01013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e0:	89 c2                	mov    %eax,%edx
c01013e2:	ec                   	in     (%dx),%al
c01013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ea:	0f b6 c0             	movzbl %al,%eax
c01013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f4:	75 07                	jne    c01013fd <serial_proc_data+0x52>
        c = '\b';
c01013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101400:	c9                   	leave  
c0101401:	c3                   	ret    

c0101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101402:	55                   	push   %ebp
c0101403:	89 e5                	mov    %esp,%ebp
c0101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101408:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c010140d:	85 c0                	test   %eax,%eax
c010140f:	74 0c                	je     c010141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101411:	c7 04 24 ab 13 10 c0 	movl   $0xc01013ab,(%esp)
c0101418:	e8 43 ff ff ff       	call   c0101360 <cons_intr>
    }
}
c010141d:	c9                   	leave  
c010141e:	c3                   	ret    

c010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 38             	sub    $0x38,%esp
c0101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2e>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 59 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101457:	89 c2                	mov    %eax,%edx
c0101459:	ec                   	in     (%dx),%al
c010145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101468:	75 17                	jne    c0101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146a:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010146f:	83 c8 40             	or     $0x40,%eax
c0101472:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c0101477:	b8 00 00 00 00       	mov    $0x0,%eax
c010147c:	e9 25 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	84 c0                	test   %al,%al
c0101487:	79 47                	jns    c01014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101489:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010148e:	83 e0 40             	and    $0x40,%eax
c0101491:	85 c0                	test   %eax,%eax
c0101493:	75 09                	jne    c010149e <kbd_proc_data+0x7f>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	83 e0 7f             	and    $0x7f,%eax
c010149c:	eb 04                	jmp    c01014a2 <kbd_proc_data+0x83>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014b0:	83 c8 40             	or     $0x40,%eax
c01014b3:	0f b6 c0             	movzbl %al,%eax
c01014b6:	f7 d0                	not    %eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014bf:	21 d0                	and    %edx,%eax
c01014c1:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c01014c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cb:	e9 d6 00 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d0:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014d5:	83 e0 40             	and    $0x40,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 11                	je     c01014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e0:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e8:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    }

    shift |= shiftcode[data];
c01014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f1:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014f8:	0f b6 d0             	movzbl %al,%edx
c01014fb:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101500:	09 d0                	or     %edx,%eax
c0101502:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    shift ^= togglecode[data];
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	0f b6 80 60 a1 11 c0 	movzbl -0x3fee5ea0(%eax),%eax
c0101512:	0f b6 d0             	movzbl %al,%edx
c0101515:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010151a:	31 d0                	xor    %edx,%eax
c010151c:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101521:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101526:	83 e0 03             	and    $0x3,%eax
c0101529:	8b 14 85 60 a5 11 c0 	mov    -0x3fee5aa0(,%eax,4),%edx
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	01 d0                	add    %edx,%eax
c0101536:	0f b6 00             	movzbl (%eax),%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153f:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101544:	83 e0 08             	and    $0x8,%eax
c0101547:	85 c0                	test   %eax,%eax
c0101549:	74 22                	je     c010156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154f:	7e 0c                	jle    c010155d <kbd_proc_data+0x13e>
c0101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101555:	7f 06                	jg     c010155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155b:	eb 10                	jmp    c010156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101561:	7e 0a                	jle    c010156d <kbd_proc_data+0x14e>
c0101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101567:	7f 04                	jg     c010156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156d:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101572:	f7 d0                	not    %eax
c0101574:	83 e0 06             	and    $0x6,%eax
c0101577:	85 c0                	test   %eax,%eax
c0101579:	75 28                	jne    c01015a3 <kbd_proc_data+0x184>
c010157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101582:	75 1f                	jne    c01015a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101584:	c7 04 24 59 76 10 c0 	movl   $0xc0107659,(%esp)
c010158b:	e8 b3 ed ff ff       	call   c0100343 <cprintf>
c0101590:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101596:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a6:	c9                   	leave  
c01015a7:	c3                   	ret    

c01015a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a8:	55                   	push   %ebp
c01015a9:	89 e5                	mov    %esp,%ebp
c01015ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ae:	c7 04 24 1f 14 10 c0 	movl   $0xc010141f,(%esp)
c01015b5:	e8 a6 fd ff ff       	call   c0101360 <cons_intr>
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_init>:

static void
kbd_init(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c2:	e8 e1 ff ff ff       	call   c01015a8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ce:	e8 3d 01 00 00       	call   c0101710 <pic_enable>
}
c01015d3:	c9                   	leave  
c01015d4:	c3                   	ret    

c01015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d5:	55                   	push   %ebp
c01015d6:	89 e5                	mov    %esp,%ebp
c01015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015db:	e8 93 f8 ff ff       	call   c0100e73 <cga_init>
    serial_init();
c01015e0:	e8 74 f9 ff ff       	call   c0100f59 <serial_init>
    kbd_init();
c01015e5:	e8 d2 ff ff ff       	call   c01015bc <kbd_init>
    if (!serial_exists) {
c01015ea:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c01015ef:	85 c0                	test   %eax,%eax
c01015f1:	75 0c                	jne    c01015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f3:	c7 04 24 65 76 10 c0 	movl   $0xc0107665,(%esp)
c01015fa:	e8 44 ed ff ff       	call   c0100343 <cprintf>
    }
}
c01015ff:	c9                   	leave  
c0101600:	c3                   	ret    

c0101601 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101601:	55                   	push   %ebp
c0101602:	89 e5                	mov    %esp,%ebp
c0101604:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101607:	e8 e2 f7 ff ff       	call   c0100dee <__intr_save>
c010160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101612:	89 04 24             	mov    %eax,(%esp)
c0101615:	e8 9b fa ff ff       	call   c01010b5 <lpt_putc>
        cga_putc(c);
c010161a:	8b 45 08             	mov    0x8(%ebp),%eax
c010161d:	89 04 24             	mov    %eax,(%esp)
c0101620:	e8 cf fa ff ff       	call   c01010f4 <cga_putc>
        serial_putc(c);
c0101625:	8b 45 08             	mov    0x8(%ebp),%eax
c0101628:	89 04 24             	mov    %eax,(%esp)
c010162b:	e8 f1 fc ff ff       	call   c0101321 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101633:	89 04 24             	mov    %eax,(%esp)
c0101636:	e8 dd f7 ff ff       	call   c0100e18 <__intr_restore>
}
c010163b:	c9                   	leave  
c010163c:	c3                   	ret    

c010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163d:	55                   	push   %ebp
c010163e:	89 e5                	mov    %esp,%ebp
c0101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164a:	e8 9f f7 ff ff       	call   c0100dee <__intr_save>
c010164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101652:	e8 ab fd ff ff       	call   c0101402 <serial_intr>
        kbd_intr();
c0101657:	e8 4c ff ff ff       	call   c01015a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165c:	8b 15 a0 b0 11 c0    	mov    0xc011b0a0,%edx
c0101662:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c0101667:	39 c2                	cmp    %eax,%edx
c0101669:	74 31                	je     c010169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166b:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c0101670:	8d 50 01             	lea    0x1(%eax),%edx
c0101673:	89 15 a0 b0 11 c0    	mov    %edx,0xc011b0a0
c0101679:	0f b6 80 a0 ae 11 c0 	movzbl -0x3fee5160(%eax),%eax
c0101680:	0f b6 c0             	movzbl %al,%eax
c0101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101686:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c010168b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101690:	75 0a                	jne    c010169c <cons_getc+0x5f>
                cons.rpos = 0;
c0101692:	c7 05 a0 b0 11 c0 00 	movl   $0x0,0xc011b0a0
c0101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169f:	89 04 24             	mov    %eax,(%esp)
c01016a2:	e8 71 f7 ff ff       	call   c0100e18 <__intr_restore>
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016af:	fb                   	sti    
    sti();
}
c01016b0:	5d                   	pop    %ebp
c01016b1:	c3                   	ret    

c01016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b5:	fa                   	cli    
    cli();
}
c01016b6:	5d                   	pop    %ebp
c01016b7:	c3                   	ret    

c01016b8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b8:	55                   	push   %ebp
c01016b9:	89 e5                	mov    %esp,%ebp
c01016bb:	83 ec 14             	sub    $0x14,%esp
c01016be:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c9:	66 a3 70 a5 11 c0    	mov    %ax,0xc011a570
    if (did_init) {
c01016cf:	a1 ac b0 11 c0       	mov    0xc011b0ac,%eax
c01016d4:	85 c0                	test   %eax,%eax
c01016d6:	74 36                	je     c010170e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e5:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ec:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016f0:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f5:	66 c1 e8 08          	shr    $0x8,%ax
c01016f9:	0f b6 c0             	movzbl %al,%eax
c01016fc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101702:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101705:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101709:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170d:	ee                   	out    %al,(%dx)
    }
}
c010170e:	c9                   	leave  
c010170f:	c3                   	ret    

c0101710 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101710:	55                   	push   %ebp
c0101711:	89 e5                	mov    %esp,%ebp
c0101713:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101716:	8b 45 08             	mov    0x8(%ebp),%eax
c0101719:	ba 01 00 00 00       	mov    $0x1,%edx
c010171e:	89 c1                	mov    %eax,%ecx
c0101720:	d3 e2                	shl    %cl,%edx
c0101722:	89 d0                	mov    %edx,%eax
c0101724:	f7 d0                	not    %eax
c0101726:	89 c2                	mov    %eax,%edx
c0101728:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c010172f:	21 d0                	and    %edx,%eax
c0101731:	0f b7 c0             	movzwl %ax,%eax
c0101734:	89 04 24             	mov    %eax,(%esp)
c0101737:	e8 7c ff ff ff       	call   c01016b8 <pic_setmask>
}
c010173c:	c9                   	leave  
c010173d:	c3                   	ret    

c010173e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173e:	55                   	push   %ebp
c010173f:	89 e5                	mov    %esp,%ebp
c0101741:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101744:	c7 05 ac b0 11 c0 01 	movl   $0x1,0xc011b0ac
c010174b:	00 00 00 
c010174e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101754:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101760:	ee                   	out    %al,(%dx)
c0101761:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101767:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010176b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101773:	ee                   	out    %al,(%dx)
c0101774:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010177a:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101782:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101786:	ee                   	out    %al,(%dx)
c0101787:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178d:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101791:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101795:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101799:	ee                   	out    %al,(%dx)
c010179a:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017a0:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ac:	ee                   	out    %al,(%dx)
c01017ad:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b3:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bf:	ee                   	out    %al,(%dx)
c01017c0:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c6:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017ca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ce:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d2:	ee                   	out    %al,(%dx)
c01017d3:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d9:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017dd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e5:	ee                   	out    %al,(%dx)
c01017e6:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ec:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017f0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f8:	ee                   	out    %al,(%dx)
c01017f9:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017ff:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101803:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101807:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010180b:	ee                   	out    %al,(%dx)
c010180c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101812:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101816:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010181a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181e:	ee                   	out    %al,(%dx)
c010181f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101825:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101829:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101831:	ee                   	out    %al,(%dx)
c0101832:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101838:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101840:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101844:	ee                   	out    %al,(%dx)
c0101845:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010184b:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101857:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101858:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c010185f:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101863:	74 12                	je     c0101877 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101865:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c010186c:	0f b7 c0             	movzwl %ax,%eax
c010186f:	89 04 24             	mov    %eax,(%esp)
c0101872:	e8 41 fe ff ff       	call   c01016b8 <pic_setmask>
    }
}
c0101877:	c9                   	leave  
c0101878:	c3                   	ret    

c0101879 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101879:	55                   	push   %ebp
c010187a:	89 e5                	mov    %esp,%ebp
c010187c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101886:	00 
c0101887:	c7 04 24 a0 76 10 c0 	movl   $0xc01076a0,(%esp)
c010188e:	e8 b0 ea ff ff       	call   c0100343 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101893:	c9                   	leave  
c0101894:	c3                   	ret    

c0101895 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101895:	55                   	push   %ebp
c0101896:	89 e5                	mov    %esp,%ebp
c0101898:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    // sel means segment selector rather than GDT index
    for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++) {
c010189b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a2:	e9 c3 00 00 00       	jmp    c010196a <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018aa:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c01018b1:	89 c2                	mov    %eax,%edx
c01018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b6:	66 89 14 c5 c0 b0 11 	mov    %dx,-0x3fee4f40(,%eax,8)
c01018bd:	c0 
c01018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c1:	66 c7 04 c5 c2 b0 11 	movw   $0x8,-0x3fee4f3e(,%eax,8)
c01018c8:	c0 08 00 
c01018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ce:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c01018d5:	c0 
c01018d6:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d9:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c01018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e3:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c01018ea:	c0 
c01018eb:	83 e2 1f             	and    $0x1f,%edx
c01018ee:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c01018f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f8:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c01018ff:	c0 
c0101900:	83 e2 f0             	and    $0xfffffff0,%edx
c0101903:	83 ca 0e             	or     $0xe,%edx
c0101906:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c010190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101910:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101917:	c0 
c0101918:	83 e2 ef             	and    $0xffffffef,%edx
c010191b:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101925:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c010192c:	c0 
c010192d:	83 e2 9f             	and    $0xffffff9f,%edx
c0101930:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193a:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101941:	c0 
c0101942:	83 ca 80             	or     $0xffffff80,%edx
c0101945:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c010194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194f:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c0101956:	c1 e8 10             	shr    $0x10,%eax
c0101959:	89 c2                	mov    %eax,%edx
c010195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195e:	66 89 14 c5 c6 b0 11 	mov    %dx,-0x3fee4f3a(,%eax,8)
c0101965:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    // sel means segment selector rather than GDT index
    for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++) {
c0101966:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196d:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101972:	0f 86 2f ff ff ff    	jbe    c01018a7 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    // for T_SWITCH_TOU and T_SWITCH_TOK
    // T_SWITCH_TOU is already set from above
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101978:	a1 e4 a7 11 c0       	mov    0xc011a7e4,%eax
c010197d:	66 a3 88 b4 11 c0    	mov    %ax,0xc011b488
c0101983:	66 c7 05 8a b4 11 c0 	movw   $0x8,0xc011b48a
c010198a:	08 00 
c010198c:	0f b6 05 8c b4 11 c0 	movzbl 0xc011b48c,%eax
c0101993:	83 e0 e0             	and    $0xffffffe0,%eax
c0101996:	a2 8c b4 11 c0       	mov    %al,0xc011b48c
c010199b:	0f b6 05 8c b4 11 c0 	movzbl 0xc011b48c,%eax
c01019a2:	83 e0 1f             	and    $0x1f,%eax
c01019a5:	a2 8c b4 11 c0       	mov    %al,0xc011b48c
c01019aa:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019b1:	83 e0 f0             	and    $0xfffffff0,%eax
c01019b4:	83 c8 0e             	or     $0xe,%eax
c01019b7:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019bc:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019c3:	83 e0 ef             	and    $0xffffffef,%eax
c01019c6:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019cb:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019d2:	83 c8 60             	or     $0x60,%eax
c01019d5:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019da:	0f b6 05 8d b4 11 c0 	movzbl 0xc011b48d,%eax
c01019e1:	83 c8 80             	or     $0xffffff80,%eax
c01019e4:	a2 8d b4 11 c0       	mov    %al,0xc011b48d
c01019e9:	a1 e4 a7 11 c0       	mov    0xc011a7e4,%eax
c01019ee:	c1 e8 10             	shr    $0x10,%eax
c01019f1:	66 a3 8e b4 11 c0    	mov    %ax,0xc011b48e
c01019f7:	c7 45 f8 80 a5 11 c0 	movl   $0xc011a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a01:	0f 01 18             	lidtl  (%eax)
    
    lidt(&idt_pd);
}
c0101a04:	c9                   	leave  
c0101a05:	c3                   	ret    

c0101a06 <trapname>:

static const char *
trapname(int trapno) {
c0101a06:	55                   	push   %ebp
c0101a07:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0c:	83 f8 13             	cmp    $0x13,%eax
c0101a0f:	77 0c                	ja     c0101a1d <trapname+0x17>
        return excnames[trapno];
c0101a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a14:	8b 04 85 00 7a 10 c0 	mov    -0x3fef8600(,%eax,4),%eax
c0101a1b:	eb 18                	jmp    c0101a35 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a1d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a21:	7e 0d                	jle    c0101a30 <trapname+0x2a>
c0101a23:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a27:	7f 07                	jg     c0101a30 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a29:	b8 aa 76 10 c0       	mov    $0xc01076aa,%eax
c0101a2e:	eb 05                	jmp    c0101a35 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a30:	b8 bd 76 10 c0       	mov    $0xc01076bd,%eax
}
c0101a35:	5d                   	pop    %ebp
c0101a36:	c3                   	ret    

c0101a37 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a37:	55                   	push   %ebp
c0101a38:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a41:	66 83 f8 08          	cmp    $0x8,%ax
c0101a45:	0f 94 c0             	sete   %al
c0101a48:	0f b6 c0             	movzbl %al,%eax
}
c0101a4b:	5d                   	pop    %ebp
c0101a4c:	c3                   	ret    

c0101a4d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a4d:	55                   	push   %ebp
c0101a4e:	89 e5                	mov    %esp,%ebp
c0101a50:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5a:	c7 04 24 fe 76 10 c0 	movl   $0xc01076fe,(%esp)
c0101a61:	e8 dd e8 ff ff       	call   c0100343 <cprintf>
    print_regs(&tf->tf_regs);
c0101a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a69:	89 04 24             	mov    %eax,(%esp)
c0101a6c:	e8 a1 01 00 00       	call   c0101c12 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a78:	0f b7 c0             	movzwl %ax,%eax
c0101a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a7f:	c7 04 24 0f 77 10 c0 	movl   $0xc010770f,(%esp)
c0101a86:	e8 b8 e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a92:	0f b7 c0             	movzwl %ax,%eax
c0101a95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a99:	c7 04 24 22 77 10 c0 	movl   $0xc0107722,(%esp)
c0101aa0:	e8 9e e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aac:	0f b7 c0             	movzwl %ax,%eax
c0101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab3:	c7 04 24 35 77 10 c0 	movl   $0xc0107735,(%esp)
c0101aba:	e8 84 e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac2:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ac6:	0f b7 c0             	movzwl %ax,%eax
c0101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101acd:	c7 04 24 48 77 10 c0 	movl   $0xc0107748,(%esp)
c0101ad4:	e8 6a e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adc:	8b 40 30             	mov    0x30(%eax),%eax
c0101adf:	89 04 24             	mov    %eax,(%esp)
c0101ae2:	e8 1f ff ff ff       	call   c0101a06 <trapname>
c0101ae7:	8b 55 08             	mov    0x8(%ebp),%edx
c0101aea:	8b 52 30             	mov    0x30(%edx),%edx
c0101aed:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101af1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101af5:	c7 04 24 5b 77 10 c0 	movl   $0xc010775b,(%esp)
c0101afc:	e8 42 e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b04:	8b 40 34             	mov    0x34(%eax),%eax
c0101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0b:	c7 04 24 6d 77 10 c0 	movl   $0xc010776d,(%esp)
c0101b12:	e8 2c e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1a:	8b 40 38             	mov    0x38(%eax),%eax
c0101b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b21:	c7 04 24 7c 77 10 c0 	movl   $0xc010777c,(%esp)
c0101b28:	e8 16 e8 ff ff       	call   c0100343 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b34:	0f b7 c0             	movzwl %ax,%eax
c0101b37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3b:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0101b42:	e8 fc e7 ff ff       	call   c0100343 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4a:	8b 40 40             	mov    0x40(%eax),%eax
c0101b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b51:	c7 04 24 9e 77 10 c0 	movl   $0xc010779e,(%esp)
c0101b58:	e8 e6 e7 ff ff       	call   c0100343 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b64:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b6b:	eb 3e                	jmp    c0101bab <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b70:	8b 50 40             	mov    0x40(%eax),%edx
c0101b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b76:	21 d0                	and    %edx,%eax
c0101b78:	85 c0                	test   %eax,%eax
c0101b7a:	74 28                	je     c0101ba4 <print_trapframe+0x157>
c0101b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b7f:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101b86:	85 c0                	test   %eax,%eax
c0101b88:	74 1a                	je     c0101ba4 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b8d:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101b94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b98:	c7 04 24 ad 77 10 c0 	movl   $0xc01077ad,(%esp)
c0101b9f:	e8 9f e7 ff ff       	call   c0100343 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ba8:	d1 65 f0             	shll   -0x10(%ebp)
c0101bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bae:	83 f8 17             	cmp    $0x17,%eax
c0101bb1:	76 ba                	jbe    c0101b6d <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb6:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb9:	25 00 30 00 00       	and    $0x3000,%eax
c0101bbe:	c1 e8 0c             	shr    $0xc,%eax
c0101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc5:	c7 04 24 b1 77 10 c0 	movl   $0xc01077b1,(%esp)
c0101bcc:	e8 72 e7 ff ff       	call   c0100343 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	89 04 24             	mov    %eax,(%esp)
c0101bd7:	e8 5b fe ff ff       	call   c0101a37 <trap_in_kernel>
c0101bdc:	85 c0                	test   %eax,%eax
c0101bde:	75 30                	jne    c0101c10 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be3:	8b 40 44             	mov    0x44(%eax),%eax
c0101be6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bea:	c7 04 24 ba 77 10 c0 	movl   $0xc01077ba,(%esp)
c0101bf1:	e8 4d e7 ff ff       	call   c0100343 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf9:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bfd:	0f b7 c0             	movzwl %ax,%eax
c0101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c04:	c7 04 24 c9 77 10 c0 	movl   $0xc01077c9,(%esp)
c0101c0b:	e8 33 e7 ff ff       	call   c0100343 <cprintf>
    }
}
c0101c10:	c9                   	leave  
c0101c11:	c3                   	ret    

c0101c12 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c12:	55                   	push   %ebp
c0101c13:	89 e5                	mov    %esp,%ebp
c0101c15:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1b:	8b 00                	mov    (%eax),%eax
c0101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c21:	c7 04 24 dc 77 10 c0 	movl   $0xc01077dc,(%esp)
c0101c28:	e8 16 e7 ff ff       	call   c0100343 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c30:	8b 40 04             	mov    0x4(%eax),%eax
c0101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c37:	c7 04 24 eb 77 10 c0 	movl   $0xc01077eb,(%esp)
c0101c3e:	e8 00 e7 ff ff       	call   c0100343 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c46:	8b 40 08             	mov    0x8(%eax),%eax
c0101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4d:	c7 04 24 fa 77 10 c0 	movl   $0xc01077fa,(%esp)
c0101c54:	e8 ea e6 ff ff       	call   c0100343 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5c:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c63:	c7 04 24 09 78 10 c0 	movl   $0xc0107809,(%esp)
c0101c6a:	e8 d4 e6 ff ff       	call   c0100343 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c72:	8b 40 10             	mov    0x10(%eax),%eax
c0101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c79:	c7 04 24 18 78 10 c0 	movl   $0xc0107818,(%esp)
c0101c80:	e8 be e6 ff ff       	call   c0100343 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c88:	8b 40 14             	mov    0x14(%eax),%eax
c0101c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8f:	c7 04 24 27 78 10 c0 	movl   $0xc0107827,(%esp)
c0101c96:	e8 a8 e6 ff ff       	call   c0100343 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9e:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca5:	c7 04 24 36 78 10 c0 	movl   $0xc0107836,(%esp)
c0101cac:	e8 92 e6 ff ff       	call   c0100343 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb4:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbb:	c7 04 24 45 78 10 c0 	movl   $0xc0107845,(%esp)
c0101cc2:	e8 7c e6 ff ff       	call   c0100343 <cprintf>
}
c0101cc7:	c9                   	leave  
c0101cc8:	c3                   	ret    

c0101cc9 <trap_dispatch>:

struct trapframe k2u;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cc9:	55                   	push   %ebp
c0101cca:	89 e5                	mov    %esp,%ebp
c0101ccc:	57                   	push   %edi
c0101ccd:	56                   	push   %esi
c0101cce:	53                   	push   %ebx
c0101ccf:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd5:	8b 40 30             	mov    0x30(%eax),%eax
c0101cd8:	83 f8 2f             	cmp    $0x2f,%eax
c0101cdb:	77 1d                	ja     c0101cfa <trap_dispatch+0x31>
c0101cdd:	83 f8 2e             	cmp    $0x2e,%eax
c0101ce0:	0f 83 c7 01 00 00    	jae    c0101ead <trap_dispatch+0x1e4>
c0101ce6:	83 f8 21             	cmp    $0x21,%eax
c0101ce9:	74 7f                	je     c0101d6a <trap_dispatch+0xa1>
c0101ceb:	83 f8 24             	cmp    $0x24,%eax
c0101cee:	74 51                	je     c0101d41 <trap_dispatch+0x78>
c0101cf0:	83 f8 20             	cmp    $0x20,%eax
c0101cf3:	74 1c                	je     c0101d11 <trap_dispatch+0x48>
c0101cf5:	e9 7b 01 00 00       	jmp    c0101e75 <trap_dispatch+0x1ac>
c0101cfa:	83 f8 78             	cmp    $0x78,%eax
c0101cfd:	0f 84 a3 00 00 00    	je     c0101da6 <trap_dispatch+0xdd>
c0101d03:	83 f8 79             	cmp    $0x79,%eax
c0101d06:	0f 84 19 01 00 00    	je     c0101e25 <trap_dispatch+0x15c>
c0101d0c:	e9 64 01 00 00       	jmp    c0101e75 <trap_dispatch+0x1ac>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if (ticks == TICK_NUM) {
c0101d11:	a1 4c b9 11 c0       	mov    0xc011b94c,%eax
c0101d16:	83 f8 64             	cmp    $0x64,%eax
c0101d19:	75 14                	jne    c0101d2f <trap_dispatch+0x66>
            print_ticks();
c0101d1b:	e8 59 fb ff ff       	call   c0101879 <print_ticks>
            ticks = 0;
c0101d20:	c7 05 4c b9 11 c0 00 	movl   $0x0,0xc011b94c
c0101d27:	00 00 00 
        } else {
            ticks++;
        }
        break;
c0101d2a:	e9 7f 01 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
         */
        if (ticks == TICK_NUM) {
            print_ticks();
            ticks = 0;
        } else {
            ticks++;
c0101d2f:	a1 4c b9 11 c0       	mov    0xc011b94c,%eax
c0101d34:	83 c0 01             	add    $0x1,%eax
c0101d37:	a3 4c b9 11 c0       	mov    %eax,0xc011b94c
        }
        break;
c0101d3c:	e9 6d 01 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d41:	e8 f7 f8 ff ff       	call   c010163d <cons_getc>
c0101d46:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d49:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d4d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d51:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d59:	c7 04 24 54 78 10 c0 	movl   $0xc0107854,(%esp)
c0101d60:	e8 de e5 ff ff       	call   c0100343 <cprintf>
        break;
c0101d65:	e9 44 01 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d6a:	e8 ce f8 ff ff       	call   c010163d <cons_getc>
c0101d6f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d72:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d76:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 66 78 10 c0 	movl   $0xc0107866,(%esp)
c0101d89:	e8 b5 e5 ff ff       	call   c0100343 <cprintf>
        if (c == '0') {
c0101d8e:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
c0101d92:	75 05                	jne    c0101d99 <trap_dispatch+0xd0>
            goto u2k_loc;
c0101d94:	e9 8c 00 00 00       	jmp    c0101e25 <trap_dispatch+0x15c>
        } else if (c == '3') {
c0101d99:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
c0101d9d:	75 02                	jne    c0101da1 <trap_dispatch+0xd8>
            goto k2u_loc;
c0101d9f:	eb 05                	jmp    c0101da6 <trap_dispatch+0xdd>
        }
        break;
c0101da1:	e9 08 01 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
k2u_loc:
        if (tf->tf_cs != USER_CS) {
c0101da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dad:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101db1:	74 6d                	je     c0101e20 <trap_dispatch+0x157>
            k2u = *tf;
c0101db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db6:	ba 60 b9 11 c0       	mov    $0xc011b960,%edx
c0101dbb:	89 c3                	mov    %eax,%ebx
c0101dbd:	b8 13 00 00 00       	mov    $0x13,%eax
c0101dc2:	89 d7                	mov    %edx,%edi
c0101dc4:	89 de                	mov    %ebx,%esi
c0101dc6:	89 c1                	mov    %eax,%ecx
c0101dc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            k2u.tf_cs = USER_CS;
c0101dca:	66 c7 05 9c b9 11 c0 	movw   $0x1b,0xc011b99c
c0101dd1:	1b 00 
            k2u.tf_ds = k2u.tf_es = k2u.tf_ss = USER_DS;
c0101dd3:	66 c7 05 a8 b9 11 c0 	movw   $0x23,0xc011b9a8
c0101dda:	23 00 
c0101ddc:	0f b7 05 a8 b9 11 c0 	movzwl 0xc011b9a8,%eax
c0101de3:	66 a3 88 b9 11 c0    	mov    %ax,0xc011b988
c0101de9:	0f b7 05 88 b9 11 c0 	movzwl 0xc011b988,%eax
c0101df0:	66 a3 8c b9 11 c0    	mov    %ax,0xc011b98c
            k2u.tf_esp = (uint32_t) tf + (sizeof(struct trapframe) - 8);
c0101df6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df9:	83 c0 44             	add    $0x44,%eax
c0101dfc:	a3 a4 b9 11 c0       	mov    %eax,0xc011b9a4
            k2u.tf_eflags |= FL_IOPL_3;
c0101e01:	a1 a0 b9 11 c0       	mov    0xc011b9a0,%eax
c0101e06:	80 cc 30             	or     $0x30,%ah
c0101e09:	a3 a0 b9 11 c0       	mov    %eax,0xc011b9a0

            *((uint32_t *)tf - 1) = (uint32_t)&k2u;
c0101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e11:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e14:	b8 60 b9 11 c0       	mov    $0xc011b960,%eax
c0101e19:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101e1b:	e9 8e 00 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
c0101e20:	e9 89 00 00 00       	jmp    c0101eae <trap_dispatch+0x1e5>
    case T_SWITCH_TOK:
u2k_loc:
        if (tf->tf_cs != KERNEL_CS) {
c0101e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e2c:	66 83 f8 08          	cmp    $0x8,%ax
c0101e30:	74 41                	je     c0101e73 <trap_dispatch+0x1aa>
            tf->tf_cs = KERNEL_CS;
c0101e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e35:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
c0101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3e:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e47:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4e:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e55:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_3;
c0101e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e63:	8b 40 40             	mov    0x40(%eax),%eax
c0101e66:	80 e4 cf             	and    $0xcf,%ah
c0101e69:	89 c2                	mov    %eax,%edx
c0101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6e:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101e71:	eb 3b                	jmp    c0101eae <trap_dispatch+0x1e5>
c0101e73:	eb 39                	jmp    c0101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e7c:	0f b7 c0             	movzwl %ax,%eax
c0101e7f:	83 e0 03             	and    $0x3,%eax
c0101e82:	85 c0                	test   %eax,%eax
c0101e84:	75 28                	jne    c0101eae <trap_dispatch+0x1e5>
            print_trapframe(tf);
c0101e86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e89:	89 04 24             	mov    %eax,(%esp)
c0101e8c:	e8 bc fb ff ff       	call   c0101a4d <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e91:	c7 44 24 08 75 78 10 	movl   $0xc0107875,0x8(%esp)
c0101e98:	c0 
c0101e99:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0101ea0:	00 
c0101ea1:	c7 04 24 91 78 10 c0 	movl   $0xc0107891,(%esp)
c0101ea8:	e8 22 ee ff ff       	call   c0100ccf <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101ead:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101eae:	83 c4 2c             	add    $0x2c,%esp
c0101eb1:	5b                   	pop    %ebx
c0101eb2:	5e                   	pop    %esi
c0101eb3:	5f                   	pop    %edi
c0101eb4:	5d                   	pop    %ebp
c0101eb5:	c3                   	ret    

c0101eb6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101eb6:	55                   	push   %ebp
c0101eb7:	89 e5                	mov    %esp,%ebp
c0101eb9:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebf:	89 04 24             	mov    %eax,(%esp)
c0101ec2:	e8 02 fe ff ff       	call   c0101cc9 <trap_dispatch>
}
c0101ec7:	c9                   	leave  
c0101ec8:	c3                   	ret    

c0101ec9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101ec9:	1e                   	push   %ds
    pushl %es
c0101eca:	06                   	push   %es
    pushl %fs
c0101ecb:	0f a0                	push   %fs
    pushl %gs
c0101ecd:	0f a8                	push   %gs
    pushal
c0101ecf:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101ed0:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101ed5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101ed7:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101ed9:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101eda:	e8 d7 ff ff ff       	call   c0101eb6 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101edf:	5c                   	pop    %esp

c0101ee0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101ee0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101ee1:	0f a9                	pop    %gs
    popl %fs
c0101ee3:	0f a1                	pop    %fs
    popl %es
c0101ee5:	07                   	pop    %es
    popl %ds
c0101ee6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101ee7:	83 c4 08             	add    $0x8,%esp
    iret
c0101eea:	cf                   	iret   

c0101eeb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $0
c0101eed:	6a 00                	push   $0x0
  jmp __alltraps
c0101eef:	e9 d5 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101ef4 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  pushl $1
c0101ef6:	6a 01                	push   $0x1
  jmp __alltraps
c0101ef8:	e9 cc ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101efd <vector2>:
.globl vector2
vector2:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $2
c0101eff:	6a 02                	push   $0x2
  jmp __alltraps
c0101f01:	e9 c3 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f06 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $3
c0101f08:	6a 03                	push   $0x3
  jmp __alltraps
c0101f0a:	e9 ba ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f0f <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f0f:	6a 00                	push   $0x0
  pushl $4
c0101f11:	6a 04                	push   $0x4
  jmp __alltraps
c0101f13:	e9 b1 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f18 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f18:	6a 00                	push   $0x0
  pushl $5
c0101f1a:	6a 05                	push   $0x5
  jmp __alltraps
c0101f1c:	e9 a8 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f21 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f21:	6a 00                	push   $0x0
  pushl $6
c0101f23:	6a 06                	push   $0x6
  jmp __alltraps
c0101f25:	e9 9f ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f2a <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $7
c0101f2c:	6a 07                	push   $0x7
  jmp __alltraps
c0101f2e:	e9 96 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f33 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f33:	6a 08                	push   $0x8
  jmp __alltraps
c0101f35:	e9 8f ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f3a <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f3a:	6a 09                	push   $0x9
  jmp __alltraps
c0101f3c:	e9 88 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f41 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f41:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f43:	e9 81 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f48 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f48:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f4a:	e9 7a ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f4f <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f4f:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f51:	e9 73 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f56 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f56:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f58:	e9 6c ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f5d <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f5d:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f5f:	e9 65 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f64 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $15
c0101f66:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f68:	e9 5c ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f6d <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $16
c0101f6f:	6a 10                	push   $0x10
  jmp __alltraps
c0101f71:	e9 53 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f76 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f76:	6a 11                	push   $0x11
  jmp __alltraps
c0101f78:	e9 4c ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f7d <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $18
c0101f7f:	6a 12                	push   $0x12
  jmp __alltraps
c0101f81:	e9 43 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f86 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $19
c0101f88:	6a 13                	push   $0x13
  jmp __alltraps
c0101f8a:	e9 3a ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f8f <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $20
c0101f91:	6a 14                	push   $0x14
  jmp __alltraps
c0101f93:	e9 31 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101f98 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $21
c0101f9a:	6a 15                	push   $0x15
  jmp __alltraps
c0101f9c:	e9 28 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101fa1 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $22
c0101fa3:	6a 16                	push   $0x16
  jmp __alltraps
c0101fa5:	e9 1f ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101faa <vector23>:
.globl vector23
vector23:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $23
c0101fac:	6a 17                	push   $0x17
  jmp __alltraps
c0101fae:	e9 16 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101fb3 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $24
c0101fb5:	6a 18                	push   $0x18
  jmp __alltraps
c0101fb7:	e9 0d ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101fbc <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $25
c0101fbe:	6a 19                	push   $0x19
  jmp __alltraps
c0101fc0:	e9 04 ff ff ff       	jmp    c0101ec9 <__alltraps>

c0101fc5 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $26
c0101fc7:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fc9:	e9 fb fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101fce <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $27
c0101fd0:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fd2:	e9 f2 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101fd7 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $28
c0101fd9:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fdb:	e9 e9 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101fe0 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $29
c0101fe2:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fe4:	e9 e0 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101fe9 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $30
c0101feb:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fed:	e9 d7 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101ff2 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $31
c0101ff4:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ff6:	e9 ce fe ff ff       	jmp    c0101ec9 <__alltraps>

c0101ffb <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $32
c0101ffd:	6a 20                	push   $0x20
  jmp __alltraps
c0101fff:	e9 c5 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102004 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $33
c0102006:	6a 21                	push   $0x21
  jmp __alltraps
c0102008:	e9 bc fe ff ff       	jmp    c0101ec9 <__alltraps>

c010200d <vector34>:
.globl vector34
vector34:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $34
c010200f:	6a 22                	push   $0x22
  jmp __alltraps
c0102011:	e9 b3 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102016 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $35
c0102018:	6a 23                	push   $0x23
  jmp __alltraps
c010201a:	e9 aa fe ff ff       	jmp    c0101ec9 <__alltraps>

c010201f <vector36>:
.globl vector36
vector36:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $36
c0102021:	6a 24                	push   $0x24
  jmp __alltraps
c0102023:	e9 a1 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102028 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $37
c010202a:	6a 25                	push   $0x25
  jmp __alltraps
c010202c:	e9 98 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102031 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $38
c0102033:	6a 26                	push   $0x26
  jmp __alltraps
c0102035:	e9 8f fe ff ff       	jmp    c0101ec9 <__alltraps>

c010203a <vector39>:
.globl vector39
vector39:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $39
c010203c:	6a 27                	push   $0x27
  jmp __alltraps
c010203e:	e9 86 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102043 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $40
c0102045:	6a 28                	push   $0x28
  jmp __alltraps
c0102047:	e9 7d fe ff ff       	jmp    c0101ec9 <__alltraps>

c010204c <vector41>:
.globl vector41
vector41:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $41
c010204e:	6a 29                	push   $0x29
  jmp __alltraps
c0102050:	e9 74 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102055 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $42
c0102057:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102059:	e9 6b fe ff ff       	jmp    c0101ec9 <__alltraps>

c010205e <vector43>:
.globl vector43
vector43:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $43
c0102060:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102062:	e9 62 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102067 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $44
c0102069:	6a 2c                	push   $0x2c
  jmp __alltraps
c010206b:	e9 59 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102070 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $45
c0102072:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102074:	e9 50 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102079 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $46
c010207b:	6a 2e                	push   $0x2e
  jmp __alltraps
c010207d:	e9 47 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102082 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $47
c0102084:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102086:	e9 3e fe ff ff       	jmp    c0101ec9 <__alltraps>

c010208b <vector48>:
.globl vector48
vector48:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $48
c010208d:	6a 30                	push   $0x30
  jmp __alltraps
c010208f:	e9 35 fe ff ff       	jmp    c0101ec9 <__alltraps>

c0102094 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $49
c0102096:	6a 31                	push   $0x31
  jmp __alltraps
c0102098:	e9 2c fe ff ff       	jmp    c0101ec9 <__alltraps>

c010209d <vector50>:
.globl vector50
vector50:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $50
c010209f:	6a 32                	push   $0x32
  jmp __alltraps
c01020a1:	e9 23 fe ff ff       	jmp    c0101ec9 <__alltraps>

c01020a6 <vector51>:
.globl vector51
vector51:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $51
c01020a8:	6a 33                	push   $0x33
  jmp __alltraps
c01020aa:	e9 1a fe ff ff       	jmp    c0101ec9 <__alltraps>

c01020af <vector52>:
.globl vector52
vector52:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $52
c01020b1:	6a 34                	push   $0x34
  jmp __alltraps
c01020b3:	e9 11 fe ff ff       	jmp    c0101ec9 <__alltraps>

c01020b8 <vector53>:
.globl vector53
vector53:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $53
c01020ba:	6a 35                	push   $0x35
  jmp __alltraps
c01020bc:	e9 08 fe ff ff       	jmp    c0101ec9 <__alltraps>

c01020c1 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $54
c01020c3:	6a 36                	push   $0x36
  jmp __alltraps
c01020c5:	e9 ff fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020ca <vector55>:
.globl vector55
vector55:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $55
c01020cc:	6a 37                	push   $0x37
  jmp __alltraps
c01020ce:	e9 f6 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020d3 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $56
c01020d5:	6a 38                	push   $0x38
  jmp __alltraps
c01020d7:	e9 ed fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020dc <vector57>:
.globl vector57
vector57:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $57
c01020de:	6a 39                	push   $0x39
  jmp __alltraps
c01020e0:	e9 e4 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020e5 <vector58>:
.globl vector58
vector58:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $58
c01020e7:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020e9:	e9 db fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020ee <vector59>:
.globl vector59
vector59:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $59
c01020f0:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020f2:	e9 d2 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01020f7 <vector60>:
.globl vector60
vector60:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $60
c01020f9:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020fb:	e9 c9 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102100 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $61
c0102102:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102104:	e9 c0 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102109 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $62
c010210b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010210d:	e9 b7 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102112 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $63
c0102114:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102116:	e9 ae fd ff ff       	jmp    c0101ec9 <__alltraps>

c010211b <vector64>:
.globl vector64
vector64:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $64
c010211d:	6a 40                	push   $0x40
  jmp __alltraps
c010211f:	e9 a5 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102124 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $65
c0102126:	6a 41                	push   $0x41
  jmp __alltraps
c0102128:	e9 9c fd ff ff       	jmp    c0101ec9 <__alltraps>

c010212d <vector66>:
.globl vector66
vector66:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $66
c010212f:	6a 42                	push   $0x42
  jmp __alltraps
c0102131:	e9 93 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102136 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $67
c0102138:	6a 43                	push   $0x43
  jmp __alltraps
c010213a:	e9 8a fd ff ff       	jmp    c0101ec9 <__alltraps>

c010213f <vector68>:
.globl vector68
vector68:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $68
c0102141:	6a 44                	push   $0x44
  jmp __alltraps
c0102143:	e9 81 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102148 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $69
c010214a:	6a 45                	push   $0x45
  jmp __alltraps
c010214c:	e9 78 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102151 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $70
c0102153:	6a 46                	push   $0x46
  jmp __alltraps
c0102155:	e9 6f fd ff ff       	jmp    c0101ec9 <__alltraps>

c010215a <vector71>:
.globl vector71
vector71:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $71
c010215c:	6a 47                	push   $0x47
  jmp __alltraps
c010215e:	e9 66 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102163 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $72
c0102165:	6a 48                	push   $0x48
  jmp __alltraps
c0102167:	e9 5d fd ff ff       	jmp    c0101ec9 <__alltraps>

c010216c <vector73>:
.globl vector73
vector73:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $73
c010216e:	6a 49                	push   $0x49
  jmp __alltraps
c0102170:	e9 54 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102175 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $74
c0102177:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102179:	e9 4b fd ff ff       	jmp    c0101ec9 <__alltraps>

c010217e <vector75>:
.globl vector75
vector75:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $75
c0102180:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102182:	e9 42 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102187 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $76
c0102189:	6a 4c                	push   $0x4c
  jmp __alltraps
c010218b:	e9 39 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102190 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $77
c0102192:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102194:	e9 30 fd ff ff       	jmp    c0101ec9 <__alltraps>

c0102199 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $78
c010219b:	6a 4e                	push   $0x4e
  jmp __alltraps
c010219d:	e9 27 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01021a2 <vector79>:
.globl vector79
vector79:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $79
c01021a4:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021a6:	e9 1e fd ff ff       	jmp    c0101ec9 <__alltraps>

c01021ab <vector80>:
.globl vector80
vector80:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $80
c01021ad:	6a 50                	push   $0x50
  jmp __alltraps
c01021af:	e9 15 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01021b4 <vector81>:
.globl vector81
vector81:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $81
c01021b6:	6a 51                	push   $0x51
  jmp __alltraps
c01021b8:	e9 0c fd ff ff       	jmp    c0101ec9 <__alltraps>

c01021bd <vector82>:
.globl vector82
vector82:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $82
c01021bf:	6a 52                	push   $0x52
  jmp __alltraps
c01021c1:	e9 03 fd ff ff       	jmp    c0101ec9 <__alltraps>

c01021c6 <vector83>:
.globl vector83
vector83:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $83
c01021c8:	6a 53                	push   $0x53
  jmp __alltraps
c01021ca:	e9 fa fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021cf <vector84>:
.globl vector84
vector84:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $84
c01021d1:	6a 54                	push   $0x54
  jmp __alltraps
c01021d3:	e9 f1 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021d8 <vector85>:
.globl vector85
vector85:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $85
c01021da:	6a 55                	push   $0x55
  jmp __alltraps
c01021dc:	e9 e8 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021e1 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $86
c01021e3:	6a 56                	push   $0x56
  jmp __alltraps
c01021e5:	e9 df fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021ea <vector87>:
.globl vector87
vector87:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $87
c01021ec:	6a 57                	push   $0x57
  jmp __alltraps
c01021ee:	e9 d6 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021f3 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $88
c01021f5:	6a 58                	push   $0x58
  jmp __alltraps
c01021f7:	e9 cd fc ff ff       	jmp    c0101ec9 <__alltraps>

c01021fc <vector89>:
.globl vector89
vector89:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $89
c01021fe:	6a 59                	push   $0x59
  jmp __alltraps
c0102200:	e9 c4 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102205 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $90
c0102207:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102209:	e9 bb fc ff ff       	jmp    c0101ec9 <__alltraps>

c010220e <vector91>:
.globl vector91
vector91:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $91
c0102210:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102212:	e9 b2 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102217 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $92
c0102219:	6a 5c                	push   $0x5c
  jmp __alltraps
c010221b:	e9 a9 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102220 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $93
c0102222:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102224:	e9 a0 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102229 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $94
c010222b:	6a 5e                	push   $0x5e
  jmp __alltraps
c010222d:	e9 97 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102232 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $95
c0102234:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102236:	e9 8e fc ff ff       	jmp    c0101ec9 <__alltraps>

c010223b <vector96>:
.globl vector96
vector96:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $96
c010223d:	6a 60                	push   $0x60
  jmp __alltraps
c010223f:	e9 85 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102244 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $97
c0102246:	6a 61                	push   $0x61
  jmp __alltraps
c0102248:	e9 7c fc ff ff       	jmp    c0101ec9 <__alltraps>

c010224d <vector98>:
.globl vector98
vector98:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $98
c010224f:	6a 62                	push   $0x62
  jmp __alltraps
c0102251:	e9 73 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102256 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $99
c0102258:	6a 63                	push   $0x63
  jmp __alltraps
c010225a:	e9 6a fc ff ff       	jmp    c0101ec9 <__alltraps>

c010225f <vector100>:
.globl vector100
vector100:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $100
c0102261:	6a 64                	push   $0x64
  jmp __alltraps
c0102263:	e9 61 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102268 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $101
c010226a:	6a 65                	push   $0x65
  jmp __alltraps
c010226c:	e9 58 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102271 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $102
c0102273:	6a 66                	push   $0x66
  jmp __alltraps
c0102275:	e9 4f fc ff ff       	jmp    c0101ec9 <__alltraps>

c010227a <vector103>:
.globl vector103
vector103:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $103
c010227c:	6a 67                	push   $0x67
  jmp __alltraps
c010227e:	e9 46 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102283 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $104
c0102285:	6a 68                	push   $0x68
  jmp __alltraps
c0102287:	e9 3d fc ff ff       	jmp    c0101ec9 <__alltraps>

c010228c <vector105>:
.globl vector105
vector105:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $105
c010228e:	6a 69                	push   $0x69
  jmp __alltraps
c0102290:	e9 34 fc ff ff       	jmp    c0101ec9 <__alltraps>

c0102295 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $106
c0102297:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102299:	e9 2b fc ff ff       	jmp    c0101ec9 <__alltraps>

c010229e <vector107>:
.globl vector107
vector107:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $107
c01022a0:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022a2:	e9 22 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01022a7 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $108
c01022a9:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022ab:	e9 19 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01022b0 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $109
c01022b2:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022b4:	e9 10 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01022b9 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $110
c01022bb:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022bd:	e9 07 fc ff ff       	jmp    c0101ec9 <__alltraps>

c01022c2 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $111
c01022c4:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022c6:	e9 fe fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022cb <vector112>:
.globl vector112
vector112:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $112
c01022cd:	6a 70                	push   $0x70
  jmp __alltraps
c01022cf:	e9 f5 fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022d4 <vector113>:
.globl vector113
vector113:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $113
c01022d6:	6a 71                	push   $0x71
  jmp __alltraps
c01022d8:	e9 ec fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022dd <vector114>:
.globl vector114
vector114:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $114
c01022df:	6a 72                	push   $0x72
  jmp __alltraps
c01022e1:	e9 e3 fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022e6 <vector115>:
.globl vector115
vector115:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $115
c01022e8:	6a 73                	push   $0x73
  jmp __alltraps
c01022ea:	e9 da fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022ef <vector116>:
.globl vector116
vector116:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $116
c01022f1:	6a 74                	push   $0x74
  jmp __alltraps
c01022f3:	e9 d1 fb ff ff       	jmp    c0101ec9 <__alltraps>

c01022f8 <vector117>:
.globl vector117
vector117:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $117
c01022fa:	6a 75                	push   $0x75
  jmp __alltraps
c01022fc:	e9 c8 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102301 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $118
c0102303:	6a 76                	push   $0x76
  jmp __alltraps
c0102305:	e9 bf fb ff ff       	jmp    c0101ec9 <__alltraps>

c010230a <vector119>:
.globl vector119
vector119:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $119
c010230c:	6a 77                	push   $0x77
  jmp __alltraps
c010230e:	e9 b6 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102313 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $120
c0102315:	6a 78                	push   $0x78
  jmp __alltraps
c0102317:	e9 ad fb ff ff       	jmp    c0101ec9 <__alltraps>

c010231c <vector121>:
.globl vector121
vector121:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $121
c010231e:	6a 79                	push   $0x79
  jmp __alltraps
c0102320:	e9 a4 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102325 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $122
c0102327:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102329:	e9 9b fb ff ff       	jmp    c0101ec9 <__alltraps>

c010232e <vector123>:
.globl vector123
vector123:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $123
c0102330:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102332:	e9 92 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102337 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $124
c0102339:	6a 7c                	push   $0x7c
  jmp __alltraps
c010233b:	e9 89 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102340 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $125
c0102342:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102344:	e9 80 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102349 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $126
c010234b:	6a 7e                	push   $0x7e
  jmp __alltraps
c010234d:	e9 77 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102352 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $127
c0102354:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102356:	e9 6e fb ff ff       	jmp    c0101ec9 <__alltraps>

c010235b <vector128>:
.globl vector128
vector128:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $128
c010235d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102362:	e9 62 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102367 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $129
c0102369:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010236e:	e9 56 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102373 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $130
c0102375:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010237a:	e9 4a fb ff ff       	jmp    c0101ec9 <__alltraps>

c010237f <vector131>:
.globl vector131
vector131:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $131
c0102381:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102386:	e9 3e fb ff ff       	jmp    c0101ec9 <__alltraps>

c010238b <vector132>:
.globl vector132
vector132:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $132
c010238d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102392:	e9 32 fb ff ff       	jmp    c0101ec9 <__alltraps>

c0102397 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $133
c0102399:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010239e:	e9 26 fb ff ff       	jmp    c0101ec9 <__alltraps>

c01023a3 <vector134>:
.globl vector134
vector134:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $134
c01023a5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023aa:	e9 1a fb ff ff       	jmp    c0101ec9 <__alltraps>

c01023af <vector135>:
.globl vector135
vector135:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $135
c01023b1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023b6:	e9 0e fb ff ff       	jmp    c0101ec9 <__alltraps>

c01023bb <vector136>:
.globl vector136
vector136:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $136
c01023bd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023c2:	e9 02 fb ff ff       	jmp    c0101ec9 <__alltraps>

c01023c7 <vector137>:
.globl vector137
vector137:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $137
c01023c9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023ce:	e9 f6 fa ff ff       	jmp    c0101ec9 <__alltraps>

c01023d3 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $138
c01023d5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023da:	e9 ea fa ff ff       	jmp    c0101ec9 <__alltraps>

c01023df <vector139>:
.globl vector139
vector139:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $139
c01023e1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023e6:	e9 de fa ff ff       	jmp    c0101ec9 <__alltraps>

c01023eb <vector140>:
.globl vector140
vector140:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $140
c01023ed:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023f2:	e9 d2 fa ff ff       	jmp    c0101ec9 <__alltraps>

c01023f7 <vector141>:
.globl vector141
vector141:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $141
c01023f9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023fe:	e9 c6 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102403 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $142
c0102405:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010240a:	e9 ba fa ff ff       	jmp    c0101ec9 <__alltraps>

c010240f <vector143>:
.globl vector143
vector143:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $143
c0102411:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102416:	e9 ae fa ff ff       	jmp    c0101ec9 <__alltraps>

c010241b <vector144>:
.globl vector144
vector144:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $144
c010241d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102422:	e9 a2 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102427 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $145
c0102429:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010242e:	e9 96 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102433 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $146
c0102435:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010243a:	e9 8a fa ff ff       	jmp    c0101ec9 <__alltraps>

c010243f <vector147>:
.globl vector147
vector147:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $147
c0102441:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102446:	e9 7e fa ff ff       	jmp    c0101ec9 <__alltraps>

c010244b <vector148>:
.globl vector148
vector148:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $148
c010244d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102452:	e9 72 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102457 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $149
c0102459:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010245e:	e9 66 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102463 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $150
c0102465:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010246a:	e9 5a fa ff ff       	jmp    c0101ec9 <__alltraps>

c010246f <vector151>:
.globl vector151
vector151:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $151
c0102471:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102476:	e9 4e fa ff ff       	jmp    c0101ec9 <__alltraps>

c010247b <vector152>:
.globl vector152
vector152:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $152
c010247d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102482:	e9 42 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102487 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $153
c0102489:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010248e:	e9 36 fa ff ff       	jmp    c0101ec9 <__alltraps>

c0102493 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $154
c0102495:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010249a:	e9 2a fa ff ff       	jmp    c0101ec9 <__alltraps>

c010249f <vector155>:
.globl vector155
vector155:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $155
c01024a1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024a6:	e9 1e fa ff ff       	jmp    c0101ec9 <__alltraps>

c01024ab <vector156>:
.globl vector156
vector156:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $156
c01024ad:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024b2:	e9 12 fa ff ff       	jmp    c0101ec9 <__alltraps>

c01024b7 <vector157>:
.globl vector157
vector157:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $157
c01024b9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024be:	e9 06 fa ff ff       	jmp    c0101ec9 <__alltraps>

c01024c3 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $158
c01024c5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024ca:	e9 fa f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01024cf <vector159>:
.globl vector159
vector159:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $159
c01024d1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024d6:	e9 ee f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01024db <vector160>:
.globl vector160
vector160:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $160
c01024dd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024e2:	e9 e2 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01024e7 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $161
c01024e9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024ee:	e9 d6 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01024f3 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $162
c01024f5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024fa:	e9 ca f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01024ff <vector163>:
.globl vector163
vector163:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $163
c0102501:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102506:	e9 be f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010250b <vector164>:
.globl vector164
vector164:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $164
c010250d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102512:	e9 b2 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102517 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $165
c0102519:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010251e:	e9 a6 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102523 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $166
c0102525:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010252a:	e9 9a f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010252f <vector167>:
.globl vector167
vector167:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $167
c0102531:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102536:	e9 8e f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010253b <vector168>:
.globl vector168
vector168:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $168
c010253d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102542:	e9 82 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102547 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $169
c0102549:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010254e:	e9 76 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102553 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $170
c0102555:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010255a:	e9 6a f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010255f <vector171>:
.globl vector171
vector171:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $171
c0102561:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102566:	e9 5e f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010256b <vector172>:
.globl vector172
vector172:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $172
c010256d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102572:	e9 52 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102577 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $173
c0102579:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010257e:	e9 46 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c0102583 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $174
c0102585:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010258a:	e9 3a f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010258f <vector175>:
.globl vector175
vector175:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $175
c0102591:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102596:	e9 2e f9 ff ff       	jmp    c0101ec9 <__alltraps>

c010259b <vector176>:
.globl vector176
vector176:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $176
c010259d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025a2:	e9 22 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01025a7 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $177
c01025a9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025ae:	e9 16 f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01025b3 <vector178>:
.globl vector178
vector178:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $178
c01025b5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025ba:	e9 0a f9 ff ff       	jmp    c0101ec9 <__alltraps>

c01025bf <vector179>:
.globl vector179
vector179:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $179
c01025c1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025c6:	e9 fe f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01025cb <vector180>:
.globl vector180
vector180:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $180
c01025cd:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025d2:	e9 f2 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01025d7 <vector181>:
.globl vector181
vector181:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $181
c01025d9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025de:	e9 e6 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01025e3 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $182
c01025e5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025ea:	e9 da f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01025ef <vector183>:
.globl vector183
vector183:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $183
c01025f1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025f6:	e9 ce f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01025fb <vector184>:
.globl vector184
vector184:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $184
c01025fd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102602:	e9 c2 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102607 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $185
c0102609:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010260e:	e9 b6 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102613 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $186
c0102615:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010261a:	e9 aa f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010261f <vector187>:
.globl vector187
vector187:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $187
c0102621:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102626:	e9 9e f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010262b <vector188>:
.globl vector188
vector188:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $188
c010262d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102632:	e9 92 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102637 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $189
c0102639:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010263e:	e9 86 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102643 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $190
c0102645:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010264a:	e9 7a f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010264f <vector191>:
.globl vector191
vector191:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $191
c0102651:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102656:	e9 6e f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010265b <vector192>:
.globl vector192
vector192:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $192
c010265d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102662:	e9 62 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102667 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $193
c0102669:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010266e:	e9 56 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102673 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $194
c0102675:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010267a:	e9 4a f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010267f <vector195>:
.globl vector195
vector195:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $195
c0102681:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102686:	e9 3e f8 ff ff       	jmp    c0101ec9 <__alltraps>

c010268b <vector196>:
.globl vector196
vector196:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $196
c010268d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102692:	e9 32 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c0102697 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $197
c0102699:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010269e:	e9 26 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01026a3 <vector198>:
.globl vector198
vector198:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $198
c01026a5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026aa:	e9 1a f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01026af <vector199>:
.globl vector199
vector199:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $199
c01026b1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026b6:	e9 0e f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01026bb <vector200>:
.globl vector200
vector200:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $200
c01026bd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026c2:	e9 02 f8 ff ff       	jmp    c0101ec9 <__alltraps>

c01026c7 <vector201>:
.globl vector201
vector201:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $201
c01026c9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026ce:	e9 f6 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01026d3 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $202
c01026d5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026da:	e9 ea f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01026df <vector203>:
.globl vector203
vector203:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $203
c01026e1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026e6:	e9 de f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01026eb <vector204>:
.globl vector204
vector204:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $204
c01026ed:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026f2:	e9 d2 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01026f7 <vector205>:
.globl vector205
vector205:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $205
c01026f9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026fe:	e9 c6 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102703 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $206
c0102705:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010270a:	e9 ba f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010270f <vector207>:
.globl vector207
vector207:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $207
c0102711:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102716:	e9 ae f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010271b <vector208>:
.globl vector208
vector208:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $208
c010271d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102722:	e9 a2 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102727 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $209
c0102729:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010272e:	e9 96 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102733 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $210
c0102735:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010273a:	e9 8a f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010273f <vector211>:
.globl vector211
vector211:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $211
c0102741:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102746:	e9 7e f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010274b <vector212>:
.globl vector212
vector212:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $212
c010274d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102752:	e9 72 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102757 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $213
c0102759:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010275e:	e9 66 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102763 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $214
c0102765:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010276a:	e9 5a f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010276f <vector215>:
.globl vector215
vector215:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $215
c0102771:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102776:	e9 4e f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010277b <vector216>:
.globl vector216
vector216:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $216
c010277d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102782:	e9 42 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102787 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $217
c0102789:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010278e:	e9 36 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c0102793 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $218
c0102795:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010279a:	e9 2a f7 ff ff       	jmp    c0101ec9 <__alltraps>

c010279f <vector219>:
.globl vector219
vector219:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $219
c01027a1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027a6:	e9 1e f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01027ab <vector220>:
.globl vector220
vector220:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $220
c01027ad:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027b2:	e9 12 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01027b7 <vector221>:
.globl vector221
vector221:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $221
c01027b9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027be:	e9 06 f7 ff ff       	jmp    c0101ec9 <__alltraps>

c01027c3 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $222
c01027c5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027ca:	e9 fa f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01027cf <vector223>:
.globl vector223
vector223:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $223
c01027d1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027d6:	e9 ee f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01027db <vector224>:
.globl vector224
vector224:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $224
c01027dd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027e2:	e9 e2 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01027e7 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $225
c01027e9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027ee:	e9 d6 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01027f3 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $226
c01027f5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027fa:	e9 ca f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01027ff <vector227>:
.globl vector227
vector227:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $227
c0102801:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102806:	e9 be f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010280b <vector228>:
.globl vector228
vector228:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $228
c010280d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102812:	e9 b2 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102817 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $229
c0102819:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010281e:	e9 a6 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102823 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $230
c0102825:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010282a:	e9 9a f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010282f <vector231>:
.globl vector231
vector231:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $231
c0102831:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102836:	e9 8e f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010283b <vector232>:
.globl vector232
vector232:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $232
c010283d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102842:	e9 82 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102847 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $233
c0102849:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010284e:	e9 76 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102853 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $234
c0102855:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010285a:	e9 6a f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010285f <vector235>:
.globl vector235
vector235:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $235
c0102861:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102866:	e9 5e f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010286b <vector236>:
.globl vector236
vector236:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $236
c010286d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102872:	e9 52 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102877 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $237
c0102879:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010287e:	e9 46 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c0102883 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $238
c0102885:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010288a:	e9 3a f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010288f <vector239>:
.globl vector239
vector239:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $239
c0102891:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102896:	e9 2e f6 ff ff       	jmp    c0101ec9 <__alltraps>

c010289b <vector240>:
.globl vector240
vector240:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $240
c010289d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028a2:	e9 22 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01028a7 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $241
c01028a9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028ae:	e9 16 f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01028b3 <vector242>:
.globl vector242
vector242:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $242
c01028b5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028ba:	e9 0a f6 ff ff       	jmp    c0101ec9 <__alltraps>

c01028bf <vector243>:
.globl vector243
vector243:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $243
c01028c1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028c6:	e9 fe f5 ff ff       	jmp    c0101ec9 <__alltraps>

c01028cb <vector244>:
.globl vector244
vector244:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $244
c01028cd:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028d2:	e9 f2 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c01028d7 <vector245>:
.globl vector245
vector245:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $245
c01028d9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028de:	e9 e6 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c01028e3 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $246
c01028e5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028ea:	e9 da f5 ff ff       	jmp    c0101ec9 <__alltraps>

c01028ef <vector247>:
.globl vector247
vector247:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $247
c01028f1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028f6:	e9 ce f5 ff ff       	jmp    c0101ec9 <__alltraps>

c01028fb <vector248>:
.globl vector248
vector248:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $248
c01028fd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102902:	e9 c2 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c0102907 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $249
c0102909:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010290e:	e9 b6 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c0102913 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $250
c0102915:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010291a:	e9 aa f5 ff ff       	jmp    c0101ec9 <__alltraps>

c010291f <vector251>:
.globl vector251
vector251:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $251
c0102921:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102926:	e9 9e f5 ff ff       	jmp    c0101ec9 <__alltraps>

c010292b <vector252>:
.globl vector252
vector252:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $252
c010292d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102932:	e9 92 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c0102937 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $253
c0102939:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010293e:	e9 86 f5 ff ff       	jmp    c0101ec9 <__alltraps>

c0102943 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $254
c0102945:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010294a:	e9 7a f5 ff ff       	jmp    c0101ec9 <__alltraps>

c010294f <vector255>:
.globl vector255
vector255:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $255
c0102951:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102956:	e9 6e f5 ff ff       	jmp    c0101ec9 <__alltraps>

c010295b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010295b:	55                   	push   %ebp
c010295c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010295e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102961:	a1 c0 b9 11 c0       	mov    0xc011b9c0,%eax
c0102966:	29 c2                	sub    %eax,%edx
c0102968:	89 d0                	mov    %edx,%eax
c010296a:	c1 f8 02             	sar    $0x2,%eax
c010296d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102973:	5d                   	pop    %ebp
c0102974:	c3                   	ret    

c0102975 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102975:	55                   	push   %ebp
c0102976:	89 e5                	mov    %esp,%ebp
c0102978:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010297b:	8b 45 08             	mov    0x8(%ebp),%eax
c010297e:	89 04 24             	mov    %eax,(%esp)
c0102981:	e8 d5 ff ff ff       	call   c010295b <page2ppn>
c0102986:	c1 e0 0c             	shl    $0xc,%eax
}
c0102989:	c9                   	leave  
c010298a:	c3                   	ret    

c010298b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010298b:	55                   	push   %ebp
c010298c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010298e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102991:	8b 00                	mov    (%eax),%eax
}
c0102993:	5d                   	pop    %ebp
c0102994:	c3                   	ret    

c0102995 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102995:	55                   	push   %ebp
c0102996:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102998:	8b 45 08             	mov    0x8(%ebp),%eax
c010299b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010299e:	89 10                	mov    %edx,(%eax)
}
c01029a0:	5d                   	pop    %ebp
c01029a1:	c3                   	ret    

c01029a2 <buddy_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
buddy_init(void) {
c01029a2:	55                   	push   %ebp
c01029a3:	89 e5                	mov    %esp,%ebp
c01029a5:	83 ec 10             	sub    $0x10,%esp
c01029a8:	c7 45 fc ac b9 11 c0 	movl   $0xc011b9ac,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01029af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029b5:	89 50 04             	mov    %edx,0x4(%eax)
c01029b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029bb:	8b 50 04             	mov    0x4(%eax),%edx
c01029be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029c1:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01029c3:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c01029ca:	00 00 00 
}
c01029cd:	c9                   	leave  
c01029ce:	c3                   	ret    

c01029cf <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {    
c01029cf:	55                   	push   %ebp
c01029d0:	89 e5                	mov    %esp,%ebp
c01029d2:	83 ec 68             	sub    $0x68,%esp
    cprintf("Memmap: 0x%x, size %d\n", base, n);
c01029d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029d8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01029dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01029df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01029e3:	c7 04 24 50 7a 10 c0 	movl   $0xc0107a50,(%esp)
c01029ea:	e8 54 d9 ff ff       	call   c0100343 <cprintf>
    // n must be a positive number
    assert(n > 0);
c01029ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01029f3:	75 24                	jne    c0102a19 <buddy_init_memmap+0x4a>
c01029f5:	c7 44 24 0c 67 7a 10 	movl   $0xc0107a67,0xc(%esp)
c01029fc:	c0 
c01029fd:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102a04:	c0 
c0102a05:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
c0102a0c:	00 
c0102a0d:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102a14:	e8 b6 e2 ff ff       	call   c0100ccf <__panic>

    struct Page *ptr = base;
c0102a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ptr < base + n; ptr++) {
c0102a1f:	e9 a3 00 00 00       	jmp    c0102ac7 <buddy_init_memmap+0xf8>
        assert(PageReserved(ptr));
c0102a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a27:	83 c0 04             	add    $0x4,%eax
c0102a2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a3a:	0f a3 10             	bt     %edx,(%eax)
c0102a3d:	19 c0                	sbb    %eax,%eax
c0102a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102a42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102a46:	0f 95 c0             	setne  %al
c0102a49:	0f b6 c0             	movzbl %al,%eax
c0102a4c:	85 c0                	test   %eax,%eax
c0102a4e:	75 24                	jne    c0102a74 <buddy_init_memmap+0xa5>
c0102a50:	c7 44 24 0c 96 7a 10 	movl   $0xc0107a96,0xc(%esp)
c0102a57:	c0 
c0102a58:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102a5f:	c0 
c0102a60:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
c0102a67:	00 
c0102a68:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102a6f:	e8 5b e2 ff ff       	call   c0100ccf <__panic>
        // clear flags
        ClearPageProperty(ptr);
c0102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a77:	83 c0 04             	add    $0x4,%eax
c0102a7a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a81:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a8a:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
c0102a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a90:	83 c0 04             	add    $0x4,%eax
c0102a93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102aa0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102aa3:	0f b3 10             	btr    %edx,(%eax)
        // no reference
        set_page_ref(ptr, 0);
c0102aa6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102aad:	00 
c0102aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab1:	89 04 24             	mov    %eax,(%esp)
c0102ab4:	e8 dc fe ff ff       	call   c0102995 <set_page_ref>
        ptr->property = 0;
c0102ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    cprintf("Memmap: 0x%x, size %d\n", base, n);
    // n must be a positive number
    assert(n > 0);

    struct Page *ptr = base;
    for (; ptr < base + n; ptr++) {
c0102ac3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aca:	89 d0                	mov    %edx,%eax
c0102acc:	c1 e0 02             	shl    $0x2,%eax
c0102acf:	01 d0                	add    %edx,%eax
c0102ad1:	c1 e0 02             	shl    $0x2,%eax
c0102ad4:	89 c2                	mov    %eax,%edx
c0102ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad9:	01 d0                	add    %edx,%eax
c0102adb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ade:	0f 87 40 ff ff ff    	ja     c0102a24 <buddy_init_memmap+0x55>
        // no reference
        set_page_ref(ptr, 0);
        ptr->property = 0;
    }
    // set bit and property of the first page
    SetPageProperty(base);
c0102ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae7:	83 c0 04             	add    $0x4,%eax
c0102aea:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102af1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102af4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102af7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102afa:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b00:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b03:	89 50 08             	mov    %edx,0x8(%eax)
    
    nr_free += n;
c0102b06:	8b 15 b4 b9 11 c0    	mov    0xc011b9b4,%edx
c0102b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b0f:	01 d0                	add    %edx,%eax
c0102b11:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4
    list_add(&free_list, &(base->page_link));
c0102b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b19:	83 c0 0c             	add    $0xc,%eax
c0102b1c:	c7 45 cc ac b9 11 c0 	movl   $0xc011b9ac,-0x34(%ebp)
c0102b23:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b29:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b35:	8b 40 04             	mov    0x4(%eax),%eax
c0102b38:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b3b:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102b3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b41:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102b44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b47:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b4a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b4d:	89 10                	mov    %edx,(%eax)
c0102b4f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b52:	8b 10                	mov    (%eax),%edx
c0102b54:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b57:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b5a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b5d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b60:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b63:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b66:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b69:	89 10                	mov    %edx,(%eax)
}
c0102b6b:	c9                   	leave  
c0102b6c:	c3                   	ret    

c0102b6d <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
c0102b6d:	55                   	push   %ebp
c0102b6e:	89 e5                	mov    %esp,%ebp
    return NULL;
c0102b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b75:	5d                   	pop    %ebp
c0102b76:	c3                   	ret    

c0102b77 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c0102b77:	55                   	push   %ebp
c0102b78:	89 e5                	mov    %esp,%ebp
    return;
c0102b7a:	90                   	nop
}
c0102b7b:	5d                   	pop    %ebp
c0102b7c:	c3                   	ret    

c0102b7d <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c0102b7d:	55                   	push   %ebp
c0102b7e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102b80:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
}
c0102b85:	5d                   	pop    %ebp
c0102b86:	c3                   	ret    

c0102b87 <output_free_list>:

static void
output_free_list(void) {
c0102b87:	55                   	push   %ebp
c0102b88:	89 e5                	mov    %esp,%ebp
c0102b8a:	57                   	push   %edi
c0102b8b:	56                   	push   %esi
c0102b8c:	53                   	push   %ebx
c0102b8d:	83 ec 5c             	sub    $0x5c,%esp
    int index = 0;
c0102b90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    struct Page *p = NULL;
c0102b97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    list_entry_t *le = &free_list;
c0102b9e:	c7 45 e0 ac b9 11 c0 	movl   $0xc011b9ac,-0x20(%ebp)
    cprintf("free_list: NR_FREE %d\n", nr_free);
c0102ba5:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0102baa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102bae:	c7 04 24 a8 7a 10 c0 	movl   $0xc0107aa8,(%esp)
c0102bb5:	e8 89 d7 ff ff       	call   c0100343 <cprintf>
    while ((le = list_next(le)) != &free_list) {
c0102bba:	e9 98 00 00 00       	jmp    c0102c57 <output_free_list+0xd0>
        p = le2page(le, page_link);
c0102bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bc2:	83 e8 0c             	sub    $0xc,%eax
c0102bc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
c0102bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bcb:	83 c0 04             	add    $0x4,%eax
c0102bce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0102bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bdb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bde:	0f a3 10             	bt     %edx,(%eax)
c0102be1:	19 c0                	sbb    %eax,%eax
c0102be3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0102be6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102bea:	0f 95 c0             	setne  %al
c0102bed:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
c0102bf0:	89 c6                	mov    %eax,%esi
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
c0102bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bf5:	83 c0 04             	add    $0x4,%eax
c0102bf8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0102bff:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c02:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c05:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c08:	0f a3 10             	bt     %edx,(%eax)
c0102c0b:	19 c0                	sbb    %eax,%eax
c0102c0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
c0102c10:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0102c14:	0f 95 c0             	setne  %al
c0102c17:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
c0102c1a:	89 c3                	mov    %eax,%ebx
c0102c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c1f:	8b 48 08             	mov    0x8(%eax),%ecx
c0102c22:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c25:	8b 10                	mov    (%eax),%edx
c0102c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c2a:	8d 78 01             	lea    0x1(%eax),%edi
c0102c2d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
c0102c30:	89 74 24 18          	mov    %esi,0x18(%esp)
c0102c34:	89 5c 24 14          	mov    %ebx,0x14(%esp)
c0102c38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102c3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102c40:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c43:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c4b:	c7 04 24 c0 7a 10 c0 	movl   $0xc0107ac0,(%esp)
c0102c52:	e8 ec d6 ff ff       	call   c0100343 <cprintf>
c0102c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c5a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c60:	8b 40 04             	mov    0x4(%eax),%eax
output_free_list(void) {
    int index = 0;
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
c0102c63:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c66:	81 7d e0 ac b9 11 c0 	cmpl   $0xc011b9ac,-0x20(%ebp)
c0102c6d:	0f 85 4c ff ff ff    	jne    c0102bbf <output_free_list+0x38>
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
    }
}
c0102c73:	83 c4 5c             	add    $0x5c,%esp
c0102c76:	5b                   	pop    %ebx
c0102c77:	5e                   	pop    %esi
c0102c78:	5f                   	pop    %edi
c0102c79:	5d                   	pop    %ebp
c0102c7a:	c3                   	ret    

c0102c7b <basic_check>:

static void
basic_check(void) {
c0102c7b:	55                   	push   %ebp
c0102c7c:	89 e5                	mov    %esp,%ebp
c0102c7e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102c9b:	e8 bb 23 00 00       	call   c010505b <alloc_pages>
c0102ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ca7:	75 24                	jne    c0102ccd <basic_check+0x52>
c0102ca9:	c7 44 24 0c 05 7b 10 	movl   $0xc0107b05,0xc(%esp)
c0102cb0:	c0 
c0102cb1:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102cb8:	c0 
c0102cb9:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c0102cc0:	00 
c0102cc1:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102cc8:	e8 02 e0 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ccd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102cd4:	e8 82 23 00 00       	call   c010505b <alloc_pages>
c0102cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ce0:	75 24                	jne    c0102d06 <basic_check+0x8b>
c0102ce2:	c7 44 24 0c 21 7b 10 	movl   $0xc0107b21,0xc(%esp)
c0102ce9:	c0 
c0102cea:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102cf1:	c0 
c0102cf2:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0102cf9:	00 
c0102cfa:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102d01:	e8 c9 df ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102d06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d0d:	e8 49 23 00 00       	call   c010505b <alloc_pages>
c0102d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102d19:	75 24                	jne    c0102d3f <basic_check+0xc4>
c0102d1b:	c7 44 24 0c 3d 7b 10 	movl   $0xc0107b3d,0xc(%esp)
c0102d22:	c0 
c0102d23:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102d2a:	c0 
c0102d2b:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
c0102d32:	00 
c0102d33:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102d3a:	e8 90 df ff ff       	call   c0100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d45:	74 10                	je     c0102d57 <basic_check+0xdc>
c0102d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d4d:	74 08                	je     c0102d57 <basic_check+0xdc>
c0102d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d55:	75 24                	jne    c0102d7b <basic_check+0x100>
c0102d57:	c7 44 24 0c 5c 7b 10 	movl   $0xc0107b5c,0xc(%esp)
c0102d5e:	c0 
c0102d5f:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102d66:	c0 
c0102d67:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
c0102d6e:	00 
c0102d6f:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102d76:	e8 54 df ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d7e:	89 04 24             	mov    %eax,(%esp)
c0102d81:	e8 05 fc ff ff       	call   c010298b <page_ref>
c0102d86:	85 c0                	test   %eax,%eax
c0102d88:	75 1e                	jne    c0102da8 <basic_check+0x12d>
c0102d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d8d:	89 04 24             	mov    %eax,(%esp)
c0102d90:	e8 f6 fb ff ff       	call   c010298b <page_ref>
c0102d95:	85 c0                	test   %eax,%eax
c0102d97:	75 0f                	jne    c0102da8 <basic_check+0x12d>
c0102d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9c:	89 04 24             	mov    %eax,(%esp)
c0102d9f:	e8 e7 fb ff ff       	call   c010298b <page_ref>
c0102da4:	85 c0                	test   %eax,%eax
c0102da6:	74 24                	je     c0102dcc <basic_check+0x151>
c0102da8:	c7 44 24 0c 80 7b 10 	movl   $0xc0107b80,0xc(%esp)
c0102daf:	c0 
c0102db0:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102db7:	c0 
c0102db8:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
c0102dbf:	00 
c0102dc0:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102dc7:	e8 03 df ff ff       	call   c0100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dcf:	89 04 24             	mov    %eax,(%esp)
c0102dd2:	e8 9e fb ff ff       	call   c0102975 <page2pa>
c0102dd7:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0102ddd:	c1 e2 0c             	shl    $0xc,%edx
c0102de0:	39 d0                	cmp    %edx,%eax
c0102de2:	72 24                	jb     c0102e08 <basic_check+0x18d>
c0102de4:	c7 44 24 0c bc 7b 10 	movl   $0xc0107bbc,0xc(%esp)
c0102deb:	c0 
c0102dec:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102df3:	c0 
c0102df4:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c0102dfb:	00 
c0102dfc:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102e03:	e8 c7 de ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e0b:	89 04 24             	mov    %eax,(%esp)
c0102e0e:	e8 62 fb ff ff       	call   c0102975 <page2pa>
c0102e13:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0102e19:	c1 e2 0c             	shl    $0xc,%edx
c0102e1c:	39 d0                	cmp    %edx,%eax
c0102e1e:	72 24                	jb     c0102e44 <basic_check+0x1c9>
c0102e20:	c7 44 24 0c d9 7b 10 	movl   $0xc0107bd9,0xc(%esp)
c0102e27:	c0 
c0102e28:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102e2f:	c0 
c0102e30:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c0102e37:	00 
c0102e38:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102e3f:	e8 8b de ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e47:	89 04 24             	mov    %eax,(%esp)
c0102e4a:	e8 26 fb ff ff       	call   c0102975 <page2pa>
c0102e4f:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0102e55:	c1 e2 0c             	shl    $0xc,%edx
c0102e58:	39 d0                	cmp    %edx,%eax
c0102e5a:	72 24                	jb     c0102e80 <basic_check+0x205>
c0102e5c:	c7 44 24 0c f6 7b 10 	movl   $0xc0107bf6,0xc(%esp)
c0102e63:	c0 
c0102e64:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102e6b:	c0 
c0102e6c:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0102e73:	00 
c0102e74:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102e7b:	e8 4f de ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c0102e80:	a1 ac b9 11 c0       	mov    0xc011b9ac,%eax
c0102e85:	8b 15 b0 b9 11 c0    	mov    0xc011b9b0,%edx
c0102e8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e8e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e91:	c7 45 e0 ac b9 11 c0 	movl   $0xc011b9ac,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102e9e:	89 50 04             	mov    %edx,0x4(%eax)
c0102ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ea4:	8b 50 04             	mov    0x4(%eax),%edx
c0102ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102eaa:	89 10                	mov    %edx,(%eax)
c0102eac:	c7 45 dc ac b9 11 c0 	movl   $0xc011b9ac,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102eb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102eb6:	8b 40 04             	mov    0x4(%eax),%eax
c0102eb9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102ebc:	0f 94 c0             	sete   %al
c0102ebf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102ec2:	85 c0                	test   %eax,%eax
c0102ec4:	75 24                	jne    c0102eea <basic_check+0x26f>
c0102ec6:	c7 44 24 0c 13 7c 10 	movl   $0xc0107c13,0xc(%esp)
c0102ecd:	c0 
c0102ece:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102ed5:	c0 
c0102ed6:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0102edd:	00 
c0102ede:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102ee5:	e8 e5 dd ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c0102eea:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0102eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102ef2:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c0102ef9:	00 00 00 

    assert(alloc_page() == NULL);
c0102efc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f03:	e8 53 21 00 00       	call   c010505b <alloc_pages>
c0102f08:	85 c0                	test   %eax,%eax
c0102f0a:	74 24                	je     c0102f30 <basic_check+0x2b5>
c0102f0c:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c0102f13:	c0 
c0102f14:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102f1b:	c0 
c0102f1c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0102f23:	00 
c0102f24:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102f2b:	e8 9f dd ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c0102f30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102f37:	00 
c0102f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f3b:	89 04 24             	mov    %eax,(%esp)
c0102f3e:	e8 50 21 00 00       	call   c0105093 <free_pages>
    free_page(p1);
c0102f43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102f4a:	00 
c0102f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f4e:	89 04 24             	mov    %eax,(%esp)
c0102f51:	e8 3d 21 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c0102f56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102f5d:	00 
c0102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f61:	89 04 24             	mov    %eax,(%esp)
c0102f64:	e8 2a 21 00 00       	call   c0105093 <free_pages>
    assert(nr_free == 3);
c0102f69:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0102f6e:	83 f8 03             	cmp    $0x3,%eax
c0102f71:	74 24                	je     c0102f97 <basic_check+0x31c>
c0102f73:	c7 44 24 0c 3f 7c 10 	movl   $0xc0107c3f,0xc(%esp)
c0102f7a:	c0 
c0102f7b:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102f82:	c0 
c0102f83:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102f8a:	00 
c0102f8b:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102f92:	e8 38 dd ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
c0102f97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f9e:	e8 b8 20 00 00       	call   c010505b <alloc_pages>
c0102fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102fa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102faa:	75 24                	jne    c0102fd0 <basic_check+0x355>
c0102fac:	c7 44 24 0c 05 7b 10 	movl   $0xc0107b05,0xc(%esp)
c0102fb3:	c0 
c0102fb4:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102fbb:	c0 
c0102fbc:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0102fc3:	00 
c0102fc4:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0102fcb:	e8 ff dc ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fd7:	e8 7f 20 00 00       	call   c010505b <alloc_pages>
c0102fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102fe3:	75 24                	jne    c0103009 <basic_check+0x38e>
c0102fe5:	c7 44 24 0c 21 7b 10 	movl   $0xc0107b21,0xc(%esp)
c0102fec:	c0 
c0102fed:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0102ff4:	c0 
c0102ff5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102ffc:	00 
c0102ffd:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103004:	e8 c6 dc ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103009:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103010:	e8 46 20 00 00       	call   c010505b <alloc_pages>
c0103015:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010301c:	75 24                	jne    c0103042 <basic_check+0x3c7>
c010301e:	c7 44 24 0c 3d 7b 10 	movl   $0xc0107b3d,0xc(%esp)
c0103025:	c0 
c0103026:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c010302d:	c0 
c010302e:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0103035:	00 
c0103036:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c010303d:	e8 8d dc ff ff       	call   c0100ccf <__panic>

    assert(alloc_page() == NULL);
c0103042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103049:	e8 0d 20 00 00       	call   c010505b <alloc_pages>
c010304e:	85 c0                	test   %eax,%eax
c0103050:	74 24                	je     c0103076 <basic_check+0x3fb>
c0103052:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c0103059:	c0 
c010305a:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103061:	c0 
c0103062:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0103069:	00 
c010306a:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103071:	e8 59 dc ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c0103076:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010307d:	00 
c010307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103081:	89 04 24             	mov    %eax,(%esp)
c0103084:	e8 0a 20 00 00       	call   c0105093 <free_pages>
c0103089:	c7 45 d8 ac b9 11 c0 	movl   $0xc011b9ac,-0x28(%ebp)
c0103090:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103093:	8b 40 04             	mov    0x4(%eax),%eax
c0103096:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103099:	0f 94 c0             	sete   %al
c010309c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010309f:	85 c0                	test   %eax,%eax
c01030a1:	74 24                	je     c01030c7 <basic_check+0x44c>
c01030a3:	c7 44 24 0c 4c 7c 10 	movl   $0xc0107c4c,0xc(%esp)
c01030aa:	c0 
c01030ab:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01030b2:	c0 
c01030b3:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01030ba:	00 
c01030bb:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01030c2:	e8 08 dc ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01030c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030ce:	e8 88 1f 00 00       	call   c010505b <alloc_pages>
c01030d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01030d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01030dc:	74 24                	je     c0103102 <basic_check+0x487>
c01030de:	c7 44 24 0c 64 7c 10 	movl   $0xc0107c64,0xc(%esp)
c01030e5:	c0 
c01030e6:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01030ed:	c0 
c01030ee:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01030f5:	00 
c01030f6:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01030fd:	e8 cd db ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0103102:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103109:	e8 4d 1f 00 00       	call   c010505b <alloc_pages>
c010310e:	85 c0                	test   %eax,%eax
c0103110:	74 24                	je     c0103136 <basic_check+0x4bb>
c0103112:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c0103119:	c0 
c010311a:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103121:	c0 
c0103122:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c0103129:	00 
c010312a:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103131:	e8 99 db ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c0103136:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c010313b:	85 c0                	test   %eax,%eax
c010313d:	74 24                	je     c0103163 <basic_check+0x4e8>
c010313f:	c7 44 24 0c 7d 7c 10 	movl   $0xc0107c7d,0xc(%esp)
c0103146:	c0 
c0103147:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c010314e:	c0 
c010314f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0103156:	00 
c0103157:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c010315e:	e8 6c db ff ff       	call   c0100ccf <__panic>
    free_list = free_list_store;
c0103163:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103166:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103169:	a3 ac b9 11 c0       	mov    %eax,0xc011b9ac
c010316e:	89 15 b0 b9 11 c0    	mov    %edx,0xc011b9b0
    nr_free = nr_free_store;
c0103174:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103177:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4

    free_page(p);
c010317c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103183:	00 
c0103184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103187:	89 04 24             	mov    %eax,(%esp)
c010318a:	e8 04 1f 00 00       	call   c0105093 <free_pages>
    free_page(p1);
c010318f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103196:	00 
c0103197:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010319a:	89 04 24             	mov    %eax,(%esp)
c010319d:	e8 f1 1e 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c01031a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031a9:	00 
c01031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ad:	89 04 24             	mov    %eax,(%esp)
c01031b0:	e8 de 1e 00 00       	call   c0105093 <free_pages>
}
c01031b5:	c9                   	leave  
c01031b6:	c3                   	ret    

c01031b7 <buddy_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_check(void) {
c01031b7:	55                   	push   %ebp
c01031b8:	89 e5                	mov    %esp,%ebp
c01031ba:	53                   	push   %ebx
c01031bb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01031c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01031c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01031cf:	c7 45 ec ac b9 11 c0 	movl   $0xc011b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01031d6:	eb 6b                	jmp    c0103243 <buddy_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031db:	83 e8 0c             	sub    $0xc,%eax
c01031de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031e4:	83 c0 04             	add    $0x4,%eax
c01031e7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01031ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01031f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01031f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01031f7:	0f a3 10             	bt     %edx,(%eax)
c01031fa:	19 c0                	sbb    %eax,%eax
c01031fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01031ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103203:	0f 95 c0             	setne  %al
c0103206:	0f b6 c0             	movzbl %al,%eax
c0103209:	85 c0                	test   %eax,%eax
c010320b:	75 24                	jne    c0103231 <buddy_check+0x7a>
c010320d:	c7 44 24 0c 8a 7c 10 	movl   $0xc0107c8a,0xc(%esp)
c0103214:	c0 
c0103215:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c010321c:	c0 
c010321d:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0103224:	00 
c0103225:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c010322c:	e8 9e da ff ff       	call   c0100ccf <__panic>
        count ++, total += p->property;
c0103231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103235:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103238:	8b 50 08             	mov    0x8(%eax),%edx
c010323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010323e:	01 d0                	add    %edx,%eax
c0103240:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103243:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103246:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103249:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010324c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010324f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103252:	81 7d ec ac b9 11 c0 	cmpl   $0xc011b9ac,-0x14(%ebp)
c0103259:	0f 85 79 ff ff ff    	jne    c01031d8 <buddy_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010325f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103262:	e8 5e 1e 00 00       	call   c01050c5 <nr_free_pages>
c0103267:	39 c3                	cmp    %eax,%ebx
c0103269:	74 24                	je     c010328f <buddy_check+0xd8>
c010326b:	c7 44 24 0c 9a 7c 10 	movl   $0xc0107c9a,0xc(%esp)
c0103272:	c0 
c0103273:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c010327a:	c0 
c010327b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
c0103282:	00 
c0103283:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c010328a:	e8 40 da ff ff       	call   c0100ccf <__panic>

    basic_check();
c010328f:	e8 e7 f9 ff ff       	call   c0102c7b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103294:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010329b:	e8 bb 1d 00 00       	call   c010505b <alloc_pages>
c01032a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01032a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01032a7:	75 24                	jne    c01032cd <buddy_check+0x116>
c01032a9:	c7 44 24 0c b3 7c 10 	movl   $0xc0107cb3,0xc(%esp)
c01032b0:	c0 
c01032b1:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01032b8:	c0 
c01032b9:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
c01032c0:	00 
c01032c1:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01032c8:	e8 02 da ff ff       	call   c0100ccf <__panic>
    assert(!PageProperty(p0));
c01032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032d0:	83 c0 04             	add    $0x4,%eax
c01032d3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01032da:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01032e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01032e3:	0f a3 10             	bt     %edx,(%eax)
c01032e6:	19 c0                	sbb    %eax,%eax
c01032e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01032eb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01032ef:	0f 95 c0             	setne  %al
c01032f2:	0f b6 c0             	movzbl %al,%eax
c01032f5:	85 c0                	test   %eax,%eax
c01032f7:	74 24                	je     c010331d <buddy_check+0x166>
c01032f9:	c7 44 24 0c be 7c 10 	movl   $0xc0107cbe,0xc(%esp)
c0103300:	c0 
c0103301:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103308:	c0 
c0103309:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
c0103310:	00 
c0103311:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103318:	e8 b2 d9 ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c010331d:	a1 ac b9 11 c0       	mov    0xc011b9ac,%eax
c0103322:	8b 15 b0 b9 11 c0    	mov    0xc011b9b0,%edx
c0103328:	89 45 80             	mov    %eax,-0x80(%ebp)
c010332b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010332e:	c7 45 b4 ac b9 11 c0 	movl   $0xc011b9ac,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103335:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103338:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010333b:	89 50 04             	mov    %edx,0x4(%eax)
c010333e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103341:	8b 50 04             	mov    0x4(%eax),%edx
c0103344:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103347:	89 10                	mov    %edx,(%eax)
c0103349:	c7 45 b0 ac b9 11 c0 	movl   $0xc011b9ac,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103350:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103353:	8b 40 04             	mov    0x4(%eax),%eax
c0103356:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103359:	0f 94 c0             	sete   %al
c010335c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010335f:	85 c0                	test   %eax,%eax
c0103361:	75 24                	jne    c0103387 <buddy_check+0x1d0>
c0103363:	c7 44 24 0c 13 7c 10 	movl   $0xc0107c13,0xc(%esp)
c010336a:	c0 
c010336b:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103372:	c0 
c0103373:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
c010337a:	00 
c010337b:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103382:	e8 48 d9 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0103387:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010338e:	e8 c8 1c 00 00       	call   c010505b <alloc_pages>
c0103393:	85 c0                	test   %eax,%eax
c0103395:	74 24                	je     c01033bb <buddy_check+0x204>
c0103397:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c010339e:	c0 
c010339f:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01033a6:	c0 
c01033a7:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c01033ae:	00 
c01033af:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01033b6:	e8 14 d9 ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c01033bb:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c01033c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01033c3:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c01033ca:	00 00 00 

    free_pages(p0 + 2, 3);
c01033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033d0:	83 c0 28             	add    $0x28,%eax
c01033d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01033da:	00 
c01033db:	89 04 24             	mov    %eax,(%esp)
c01033de:	e8 b0 1c 00 00       	call   c0105093 <free_pages>
    assert(alloc_pages(4) == NULL);
c01033e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01033ea:	e8 6c 1c 00 00       	call   c010505b <alloc_pages>
c01033ef:	85 c0                	test   %eax,%eax
c01033f1:	74 24                	je     c0103417 <buddy_check+0x260>
c01033f3:	c7 44 24 0c d0 7c 10 	movl   $0xc0107cd0,0xc(%esp)
c01033fa:	c0 
c01033fb:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103402:	c0 
c0103403:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c010340a:	00 
c010340b:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103412:	e8 b8 d8 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010341a:	83 c0 28             	add    $0x28,%eax
c010341d:	83 c0 04             	add    $0x4,%eax
c0103420:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103427:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010342a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010342d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103430:	0f a3 10             	bt     %edx,(%eax)
c0103433:	19 c0                	sbb    %eax,%eax
c0103435:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103438:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010343c:	0f 95 c0             	setne  %al
c010343f:	0f b6 c0             	movzbl %al,%eax
c0103442:	85 c0                	test   %eax,%eax
c0103444:	74 0e                	je     c0103454 <buddy_check+0x29d>
c0103446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103449:	83 c0 28             	add    $0x28,%eax
c010344c:	8b 40 08             	mov    0x8(%eax),%eax
c010344f:	83 f8 03             	cmp    $0x3,%eax
c0103452:	74 24                	je     c0103478 <buddy_check+0x2c1>
c0103454:	c7 44 24 0c e8 7c 10 	movl   $0xc0107ce8,0xc(%esp)
c010345b:	c0 
c010345c:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103463:	c0 
c0103464:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010346b:	00 
c010346c:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103473:	e8 57 d8 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103478:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010347f:	e8 d7 1b 00 00       	call   c010505b <alloc_pages>
c0103484:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103487:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010348b:	75 24                	jne    c01034b1 <buddy_check+0x2fa>
c010348d:	c7 44 24 0c 14 7d 10 	movl   $0xc0107d14,0xc(%esp)
c0103494:	c0 
c0103495:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c010349c:	c0 
c010349d:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c01034a4:	00 
c01034a5:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01034ac:	e8 1e d8 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01034b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034b8:	e8 9e 1b 00 00       	call   c010505b <alloc_pages>
c01034bd:	85 c0                	test   %eax,%eax
c01034bf:	74 24                	je     c01034e5 <buddy_check+0x32e>
c01034c1:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c01034c8:	c0 
c01034c9:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01034d0:	c0 
c01034d1:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01034d8:	00 
c01034d9:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01034e0:	e8 ea d7 ff ff       	call   c0100ccf <__panic>
    assert(p0 + 2 == p1);
c01034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034e8:	83 c0 28             	add    $0x28,%eax
c01034eb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01034ee:	74 24                	je     c0103514 <buddy_check+0x35d>
c01034f0:	c7 44 24 0c 32 7d 10 	movl   $0xc0107d32,0xc(%esp)
c01034f7:	c0 
c01034f8:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01034ff:	c0 
c0103500:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0103507:	00 
c0103508:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c010350f:	e8 bb d7 ff ff       	call   c0100ccf <__panic>

    p2 = p0 + 1;
c0103514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103517:	83 c0 14             	add    $0x14,%eax
c010351a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010351d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103524:	00 
c0103525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103528:	89 04 24             	mov    %eax,(%esp)
c010352b:	e8 63 1b 00 00       	call   c0105093 <free_pages>
    free_pages(p1, 3);
c0103530:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103537:	00 
c0103538:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010353b:	89 04 24             	mov    %eax,(%esp)
c010353e:	e8 50 1b 00 00       	call   c0105093 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103546:	83 c0 04             	add    $0x4,%eax
c0103549:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103550:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103553:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103556:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103559:	0f a3 10             	bt     %edx,(%eax)
c010355c:	19 c0                	sbb    %eax,%eax
c010355e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103561:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103565:	0f 95 c0             	setne  %al
c0103568:	0f b6 c0             	movzbl %al,%eax
c010356b:	85 c0                	test   %eax,%eax
c010356d:	74 0b                	je     c010357a <buddy_check+0x3c3>
c010356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103572:	8b 40 08             	mov    0x8(%eax),%eax
c0103575:	83 f8 01             	cmp    $0x1,%eax
c0103578:	74 24                	je     c010359e <buddy_check+0x3e7>
c010357a:	c7 44 24 0c 40 7d 10 	movl   $0xc0107d40,0xc(%esp)
c0103581:	c0 
c0103582:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103589:	c0 
c010358a:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0103591:	00 
c0103592:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103599:	e8 31 d7 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010359e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035a1:	83 c0 04             	add    $0x4,%eax
c01035a4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01035ab:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035ae:	8b 45 90             	mov    -0x70(%ebp),%eax
c01035b1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01035b4:	0f a3 10             	bt     %edx,(%eax)
c01035b7:	19 c0                	sbb    %eax,%eax
c01035b9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01035bc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01035c0:	0f 95 c0             	setne  %al
c01035c3:	0f b6 c0             	movzbl %al,%eax
c01035c6:	85 c0                	test   %eax,%eax
c01035c8:	74 0b                	je     c01035d5 <buddy_check+0x41e>
c01035ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035cd:	8b 40 08             	mov    0x8(%eax),%eax
c01035d0:	83 f8 03             	cmp    $0x3,%eax
c01035d3:	74 24                	je     c01035f9 <buddy_check+0x442>
c01035d5:	c7 44 24 0c 68 7d 10 	movl   $0xc0107d68,0xc(%esp)
c01035dc:	c0 
c01035dd:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01035e4:	c0 
c01035e5:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01035ec:	00 
c01035ed:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01035f4:	e8 d6 d6 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01035f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103600:	e8 56 1a 00 00       	call   c010505b <alloc_pages>
c0103605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103608:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010360b:	83 e8 14             	sub    $0x14,%eax
c010360e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103611:	74 24                	je     c0103637 <buddy_check+0x480>
c0103613:	c7 44 24 0c 8e 7d 10 	movl   $0xc0107d8e,0xc(%esp)
c010361a:	c0 
c010361b:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103622:	c0 
c0103623:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c010362a:	00 
c010362b:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103632:	e8 98 d6 ff ff       	call   c0100ccf <__panic>
    free_page(p0);
c0103637:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010363e:	00 
c010363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103642:	89 04 24             	mov    %eax,(%esp)
c0103645:	e8 49 1a 00 00       	call   c0105093 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010364a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103651:	e8 05 1a 00 00       	call   c010505b <alloc_pages>
c0103656:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103659:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010365c:	83 c0 14             	add    $0x14,%eax
c010365f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103662:	74 24                	je     c0103688 <buddy_check+0x4d1>
c0103664:	c7 44 24 0c ac 7d 10 	movl   $0xc0107dac,0xc(%esp)
c010366b:	c0 
c010366c:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103673:	c0 
c0103674:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c010367b:	00 
c010367c:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103683:	e8 47 d6 ff ff       	call   c0100ccf <__panic>

    free_pages(p0, 2);
c0103688:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010368f:	00 
c0103690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103693:	89 04 24             	mov    %eax,(%esp)
c0103696:	e8 f8 19 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c010369b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036a2:	00 
c01036a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036a6:	89 04 24             	mov    %eax,(%esp)
c01036a9:	e8 e5 19 00 00       	call   c0105093 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01036ae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01036b5:	e8 a1 19 00 00       	call   c010505b <alloc_pages>
c01036ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01036c1:	75 24                	jne    c01036e7 <buddy_check+0x530>
c01036c3:	c7 44 24 0c cc 7d 10 	movl   $0xc0107dcc,0xc(%esp)
c01036ca:	c0 
c01036cb:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01036d2:	c0 
c01036d3:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c01036da:	00 
c01036db:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01036e2:	e8 e8 d5 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01036e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036ee:	e8 68 19 00 00       	call   c010505b <alloc_pages>
c01036f3:	85 c0                	test   %eax,%eax
c01036f5:	74 24                	je     c010371b <buddy_check+0x564>
c01036f7:	c7 44 24 0c 2a 7c 10 	movl   $0xc0107c2a,0xc(%esp)
c01036fe:	c0 
c01036ff:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103706:	c0 
c0103707:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010370e:	00 
c010370f:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103716:	e8 b4 d5 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c010371b:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0103720:	85 c0                	test   %eax,%eax
c0103722:	74 24                	je     c0103748 <buddy_check+0x591>
c0103724:	c7 44 24 0c 7d 7c 10 	movl   $0xc0107c7d,0xc(%esp)
c010372b:	c0 
c010372c:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c0103733:	c0 
c0103734:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c010373b:	00 
c010373c:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103743:	e8 87 d5 ff ff       	call   c0100ccf <__panic>
    nr_free = nr_free_store;
c0103748:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010374b:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4

    free_list = free_list_store;
c0103750:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103753:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103756:	a3 ac b9 11 c0       	mov    %eax,0xc011b9ac
c010375b:	89 15 b0 b9 11 c0    	mov    %edx,0xc011b9b0
    free_pages(p0, 5);
c0103761:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103768:	00 
c0103769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010376c:	89 04 24             	mov    %eax,(%esp)
c010376f:	e8 1f 19 00 00       	call   c0105093 <free_pages>

    le = &free_list;
c0103774:	c7 45 ec ac b9 11 c0 	movl   $0xc011b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010377b:	eb 1d                	jmp    c010379a <buddy_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010377d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103780:	83 e8 0c             	sub    $0xc,%eax
c0103783:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103786:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010378a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010378d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103790:	8b 40 08             	mov    0x8(%eax),%eax
c0103793:	29 c2                	sub    %eax,%edx
c0103795:	89 d0                	mov    %edx,%eax
c0103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010379a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010379d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037a0:	8b 45 88             	mov    -0x78(%ebp),%eax
c01037a3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01037a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a9:	81 7d ec ac b9 11 c0 	cmpl   $0xc011b9ac,-0x14(%ebp)
c01037b0:	75 cb                	jne    c010377d <buddy_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037b6:	74 24                	je     c01037dc <buddy_check+0x625>
c01037b8:	c7 44 24 0c ea 7d 10 	movl   $0xc0107dea,0xc(%esp)
c01037bf:	c0 
c01037c0:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01037c7:	c0 
c01037c8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01037cf:	00 
c01037d0:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c01037d7:	e8 f3 d4 ff ff       	call   c0100ccf <__panic>
    assert(total == 0);
c01037dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037e0:	74 24                	je     c0103806 <buddy_check+0x64f>
c01037e2:	c7 44 24 0c f5 7d 10 	movl   $0xc0107df5,0xc(%esp)
c01037e9:	c0 
c01037ea:	c7 44 24 08 6d 7a 10 	movl   $0xc0107a6d,0x8(%esp)
c01037f1:	c0 
c01037f2:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01037f9:	00 
c01037fa:	c7 04 24 82 7a 10 c0 	movl   $0xc0107a82,(%esp)
c0103801:	e8 c9 d4 ff ff       	call   c0100ccf <__panic>
}
c0103806:	81 c4 94 00 00 00    	add    $0x94,%esp
c010380c:	5b                   	pop    %ebx
c010380d:	5d                   	pop    %ebp
c010380e:	c3                   	ret    

c010380f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010380f:	55                   	push   %ebp
c0103810:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103812:	8b 55 08             	mov    0x8(%ebp),%edx
c0103815:	a1 c0 b9 11 c0       	mov    0xc011b9c0,%eax
c010381a:	29 c2                	sub    %eax,%edx
c010381c:	89 d0                	mov    %edx,%eax
c010381e:	c1 f8 02             	sar    $0x2,%eax
c0103821:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103827:	5d                   	pop    %ebp
c0103828:	c3                   	ret    

c0103829 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103829:	55                   	push   %ebp
c010382a:	89 e5                	mov    %esp,%ebp
c010382c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010382f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103832:	89 04 24             	mov    %eax,(%esp)
c0103835:	e8 d5 ff ff ff       	call   c010380f <page2ppn>
c010383a:	c1 e0 0c             	shl    $0xc,%eax
}
c010383d:	c9                   	leave  
c010383e:	c3                   	ret    

c010383f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010383f:	55                   	push   %ebp
c0103840:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103842:	8b 45 08             	mov    0x8(%ebp),%eax
c0103845:	8b 00                	mov    (%eax),%eax
}
c0103847:	5d                   	pop    %ebp
c0103848:	c3                   	ret    

c0103849 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103849:	55                   	push   %ebp
c010384a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010384c:	8b 45 08             	mov    0x8(%ebp),%eax
c010384f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103852:	89 10                	mov    %edx,(%eax)
}
c0103854:	5d                   	pop    %ebp
c0103855:	c3                   	ret    

c0103856 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103856:	55                   	push   %ebp
c0103857:	89 e5                	mov    %esp,%ebp
c0103859:	83 ec 10             	sub    $0x10,%esp
c010385c:	c7 45 fc ac b9 11 c0 	movl   $0xc011b9ac,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103863:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103866:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103869:	89 50 04             	mov    %edx,0x4(%eax)
c010386c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010386f:	8b 50 04             	mov    0x4(%eax),%edx
c0103872:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103875:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103877:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c010387e:	00 00 00 
}
c0103881:	c9                   	leave  
c0103882:	c3                   	ret    

c0103883 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {    
c0103883:	55                   	push   %ebp
c0103884:	89 e5                	mov    %esp,%ebp
c0103886:	83 ec 68             	sub    $0x68,%esp
    cprintf("Memmap: 0x%x, size %d\n", base, n);
c0103889:	8b 45 0c             	mov    0xc(%ebp),%eax
c010388c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103890:	8b 45 08             	mov    0x8(%ebp),%eax
c0103893:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103897:	c7 04 24 30 7e 10 c0 	movl   $0xc0107e30,(%esp)
c010389e:	e8 a0 ca ff ff       	call   c0100343 <cprintf>
    // n must be a positive number
    assert(n > 0);
c01038a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01038a7:	75 24                	jne    c01038cd <default_init_memmap+0x4a>
c01038a9:	c7 44 24 0c 47 7e 10 	movl   $0xc0107e47,0xc(%esp)
c01038b0:	c0 
c01038b1:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01038b8:	c0 
c01038b9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01038c0:	00 
c01038c1:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01038c8:	e8 02 d4 ff ff       	call   c0100ccf <__panic>

    struct Page *ptr = base;
c01038cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01038d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ptr < base + n; ptr++) {
c01038d3:	e9 a3 00 00 00       	jmp    c010397b <default_init_memmap+0xf8>
        assert(PageReserved(ptr));
c01038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038db:	83 c0 04             	add    $0x4,%eax
c01038de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01038e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01038ee:	0f a3 10             	bt     %edx,(%eax)
c01038f1:	19 c0                	sbb    %eax,%eax
c01038f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01038f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01038fa:	0f 95 c0             	setne  %al
c01038fd:	0f b6 c0             	movzbl %al,%eax
c0103900:	85 c0                	test   %eax,%eax
c0103902:	75 24                	jne    c0103928 <default_init_memmap+0xa5>
c0103904:	c7 44 24 0c 78 7e 10 	movl   $0xc0107e78,0xc(%esp)
c010390b:	c0 
c010390c:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0103913:	c0 
c0103914:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
c010391b:	00 
c010391c:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0103923:	e8 a7 d3 ff ff       	call   c0100ccf <__panic>
        // clear flags
        ClearPageProperty(ptr);
c0103928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010392b:	83 c0 04             	add    $0x4,%eax
c010392e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103935:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103938:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010393b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010393e:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
c0103941:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103944:	83 c0 04             	add    $0x4,%eax
c0103947:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010394e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103951:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103954:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103957:	0f b3 10             	btr    %edx,(%eax)
        // no reference
        set_page_ref(ptr, 0);
c010395a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103961:	00 
c0103962:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103965:	89 04 24             	mov    %eax,(%esp)
c0103968:	e8 dc fe ff ff       	call   c0103849 <set_page_ref>
        ptr->property = 0;
c010396d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103970:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    cprintf("Memmap: 0x%x, size %d\n", base, n);
    // n must be a positive number
    assert(n > 0);

    struct Page *ptr = base;
    for (; ptr < base + n; ptr++) {
c0103977:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010397b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010397e:	89 d0                	mov    %edx,%eax
c0103980:	c1 e0 02             	shl    $0x2,%eax
c0103983:	01 d0                	add    %edx,%eax
c0103985:	c1 e0 02             	shl    $0x2,%eax
c0103988:	89 c2                	mov    %eax,%edx
c010398a:	8b 45 08             	mov    0x8(%ebp),%eax
c010398d:	01 d0                	add    %edx,%eax
c010398f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103992:	0f 87 40 ff ff ff    	ja     c01038d8 <default_init_memmap+0x55>
        // no reference
        set_page_ref(ptr, 0);
        ptr->property = 0;
    }
    // set bit and property of the first page
    SetPageProperty(base);
c0103998:	8b 45 08             	mov    0x8(%ebp),%eax
c010399b:	83 c0 04             	add    $0x4,%eax
c010399e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01039a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01039a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01039ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01039ae:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c01039b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039b7:	89 50 08             	mov    %edx,0x8(%eax)
    
    nr_free += n;
c01039ba:	8b 15 b4 b9 11 c0    	mov    0xc011b9b4,%edx
c01039c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039c3:	01 d0                	add    %edx,%eax
c01039c5:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4
    list_add(&free_list, &(base->page_link));
c01039ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cd:	83 c0 0c             	add    $0xc,%eax
c01039d0:	c7 45 cc ac b9 11 c0 	movl   $0xc011b9ac,-0x34(%ebp)
c01039d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01039da:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01039dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01039e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01039e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01039e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01039e9:	8b 40 04             	mov    0x4(%eax),%eax
c01039ec:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01039ef:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01039f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01039f5:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01039f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01039fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01039fe:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103a01:	89 10                	mov    %edx,(%eax)
c0103a03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103a06:	8b 10                	mov    (%eax),%edx
c0103a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103a0b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103a0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103a11:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103a14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103a17:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103a1a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103a1d:	89 10                	mov    %edx,(%eax)
}
c0103a1f:	c9                   	leave  
c0103a20:	c3                   	ret    

c0103a21 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103a21:	55                   	push   %ebp
c0103a22:	89 e5                	mov    %esp,%ebp
c0103a24:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a2b:	75 24                	jne    c0103a51 <default_alloc_pages+0x30>
c0103a2d:	c7 44 24 0c 47 7e 10 	movl   $0xc0107e47,0xc(%esp)
c0103a34:	c0 
c0103a35:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0103a3c:	c0 
c0103a3d:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0103a44:	00 
c0103a45:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0103a4c:	e8 7e d2 ff ff       	call   c0100ccf <__panic>
    if (n > nr_free) {
c0103a51:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0103a56:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103a59:	73 0a                	jae    c0103a65 <default_alloc_pages+0x44>
        return NULL;
c0103a5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103a60:	e9 7b 01 00 00       	jmp    c0103be0 <default_alloc_pages+0x1bf>
    }

    struct Page *p = NULL;
c0103a65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103a6c:	c7 45 f4 ac b9 11 c0 	movl   $0xc011b9ac,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103a73:	eb 21                	jmp    c0103a96 <default_alloc_pages+0x75>
        p = le2page(le, page_link);
c0103a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a78:	83 e8 0c             	sub    $0xc,%eax
c0103a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->property >= n) {
c0103a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a81:	8b 40 08             	mov    0x8(%eax),%eax
c0103a84:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103a87:	72 0d                	jb     c0103a96 <default_alloc_pages+0x75>
            goto can_alloc;
c0103a89:	90                   	nop
        }
    }
    return NULL;
can_alloc:
    if (p != NULL) {
c0103a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a8e:	0f 84 49 01 00 00    	je     c0103bdd <default_alloc_pages+0x1bc>
c0103a94:	eb 22                	jmp    c0103ab8 <default_alloc_pages+0x97>
c0103a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a99:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a9f:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aa5:	81 7d f4 ac b9 11 c0 	cmpl   $0xc011b9ac,-0xc(%ebp)
c0103aac:	75 c7                	jne    c0103a75 <default_alloc_pages+0x54>
        p = le2page(le, page_link);
        if (p->property >= n) {
            goto can_alloc;
        }
    }
    return NULL;
c0103aae:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ab3:	e9 28 01 00 00       	jmp    c0103be0 <default_alloc_pages+0x1bf>
can_alloc:
    if (p != NULL) {
        list_entry_t *tmp = list_next(&(p->page_link));
c0103ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103abb:	83 c0 0c             	add    $0xc,%eax
c0103abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ac4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // adjust the free block list
        list_del(&(p->page_link));
c0103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103acd:	83 c0 0c             	add    $0xc,%eax
c0103ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ad6:	8b 40 04             	mov    0x4(%eax),%eax
c0103ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103adc:	8b 12                	mov    (%edx),%edx
c0103ade:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0103ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103ae4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ae7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103aea:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103aed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103af3:	89 10                	mov    %edx,(%eax)
        if (p->property > n) {
c0103af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103af8:	8b 40 08             	mov    0x8(%eax),%eax
c0103afb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103afe:	0f 86 a2 00 00 00    	jbe    c0103ba6 <default_alloc_pages+0x185>
            // set head page of the new free bloc
            SetPageProperty(p + n);
c0103b04:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b07:	89 d0                	mov    %edx,%eax
c0103b09:	c1 e0 02             	shl    $0x2,%eax
c0103b0c:	01 d0                	add    %edx,%eax
c0103b0e:	c1 e0 02             	shl    $0x2,%eax
c0103b11:	89 c2                	mov    %eax,%edx
c0103b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b16:	01 d0                	add    %edx,%eax
c0103b18:	83 c0 04             	add    $0x4,%eax
c0103b1b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103b22:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103b28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103b2b:	0f ab 10             	bts    %edx,(%eax)
            (p + n)->property = p->property - n;
c0103b2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b31:	89 d0                	mov    %edx,%eax
c0103b33:	c1 e0 02             	shl    $0x2,%eax
c0103b36:	01 d0                	add    %edx,%eax
c0103b38:	c1 e0 02             	shl    $0x2,%eax
c0103b3b:	89 c2                	mov    %eax,%edx
c0103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b40:	01 c2                	add    %eax,%edx
c0103b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b45:	8b 40 08             	mov    0x8(%eax),%eax
c0103b48:	2b 45 08             	sub    0x8(%ebp),%eax
c0103b4b:	89 42 08             	mov    %eax,0x8(%edx)
            list_add_before(tmp, &((p+n)->page_link));
c0103b4e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b51:	89 d0                	mov    %edx,%eax
c0103b53:	c1 e0 02             	shl    $0x2,%eax
c0103b56:	01 d0                	add    %edx,%eax
c0103b58:	c1 e0 02             	shl    $0x2,%eax
c0103b5b:	89 c2                	mov    %eax,%edx
c0103b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b60:	01 d0                	add    %edx,%eax
c0103b62:	8d 50 0c             	lea    0xc(%eax),%edx
c0103b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b68:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0103b6b:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103b6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103b71:	8b 00                	mov    (%eax),%eax
c0103b73:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103b76:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0103b79:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0103b7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103b7f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103b82:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103b85:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103b88:	89 10                	mov    %edx,(%eax)
c0103b8a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103b8d:	8b 10                	mov    (%eax),%edx
c0103b8f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103b92:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103b95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103b98:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103b9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103b9e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ba1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ba4:	89 10                	mov    %edx,(%eax)
        }
        // set bits of the allocated pages
        ClearPageProperty(p);
c0103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ba9:	83 c0 04             	add    $0x4,%eax
c0103bac:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103bb3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103bb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103bb9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103bbc:	0f b3 10             	btr    %edx,(%eax)
        p->property -= n; 
c0103bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bc2:	8b 40 08             	mov    0x8(%eax),%eax
c0103bc5:	2b 45 08             	sub    0x8(%ebp),%eax
c0103bc8:	89 c2                	mov    %eax,%edx
c0103bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bcd:	89 50 08             	mov    %edx,0x8(%eax)
        nr_free -= n;
c0103bd0:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0103bd5:	2b 45 08             	sub    0x8(%ebp),%eax
c0103bd8:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4
    }
    return p;
c0103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103be0:	c9                   	leave  
c0103be1:	c3                   	ret    

c0103be2 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103be2:	55                   	push   %ebp
c0103be3:	89 e5                	mov    %esp,%ebp
c0103be5:	81 ec d8 00 00 00    	sub    $0xd8,%esp
    assert(n > 0);
c0103beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103bef:	75 24                	jne    c0103c15 <default_free_pages+0x33>
c0103bf1:	c7 44 24 0c 47 7e 10 	movl   $0xc0107e47,0xc(%esp)
c0103bf8:	c0 
c0103bf9:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0103c00:	c0 
c0103c01:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0103c08:	00 
c0103c09:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0103c10:	e8 ba d0 ff ff       	call   c0100ccf <__panic>
    struct Page *ptr = base, *next = NULL;
c0103c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (; ptr < base + n; ptr++) {
c0103c22:	e9 c5 00 00 00       	jmp    c0103cec <default_free_pages+0x10a>
        // reset all pages that needs to be free
        assert(!PageReserved(ptr) && !PageProperty(ptr));
c0103c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c2a:	83 c0 04             	add    $0x4,%eax
c0103c2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0103c34:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103c3d:	0f a3 10             	bt     %edx,(%eax)
c0103c40:	19 c0                	sbb    %eax,%eax
c0103c42:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0103c45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103c49:	0f 95 c0             	setne  %al
c0103c4c:	0f b6 c0             	movzbl %al,%eax
c0103c4f:	85 c0                	test   %eax,%eax
c0103c51:	75 2c                	jne    c0103c7f <default_free_pages+0x9d>
c0103c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c56:	83 c0 04             	add    $0x4,%eax
c0103c59:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0103c60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103c66:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103c69:	0f a3 10             	bt     %edx,(%eax)
c0103c6c:	19 c0                	sbb    %eax,%eax
c0103c6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0103c71:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103c75:	0f 95 c0             	setne  %al
c0103c78:	0f b6 c0             	movzbl %al,%eax
c0103c7b:	85 c0                	test   %eax,%eax
c0103c7d:	74 24                	je     c0103ca3 <default_free_pages+0xc1>
c0103c7f:	c7 44 24 0c 8c 7e 10 	movl   $0xc0107e8c,0xc(%esp)
c0103c86:	c0 
c0103c87:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0103c8e:	c0 
c0103c8f:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c0103c96:	00 
c0103c97:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0103c9e:	e8 2c d0 ff ff       	call   c0100ccf <__panic>
        ClearPageProperty(ptr);
c0103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ca6:	83 c0 04             	add    $0x4,%eax
c0103ca9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103cb0:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103cb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103cb6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103cb9:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
c0103cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cbf:	83 c0 04             	add    $0x4,%eax
c0103cc2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
c0103cc9:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0103ccc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103ccf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103cd2:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(ptr, 0);
c0103cd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103cdc:	00 
c0103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce0:	89 04 24             	mov    %eax,(%esp)
c0103ce3:	e8 61 fb ff ff       	call   c0103849 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *ptr = base, *next = NULL;
    for (; ptr < base + n; ptr++) {
c0103ce8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103cec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cef:	89 d0                	mov    %edx,%eax
c0103cf1:	c1 e0 02             	shl    $0x2,%eax
c0103cf4:	01 d0                	add    %edx,%eax
c0103cf6:	c1 e0 02             	shl    $0x2,%eax
c0103cf9:	89 c2                	mov    %eax,%edx
c0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cfe:	01 d0                	add    %edx,%eax
c0103d00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d03:	0f 87 1e ff ff ff    	ja     c0103c27 <default_free_pages+0x45>
        ClearPageProperty(ptr);
        ClearPageReserved(ptr);
        set_page_ref(ptr, 0);
    }
    // reset head page of the block
    base->property = n;
c0103d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d15:	83 c0 04             	add    $0x4,%eax
c0103d18:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0103d1f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103d22:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d25:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d28:	0f ab 10             	bts    %edx,(%eax)
    // check if this block can be merged with another block
    list_entry_t *le = &free_list, *tmp = NULL;
c0103d2b:	c7 45 f0 ac b9 11 c0 	movl   $0xc011b9ac,-0x10(%ebp)
c0103d32:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d39:	e9 b1 02 00 00       	jmp    c0103fef <default_free_pages+0x40d>
        ptr = le2page(le, page_link);
c0103d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d41:	83 e8 0c             	sub    $0xc,%eax
c0103d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptr + ptr->property == base) {
c0103d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d4a:	8b 50 08             	mov    0x8(%eax),%edx
c0103d4d:	89 d0                	mov    %edx,%eax
c0103d4f:	c1 e0 02             	shl    $0x2,%eax
c0103d52:	01 d0                	add    %edx,%eax
c0103d54:	c1 e0 02             	shl    $0x2,%eax
c0103d57:	89 c2                	mov    %eax,%edx
c0103d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d5c:	01 d0                	add    %edx,%eax
c0103d5e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103d61:	0f 85 cc 00 00 00    	jne    c0103e33 <default_free_pages+0x251>
            // merge after this block
            ptr->property += base->property;
c0103d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d6a:	8b 50 08             	mov    0x8(%eax),%edx
c0103d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d70:	8b 40 08             	mov    0x8(%eax),%eax
c0103d73:	01 c2                	add    %eax,%edx
c0103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d78:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7e:	83 c0 04             	add    $0x4,%eax
c0103d81:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0103d88:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103d8b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d8e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d91:	0f b3 10             	btr    %edx,(%eax)
            // check if next block can also be merged
            tmp = list_next(&(ptr->page_link));
c0103d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d97:	83 c0 0c             	add    $0xc,%eax
c0103d9a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d9d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103da0:	8b 40 04             	mov    0x4(%eax),%eax
c0103da3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            next = le2page(tmp, page_link);
c0103da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103da9:	83 e8 0c             	sub    $0xc,%eax
c0103dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (tmp != &free_list && base + base->property == next) {
c0103daf:	81 7d e8 ac b9 11 c0 	cmpl   $0xc011b9ac,-0x18(%ebp)
c0103db6:	74 76                	je     c0103e2e <default_free_pages+0x24c>
c0103db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dbb:	8b 50 08             	mov    0x8(%eax),%edx
c0103dbe:	89 d0                	mov    %edx,%eax
c0103dc0:	c1 e0 02             	shl    $0x2,%eax
c0103dc3:	01 d0                	add    %edx,%eax
c0103dc5:	c1 e0 02             	shl    $0x2,%eax
c0103dc8:	89 c2                	mov    %eax,%edx
c0103dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dcd:	01 d0                	add    %edx,%eax
c0103dcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103dd2:	75 5a                	jne    c0103e2e <default_free_pages+0x24c>
                ptr->property += next->property;
c0103dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dd7:	8b 50 08             	mov    0x8(%eax),%edx
c0103dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ddd:	8b 40 08             	mov    0x8(%eax),%eax
c0103de0:	01 c2                	add    %eax,%edx
c0103de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de5:	89 50 08             	mov    %edx,0x8(%eax)
                ClearPageProperty(next);
c0103de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103deb:	83 c0 04             	add    $0x4,%eax
c0103dee:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0103df5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103df8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103dfb:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103dfe:	0f b3 10             	btr    %edx,(%eax)
c0103e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e04:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103e07:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103e0a:	8b 40 04             	mov    0x4(%eax),%eax
c0103e0d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103e10:	8b 12                	mov    (%edx),%edx
c0103e12:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0103e15:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103e18:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103e1b:	8b 55 98             	mov    -0x68(%ebp),%edx
c0103e1e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103e21:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103e24:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103e27:	89 10                	mov    %edx,(%eax)
                list_del(tmp);
            }
            goto done;
c0103e29:	e9 5b 02 00 00       	jmp    c0104089 <default_free_pages+0x4a7>
c0103e2e:	e9 56 02 00 00       	jmp    c0104089 <default_free_pages+0x4a7>
        } else if (base + base->property == ptr) {
c0103e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e36:	8b 50 08             	mov    0x8(%eax),%edx
c0103e39:	89 d0                	mov    %edx,%eax
c0103e3b:	c1 e0 02             	shl    $0x2,%eax
c0103e3e:	01 d0                	add    %edx,%eax
c0103e40:	c1 e0 02             	shl    $0x2,%eax
c0103e43:	89 c2                	mov    %eax,%edx
c0103e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e48:	01 d0                	add    %edx,%eax
c0103e4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103e4d:	0f 85 e6 00 00 00    	jne    c0103f39 <default_free_pages+0x357>
            // merge before this block
            base->property += ptr->property;
c0103e53:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e56:	8b 50 08             	mov    0x8(%eax),%edx
c0103e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e5c:	8b 40 08             	mov    0x8(%eax),%eax
c0103e5f:	01 c2                	add    %eax,%edx
c0103e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e64:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(ptr);
c0103e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e6a:	83 c0 04             	add    $0x4,%eax
c0103e6d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103e74:	89 45 90             	mov    %eax,-0x70(%ebp)
c0103e77:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103e7a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103e7d:	0f b3 10             	btr    %edx,(%eax)
            // need to set up free_list
            tmp = list_next(&(ptr->page_link));
c0103e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e83:	83 c0 0c             	add    $0xc,%eax
c0103e86:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e89:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103e8c:	8b 40 04             	mov    0x4(%eax),%eax
c0103e8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            list_del(&(ptr->page_link));
c0103e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e95:	83 c0 0c             	add    $0xc,%eax
c0103e98:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103e9b:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103e9e:	8b 40 04             	mov    0x4(%eax),%eax
c0103ea1:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103ea4:	8b 12                	mov    (%edx),%edx
c0103ea6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103ea9:	89 45 80             	mov    %eax,-0x80(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103eac:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103eaf:	8b 55 80             	mov    -0x80(%ebp),%edx
c0103eb2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103eb5:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103eb8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103ebb:	89 10                	mov    %edx,(%eax)
            list_add_before(tmp, &(base->page_link));
c0103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec0:	8d 50 0c             	lea    0xc(%eax),%edx
c0103ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ec6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103ecc:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103ed2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ed8:	8b 00                	mov    (%eax),%eax
c0103eda:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0103ee0:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
c0103ee6:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
c0103eec:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ef2:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103ef8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0103efe:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0103f04:	89 10                	mov    %edx,(%eax)
c0103f06:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0103f0c:	8b 10                	mov    (%eax),%edx
c0103f0e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0103f14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103f17:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0103f1d:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c0103f23:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103f26:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0103f2c:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0103f32:	89 10                	mov    %edx,(%eax)
            goto done;
c0103f34:	e9 50 01 00 00       	jmp    c0104089 <default_free_pages+0x4a7>
        } else if (ptr > base) {
c0103f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f3c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103f3f:	0f 86 aa 00 00 00    	jbe    c0103fef <default_free_pages+0x40d>
            tmp = list_prev(&(ptr->page_link));
c0103f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f48:	83 c0 0c             	add    $0xc,%eax
c0103f4b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103f51:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0103f57:	8b 00                	mov    (%eax),%eax
c0103f59:	89 45 e8             	mov    %eax,-0x18(%ebp)
            // addr boundary check
            if (tmp == &free_list || le2page(tmp, page_link) < ptr) {
c0103f5c:	81 7d e8 ac b9 11 c0 	cmpl   $0xc011b9ac,-0x18(%ebp)
c0103f63:	74 0b                	je     c0103f70 <default_free_pages+0x38e>
c0103f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f68:	83 e8 0c             	sub    $0xc,%eax
c0103f6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103f6e:	73 7f                	jae    c0103fef <default_free_pages+0x40d>
                // independent block donot need to merge, just simply insert
                list_add_before(&(ptr->page_link), &(base->page_link));
c0103f70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f73:	83 c0 0c             	add    $0xc,%eax
c0103f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f79:	83 c2 0c             	add    $0xc,%edx
c0103f7c:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
c0103f82:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103f88:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0103f8e:	8b 00                	mov    (%eax),%eax
c0103f90:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
c0103f96:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
c0103f9c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
c0103fa2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0103fa8:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103fae:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c0103fb4:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
c0103fba:	89 10                	mov    %edx,(%eax)
c0103fbc:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c0103fc2:	8b 10                	mov    (%eax),%edx
c0103fc4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
c0103fca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103fcd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c0103fd3:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
c0103fd9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103fdc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c0103fe2:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
c0103fe8:	89 10                	mov    %edx,(%eax)
                goto done;
c0103fea:	e9 9a 00 00 00       	jmp    c0104089 <default_free_pages+0x4a7>
c0103fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ff2:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ff8:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
c0103ffe:	8b 40 04             	mov    0x4(%eax),%eax
    // reset head page of the block
    base->property = n;
    SetPageProperty(base);
    // check if this block can be merged with another block
    list_entry_t *le = &free_list, *tmp = NULL;
    while ((le = list_next(le)) != &free_list) {
c0104001:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104004:	81 7d f0 ac b9 11 c0 	cmpl   $0xc011b9ac,-0x10(%ebp)
c010400b:	0f 85 2d fd ff ff    	jne    c0103d3e <default_free_pages+0x15c>
            }
        }
    }
    // this block cannot be merged with any blocks, and it has the biggest addr
    // then insert to the end of the list
    list_add_before(&free_list, &(base->page_link));
c0104011:	8b 45 08             	mov    0x8(%ebp),%eax
c0104014:	83 c0 0c             	add    $0xc,%eax
c0104017:	c7 85 4c ff ff ff ac 	movl   $0xc011b9ac,-0xb4(%ebp)
c010401e:	b9 11 c0 
c0104021:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104027:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
c010402d:	8b 00                	mov    (%eax),%eax
c010402f:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
c0104035:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
c010403b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
c0104041:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
c0104047:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010404d:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
c0104053:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
c0104059:	89 10                	mov    %edx,(%eax)
c010405b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
c0104061:	8b 10                	mov    (%eax),%edx
c0104063:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0104069:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010406c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
c0104072:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
c0104078:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010407b:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
c0104081:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
c0104087:	89 10                	mov    %edx,(%eax)
done:
    nr_free += n;
c0104089:	8b 15 b4 b9 11 c0    	mov    0xc011b9b4,%edx
c010408f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104092:	01 d0                	add    %edx,%eax
c0104094:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4
}
c0104099:	c9                   	leave  
c010409a:	c3                   	ret    

c010409b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010409b:	55                   	push   %ebp
c010409c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010409e:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
}
c01040a3:	5d                   	pop    %ebp
c01040a4:	c3                   	ret    

c01040a5 <output_free_list>:

static void
output_free_list(void) {
c01040a5:	55                   	push   %ebp
c01040a6:	89 e5                	mov    %esp,%ebp
c01040a8:	57                   	push   %edi
c01040a9:	56                   	push   %esi
c01040aa:	53                   	push   %ebx
c01040ab:	83 ec 5c             	sub    $0x5c,%esp
    int index = 0;
c01040ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    struct Page *p = NULL;
c01040b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    list_entry_t *le = &free_list;
c01040bc:	c7 45 e0 ac b9 11 c0 	movl   $0xc011b9ac,-0x20(%ebp)
    cprintf("free_list: NR_FREE %d\n", nr_free);
c01040c3:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c01040c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040cc:	c7 04 24 b5 7e 10 c0 	movl   $0xc0107eb5,(%esp)
c01040d3:	e8 6b c2 ff ff       	call   c0100343 <cprintf>
    while ((le = list_next(le)) != &free_list) {
c01040d8:	e9 98 00 00 00       	jmp    c0104175 <output_free_list+0xd0>
        p = le2page(le, page_link);
c01040dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040e0:	83 e8 0c             	sub    $0xc,%eax
c01040e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
c01040e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040e9:	83 c0 04             	add    $0x4,%eax
c01040ec:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01040f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040fc:	0f a3 10             	bt     %edx,(%eax)
c01040ff:	19 c0                	sbb    %eax,%eax
c0104101:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0104104:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104108:	0f 95 c0             	setne  %al
c010410b:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
c010410e:	89 c6                	mov    %eax,%esi
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
c0104110:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104113:	83 c0 04             	add    $0x4,%eax
c0104116:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c010411d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104120:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104123:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104126:	0f a3 10             	bt     %edx,(%eax)
c0104129:	19 c0                	sbb    %eax,%eax
c010412b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
c010412e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104132:	0f 95 c0             	setne  %al
c0104135:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
c0104138:	89 c3                	mov    %eax,%ebx
c010413a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010413d:	8b 48 08             	mov    0x8(%eax),%ecx
c0104140:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104143:	8b 10                	mov    (%eax),%edx
c0104145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104148:	8d 78 01             	lea    0x1(%eax),%edi
c010414b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
c010414e:	89 74 24 18          	mov    %esi,0x18(%esp)
c0104152:	89 5c 24 14          	mov    %ebx,0x14(%esp)
c0104156:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010415a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010415e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104161:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104165:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104169:	c7 04 24 cc 7e 10 c0 	movl   $0xc0107ecc,(%esp)
c0104170:	e8 ce c1 ff ff       	call   c0100343 <cprintf>
c0104175:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104178:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010417b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010417e:	8b 40 04             	mov    0x4(%eax),%eax
output_free_list(void) {
    int index = 0;
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
c0104181:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104184:	81 7d e0 ac b9 11 c0 	cmpl   $0xc011b9ac,-0x20(%ebp)
c010418b:	0f 85 4c ff ff ff    	jne    c01040dd <output_free_list+0x38>
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
    }
}
c0104191:	83 c4 5c             	add    $0x5c,%esp
c0104194:	5b                   	pop    %ebx
c0104195:	5e                   	pop    %esi
c0104196:	5f                   	pop    %edi
c0104197:	5d                   	pop    %ebp
c0104198:	c3                   	ret    

c0104199 <basic_check>:

static void
basic_check(void) {
c0104199:	55                   	push   %ebp
c010419a:	89 e5                	mov    %esp,%ebp
c010419c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010419f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01041b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041b9:	e8 9d 0e 00 00       	call   c010505b <alloc_pages>
c01041be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01041c5:	75 24                	jne    c01041eb <basic_check+0x52>
c01041c7:	c7 44 24 0c 11 7f 10 	movl   $0xc0107f11,0xc(%esp)
c01041ce:	c0 
c01041cf:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01041d6:	c0 
c01041d7:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01041de:	00 
c01041df:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01041e6:	e8 e4 ca ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c01041eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041f2:	e8 64 0e 00 00       	call   c010505b <alloc_pages>
c01041f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01041fe:	75 24                	jne    c0104224 <basic_check+0x8b>
c0104200:	c7 44 24 0c 2d 7f 10 	movl   $0xc0107f2d,0xc(%esp)
c0104207:	c0 
c0104208:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010420f:	c0 
c0104210:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104217:	00 
c0104218:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010421f:	e8 ab ca ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010422b:	e8 2b 0e 00 00       	call   c010505b <alloc_pages>
c0104230:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104237:	75 24                	jne    c010425d <basic_check+0xc4>
c0104239:	c7 44 24 0c 49 7f 10 	movl   $0xc0107f49,0xc(%esp)
c0104240:	c0 
c0104241:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104248:	c0 
c0104249:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104250:	00 
c0104251:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104258:	e8 72 ca ff ff       	call   c0100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010425d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104260:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104263:	74 10                	je     c0104275 <basic_check+0xdc>
c0104265:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104268:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010426b:	74 08                	je     c0104275 <basic_check+0xdc>
c010426d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104270:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104273:	75 24                	jne    c0104299 <basic_check+0x100>
c0104275:	c7 44 24 0c 68 7f 10 	movl   $0xc0107f68,0xc(%esp)
c010427c:	c0 
c010427d:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104284:	c0 
c0104285:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c010428c:	00 
c010428d:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104294:	e8 36 ca ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104299:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010429c:	89 04 24             	mov    %eax,(%esp)
c010429f:	e8 9b f5 ff ff       	call   c010383f <page_ref>
c01042a4:	85 c0                	test   %eax,%eax
c01042a6:	75 1e                	jne    c01042c6 <basic_check+0x12d>
c01042a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042ab:	89 04 24             	mov    %eax,(%esp)
c01042ae:	e8 8c f5 ff ff       	call   c010383f <page_ref>
c01042b3:	85 c0                	test   %eax,%eax
c01042b5:	75 0f                	jne    c01042c6 <basic_check+0x12d>
c01042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ba:	89 04 24             	mov    %eax,(%esp)
c01042bd:	e8 7d f5 ff ff       	call   c010383f <page_ref>
c01042c2:	85 c0                	test   %eax,%eax
c01042c4:	74 24                	je     c01042ea <basic_check+0x151>
c01042c6:	c7 44 24 0c 8c 7f 10 	movl   $0xc0107f8c,0xc(%esp)
c01042cd:	c0 
c01042ce:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01042d5:	c0 
c01042d6:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01042dd:	00 
c01042de:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01042e5:	e8 e5 c9 ff ff       	call   c0100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01042ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042ed:	89 04 24             	mov    %eax,(%esp)
c01042f0:	e8 34 f5 ff ff       	call   c0103829 <page2pa>
c01042f5:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c01042fb:	c1 e2 0c             	shl    $0xc,%edx
c01042fe:	39 d0                	cmp    %edx,%eax
c0104300:	72 24                	jb     c0104326 <basic_check+0x18d>
c0104302:	c7 44 24 0c c8 7f 10 	movl   $0xc0107fc8,0xc(%esp)
c0104309:	c0 
c010430a:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104311:	c0 
c0104312:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0104319:	00 
c010431a:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104321:	e8 a9 c9 ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104326:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104329:	89 04 24             	mov    %eax,(%esp)
c010432c:	e8 f8 f4 ff ff       	call   c0103829 <page2pa>
c0104331:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0104337:	c1 e2 0c             	shl    $0xc,%edx
c010433a:	39 d0                	cmp    %edx,%eax
c010433c:	72 24                	jb     c0104362 <basic_check+0x1c9>
c010433e:	c7 44 24 0c e5 7f 10 	movl   $0xc0107fe5,0xc(%esp)
c0104345:	c0 
c0104346:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010434d:	c0 
c010434e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104355:	00 
c0104356:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010435d:	e8 6d c9 ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104362:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104365:	89 04 24             	mov    %eax,(%esp)
c0104368:	e8 bc f4 ff ff       	call   c0103829 <page2pa>
c010436d:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0104373:	c1 e2 0c             	shl    $0xc,%edx
c0104376:	39 d0                	cmp    %edx,%eax
c0104378:	72 24                	jb     c010439e <basic_check+0x205>
c010437a:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0104381:	c0 
c0104382:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104389:	c0 
c010438a:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0104391:	00 
c0104392:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104399:	e8 31 c9 ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c010439e:	a1 ac b9 11 c0       	mov    0xc011b9ac,%eax
c01043a3:	8b 15 b0 b9 11 c0    	mov    0xc011b9b0,%edx
c01043a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01043ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043af:	c7 45 e0 ac b9 11 c0 	movl   $0xc011b9ac,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01043b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043bc:	89 50 04             	mov    %edx,0x4(%eax)
c01043bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043c2:	8b 50 04             	mov    0x4(%eax),%edx
c01043c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043c8:	89 10                	mov    %edx,(%eax)
c01043ca:	c7 45 dc ac b9 11 c0 	movl   $0xc011b9ac,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01043d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043d4:	8b 40 04             	mov    0x4(%eax),%eax
c01043d7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01043da:	0f 94 c0             	sete   %al
c01043dd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01043e0:	85 c0                	test   %eax,%eax
c01043e2:	75 24                	jne    c0104408 <basic_check+0x26f>
c01043e4:	c7 44 24 0c 1f 80 10 	movl   $0xc010801f,0xc(%esp)
c01043eb:	c0 
c01043ec:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01043f3:	c0 
c01043f4:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01043fb:	00 
c01043fc:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104403:	e8 c7 c8 ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c0104408:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c010440d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104410:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c0104417:	00 00 00 

    assert(alloc_page() == NULL);
c010441a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104421:	e8 35 0c 00 00       	call   c010505b <alloc_pages>
c0104426:	85 c0                	test   %eax,%eax
c0104428:	74 24                	je     c010444e <basic_check+0x2b5>
c010442a:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c0104431:	c0 
c0104432:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104439:	c0 
c010443a:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104441:	00 
c0104442:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104449:	e8 81 c8 ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c010444e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104455:	00 
c0104456:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104459:	89 04 24             	mov    %eax,(%esp)
c010445c:	e8 32 0c 00 00       	call   c0105093 <free_pages>
    free_page(p1);
c0104461:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104468:	00 
c0104469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010446c:	89 04 24             	mov    %eax,(%esp)
c010446f:	e8 1f 0c 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c0104474:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010447b:	00 
c010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010447f:	89 04 24             	mov    %eax,(%esp)
c0104482:	e8 0c 0c 00 00       	call   c0105093 <free_pages>
    assert(nr_free == 3);
c0104487:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c010448c:	83 f8 03             	cmp    $0x3,%eax
c010448f:	74 24                	je     c01044b5 <basic_check+0x31c>
c0104491:	c7 44 24 0c 4b 80 10 	movl   $0xc010804b,0xc(%esp)
c0104498:	c0 
c0104499:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01044a0:	c0 
c01044a1:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01044a8:	00 
c01044a9:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01044b0:	e8 1a c8 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
c01044b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044bc:	e8 9a 0b 00 00       	call   c010505b <alloc_pages>
c01044c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01044c8:	75 24                	jne    c01044ee <basic_check+0x355>
c01044ca:	c7 44 24 0c 11 7f 10 	movl   $0xc0107f11,0xc(%esp)
c01044d1:	c0 
c01044d2:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01044d9:	c0 
c01044da:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01044e1:	00 
c01044e2:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01044e9:	e8 e1 c7 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c01044ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044f5:	e8 61 0b 00 00       	call   c010505b <alloc_pages>
c01044fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104501:	75 24                	jne    c0104527 <basic_check+0x38e>
c0104503:	c7 44 24 0c 2d 7f 10 	movl   $0xc0107f2d,0xc(%esp)
c010450a:	c0 
c010450b:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104512:	c0 
c0104513:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010451a:	00 
c010451b:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104522:	e8 a8 c7 ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010452e:	e8 28 0b 00 00       	call   c010505b <alloc_pages>
c0104533:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010453a:	75 24                	jne    c0104560 <basic_check+0x3c7>
c010453c:	c7 44 24 0c 49 7f 10 	movl   $0xc0107f49,0xc(%esp)
c0104543:	c0 
c0104544:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010454b:	c0 
c010454c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104553:	00 
c0104554:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010455b:	e8 6f c7 ff ff       	call   c0100ccf <__panic>

    assert(alloc_page() == NULL);
c0104560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104567:	e8 ef 0a 00 00       	call   c010505b <alloc_pages>
c010456c:	85 c0                	test   %eax,%eax
c010456e:	74 24                	je     c0104594 <basic_check+0x3fb>
c0104570:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c0104577:	c0 
c0104578:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010457f:	c0 
c0104580:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104587:	00 
c0104588:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010458f:	e8 3b c7 ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c0104594:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010459b:	00 
c010459c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010459f:	89 04 24             	mov    %eax,(%esp)
c01045a2:	e8 ec 0a 00 00       	call   c0105093 <free_pages>
c01045a7:	c7 45 d8 ac b9 11 c0 	movl   $0xc011b9ac,-0x28(%ebp)
c01045ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01045b1:	8b 40 04             	mov    0x4(%eax),%eax
c01045b4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01045b7:	0f 94 c0             	sete   %al
c01045ba:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01045bd:	85 c0                	test   %eax,%eax
c01045bf:	74 24                	je     c01045e5 <basic_check+0x44c>
c01045c1:	c7 44 24 0c 58 80 10 	movl   $0xc0108058,0xc(%esp)
c01045c8:	c0 
c01045c9:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01045d0:	c0 
c01045d1:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01045d8:	00 
c01045d9:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01045e0:	e8 ea c6 ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01045e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045ec:	e8 6a 0a 00 00       	call   c010505b <alloc_pages>
c01045f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01045fa:	74 24                	je     c0104620 <basic_check+0x487>
c01045fc:	c7 44 24 0c 70 80 10 	movl   $0xc0108070,0xc(%esp)
c0104603:	c0 
c0104604:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010460b:	c0 
c010460c:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0104613:	00 
c0104614:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010461b:	e8 af c6 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0104620:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104627:	e8 2f 0a 00 00       	call   c010505b <alloc_pages>
c010462c:	85 c0                	test   %eax,%eax
c010462e:	74 24                	je     c0104654 <basic_check+0x4bb>
c0104630:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c0104637:	c0 
c0104638:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010463f:	c0 
c0104640:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0104647:	00 
c0104648:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010464f:	e8 7b c6 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c0104654:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0104659:	85 c0                	test   %eax,%eax
c010465b:	74 24                	je     c0104681 <basic_check+0x4e8>
c010465d:	c7 44 24 0c 89 80 10 	movl   $0xc0108089,0xc(%esp)
c0104664:	c0 
c0104665:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010466c:	c0 
c010466d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104674:	00 
c0104675:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010467c:	e8 4e c6 ff ff       	call   c0100ccf <__panic>
    free_list = free_list_store;
c0104681:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104684:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104687:	a3 ac b9 11 c0       	mov    %eax,0xc011b9ac
c010468c:	89 15 b0 b9 11 c0    	mov    %edx,0xc011b9b0
    nr_free = nr_free_store;
c0104692:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104695:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4

    free_page(p);
c010469a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046a1:	00 
c01046a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046a5:	89 04 24             	mov    %eax,(%esp)
c01046a8:	e8 e6 09 00 00       	call   c0105093 <free_pages>
    free_page(p1);
c01046ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046b4:	00 
c01046b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b8:	89 04 24             	mov    %eax,(%esp)
c01046bb:	e8 d3 09 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c01046c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046c7:	00 
c01046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cb:	89 04 24             	mov    %eax,(%esp)
c01046ce:	e8 c0 09 00 00       	call   c0105093 <free_pages>
}
c01046d3:	c9                   	leave  
c01046d4:	c3                   	ret    

c01046d5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01046d5:	55                   	push   %ebp
c01046d6:	89 e5                	mov    %esp,%ebp
c01046d8:	53                   	push   %ebx
c01046d9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01046df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01046e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01046ed:	c7 45 ec ac b9 11 c0 	movl   $0xc011b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01046f4:	eb 6b                	jmp    c0104761 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01046f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046f9:	83 e8 0c             	sub    $0xc,%eax
c01046fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01046ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104702:	83 c0 04             	add    $0x4,%eax
c0104705:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010470c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010470f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104712:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104715:	0f a3 10             	bt     %edx,(%eax)
c0104718:	19 c0                	sbb    %eax,%eax
c010471a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010471d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104721:	0f 95 c0             	setne  %al
c0104724:	0f b6 c0             	movzbl %al,%eax
c0104727:	85 c0                	test   %eax,%eax
c0104729:	75 24                	jne    c010474f <default_check+0x7a>
c010472b:	c7 44 24 0c 96 80 10 	movl   $0xc0108096,0xc(%esp)
c0104732:	c0 
c0104733:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c010473a:	c0 
c010473b:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104742:	00 
c0104743:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c010474a:	e8 80 c5 ff ff       	call   c0100ccf <__panic>
        count ++, total += p->property;
c010474f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104753:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104756:	8b 50 08             	mov    0x8(%eax),%edx
c0104759:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475c:	01 d0                	add    %edx,%eax
c010475e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104761:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104764:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104767:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010476a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010476d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104770:	81 7d ec ac b9 11 c0 	cmpl   $0xc011b9ac,-0x14(%ebp)
c0104777:	0f 85 79 ff ff ff    	jne    c01046f6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010477d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104780:	e8 40 09 00 00       	call   c01050c5 <nr_free_pages>
c0104785:	39 c3                	cmp    %eax,%ebx
c0104787:	74 24                	je     c01047ad <default_check+0xd8>
c0104789:	c7 44 24 0c a6 80 10 	movl   $0xc01080a6,0xc(%esp)
c0104790:	c0 
c0104791:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104798:	c0 
c0104799:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01047a0:	00 
c01047a1:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01047a8:	e8 22 c5 ff ff       	call   c0100ccf <__panic>

    basic_check();
c01047ad:	e8 e7 f9 ff ff       	call   c0104199 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01047b2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01047b9:	e8 9d 08 00 00       	call   c010505b <alloc_pages>
c01047be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01047c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01047c5:	75 24                	jne    c01047eb <default_check+0x116>
c01047c7:	c7 44 24 0c bf 80 10 	movl   $0xc01080bf,0xc(%esp)
c01047ce:	c0 
c01047cf:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01047d6:	c0 
c01047d7:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01047de:	00 
c01047df:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01047e6:	e8 e4 c4 ff ff       	call   c0100ccf <__panic>
    assert(!PageProperty(p0));
c01047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ee:	83 c0 04             	add    $0x4,%eax
c01047f1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01047f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01047fe:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104801:	0f a3 10             	bt     %edx,(%eax)
c0104804:	19 c0                	sbb    %eax,%eax
c0104806:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104809:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010480d:	0f 95 c0             	setne  %al
c0104810:	0f b6 c0             	movzbl %al,%eax
c0104813:	85 c0                	test   %eax,%eax
c0104815:	74 24                	je     c010483b <default_check+0x166>
c0104817:	c7 44 24 0c ca 80 10 	movl   $0xc01080ca,0xc(%esp)
c010481e:	c0 
c010481f:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104826:	c0 
c0104827:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c010482e:	00 
c010482f:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104836:	e8 94 c4 ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c010483b:	a1 ac b9 11 c0       	mov    0xc011b9ac,%eax
c0104840:	8b 15 b0 b9 11 c0    	mov    0xc011b9b0,%edx
c0104846:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104849:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010484c:	c7 45 b4 ac b9 11 c0 	movl   $0xc011b9ac,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104853:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104856:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104859:	89 50 04             	mov    %edx,0x4(%eax)
c010485c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010485f:	8b 50 04             	mov    0x4(%eax),%edx
c0104862:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104865:	89 10                	mov    %edx,(%eax)
c0104867:	c7 45 b0 ac b9 11 c0 	movl   $0xc011b9ac,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010486e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104871:	8b 40 04             	mov    0x4(%eax),%eax
c0104874:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104877:	0f 94 c0             	sete   %al
c010487a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010487d:	85 c0                	test   %eax,%eax
c010487f:	75 24                	jne    c01048a5 <default_check+0x1d0>
c0104881:	c7 44 24 0c 1f 80 10 	movl   $0xc010801f,0xc(%esp)
c0104888:	c0 
c0104889:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104890:	c0 
c0104891:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0104898:	00 
c0104899:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01048a0:	e8 2a c4 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01048a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048ac:	e8 aa 07 00 00       	call   c010505b <alloc_pages>
c01048b1:	85 c0                	test   %eax,%eax
c01048b3:	74 24                	je     c01048d9 <default_check+0x204>
c01048b5:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c01048bc:	c0 
c01048bd:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01048c4:	c0 
c01048c5:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01048cc:	00 
c01048cd:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01048d4:	e8 f6 c3 ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c01048d9:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c01048de:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01048e1:	c7 05 b4 b9 11 c0 00 	movl   $0x0,0xc011b9b4
c01048e8:	00 00 00 

    free_pages(p0 + 2, 3);
c01048eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048ee:	83 c0 28             	add    $0x28,%eax
c01048f1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01048f8:	00 
c01048f9:	89 04 24             	mov    %eax,(%esp)
c01048fc:	e8 92 07 00 00       	call   c0105093 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104901:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104908:	e8 4e 07 00 00       	call   c010505b <alloc_pages>
c010490d:	85 c0                	test   %eax,%eax
c010490f:	74 24                	je     c0104935 <default_check+0x260>
c0104911:	c7 44 24 0c dc 80 10 	movl   $0xc01080dc,0xc(%esp)
c0104918:	c0 
c0104919:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104920:	c0 
c0104921:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104928:	00 
c0104929:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104930:	e8 9a c3 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104938:	83 c0 28             	add    $0x28,%eax
c010493b:	83 c0 04             	add    $0x4,%eax
c010493e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104945:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104948:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010494b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010494e:	0f a3 10             	bt     %edx,(%eax)
c0104951:	19 c0                	sbb    %eax,%eax
c0104953:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104956:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010495a:	0f 95 c0             	setne  %al
c010495d:	0f b6 c0             	movzbl %al,%eax
c0104960:	85 c0                	test   %eax,%eax
c0104962:	74 0e                	je     c0104972 <default_check+0x29d>
c0104964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104967:	83 c0 28             	add    $0x28,%eax
c010496a:	8b 40 08             	mov    0x8(%eax),%eax
c010496d:	83 f8 03             	cmp    $0x3,%eax
c0104970:	74 24                	je     c0104996 <default_check+0x2c1>
c0104972:	c7 44 24 0c f4 80 10 	movl   $0xc01080f4,0xc(%esp)
c0104979:	c0 
c010497a:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104981:	c0 
c0104982:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0104989:	00 
c010498a:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104991:	e8 39 c3 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104996:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010499d:	e8 b9 06 00 00       	call   c010505b <alloc_pages>
c01049a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01049a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01049a9:	75 24                	jne    c01049cf <default_check+0x2fa>
c01049ab:	c7 44 24 0c 20 81 10 	movl   $0xc0108120,0xc(%esp)
c01049b2:	c0 
c01049b3:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01049ba:	c0 
c01049bb:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01049c2:	00 
c01049c3:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01049ca:	e8 00 c3 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01049cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049d6:	e8 80 06 00 00       	call   c010505b <alloc_pages>
c01049db:	85 c0                	test   %eax,%eax
c01049dd:	74 24                	je     c0104a03 <default_check+0x32e>
c01049df:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c01049e6:	c0 
c01049e7:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c01049ee:	c0 
c01049ef:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01049f6:	00 
c01049f7:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c01049fe:	e8 cc c2 ff ff       	call   c0100ccf <__panic>
    assert(p0 + 2 == p1);
c0104a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a06:	83 c0 28             	add    $0x28,%eax
c0104a09:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104a0c:	74 24                	je     c0104a32 <default_check+0x35d>
c0104a0e:	c7 44 24 0c 3e 81 10 	movl   $0xc010813e,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104a2d:	e8 9d c2 ff ff       	call   c0100ccf <__panic>

    p2 = p0 + 1;
c0104a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a35:	83 c0 14             	add    $0x14,%eax
c0104a38:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104a3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a42:	00 
c0104a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a46:	89 04 24             	mov    %eax,(%esp)
c0104a49:	e8 45 06 00 00       	call   c0105093 <free_pages>
    free_pages(p1, 3);
c0104a4e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104a55:	00 
c0104a56:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a59:	89 04 24             	mov    %eax,(%esp)
c0104a5c:	e8 32 06 00 00       	call   c0105093 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a64:	83 c0 04             	add    $0x4,%eax
c0104a67:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104a6e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a71:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a74:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104a77:	0f a3 10             	bt     %edx,(%eax)
c0104a7a:	19 c0                	sbb    %eax,%eax
c0104a7c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104a7f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104a83:	0f 95 c0             	setne  %al
c0104a86:	0f b6 c0             	movzbl %al,%eax
c0104a89:	85 c0                	test   %eax,%eax
c0104a8b:	74 0b                	je     c0104a98 <default_check+0x3c3>
c0104a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a90:	8b 40 08             	mov    0x8(%eax),%eax
c0104a93:	83 f8 01             	cmp    $0x1,%eax
c0104a96:	74 24                	je     c0104abc <default_check+0x3e7>
c0104a98:	c7 44 24 0c 4c 81 10 	movl   $0xc010814c,0xc(%esp)
c0104a9f:	c0 
c0104aa0:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104aa7:	c0 
c0104aa8:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104aaf:	00 
c0104ab0:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104ab7:	e8 13 c2 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104abf:	83 c0 04             	add    $0x4,%eax
c0104ac2:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104ac9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104acc:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104acf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104ad2:	0f a3 10             	bt     %edx,(%eax)
c0104ad5:	19 c0                	sbb    %eax,%eax
c0104ad7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104ada:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104ade:	0f 95 c0             	setne  %al
c0104ae1:	0f b6 c0             	movzbl %al,%eax
c0104ae4:	85 c0                	test   %eax,%eax
c0104ae6:	74 0b                	je     c0104af3 <default_check+0x41e>
c0104ae8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104aeb:	8b 40 08             	mov    0x8(%eax),%eax
c0104aee:	83 f8 03             	cmp    $0x3,%eax
c0104af1:	74 24                	je     c0104b17 <default_check+0x442>
c0104af3:	c7 44 24 0c 74 81 10 	movl   $0xc0108174,0xc(%esp)
c0104afa:	c0 
c0104afb:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104b02:	c0 
c0104b03:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0104b0a:	00 
c0104b0b:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104b12:	e8 b8 c1 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104b17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b1e:	e8 38 05 00 00       	call   c010505b <alloc_pages>
c0104b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b29:	83 e8 14             	sub    $0x14,%eax
c0104b2c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104b2f:	74 24                	je     c0104b55 <default_check+0x480>
c0104b31:	c7 44 24 0c 9a 81 10 	movl   $0xc010819a,0xc(%esp)
c0104b38:	c0 
c0104b39:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104b40:	c0 
c0104b41:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0104b48:	00 
c0104b49:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104b50:	e8 7a c1 ff ff       	call   c0100ccf <__panic>
    free_page(p0);
c0104b55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b5c:	00 
c0104b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b60:	89 04 24             	mov    %eax,(%esp)
c0104b63:	e8 2b 05 00 00       	call   c0105093 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104b68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104b6f:	e8 e7 04 00 00       	call   c010505b <alloc_pages>
c0104b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b7a:	83 c0 14             	add    $0x14,%eax
c0104b7d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104b80:	74 24                	je     c0104ba6 <default_check+0x4d1>
c0104b82:	c7 44 24 0c b8 81 10 	movl   $0xc01081b8,0xc(%esp)
c0104b89:	c0 
c0104b8a:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104b91:	c0 
c0104b92:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0104b99:	00 
c0104b9a:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104ba1:	e8 29 c1 ff ff       	call   c0100ccf <__panic>

    free_pages(p0, 2);
c0104ba6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104bad:	00 
c0104bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb1:	89 04 24             	mov    %eax,(%esp)
c0104bb4:	e8 da 04 00 00       	call   c0105093 <free_pages>
    free_page(p2);
c0104bb9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104bc0:	00 
c0104bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104bc4:	89 04 24             	mov    %eax,(%esp)
c0104bc7:	e8 c7 04 00 00       	call   c0105093 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104bcc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104bd3:	e8 83 04 00 00       	call   c010505b <alloc_pages>
c0104bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104bdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104bdf:	75 24                	jne    c0104c05 <default_check+0x530>
c0104be1:	c7 44 24 0c d8 81 10 	movl   $0xc01081d8,0xc(%esp)
c0104be8:	c0 
c0104be9:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104bf0:	c0 
c0104bf1:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0104bf8:	00 
c0104bf9:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104c00:	e8 ca c0 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0104c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c0c:	e8 4a 04 00 00       	call   c010505b <alloc_pages>
c0104c11:	85 c0                	test   %eax,%eax
c0104c13:	74 24                	je     c0104c39 <default_check+0x564>
c0104c15:	c7 44 24 0c 36 80 10 	movl   $0xc0108036,0xc(%esp)
c0104c1c:	c0 
c0104c1d:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104c24:	c0 
c0104c25:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0104c2c:	00 
c0104c2d:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104c34:	e8 96 c0 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c0104c39:	a1 b4 b9 11 c0       	mov    0xc011b9b4,%eax
c0104c3e:	85 c0                	test   %eax,%eax
c0104c40:	74 24                	je     c0104c66 <default_check+0x591>
c0104c42:	c7 44 24 0c 89 80 10 	movl   $0xc0108089,0xc(%esp)
c0104c49:	c0 
c0104c4a:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104c51:	c0 
c0104c52:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104c59:	00 
c0104c5a:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104c61:	e8 69 c0 ff ff       	call   c0100ccf <__panic>
    nr_free = nr_free_store;
c0104c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c69:	a3 b4 b9 11 c0       	mov    %eax,0xc011b9b4

    free_list = free_list_store;
c0104c6e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104c71:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104c74:	a3 ac b9 11 c0       	mov    %eax,0xc011b9ac
c0104c79:	89 15 b0 b9 11 c0    	mov    %edx,0xc011b9b0
    free_pages(p0, 5);
c0104c7f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104c86:	00 
c0104c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c8a:	89 04 24             	mov    %eax,(%esp)
c0104c8d:	e8 01 04 00 00       	call   c0105093 <free_pages>

    le = &free_list;
c0104c92:	c7 45 ec ac b9 11 c0 	movl   $0xc011b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104c99:	eb 1d                	jmp    c0104cb8 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c9e:	83 e8 0c             	sub    $0xc,%eax
c0104ca1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104ca4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104cae:	8b 40 08             	mov    0x8(%eax),%eax
c0104cb1:	29 c2                	sub    %eax,%edx
c0104cb3:	89 d0                	mov    %edx,%eax
c0104cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cbb:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104cbe:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104cc1:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cc7:	81 7d ec ac b9 11 c0 	cmpl   $0xc011b9ac,-0x14(%ebp)
c0104cce:	75 cb                	jne    c0104c9b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cd4:	74 24                	je     c0104cfa <default_check+0x625>
c0104cd6:	c7 44 24 0c f6 81 10 	movl   $0xc01081f6,0xc(%esp)
c0104cdd:	c0 
c0104cde:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104ce5:	c0 
c0104ce6:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0104ced:	00 
c0104cee:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104cf5:	e8 d5 bf ff ff       	call   c0100ccf <__panic>
    assert(total == 0);
c0104cfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cfe:	74 24                	je     c0104d24 <default_check+0x64f>
c0104d00:	c7 44 24 0c 01 82 10 	movl   $0xc0108201,0xc(%esp)
c0104d07:	c0 
c0104d08:	c7 44 24 08 4d 7e 10 	movl   $0xc0107e4d,0x8(%esp)
c0104d0f:	c0 
c0104d10:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0104d17:	00 
c0104d18:	c7 04 24 62 7e 10 c0 	movl   $0xc0107e62,(%esp)
c0104d1f:	e8 ab bf ff ff       	call   c0100ccf <__panic>
}
c0104d24:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104d2a:	5b                   	pop    %ebx
c0104d2b:	5d                   	pop    %ebp
c0104d2c:	c3                   	ret    

c0104d2d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104d2d:	55                   	push   %ebp
c0104d2e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104d30:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d33:	a1 c0 b9 11 c0       	mov    0xc011b9c0,%eax
c0104d38:	29 c2                	sub    %eax,%edx
c0104d3a:	89 d0                	mov    %edx,%eax
c0104d3c:	c1 f8 02             	sar    $0x2,%eax
c0104d3f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104d45:	5d                   	pop    %ebp
c0104d46:	c3                   	ret    

c0104d47 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104d47:	55                   	push   %ebp
c0104d48:	89 e5                	mov    %esp,%ebp
c0104d4a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d50:	89 04 24             	mov    %eax,(%esp)
c0104d53:	e8 d5 ff ff ff       	call   c0104d2d <page2ppn>
c0104d58:	c1 e0 0c             	shl    $0xc,%eax
}
c0104d5b:	c9                   	leave  
c0104d5c:	c3                   	ret    

c0104d5d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104d5d:	55                   	push   %ebp
c0104d5e:	89 e5                	mov    %esp,%ebp
c0104d60:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d66:	c1 e8 0c             	shr    $0xc,%eax
c0104d69:	89 c2                	mov    %eax,%edx
c0104d6b:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0104d70:	39 c2                	cmp    %eax,%edx
c0104d72:	72 1c                	jb     c0104d90 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104d74:	c7 44 24 08 3c 82 10 	movl   $0xc010823c,0x8(%esp)
c0104d7b:	c0 
c0104d7c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0104d83:	00 
c0104d84:	c7 04 24 5b 82 10 c0 	movl   $0xc010825b,(%esp)
c0104d8b:	e8 3f bf ff ff       	call   c0100ccf <__panic>
    }
    return &pages[PPN(pa)];
c0104d90:	8b 0d c0 b9 11 c0    	mov    0xc011b9c0,%ecx
c0104d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d99:	c1 e8 0c             	shr    $0xc,%eax
c0104d9c:	89 c2                	mov    %eax,%edx
c0104d9e:	89 d0                	mov    %edx,%eax
c0104da0:	c1 e0 02             	shl    $0x2,%eax
c0104da3:	01 d0                	add    %edx,%eax
c0104da5:	c1 e0 02             	shl    $0x2,%eax
c0104da8:	01 c8                	add    %ecx,%eax
}
c0104daa:	c9                   	leave  
c0104dab:	c3                   	ret    

c0104dac <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104dac:	55                   	push   %ebp
c0104dad:	89 e5                	mov    %esp,%ebp
c0104daf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db5:	89 04 24             	mov    %eax,(%esp)
c0104db8:	e8 8a ff ff ff       	call   c0104d47 <page2pa>
c0104dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc3:	c1 e8 0c             	shr    $0xc,%eax
c0104dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dc9:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0104dce:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104dd1:	72 23                	jb     c0104df6 <page2kva+0x4a>
c0104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104dda:	c7 44 24 08 6c 82 10 	movl   $0xc010826c,0x8(%esp)
c0104de1:	c0 
c0104de2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0104de9:	00 
c0104dea:	c7 04 24 5b 82 10 c0 	movl   $0xc010825b,(%esp)
c0104df1:	e8 d9 be ff ff       	call   c0100ccf <__panic>
c0104df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104dfe:	c9                   	leave  
c0104dff:	c3                   	ret    

c0104e00 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104e00:	55                   	push   %ebp
c0104e01:	89 e5                	mov    %esp,%ebp
c0104e03:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e09:	83 e0 01             	and    $0x1,%eax
c0104e0c:	85 c0                	test   %eax,%eax
c0104e0e:	75 1c                	jne    c0104e2c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104e10:	c7 44 24 08 90 82 10 	movl   $0xc0108290,0x8(%esp)
c0104e17:	c0 
c0104e18:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0104e1f:	00 
c0104e20:	c7 04 24 5b 82 10 c0 	movl   $0xc010825b,(%esp)
c0104e27:	e8 a3 be ff ff       	call   c0100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e34:	89 04 24             	mov    %eax,(%esp)
c0104e37:	e8 21 ff ff ff       	call   c0104d5d <pa2page>
}
c0104e3c:	c9                   	leave  
c0104e3d:	c3                   	ret    

c0104e3e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104e3e:	55                   	push   %ebp
c0104e3f:	89 e5                	mov    %esp,%ebp
c0104e41:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e4c:	89 04 24             	mov    %eax,(%esp)
c0104e4f:	e8 09 ff ff ff       	call   c0104d5d <pa2page>
}
c0104e54:	c9                   	leave  
c0104e55:	c3                   	ret    

c0104e56 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104e56:	55                   	push   %ebp
c0104e57:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e5c:	8b 00                	mov    (%eax),%eax
}
c0104e5e:	5d                   	pop    %ebp
c0104e5f:	c3                   	ret    

c0104e60 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104e60:	55                   	push   %ebp
c0104e61:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104e63:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e66:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e69:	89 10                	mov    %edx,(%eax)
}
c0104e6b:	5d                   	pop    %ebp
c0104e6c:	c3                   	ret    

c0104e6d <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104e6d:	55                   	push   %ebp
c0104e6e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104e70:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e73:	8b 00                	mov    (%eax),%eax
c0104e75:	8d 50 01             	lea    0x1(%eax),%edx
c0104e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e7b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e80:	8b 00                	mov    (%eax),%eax
}
c0104e82:	5d                   	pop    %ebp
c0104e83:	c3                   	ret    

c0104e84 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104e84:	55                   	push   %ebp
c0104e85:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104e87:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e8a:	8b 00                	mov    (%eax),%eax
c0104e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104e8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e92:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e94:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e97:	8b 00                	mov    (%eax),%eax
}
c0104e99:	5d                   	pop    %ebp
c0104e9a:	c3                   	ret    

c0104e9b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104e9b:	55                   	push   %ebp
c0104e9c:	89 e5                	mov    %esp,%ebp
c0104e9e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104ea1:	9c                   	pushf  
c0104ea2:	58                   	pop    %eax
c0104ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104ea9:	25 00 02 00 00       	and    $0x200,%eax
c0104eae:	85 c0                	test   %eax,%eax
c0104eb0:	74 0c                	je     c0104ebe <__intr_save+0x23>
        intr_disable();
c0104eb2:	e8 fb c7 ff ff       	call   c01016b2 <intr_disable>
        return 1;
c0104eb7:	b8 01 00 00 00       	mov    $0x1,%eax
c0104ebc:	eb 05                	jmp    c0104ec3 <__intr_save+0x28>
    }
    return 0;
c0104ebe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec3:	c9                   	leave  
c0104ec4:	c3                   	ret    

c0104ec5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104ec5:	55                   	push   %ebp
c0104ec6:	89 e5                	mov    %esp,%ebp
c0104ec8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104ecb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ecf:	74 05                	je     c0104ed6 <__intr_restore+0x11>
        intr_enable();
c0104ed1:	e8 d6 c7 ff ff       	call   c01016ac <intr_enable>
    }
}
c0104ed6:	c9                   	leave  
c0104ed7:	c3                   	ret    

c0104ed8 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104ed8:	55                   	push   %ebp
c0104ed9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104edb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ede:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104ee1:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ee6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104ee8:	b8 23 00 00 00       	mov    $0x23,%eax
c0104eed:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104eef:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ef4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104ef6:	b8 10 00 00 00       	mov    $0x10,%eax
c0104efb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104efd:	b8 10 00 00 00       	mov    $0x10,%eax
c0104f02:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104f04:	ea 0b 4f 10 c0 08 00 	ljmp   $0x8,$0xc0104f0b
}
c0104f0b:	5d                   	pop    %ebp
c0104f0c:	c3                   	ret    

c0104f0d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104f0d:	55                   	push   %ebp
c0104f0e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f13:	a3 e4 b8 11 c0       	mov    %eax,0xc011b8e4
}
c0104f18:	5d                   	pop    %ebp
c0104f19:	c3                   	ret    

c0104f1a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104f1a:	55                   	push   %ebp
c0104f1b:	89 e5                	mov    %esp,%ebp
c0104f1d:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104f20:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0104f25:	89 04 24             	mov    %eax,(%esp)
c0104f28:	e8 e0 ff ff ff       	call   c0104f0d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104f2d:	66 c7 05 e8 b8 11 c0 	movw   $0x10,0xc011b8e8
c0104f34:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104f36:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0104f3d:	68 00 
c0104f3f:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104f44:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0104f4a:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104f4f:	c1 e8 10             	shr    $0x10,%eax
c0104f52:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0104f57:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f5e:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f61:	83 c8 09             	or     $0x9,%eax
c0104f64:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f69:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f70:	83 e0 ef             	and    $0xffffffef,%eax
c0104f73:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f78:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f7f:	83 e0 9f             	and    $0xffffff9f,%eax
c0104f82:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f87:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f8e:	83 c8 80             	or     $0xffffff80,%eax
c0104f91:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f96:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104f9d:	83 e0 f0             	and    $0xfffffff0,%eax
c0104fa0:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fa5:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fac:	83 e0 ef             	and    $0xffffffef,%eax
c0104faf:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fb4:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fbb:	83 e0 df             	and    $0xffffffdf,%eax
c0104fbe:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fc3:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fca:	83 c8 40             	or     $0x40,%eax
c0104fcd:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fd2:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fd9:	83 e0 7f             	and    $0x7f,%eax
c0104fdc:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fe1:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104fe6:	c1 e8 18             	shr    $0x18,%eax
c0104fe9:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104fee:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c0104ff5:	e8 de fe ff ff       	call   c0104ed8 <lgdt>
c0104ffa:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0105000:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0105004:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0105007:	c9                   	leave  
c0105008:	c3                   	ret    

c0105009 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0105009:	55                   	push   %ebp
c010500a:	89 e5                	mov    %esp,%ebp
c010500c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010500f:	c7 05 b8 b9 11 c0 20 	movl   $0xc0108220,0xc011b9b8
c0105016:	82 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0105019:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c010501e:	8b 00                	mov    (%eax),%eax
c0105020:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105024:	c7 04 24 bc 82 10 c0 	movl   $0xc01082bc,(%esp)
c010502b:	e8 13 b3 ff ff       	call   c0100343 <cprintf>
    pmm_manager->init();
c0105030:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c0105035:	8b 40 04             	mov    0x4(%eax),%eax
c0105038:	ff d0                	call   *%eax
}
c010503a:	c9                   	leave  
c010503b:	c3                   	ret    

c010503c <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010503c:	55                   	push   %ebp
c010503d:	89 e5                	mov    %esp,%ebp
c010503f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0105042:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c0105047:	8b 40 08             	mov    0x8(%eax),%eax
c010504a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010504d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105051:	8b 55 08             	mov    0x8(%ebp),%edx
c0105054:	89 14 24             	mov    %edx,(%esp)
c0105057:	ff d0                	call   *%eax
}
c0105059:	c9                   	leave  
c010505a:	c3                   	ret    

c010505b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010505b:	55                   	push   %ebp
c010505c:	89 e5                	mov    %esp,%ebp
c010505e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0105061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0105068:	e8 2e fe ff ff       	call   c0104e9b <__intr_save>
c010506d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0105070:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c0105075:	8b 40 0c             	mov    0xc(%eax),%eax
c0105078:	8b 55 08             	mov    0x8(%ebp),%edx
c010507b:	89 14 24             	mov    %edx,(%esp)
c010507e:	ff d0                	call   *%eax
c0105080:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0105083:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105086:	89 04 24             	mov    %eax,(%esp)
c0105089:	e8 37 fe ff ff       	call   c0104ec5 <__intr_restore>
    return page;
c010508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105091:	c9                   	leave  
c0105092:	c3                   	ret    

c0105093 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0105093:	55                   	push   %ebp
c0105094:	89 e5                	mov    %esp,%ebp
c0105096:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0105099:	e8 fd fd ff ff       	call   c0104e9b <__intr_save>
c010509e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01050a1:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c01050a6:	8b 40 10             	mov    0x10(%eax),%eax
c01050a9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050ac:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01050b3:	89 14 24             	mov    %edx,(%esp)
c01050b6:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050bb:	89 04 24             	mov    %eax,(%esp)
c01050be:	e8 02 fe ff ff       	call   c0104ec5 <__intr_restore>
}
c01050c3:	c9                   	leave  
c01050c4:	c3                   	ret    

c01050c5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01050c5:	55                   	push   %ebp
c01050c6:	89 e5                	mov    %esp,%ebp
c01050c8:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01050cb:	e8 cb fd ff ff       	call   c0104e9b <__intr_save>
c01050d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01050d3:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c01050d8:	8b 40 14             	mov    0x14(%eax),%eax
c01050db:	ff d0                	call   *%eax
c01050dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01050e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e3:	89 04 24             	mov    %eax,(%esp)
c01050e6:	e8 da fd ff ff       	call   c0104ec5 <__intr_restore>
    return ret;
c01050eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01050ee:	c9                   	leave  
c01050ef:	c3                   	ret    

c01050f0 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01050f0:	55                   	push   %ebp
c01050f1:	89 e5                	mov    %esp,%ebp
c01050f3:	57                   	push   %edi
c01050f4:	56                   	push   %esi
c01050f5:	53                   	push   %ebx
c01050f6:	81 ec ac 00 00 00    	sub    $0xac,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01050fc:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0105103:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010510a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0105111:	c7 04 24 d3 82 10 c0 	movl   $0xc01082d3,(%esp)
c0105118:	e8 26 b2 ff ff       	call   c0100343 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010511d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105124:	e9 42 01 00 00       	jmp    c010526b <page_init+0x17b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105129:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010512c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010512f:	89 d0                	mov    %edx,%eax
c0105131:	c1 e0 02             	shl    $0x2,%eax
c0105134:	01 d0                	add    %edx,%eax
c0105136:	c1 e0 02             	shl    $0x2,%eax
c0105139:	01 c8                	add    %ecx,%eax
c010513b:	8b 50 08             	mov    0x8(%eax),%edx
c010513e:	8b 40 04             	mov    0x4(%eax),%eax
c0105141:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105144:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105147:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010514a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010514d:	89 d0                	mov    %edx,%eax
c010514f:	c1 e0 02             	shl    $0x2,%eax
c0105152:	01 d0                	add    %edx,%eax
c0105154:	c1 e0 02             	shl    $0x2,%eax
c0105157:	01 c8                	add    %ecx,%eax
c0105159:	8b 48 0c             	mov    0xc(%eax),%ecx
c010515c:	8b 58 10             	mov    0x10(%eax),%ebx
c010515f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105162:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105165:	01 c8                	add    %ecx,%eax
c0105167:	11 da                	adc    %ebx,%edx
c0105169:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010516c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d(%s).\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type,
                memmap->map[i].type == E820_ARM ? "MEMORY" : "RESERVED");
c010516f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105172:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105175:	89 d0                	mov    %edx,%eax
c0105177:	c1 e0 02             	shl    $0x2,%eax
c010517a:	01 d0                	add    %edx,%eax
c010517c:	c1 e0 02             	shl    $0x2,%eax
c010517f:	01 c8                	add    %ecx,%eax
c0105181:	83 c0 14             	add    $0x14,%eax
c0105184:	8b 00                	mov    (%eax),%eax

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d(%s).\n",
c0105186:	83 f8 01             	cmp    $0x1,%eax
c0105189:	75 09                	jne    c0105194 <page_init+0xa4>
c010518b:	c7 45 84 dd 82 10 c0 	movl   $0xc01082dd,-0x7c(%ebp)
c0105192:	eb 07                	jmp    c010519b <page_init+0xab>
c0105194:	c7 45 84 e4 82 10 c0 	movl   $0xc01082e4,-0x7c(%ebp)
c010519b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010519e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a1:	89 d0                	mov    %edx,%eax
c01051a3:	c1 e0 02             	shl    $0x2,%eax
c01051a6:	01 d0                	add    %edx,%eax
c01051a8:	c1 e0 02             	shl    $0x2,%eax
c01051ab:	01 c8                	add    %ecx,%eax
c01051ad:	83 c0 14             	add    $0x14,%eax
c01051b0:	8b 00                	mov    (%eax),%eax
c01051b2:	89 45 80             	mov    %eax,-0x80(%ebp)
c01051b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01051b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01051bb:	83 c0 ff             	add    $0xffffffff,%eax
c01051be:	83 d2 ff             	adc    $0xffffffff,%edx
c01051c1:	89 c6                	mov    %eax,%esi
c01051c3:	89 d7                	mov    %edx,%edi
c01051c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051cb:	89 d0                	mov    %edx,%eax
c01051cd:	c1 e0 02             	shl    $0x2,%eax
c01051d0:	01 d0                	add    %edx,%eax
c01051d2:	c1 e0 02             	shl    $0x2,%eax
c01051d5:	01 c8                	add    %ecx,%eax
c01051d7:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051da:	8b 58 10             	mov    0x10(%eax),%ebx
c01051dd:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01051e0:	89 54 24 20          	mov    %edx,0x20(%esp)
c01051e4:	8b 45 80             	mov    -0x80(%ebp),%eax
c01051e7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01051eb:	89 74 24 14          	mov    %esi,0x14(%esp)
c01051ef:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01051f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01051f6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01051f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051fd:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105201:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105205:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105209:	c7 04 24 f0 82 10 c0 	movl   $0xc01082f0,(%esp)
c0105210:	e8 2e b1 ff ff       	call   c0100343 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type,
                memmap->map[i].type == E820_ARM ? "MEMORY" : "RESERVED");
        if (memmap->map[i].type == E820_ARM) {
c0105215:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105218:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010521b:	89 d0                	mov    %edx,%eax
c010521d:	c1 e0 02             	shl    $0x2,%eax
c0105220:	01 d0                	add    %edx,%eax
c0105222:	c1 e0 02             	shl    $0x2,%eax
c0105225:	01 c8                	add    %ecx,%eax
c0105227:	83 c0 14             	add    $0x14,%eax
c010522a:	8b 00                	mov    (%eax),%eax
c010522c:	83 f8 01             	cmp    $0x1,%eax
c010522f:	75 36                	jne    c0105267 <page_init+0x177>
            if (maxpa < end && begin < KMEMSIZE) {
c0105231:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105237:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010523a:	77 2b                	ja     c0105267 <page_init+0x177>
c010523c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010523f:	72 05                	jb     c0105246 <page_init+0x156>
c0105241:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105244:	73 21                	jae    c0105267 <page_init+0x177>
c0105246:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010524a:	77 1b                	ja     c0105267 <page_init+0x177>
c010524c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105250:	72 09                	jb     c010525b <page_init+0x16b>
c0105252:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105259:	77 0c                	ja     c0105267 <page_init+0x177>
                maxpa = end;
c010525b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010525e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105261:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105264:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105267:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010526b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010526e:	8b 00                	mov    (%eax),%eax
c0105270:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105273:	0f 8f b0 fe ff ff    	jg     c0105129 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105279:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010527d:	72 1d                	jb     c010529c <page_init+0x1ac>
c010527f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105283:	77 09                	ja     c010528e <page_init+0x19e>
c0105285:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010528c:	76 0e                	jbe    c010529c <page_init+0x1ac>
        maxpa = KMEMSIZE;
c010528e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105295:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    // page number of Max PA, valid page must be less than this value.
    npage = maxpa / PGSIZE;
c010529c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010529f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052a2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01052a6:	c1 ea 0c             	shr    $0xc,%edx
c01052a9:	a3 c0 b8 11 c0       	mov    %eax,0xc011b8c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01052ae:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01052b5:	b8 c4 b9 11 c0       	mov    $0xc011b9c4,%eax
c01052ba:	8d 50 ff             	lea    -0x1(%eax),%edx
c01052bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01052c0:	01 d0                	add    %edx,%eax
c01052c2:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01052c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01052c8:	ba 00 00 00 00       	mov    $0x0,%edx
c01052cd:	f7 75 ac             	divl   -0x54(%ebp)
c01052d0:	89 d0                	mov    %edx,%eax
c01052d2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01052d5:	29 c2                	sub    %eax,%edx
c01052d7:	89 d0                	mov    %edx,%eax
c01052d9:	a3 c0 b9 11 c0       	mov    %eax,0xc011b9c0

    for (i = 0; i < npage; i ++) {
c01052de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01052e5:	eb 2f                	jmp    c0105316 <page_init+0x226>
        SetPageReserved(pages + i);
c01052e7:	8b 0d c0 b9 11 c0    	mov    0xc011b9c0,%ecx
c01052ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f0:	89 d0                	mov    %edx,%eax
c01052f2:	c1 e0 02             	shl    $0x2,%eax
c01052f5:	01 d0                	add    %edx,%eax
c01052f7:	c1 e0 02             	shl    $0x2,%eax
c01052fa:	01 c8                	add    %ecx,%eax
c01052fc:	83 c0 04             	add    $0x4,%eax
c01052ff:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0105306:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105309:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010530c:	8b 55 90             	mov    -0x70(%ebp),%edx
c010530f:	0f ab 10             	bts    %edx,(%eax)

    // page number of Max PA, valid page must be less than this value.
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105312:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105316:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105319:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c010531e:	39 c2                	cmp    %eax,%edx
c0105320:	72 c5                	jb     c01052e7 <page_init+0x1f7>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105322:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0105328:	89 d0                	mov    %edx,%eax
c010532a:	c1 e0 02             	shl    $0x2,%eax
c010532d:	01 d0                	add    %edx,%eax
c010532f:	c1 e0 02             	shl    $0x2,%eax
c0105332:	89 c2                	mov    %eax,%edx
c0105334:	a1 c0 b9 11 c0       	mov    0xc011b9c0,%eax
c0105339:	01 d0                	add    %edx,%eax
c010533b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010533e:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105345:	77 23                	ja     c010536a <page_init+0x27a>
c0105347:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010534a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010534e:	c7 44 24 08 24 83 10 	movl   $0xc0108324,0x8(%esp)
c0105355:	c0 
c0105356:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010535d:	00 
c010535e:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105365:	e8 65 b9 ff ff       	call   c0100ccf <__panic>
c010536a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010536d:	05 00 00 00 40       	add    $0x40000000,%eax
c0105372:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105375:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010537c:	e9 80 01 00 00       	jmp    c0105501 <page_init+0x411>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105381:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105384:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105387:	89 d0                	mov    %edx,%eax
c0105389:	c1 e0 02             	shl    $0x2,%eax
c010538c:	01 d0                	add    %edx,%eax
c010538e:	c1 e0 02             	shl    $0x2,%eax
c0105391:	01 c8                	add    %ecx,%eax
c0105393:	8b 50 08             	mov    0x8(%eax),%edx
c0105396:	8b 40 04             	mov    0x4(%eax),%eax
c0105399:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010539c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010539f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01053a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a5:	89 d0                	mov    %edx,%eax
c01053a7:	c1 e0 02             	shl    $0x2,%eax
c01053aa:	01 d0                	add    %edx,%eax
c01053ac:	c1 e0 02             	shl    $0x2,%eax
c01053af:	01 c8                	add    %ecx,%eax
c01053b1:	8b 48 0c             	mov    0xc(%eax),%ecx
c01053b4:	8b 58 10             	mov    0x10(%eax),%ebx
c01053b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053bd:	01 c8                	add    %ecx,%eax
c01053bf:	11 da                	adc    %ebx,%edx
c01053c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01053c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01053c7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01053ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053cd:	89 d0                	mov    %edx,%eax
c01053cf:	c1 e0 02             	shl    $0x2,%eax
c01053d2:	01 d0                	add    %edx,%eax
c01053d4:	c1 e0 02             	shl    $0x2,%eax
c01053d7:	01 c8                	add    %ecx,%eax
c01053d9:	83 c0 14             	add    $0x14,%eax
c01053dc:	8b 00                	mov    (%eax),%eax
c01053de:	83 f8 01             	cmp    $0x1,%eax
c01053e1:	0f 85 16 01 00 00    	jne    c01054fd <page_init+0x40d>
            if (begin < freemem) {
c01053e7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053ea:	ba 00 00 00 00       	mov    $0x0,%edx
c01053ef:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053f2:	72 17                	jb     c010540b <page_init+0x31b>
c01053f4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053f7:	77 05                	ja     c01053fe <page_init+0x30e>
c01053f9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053fc:	76 0d                	jbe    c010540b <page_init+0x31b>
                begin = freemem;
c01053fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105401:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105404:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010540b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010540f:	72 1d                	jb     c010542e <page_init+0x33e>
c0105411:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105415:	77 09                	ja     c0105420 <page_init+0x330>
c0105417:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010541e:	76 0e                	jbe    c010542e <page_init+0x33e>
                end = KMEMSIZE;
c0105420:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105427:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010542e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105431:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105434:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105437:	0f 87 c0 00 00 00    	ja     c01054fd <page_init+0x40d>
c010543d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105440:	72 09                	jb     c010544b <page_init+0x35b>
c0105442:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105445:	0f 83 b2 00 00 00    	jae    c01054fd <page_init+0x40d>
                begin = ROUNDUP(begin, PGSIZE);
c010544b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105452:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105455:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105458:	01 d0                	add    %edx,%eax
c010545a:	83 e8 01             	sub    $0x1,%eax
c010545d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105460:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105463:	ba 00 00 00 00       	mov    $0x0,%edx
c0105468:	f7 75 9c             	divl   -0x64(%ebp)
c010546b:	89 d0                	mov    %edx,%eax
c010546d:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105470:	29 c2                	sub    %eax,%edx
c0105472:	89 d0                	mov    %edx,%eax
c0105474:	ba 00 00 00 00       	mov    $0x0,%edx
c0105479:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010547c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010547f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105482:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105485:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105488:	ba 00 00 00 00       	mov    $0x0,%edx
c010548d:	89 c7                	mov    %eax,%edi
c010548f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105495:	89 bd 78 ff ff ff    	mov    %edi,-0x88(%ebp)
c010549b:	89 d0                	mov    %edx,%eax
c010549d:	83 e0 00             	and    $0x0,%eax
c01054a0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01054a6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01054ac:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01054b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01054b5:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01054b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054be:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01054c1:	77 3a                	ja     c01054fd <page_init+0x40d>
c01054c3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01054c6:	72 05                	jb     c01054cd <page_init+0x3dd>
c01054c8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01054cb:	73 30                	jae    c01054fd <page_init+0x40d>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01054cd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01054d0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01054d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01054d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01054d9:	29 c8                	sub    %ecx,%eax
c01054db:	19 da                	sbb    %ebx,%edx
c01054dd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01054e1:	c1 ea 0c             	shr    $0xc,%edx
c01054e4:	89 c3                	mov    %eax,%ebx
c01054e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054e9:	89 04 24             	mov    %eax,(%esp)
c01054ec:	e8 6c f8 ff ff       	call   c0104d5d <pa2page>
c01054f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01054f5:	89 04 24             	mov    %eax,(%esp)
c01054f8:	e8 3f fb ff ff       	call   c010503c <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01054fd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105501:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105504:	8b 00                	mov    (%eax),%eax
c0105506:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105509:	0f 8f 72 fe ff ff    	jg     c0105381 <page_init+0x291>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010550f:	81 c4 ac 00 00 00    	add    $0xac,%esp
c0105515:	5b                   	pop    %ebx
c0105516:	5e                   	pop    %esi
c0105517:	5f                   	pop    %edi
c0105518:	5d                   	pop    %ebp
c0105519:	c3                   	ret    

c010551a <enable_paging>:

static void
enable_paging(void) {
c010551a:	55                   	push   %ebp
c010551b:	89 e5                	mov    %esp,%ebp
c010551d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105520:	a1 bc b9 11 c0       	mov    0xc011b9bc,%eax
c0105525:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105528:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010552b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010552e:	0f 20 c0             	mov    %cr0,%eax
c0105531:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105534:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105537:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010553a:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105541:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105545:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010554b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010554e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105551:	c9                   	leave  
c0105552:	c3                   	ret    

c0105553 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105553:	55                   	push   %ebp
c0105554:	89 e5                	mov    %esp,%ebp
c0105556:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105559:	8b 45 14             	mov    0x14(%ebp),%eax
c010555c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010555f:	31 d0                	xor    %edx,%eax
c0105561:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105566:	85 c0                	test   %eax,%eax
c0105568:	74 24                	je     c010558e <boot_map_segment+0x3b>
c010556a:	c7 44 24 0c 56 83 10 	movl   $0xc0108356,0xc(%esp)
c0105571:	c0 
c0105572:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105579:	c0 
c010557a:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0105581:	00 
c0105582:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105589:	e8 41 b7 ff ff       	call   c0100ccf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010558e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105595:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105598:	25 ff 0f 00 00       	and    $0xfff,%eax
c010559d:	89 c2                	mov    %eax,%edx
c010559f:	8b 45 10             	mov    0x10(%ebp),%eax
c01055a2:	01 c2                	add    %eax,%edx
c01055a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a7:	01 d0                	add    %edx,%eax
c01055a9:	83 e8 01             	sub    $0x1,%eax
c01055ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055b2:	ba 00 00 00 00       	mov    $0x0,%edx
c01055b7:	f7 75 f0             	divl   -0x10(%ebp)
c01055ba:	89 d0                	mov    %edx,%eax
c01055bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055bf:	29 c2                	sub    %eax,%edx
c01055c1:	89 d0                	mov    %edx,%eax
c01055c3:	c1 e8 0c             	shr    $0xc,%eax
c01055c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01055c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055d7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01055da:	8b 45 14             	mov    0x14(%ebp),%eax
c01055dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055e8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01055eb:	eb 6b                	jmp    c0105658 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01055ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01055f4:	00 
c01055f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ff:	89 04 24             	mov    %eax,(%esp)
c0105602:	e8 cc 01 00 00       	call   c01057d3 <get_pte>
c0105607:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010560a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010560e:	75 24                	jne    c0105634 <boot_map_segment+0xe1>
c0105610:	c7 44 24 0c 82 83 10 	movl   $0xc0108382,0xc(%esp)
c0105617:	c0 
c0105618:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c010561f:	c0 
c0105620:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0105627:	00 
c0105628:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c010562f:	e8 9b b6 ff ff       	call   c0100ccf <__panic>
        *ptep = pa | PTE_P | perm;
c0105634:	8b 45 18             	mov    0x18(%ebp),%eax
c0105637:	8b 55 14             	mov    0x14(%ebp),%edx
c010563a:	09 d0                	or     %edx,%eax
c010563c:	83 c8 01             	or     $0x1,%eax
c010563f:	89 c2                	mov    %eax,%edx
c0105641:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105644:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105646:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010564a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105651:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010565c:	75 8f                	jne    c01055ed <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010565e:	c9                   	leave  
c010565f:	c3                   	ret    

c0105660 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105660:	55                   	push   %ebp
c0105661:	89 e5                	mov    %esp,%ebp
c0105663:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010566d:	e8 e9 f9 ff ff       	call   c010505b <alloc_pages>
c0105672:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105679:	75 1c                	jne    c0105697 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010567b:	c7 44 24 08 8f 83 10 	movl   $0xc010838f,0x8(%esp)
c0105682:	c0 
c0105683:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010568a:	00 
c010568b:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105692:	e8 38 b6 ff ff       	call   c0100ccf <__panic>
    }
    return page2kva(p);
c0105697:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010569a:	89 04 24             	mov    %eax,(%esp)
c010569d:	e8 0a f7 ff ff       	call   c0104dac <page2kva>
}
c01056a2:	c9                   	leave  
c01056a3:	c3                   	ret    

c01056a4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01056a4:	55                   	push   %ebp
c01056a5:	89 e5                	mov    %esp,%ebp
c01056a7:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01056aa:	e8 5a f9 ff ff       	call   c0105009 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01056af:	e8 3c fa ff ff       	call   c01050f0 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01056b4:	e8 75 04 00 00       	call   c0105b2e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01056b9:	e8 a2 ff ff ff       	call   c0105660 <boot_alloc_page>
c01056be:	a3 c4 b8 11 c0       	mov    %eax,0xc011b8c4
    memset(boot_pgdir, 0, PGSIZE);
c01056c3:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01056c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01056cf:	00 
c01056d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056d7:	00 
c01056d8:	89 04 24             	mov    %eax,(%esp)
c01056db:	e8 b2 1a 00 00       	call   c0107192 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01056e0:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01056e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056e8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01056ef:	77 23                	ja     c0105714 <pmm_init+0x70>
c01056f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056f8:	c7 44 24 08 24 83 10 	movl   $0xc0108324,0x8(%esp)
c01056ff:	c0 
c0105700:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0105707:	00 
c0105708:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c010570f:	e8 bb b5 ff ff       	call   c0100ccf <__panic>
c0105714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105717:	05 00 00 00 40       	add    $0x40000000,%eax
c010571c:	a3 bc b9 11 c0       	mov    %eax,0xc011b9bc

    check_pgdir();
c0105721:	e8 26 04 00 00       	call   c0105b4c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105726:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010572b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105731:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105736:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105739:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105740:	77 23                	ja     c0105765 <pmm_init+0xc1>
c0105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105745:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105749:	c7 44 24 08 24 83 10 	movl   $0xc0108324,0x8(%esp)
c0105750:	c0 
c0105751:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c0105758:	00 
c0105759:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105760:	e8 6a b5 ff ff       	call   c0100ccf <__panic>
c0105765:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105768:	05 00 00 00 40       	add    $0x40000000,%eax
c010576d:	83 c8 03             	or     $0x3,%eax
c0105770:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105772:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105777:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010577e:	00 
c010577f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105786:	00 
c0105787:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010578e:	38 
c010578f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105796:	c0 
c0105797:	89 04 24             	mov    %eax,(%esp)
c010579a:	e8 b4 fd ff ff       	call   c0105553 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010579f:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01057a4:	8b 15 c4 b8 11 c0    	mov    0xc011b8c4,%edx
c01057aa:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01057b0:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01057b2:	e8 63 fd ff ff       	call   c010551a <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01057b7:	e8 5e f7 ff ff       	call   c0104f1a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01057bc:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01057c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01057c7:	e8 1b 0a 00 00       	call   c01061e7 <check_boot_pgdir>

    print_pgdir();
c01057cc:	e8 a3 0e 00 00       	call   c0106674 <print_pgdir>

}
c01057d1:	c9                   	leave  
c01057d2:	c3                   	ret    

c01057d3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01057d3:	55                   	push   %ebp
c01057d4:	89 e5                	mov    %esp,%ebp
c01057d6:	83 ec 38             	sub    $0x38,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */ 

    
    pde_t *pdep = &pgdir[PDX(la)];                    // (1) find page directory entry
c01057d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057dc:	c1 e8 16             	shr    $0x16,%eax
c01057df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e9:	01 d0                	add    %edx,%eax
c01057eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {                           // (2) check if entry is not present
c01057ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f1:	8b 00                	mov    (%eax),%eax
c01057f3:	83 e0 01             	and    $0x1,%eax
c01057f6:	85 c0                	test   %eax,%eax
c01057f8:	0f 85 b6 00 00 00    	jne    c01058b4 <get_pte+0xe1>
        struct Page *p = NULL;
c01057fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        if (!create || (p = alloc_page()) == NULL) {  // (3) check if creating is needed, then alloc page for page table
c0105805:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105809:	74 15                	je     c0105820 <get_pte+0x4d>
c010580b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105812:	e8 44 f8 ff ff       	call   c010505b <alloc_pages>
c0105817:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010581a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010581e:	75 0a                	jne    c010582a <get_pte+0x57>
            return NULL;
c0105820:	b8 00 00 00 00       	mov    $0x0,%eax
c0105825:	e9 e9 00 00 00       	jmp    c0105913 <get_pte+0x140>
        }
        set_page_ref(p, 1);                           // (4) set page reference
c010582a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105831:	00 
c0105832:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105835:	89 04 24             	mov    %eax,(%esp)
c0105838:	e8 23 f6 ff ff       	call   c0104e60 <set_page_ref>
        uintptr_t pa = page2pa(p);                    // (5) get linear address of page
c010583d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105840:	89 04 24             	mov    %eax,(%esp)
c0105843:	e8 ff f4 ff ff       	call   c0104d47 <page2pa>
c0105848:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                 // (6) clear page content using memset
c010584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010584e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105851:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105854:	c1 e8 0c             	shr    $0xc,%eax
c0105857:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010585a:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c010585f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105862:	72 23                	jb     c0105887 <get_pte+0xb4>
c0105864:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105867:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010586b:	c7 44 24 08 6c 82 10 	movl   $0xc010826c,0x8(%esp)
c0105872:	c0 
c0105873:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c010587a:	00 
c010587b:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105882:	e8 48 b4 ff ff       	call   c0100ccf <__panic>
c0105887:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010588a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010588f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105896:	00 
c0105897:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010589e:	00 
c010589f:	89 04 24             	mov    %eax,(%esp)
c01058a2:	e8 eb 18 00 00       	call   c0107192 <memset>
        *pdep = pa | PTE_P | PTE_W | PTE_U;           // (7) set page directory entry's permission
c01058a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058aa:	83 c8 07             	or     $0x7,%eax
c01058ad:	89 c2                	mov    %eax,%edx
c01058af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b2:	89 10                	mov    %edx,(%eax)
    }
    return KADDR(                                     // (8) return page table entry
c01058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b7:	c1 e8 0c             	shr    $0xc,%eax
c01058ba:	25 ff 03 00 00       	and    $0x3ff,%eax
c01058bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01058c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058c9:	8b 00                	mov    (%eax),%eax
c01058cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01058d0:	01 d0                	add    %edx,%eax
c01058d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d8:	c1 e8 0c             	shr    $0xc,%eax
c01058db:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01058de:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c01058e3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01058e6:	72 23                	jb     c010590b <get_pte+0x138>
c01058e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058ef:	c7 44 24 08 6c 82 10 	movl   $0xc010826c,0x8(%esp)
c01058f6:	c0 
c01058f7:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c01058fe:	00 
c01058ff:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105906:	e8 c4 b3 ff ff       	call   c0100ccf <__panic>
c010590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010590e:	2d 00 00 00 40       	sub    $0x40000000,%eax
        &((pte_t *)PDE_ADDR(*pdep))[PTX(la)]
    );
}
c0105913:	c9                   	leave  
c0105914:	c3                   	ret    

c0105915 <get_page>:

//get_page - get related Page structfor linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105915:	55                   	push   %ebp
c0105916:	89 e5                	mov    %esp,%ebp
c0105918:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010591b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105922:	00 
c0105923:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105926:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592a:	8b 45 08             	mov    0x8(%ebp),%eax
c010592d:	89 04 24             	mov    %eax,(%esp)
c0105930:	e8 9e fe ff ff       	call   c01057d3 <get_pte>
c0105935:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105938:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010593c:	74 08                	je     c0105946 <get_page+0x31>
        *ptep_store = ptep;
c010593e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105941:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105944:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010594a:	74 1b                	je     c0105967 <get_page+0x52>
c010594c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	83 e0 01             	and    $0x1,%eax
c0105954:	85 c0                	test   %eax,%eax
c0105956:	74 0f                	je     c0105967 <get_page+0x52>
        return pte2page(*ptep);
c0105958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595b:	8b 00                	mov    (%eax),%eax
c010595d:	89 04 24             	mov    %eax,(%esp)
c0105960:	e8 9b f4 ff ff       	call   c0104e00 <pte2page>
c0105965:	eb 05                	jmp    c010596c <get_page+0x57>
    }
    return NULL;
c0105967:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010596c:	c9                   	leave  
c010596d:	c3                   	ret    

c010596e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010596e:	55                   	push   %ebp
c010596f:	89 e5                	mov    %esp,%ebp
c0105971:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {                      // (1) check if this page table entry is present
c0105974:	8b 45 10             	mov    0x10(%ebp),%eax
c0105977:	8b 00                	mov    (%eax),%eax
c0105979:	83 e0 01             	and    $0x1,%eax
c010597c:	85 c0                	test   %eax,%eax
c010597e:	74 52                	je     c01059d2 <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);  // (2) find corresponding page to pte
c0105980:	8b 45 10             	mov    0x10(%ebp),%eax
c0105983:	8b 00                	mov    (%eax),%eax
c0105985:	89 04 24             	mov    %eax,(%esp)
c0105988:	e8 73 f4 ff ff       	call   c0104e00 <pte2page>
c010598d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                   // (3) decrease page reference
c0105990:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105993:	89 04 24             	mov    %eax,(%esp)
c0105996:	e8 e9 f4 ff ff       	call   c0104e84 <page_ref_dec>
        if (page->ref == 0) {                 // (4) and free this page when page reference reachs 0
c010599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010599e:	8b 00                	mov    (%eax),%eax
c01059a0:	85 c0                	test   %eax,%eax
c01059a2:	75 13                	jne    c01059b7 <page_remove_pte+0x49>
            free_page(page);
c01059a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01059ab:	00 
c01059ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059af:	89 04 24             	mov    %eax,(%esp)
c01059b2:	e8 dc f6 ff ff       	call   c0105093 <free_pages>
        }
        *ptep = 0;                            // (5) clear second page table entry
c01059b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);            // (6) flush tlb
c01059c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ca:	89 04 24             	mov    %eax,(%esp)
c01059cd:	e8 ff 00 00 00       	call   c0105ad1 <tlb_invalidate>
    }
}
c01059d2:	c9                   	leave  
c01059d3:	c3                   	ret    

c01059d4 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01059d4:	55                   	push   %ebp
c01059d5:	89 e5                	mov    %esp,%ebp
c01059d7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01059da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059e1:	00 
c01059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ec:	89 04 24             	mov    %eax,(%esp)
c01059ef:	e8 df fd ff ff       	call   c01057d3 <get_pte>
c01059f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01059f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059fb:	74 19                	je     c0105a16 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01059fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a00:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0e:	89 04 24             	mov    %eax,(%esp)
c0105a11:	e8 58 ff ff ff       	call   c010596e <page_remove_pte>
    }
}
c0105a16:	c9                   	leave  
c0105a17:	c3                   	ret    

c0105a18 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105a18:	55                   	push   %ebp
c0105a19:	89 e5                	mov    %esp,%ebp
c0105a1b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105a1e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105a25:	00 
c0105a26:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a30:	89 04 24             	mov    %eax,(%esp)
c0105a33:	e8 9b fd ff ff       	call   c01057d3 <get_pte>
c0105a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a3f:	75 0a                	jne    c0105a4b <page_insert+0x33>
        return -E_NO_MEM;
c0105a41:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105a46:	e9 84 00 00 00       	jmp    c0105acf <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4e:	89 04 24             	mov    %eax,(%esp)
c0105a51:	e8 17 f4 ff ff       	call   c0104e6d <page_ref_inc>
    if (*ptep & PTE_P) {
c0105a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a59:	8b 00                	mov    (%eax),%eax
c0105a5b:	83 e0 01             	and    $0x1,%eax
c0105a5e:	85 c0                	test   %eax,%eax
c0105a60:	74 3e                	je     c0105aa0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a65:	8b 00                	mov    (%eax),%eax
c0105a67:	89 04 24             	mov    %eax,(%esp)
c0105a6a:	e8 91 f3 ff ff       	call   c0104e00 <pte2page>
c0105a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a75:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a78:	75 0d                	jne    c0105a87 <page_insert+0x6f>
            page_ref_dec(page);
c0105a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7d:	89 04 24             	mov    %eax,(%esp)
c0105a80:	e8 ff f3 ff ff       	call   c0104e84 <page_ref_dec>
c0105a85:	eb 19                	jmp    c0105aa0 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a98:	89 04 24             	mov    %eax,(%esp)
c0105a9b:	e8 ce fe ff ff       	call   c010596e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa3:	89 04 24             	mov    %eax,(%esp)
c0105aa6:	e8 9c f2 ff ff       	call   c0104d47 <page2pa>
c0105aab:	0b 45 14             	or     0x14(%ebp),%eax
c0105aae:	83 c8 01             	or     $0x1,%eax
c0105ab1:	89 c2                	mov    %eax,%edx
c0105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ab6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105ab8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac2:	89 04 24             	mov    %eax,(%esp)
c0105ac5:	e8 07 00 00 00       	call   c0105ad1 <tlb_invalidate>
    return 0;
c0105aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105acf:	c9                   	leave  
c0105ad0:	c3                   	ret    

c0105ad1 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105ad1:	55                   	push   %ebp
c0105ad2:	89 e5                	mov    %esp,%ebp
c0105ad4:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105ad7:	0f 20 d8             	mov    %cr3,%eax
c0105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105add:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105ae0:	89 c2                	mov    %eax,%edx
c0105ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ae8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105aef:	77 23                	ja     c0105b14 <tlb_invalidate+0x43>
c0105af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105af8:	c7 44 24 08 24 83 10 	movl   $0xc0108324,0x8(%esp)
c0105aff:	c0 
c0105b00:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c0105b07:	00 
c0105b08:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105b0f:	e8 bb b1 ff ff       	call   c0100ccf <__panic>
c0105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b17:	05 00 00 00 40       	add    $0x40000000,%eax
c0105b1c:	39 c2                	cmp    %eax,%edx
c0105b1e:	75 0c                	jne    c0105b2c <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105b20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b29:	0f 01 38             	invlpg (%eax)
    }
}
c0105b2c:	c9                   	leave  
c0105b2d:	c3                   	ret    

c0105b2e <check_alloc_page>:

static void
check_alloc_page(void) {
c0105b2e:	55                   	push   %ebp
c0105b2f:	89 e5                	mov    %esp,%ebp
c0105b31:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105b34:	a1 b8 b9 11 c0       	mov    0xc011b9b8,%eax
c0105b39:	8b 40 18             	mov    0x18(%eax),%eax
c0105b3c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105b3e:	c7 04 24 a8 83 10 c0 	movl   $0xc01083a8,(%esp)
c0105b45:	e8 f9 a7 ff ff       	call   c0100343 <cprintf>
}
c0105b4a:	c9                   	leave  
c0105b4b:	c3                   	ret    

c0105b4c <check_pgdir>:

static void
check_pgdir(void) {
c0105b4c:	55                   	push   %ebp
c0105b4d:	89 e5                	mov    %esp,%ebp
c0105b4f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105b52:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0105b57:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105b5c:	76 24                	jbe    c0105b82 <check_pgdir+0x36>
c0105b5e:	c7 44 24 0c c7 83 10 	movl   $0xc01083c7,0xc(%esp)
c0105b65:	c0 
c0105b66:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105b6d:	c0 
c0105b6e:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0105b75:	00 
c0105b76:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105b7d:	e8 4d b1 ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105b82:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105b87:	85 c0                	test   %eax,%eax
c0105b89:	74 0e                	je     c0105b99 <check_pgdir+0x4d>
c0105b8b:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105b90:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105b95:	85 c0                	test   %eax,%eax
c0105b97:	74 24                	je     c0105bbd <check_pgdir+0x71>
c0105b99:	c7 44 24 0c e4 83 10 	movl   $0xc01083e4,0xc(%esp)
c0105ba0:	c0 
c0105ba1:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105ba8:	c0 
c0105ba9:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0105bb0:	00 
c0105bb1:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105bb8:	e8 12 b1 ff ff       	call   c0100ccf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105bbd:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105bc2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105bc9:	00 
c0105bca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105bd1:	00 
c0105bd2:	89 04 24             	mov    %eax,(%esp)
c0105bd5:	e8 3b fd ff ff       	call   c0105915 <get_page>
c0105bda:	85 c0                	test   %eax,%eax
c0105bdc:	74 24                	je     c0105c02 <check_pgdir+0xb6>
c0105bde:	c7 44 24 0c 1c 84 10 	movl   $0xc010841c,0xc(%esp)
c0105be5:	c0 
c0105be6:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105bed:	c0 
c0105bee:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0105bf5:	00 
c0105bf6:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105bfd:	e8 cd b0 ff ff       	call   c0100ccf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105c02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c09:	e8 4d f4 ff ff       	call   c010505b <alloc_pages>
c0105c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105c11:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105c16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105c1d:	00 
c0105c1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c25:	00 
c0105c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c29:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c2d:	89 04 24             	mov    %eax,(%esp)
c0105c30:	e8 e3 fd ff ff       	call   c0105a18 <page_insert>
c0105c35:	85 c0                	test   %eax,%eax
c0105c37:	74 24                	je     c0105c5d <check_pgdir+0x111>
c0105c39:	c7 44 24 0c 44 84 10 	movl   $0xc0108444,0xc(%esp)
c0105c40:	c0 
c0105c41:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105c48:	c0 
c0105c49:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0105c50:	00 
c0105c51:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105c58:	e8 72 b0 ff ff       	call   c0100ccf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105c5d:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105c62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c69:	00 
c0105c6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105c71:	00 
c0105c72:	89 04 24             	mov    %eax,(%esp)
c0105c75:	e8 59 fb ff ff       	call   c01057d3 <get_pte>
c0105c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c81:	75 24                	jne    c0105ca7 <check_pgdir+0x15b>
c0105c83:	c7 44 24 0c 70 84 10 	movl   $0xc0108470,0xc(%esp)
c0105c8a:	c0 
c0105c8b:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105c92:	c0 
c0105c93:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0105c9a:	00 
c0105c9b:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105ca2:	e8 28 b0 ff ff       	call   c0100ccf <__panic>
    assert(pte2page(*ptep) == p1);
c0105ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105caa:	8b 00                	mov    (%eax),%eax
c0105cac:	89 04 24             	mov    %eax,(%esp)
c0105caf:	e8 4c f1 ff ff       	call   c0104e00 <pte2page>
c0105cb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105cb7:	74 24                	je     c0105cdd <check_pgdir+0x191>
c0105cb9:	c7 44 24 0c 9d 84 10 	movl   $0xc010849d,0xc(%esp)
c0105cc0:	c0 
c0105cc1:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105cc8:	c0 
c0105cc9:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0105cd0:	00 
c0105cd1:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105cd8:	e8 f2 af ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 1);
c0105cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce0:	89 04 24             	mov    %eax,(%esp)
c0105ce3:	e8 6e f1 ff ff       	call   c0104e56 <page_ref>
c0105ce8:	83 f8 01             	cmp    $0x1,%eax
c0105ceb:	74 24                	je     c0105d11 <check_pgdir+0x1c5>
c0105ced:	c7 44 24 0c b3 84 10 	movl   $0xc01084b3,0xc(%esp)
c0105cf4:	c0 
c0105cf5:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105cfc:	c0 
c0105cfd:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0105d04:	00 
c0105d05:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105d0c:	e8 be af ff ff       	call   c0100ccf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105d11:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105d16:	8b 00                	mov    (%eax),%eax
c0105d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d23:	c1 e8 0c             	shr    $0xc,%eax
c0105d26:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d29:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0105d2e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105d31:	72 23                	jb     c0105d56 <check_pgdir+0x20a>
c0105d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d3a:	c7 44 24 08 6c 82 10 	movl   $0xc010826c,0x8(%esp)
c0105d41:	c0 
c0105d42:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0105d49:	00 
c0105d4a:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105d51:	e8 79 af ff ff       	call   c0100ccf <__panic>
c0105d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d59:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105d5e:	83 c0 04             	add    $0x4,%eax
c0105d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105d64:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105d69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d70:	00 
c0105d71:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d78:	00 
c0105d79:	89 04 24             	mov    %eax,(%esp)
c0105d7c:	e8 52 fa ff ff       	call   c01057d3 <get_pte>
c0105d81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105d84:	74 24                	je     c0105daa <check_pgdir+0x25e>
c0105d86:	c7 44 24 0c c8 84 10 	movl   $0xc01084c8,0xc(%esp)
c0105d8d:	c0 
c0105d8e:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105d95:	c0 
c0105d96:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0105d9d:	00 
c0105d9e:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105da5:	e8 25 af ff ff       	call   c0100ccf <__panic>

    p2 = alloc_page();
c0105daa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105db1:	e8 a5 f2 ff ff       	call   c010505b <alloc_pages>
c0105db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105db9:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105dbe:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105dc5:	00 
c0105dc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105dcd:	00 
c0105dce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105dd1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dd5:	89 04 24             	mov    %eax,(%esp)
c0105dd8:	e8 3b fc ff ff       	call   c0105a18 <page_insert>
c0105ddd:	85 c0                	test   %eax,%eax
c0105ddf:	74 24                	je     c0105e05 <check_pgdir+0x2b9>
c0105de1:	c7 44 24 0c f0 84 10 	movl   $0xc01084f0,0xc(%esp)
c0105de8:	c0 
c0105de9:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105df0:	c0 
c0105df1:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0105df8:	00 
c0105df9:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105e00:	e8 ca ae ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105e05:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105e0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e11:	00 
c0105e12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e19:	00 
c0105e1a:	89 04 24             	mov    %eax,(%esp)
c0105e1d:	e8 b1 f9 ff ff       	call   c01057d3 <get_pte>
c0105e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e29:	75 24                	jne    c0105e4f <check_pgdir+0x303>
c0105e2b:	c7 44 24 0c 28 85 10 	movl   $0xc0108528,0xc(%esp)
c0105e32:	c0 
c0105e33:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105e3a:	c0 
c0105e3b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0105e42:	00 
c0105e43:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105e4a:	e8 80 ae ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_U);
c0105e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e52:	8b 00                	mov    (%eax),%eax
c0105e54:	83 e0 04             	and    $0x4,%eax
c0105e57:	85 c0                	test   %eax,%eax
c0105e59:	75 24                	jne    c0105e7f <check_pgdir+0x333>
c0105e5b:	c7 44 24 0c 58 85 10 	movl   $0xc0108558,0xc(%esp)
c0105e62:	c0 
c0105e63:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105e6a:	c0 
c0105e6b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0105e72:	00 
c0105e73:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105e7a:	e8 50 ae ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_W);
c0105e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e82:	8b 00                	mov    (%eax),%eax
c0105e84:	83 e0 02             	and    $0x2,%eax
c0105e87:	85 c0                	test   %eax,%eax
c0105e89:	75 24                	jne    c0105eaf <check_pgdir+0x363>
c0105e8b:	c7 44 24 0c 66 85 10 	movl   $0xc0108566,0xc(%esp)
c0105e92:	c0 
c0105e93:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105e9a:	c0 
c0105e9b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0105ea2:	00 
c0105ea3:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105eaa:	e8 20 ae ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105eaf:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105eb4:	8b 00                	mov    (%eax),%eax
c0105eb6:	83 e0 04             	and    $0x4,%eax
c0105eb9:	85 c0                	test   %eax,%eax
c0105ebb:	75 24                	jne    c0105ee1 <check_pgdir+0x395>
c0105ebd:	c7 44 24 0c 74 85 10 	movl   $0xc0108574,0xc(%esp)
c0105ec4:	c0 
c0105ec5:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105ecc:	c0 
c0105ecd:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0105ed4:	00 
c0105ed5:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105edc:	e8 ee ad ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 1);
c0105ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ee4:	89 04 24             	mov    %eax,(%esp)
c0105ee7:	e8 6a ef ff ff       	call   c0104e56 <page_ref>
c0105eec:	83 f8 01             	cmp    $0x1,%eax
c0105eef:	74 24                	je     c0105f15 <check_pgdir+0x3c9>
c0105ef1:	c7 44 24 0c 8a 85 10 	movl   $0xc010858a,0xc(%esp)
c0105ef8:	c0 
c0105ef9:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105f00:	c0 
c0105f01:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0105f08:	00 
c0105f09:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105f10:	e8 ba ad ff ff       	call   c0100ccf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105f15:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105f1a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105f21:	00 
c0105f22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105f29:	00 
c0105f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f2d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f31:	89 04 24             	mov    %eax,(%esp)
c0105f34:	e8 df fa ff ff       	call   c0105a18 <page_insert>
c0105f39:	85 c0                	test   %eax,%eax
c0105f3b:	74 24                	je     c0105f61 <check_pgdir+0x415>
c0105f3d:	c7 44 24 0c 9c 85 10 	movl   $0xc010859c,0xc(%esp)
c0105f44:	c0 
c0105f45:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105f4c:	c0 
c0105f4d:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0105f54:	00 
c0105f55:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105f5c:	e8 6e ad ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 2);
c0105f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f64:	89 04 24             	mov    %eax,(%esp)
c0105f67:	e8 ea ee ff ff       	call   c0104e56 <page_ref>
c0105f6c:	83 f8 02             	cmp    $0x2,%eax
c0105f6f:	74 24                	je     c0105f95 <check_pgdir+0x449>
c0105f71:	c7 44 24 0c c8 85 10 	movl   $0xc01085c8,0xc(%esp)
c0105f78:	c0 
c0105f79:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105f80:	c0 
c0105f81:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0105f88:	00 
c0105f89:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105f90:	e8 3a ad ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c0105f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f98:	89 04 24             	mov    %eax,(%esp)
c0105f9b:	e8 b6 ee ff ff       	call   c0104e56 <page_ref>
c0105fa0:	85 c0                	test   %eax,%eax
c0105fa2:	74 24                	je     c0105fc8 <check_pgdir+0x47c>
c0105fa4:	c7 44 24 0c da 85 10 	movl   $0xc01085da,0xc(%esp)
c0105fab:	c0 
c0105fac:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105fb3:	c0 
c0105fb4:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0105fbb:	00 
c0105fbc:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0105fc3:	e8 07 ad ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105fc8:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105fcd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fd4:	00 
c0105fd5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105fdc:	00 
c0105fdd:	89 04 24             	mov    %eax,(%esp)
c0105fe0:	e8 ee f7 ff ff       	call   c01057d3 <get_pte>
c0105fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105fec:	75 24                	jne    c0106012 <check_pgdir+0x4c6>
c0105fee:	c7 44 24 0c 28 85 10 	movl   $0xc0108528,0xc(%esp)
c0105ff5:	c0 
c0105ff6:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0105ffd:	c0 
c0105ffe:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0106005:	00 
c0106006:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c010600d:	e8 bd ac ff ff       	call   c0100ccf <__panic>
    assert(pte2page(*ptep) == p1);
c0106012:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106015:	8b 00                	mov    (%eax),%eax
c0106017:	89 04 24             	mov    %eax,(%esp)
c010601a:	e8 e1 ed ff ff       	call   c0104e00 <pte2page>
c010601f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106022:	74 24                	je     c0106048 <check_pgdir+0x4fc>
c0106024:	c7 44 24 0c 9d 84 10 	movl   $0xc010849d,0xc(%esp)
c010602b:	c0 
c010602c:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106033:	c0 
c0106034:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c010603b:	00 
c010603c:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106043:	e8 87 ac ff ff       	call   c0100ccf <__panic>
    assert((*ptep & PTE_U) == 0);
c0106048:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010604b:	8b 00                	mov    (%eax),%eax
c010604d:	83 e0 04             	and    $0x4,%eax
c0106050:	85 c0                	test   %eax,%eax
c0106052:	74 24                	je     c0106078 <check_pgdir+0x52c>
c0106054:	c7 44 24 0c ec 85 10 	movl   $0xc01085ec,0xc(%esp)
c010605b:	c0 
c010605c:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106063:	c0 
c0106064:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c010606b:	00 
c010606c:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106073:	e8 57 ac ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, 0x0);
c0106078:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010607d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106084:	00 
c0106085:	89 04 24             	mov    %eax,(%esp)
c0106088:	e8 47 f9 ff ff       	call   c01059d4 <page_remove>
    assert(page_ref(p1) == 1);
c010608d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106090:	89 04 24             	mov    %eax,(%esp)
c0106093:	e8 be ed ff ff       	call   c0104e56 <page_ref>
c0106098:	83 f8 01             	cmp    $0x1,%eax
c010609b:	74 24                	je     c01060c1 <check_pgdir+0x575>
c010609d:	c7 44 24 0c b3 84 10 	movl   $0xc01084b3,0xc(%esp)
c01060a4:	c0 
c01060a5:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01060ac:	c0 
c01060ad:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01060b4:	00 
c01060b5:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01060bc:	e8 0e ac ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c01060c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060c4:	89 04 24             	mov    %eax,(%esp)
c01060c7:	e8 8a ed ff ff       	call   c0104e56 <page_ref>
c01060cc:	85 c0                	test   %eax,%eax
c01060ce:	74 24                	je     c01060f4 <check_pgdir+0x5a8>
c01060d0:	c7 44 24 0c da 85 10 	movl   $0xc01085da,0xc(%esp)
c01060d7:	c0 
c01060d8:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01060df:	c0 
c01060e0:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01060e7:	00 
c01060e8:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01060ef:	e8 db ab ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01060f4:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01060f9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106100:	00 
c0106101:	89 04 24             	mov    %eax,(%esp)
c0106104:	e8 cb f8 ff ff       	call   c01059d4 <page_remove>
    assert(page_ref(p1) == 0);
c0106109:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010610c:	89 04 24             	mov    %eax,(%esp)
c010610f:	e8 42 ed ff ff       	call   c0104e56 <page_ref>
c0106114:	85 c0                	test   %eax,%eax
c0106116:	74 24                	je     c010613c <check_pgdir+0x5f0>
c0106118:	c7 44 24 0c 01 86 10 	movl   $0xc0108601,0xc(%esp)
c010611f:	c0 
c0106120:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106127:	c0 
c0106128:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c010612f:	00 
c0106130:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106137:	e8 93 ab ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c010613c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010613f:	89 04 24             	mov    %eax,(%esp)
c0106142:	e8 0f ed ff ff       	call   c0104e56 <page_ref>
c0106147:	85 c0                	test   %eax,%eax
c0106149:	74 24                	je     c010616f <check_pgdir+0x623>
c010614b:	c7 44 24 0c da 85 10 	movl   $0xc01085da,0xc(%esp)
c0106152:	c0 
c0106153:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c010615a:	c0 
c010615b:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0106162:	00 
c0106163:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c010616a:	e8 60 ab ff ff       	call   c0100ccf <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010616f:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106174:	8b 00                	mov    (%eax),%eax
c0106176:	89 04 24             	mov    %eax,(%esp)
c0106179:	e8 c0 ec ff ff       	call   c0104e3e <pde2page>
c010617e:	89 04 24             	mov    %eax,(%esp)
c0106181:	e8 d0 ec ff ff       	call   c0104e56 <page_ref>
c0106186:	83 f8 01             	cmp    $0x1,%eax
c0106189:	74 24                	je     c01061af <check_pgdir+0x663>
c010618b:	c7 44 24 0c 14 86 10 	movl   $0xc0108614,0xc(%esp)
c0106192:	c0 
c0106193:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c010619a:	c0 
c010619b:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c01061a2:	00 
c01061a3:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01061aa:	e8 20 ab ff ff       	call   c0100ccf <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01061af:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01061b4:	8b 00                	mov    (%eax),%eax
c01061b6:	89 04 24             	mov    %eax,(%esp)
c01061b9:	e8 80 ec ff ff       	call   c0104e3e <pde2page>
c01061be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01061c5:	00 
c01061c6:	89 04 24             	mov    %eax,(%esp)
c01061c9:	e8 c5 ee ff ff       	call   c0105093 <free_pages>
    boot_pgdir[0] = 0;
c01061ce:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01061d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01061d9:	c7 04 24 3b 86 10 c0 	movl   $0xc010863b,(%esp)
c01061e0:	e8 5e a1 ff ff       	call   c0100343 <cprintf>
}
c01061e5:	c9                   	leave  
c01061e6:	c3                   	ret    

c01061e7 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01061e7:	55                   	push   %ebp
c01061e8:	89 e5                	mov    %esp,%ebp
c01061ea:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01061ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01061f4:	e9 ca 00 00 00       	jmp    c01062c3 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01061f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106202:	c1 e8 0c             	shr    $0xc,%eax
c0106205:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106208:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c010620d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106210:	72 23                	jb     c0106235 <check_boot_pgdir+0x4e>
c0106212:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106215:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106219:	c7 44 24 08 6c 82 10 	movl   $0xc010826c,0x8(%esp)
c0106220:	c0 
c0106221:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0106228:	00 
c0106229:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106230:	e8 9a aa ff ff       	call   c0100ccf <__panic>
c0106235:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106238:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010623d:	89 c2                	mov    %eax,%edx
c010623f:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106244:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010624b:	00 
c010624c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106250:	89 04 24             	mov    %eax,(%esp)
c0106253:	e8 7b f5 ff ff       	call   c01057d3 <get_pte>
c0106258:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010625b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010625f:	75 24                	jne    c0106285 <check_boot_pgdir+0x9e>
c0106261:	c7 44 24 0c 58 86 10 	movl   $0xc0108658,0xc(%esp)
c0106268:	c0 
c0106269:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106270:	c0 
c0106271:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0106278:	00 
c0106279:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106280:	e8 4a aa ff ff       	call   c0100ccf <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106285:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106288:	8b 00                	mov    (%eax),%eax
c010628a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010628f:	89 c2                	mov    %eax,%edx
c0106291:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106294:	39 c2                	cmp    %eax,%edx
c0106296:	74 24                	je     c01062bc <check_boot_pgdir+0xd5>
c0106298:	c7 44 24 0c 95 86 10 	movl   $0xc0108695,0xc(%esp)
c010629f:	c0 
c01062a0:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01062a7:	c0 
c01062a8:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c01062af:	00 
c01062b0:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01062b7:	e8 13 aa ff ff       	call   c0100ccf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01062bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01062c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062c6:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c01062cb:	39 c2                	cmp    %eax,%edx
c01062cd:	0f 82 26 ff ff ff    	jb     c01061f9 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01062d3:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01062d8:	05 ac 0f 00 00       	add    $0xfac,%eax
c01062dd:	8b 00                	mov    (%eax),%eax
c01062df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062e4:	89 c2                	mov    %eax,%edx
c01062e6:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01062eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01062ee:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01062f5:	77 23                	ja     c010631a <check_boot_pgdir+0x133>
c01062f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062fe:	c7 44 24 08 24 83 10 	movl   $0xc0108324,0x8(%esp)
c0106305:	c0 
c0106306:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010630d:	00 
c010630e:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106315:	e8 b5 a9 ff ff       	call   c0100ccf <__panic>
c010631a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010631d:	05 00 00 00 40       	add    $0x40000000,%eax
c0106322:	39 c2                	cmp    %eax,%edx
c0106324:	74 24                	je     c010634a <check_boot_pgdir+0x163>
c0106326:	c7 44 24 0c ac 86 10 	movl   $0xc01086ac,0xc(%esp)
c010632d:	c0 
c010632e:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106335:	c0 
c0106336:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010633d:	00 
c010633e:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106345:	e8 85 a9 ff ff       	call   c0100ccf <__panic>

    assert(boot_pgdir[0] == 0);
c010634a:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010634f:	8b 00                	mov    (%eax),%eax
c0106351:	85 c0                	test   %eax,%eax
c0106353:	74 24                	je     c0106379 <check_boot_pgdir+0x192>
c0106355:	c7 44 24 0c e0 86 10 	movl   $0xc01086e0,0xc(%esp)
c010635c:	c0 
c010635d:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106364:	c0 
c0106365:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c010636c:	00 
c010636d:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106374:	e8 56 a9 ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    p = alloc_page();
c0106379:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106380:	e8 d6 ec ff ff       	call   c010505b <alloc_pages>
c0106385:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106388:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010638d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106394:	00 
c0106395:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010639c:	00 
c010639d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01063a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063a4:	89 04 24             	mov    %eax,(%esp)
c01063a7:	e8 6c f6 ff ff       	call   c0105a18 <page_insert>
c01063ac:	85 c0                	test   %eax,%eax
c01063ae:	74 24                	je     c01063d4 <check_boot_pgdir+0x1ed>
c01063b0:	c7 44 24 0c f4 86 10 	movl   $0xc01086f4,0xc(%esp)
c01063b7:	c0 
c01063b8:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01063bf:	c0 
c01063c0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01063c7:	00 
c01063c8:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01063cf:	e8 fb a8 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 1);
c01063d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063d7:	89 04 24             	mov    %eax,(%esp)
c01063da:	e8 77 ea ff ff       	call   c0104e56 <page_ref>
c01063df:	83 f8 01             	cmp    $0x1,%eax
c01063e2:	74 24                	je     c0106408 <check_boot_pgdir+0x221>
c01063e4:	c7 44 24 0c 22 87 10 	movl   $0xc0108722,0xc(%esp)
c01063eb:	c0 
c01063ec:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01063f3:	c0 
c01063f4:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01063fb:	00 
c01063fc:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106403:	e8 c7 a8 ff ff       	call   c0100ccf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106408:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010640d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106414:	00 
c0106415:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010641c:	00 
c010641d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106420:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106424:	89 04 24             	mov    %eax,(%esp)
c0106427:	e8 ec f5 ff ff       	call   c0105a18 <page_insert>
c010642c:	85 c0                	test   %eax,%eax
c010642e:	74 24                	je     c0106454 <check_boot_pgdir+0x26d>
c0106430:	c7 44 24 0c 34 87 10 	movl   $0xc0108734,0xc(%esp)
c0106437:	c0 
c0106438:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c010643f:	c0 
c0106440:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0106447:	00 
c0106448:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c010644f:	e8 7b a8 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 2);
c0106454:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106457:	89 04 24             	mov    %eax,(%esp)
c010645a:	e8 f7 e9 ff ff       	call   c0104e56 <page_ref>
c010645f:	83 f8 02             	cmp    $0x2,%eax
c0106462:	74 24                	je     c0106488 <check_boot_pgdir+0x2a1>
c0106464:	c7 44 24 0c 6b 87 10 	movl   $0xc010876b,0xc(%esp)
c010646b:	c0 
c010646c:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106473:	c0 
c0106474:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010647b:	00 
c010647c:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106483:	e8 47 a8 ff ff       	call   c0100ccf <__panic>

    const char *str = "ucore: Hello world!!";
c0106488:	c7 45 dc 7c 87 10 c0 	movl   $0xc010877c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010648f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106496:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010649d:	e8 19 0a 00 00       	call   c0106ebb <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01064a2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01064a9:	00 
c01064aa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01064b1:	e8 7e 0a 00 00       	call   c0106f34 <strcmp>
c01064b6:	85 c0                	test   %eax,%eax
c01064b8:	74 24                	je     c01064de <check_boot_pgdir+0x2f7>
c01064ba:	c7 44 24 0c 94 87 10 	movl   $0xc0108794,0xc(%esp)
c01064c1:	c0 
c01064c2:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c01064c9:	c0 
c01064ca:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01064d1:	00 
c01064d2:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c01064d9:	e8 f1 a7 ff ff       	call   c0100ccf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01064de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064e1:	89 04 24             	mov    %eax,(%esp)
c01064e4:	e8 c3 e8 ff ff       	call   c0104dac <page2kva>
c01064e9:	05 00 01 00 00       	add    $0x100,%eax
c01064ee:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01064f1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01064f8:	e8 66 09 00 00       	call   c0106e63 <strlen>
c01064fd:	85 c0                	test   %eax,%eax
c01064ff:	74 24                	je     c0106525 <check_boot_pgdir+0x33e>
c0106501:	c7 44 24 0c cc 87 10 	movl   $0xc01087cc,0xc(%esp)
c0106508:	c0 
c0106509:	c7 44 24 08 6d 83 10 	movl   $0xc010836d,0x8(%esp)
c0106510:	c0 
c0106511:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0106518:	00 
c0106519:	c7 04 24 48 83 10 c0 	movl   $0xc0108348,(%esp)
c0106520:	e8 aa a7 ff ff       	call   c0100ccf <__panic>

    free_page(p);
c0106525:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010652c:	00 
c010652d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106530:	89 04 24             	mov    %eax,(%esp)
c0106533:	e8 5b eb ff ff       	call   c0105093 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0106538:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010653d:	8b 00                	mov    (%eax),%eax
c010653f:	89 04 24             	mov    %eax,(%esp)
c0106542:	e8 f7 e8 ff ff       	call   c0104e3e <pde2page>
c0106547:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010654e:	00 
c010654f:	89 04 24             	mov    %eax,(%esp)
c0106552:	e8 3c eb ff ff       	call   c0105093 <free_pages>
    boot_pgdir[0] = 0;
c0106557:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010655c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106562:	c7 04 24 f0 87 10 c0 	movl   $0xc01087f0,(%esp)
c0106569:	e8 d5 9d ff ff       	call   c0100343 <cprintf>
}
c010656e:	c9                   	leave  
c010656f:	c3                   	ret    

c0106570 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106570:	55                   	push   %ebp
c0106571:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106573:	8b 45 08             	mov    0x8(%ebp),%eax
c0106576:	83 e0 04             	and    $0x4,%eax
c0106579:	85 c0                	test   %eax,%eax
c010657b:	74 07                	je     c0106584 <perm2str+0x14>
c010657d:	b8 75 00 00 00       	mov    $0x75,%eax
c0106582:	eb 05                	jmp    c0106589 <perm2str+0x19>
c0106584:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106589:	a2 48 b9 11 c0       	mov    %al,0xc011b948
    str[1] = 'r';
c010658e:	c6 05 49 b9 11 c0 72 	movb   $0x72,0xc011b949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106595:	8b 45 08             	mov    0x8(%ebp),%eax
c0106598:	83 e0 02             	and    $0x2,%eax
c010659b:	85 c0                	test   %eax,%eax
c010659d:	74 07                	je     c01065a6 <perm2str+0x36>
c010659f:	b8 77 00 00 00       	mov    $0x77,%eax
c01065a4:	eb 05                	jmp    c01065ab <perm2str+0x3b>
c01065a6:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01065ab:	a2 4a b9 11 c0       	mov    %al,0xc011b94a
    str[3] = '\0';
c01065b0:	c6 05 4b b9 11 c0 00 	movb   $0x0,0xc011b94b
    return str;
c01065b7:	b8 48 b9 11 c0       	mov    $0xc011b948,%eax
}
c01065bc:	5d                   	pop    %ebp
c01065bd:	c3                   	ret    

c01065be <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01065be:	55                   	push   %ebp
c01065bf:	89 e5                	mov    %esp,%ebp
c01065c1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01065c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01065c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01065ca:	72 0a                	jb     c01065d6 <get_pgtable_items+0x18>
        return 0;
c01065cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01065d1:	e9 9c 00 00 00       	jmp    c0106672 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01065d6:	eb 04                	jmp    c01065dc <get_pgtable_items+0x1e>
        start ++;
c01065d8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01065dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01065df:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01065e2:	73 18                	jae    c01065fc <get_pgtable_items+0x3e>
c01065e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01065e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01065ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01065f1:	01 d0                	add    %edx,%eax
c01065f3:	8b 00                	mov    (%eax),%eax
c01065f5:	83 e0 01             	and    $0x1,%eax
c01065f8:	85 c0                	test   %eax,%eax
c01065fa:	74 dc                	je     c01065d8 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01065fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01065ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106602:	73 69                	jae    c010666d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106604:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106608:	74 08                	je     c0106612 <get_pgtable_items+0x54>
            *left_store = start;
c010660a:	8b 45 18             	mov    0x18(%ebp),%eax
c010660d:	8b 55 10             	mov    0x10(%ebp),%edx
c0106610:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106612:	8b 45 10             	mov    0x10(%ebp),%eax
c0106615:	8d 50 01             	lea    0x1(%eax),%edx
c0106618:	89 55 10             	mov    %edx,0x10(%ebp)
c010661b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106622:	8b 45 14             	mov    0x14(%ebp),%eax
c0106625:	01 d0                	add    %edx,%eax
c0106627:	8b 00                	mov    (%eax),%eax
c0106629:	83 e0 07             	and    $0x7,%eax
c010662c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010662f:	eb 04                	jmp    c0106635 <get_pgtable_items+0x77>
            start ++;
c0106631:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106635:	8b 45 10             	mov    0x10(%ebp),%eax
c0106638:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010663b:	73 1d                	jae    c010665a <get_pgtable_items+0x9c>
c010663d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106647:	8b 45 14             	mov    0x14(%ebp),%eax
c010664a:	01 d0                	add    %edx,%eax
c010664c:	8b 00                	mov    (%eax),%eax
c010664e:	83 e0 07             	and    $0x7,%eax
c0106651:	89 c2                	mov    %eax,%edx
c0106653:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106656:	39 c2                	cmp    %eax,%edx
c0106658:	74 d7                	je     c0106631 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010665a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010665e:	74 08                	je     c0106668 <get_pgtable_items+0xaa>
            *right_store = start;
c0106660:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106663:	8b 55 10             	mov    0x10(%ebp),%edx
c0106666:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106668:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010666b:	eb 05                	jmp    c0106672 <get_pgtable_items+0xb4>
    }
    return 0;
c010666d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106672:	c9                   	leave  
c0106673:	c3                   	ret    

c0106674 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106674:	55                   	push   %ebp
c0106675:	89 e5                	mov    %esp,%ebp
c0106677:	57                   	push   %edi
c0106678:	56                   	push   %esi
c0106679:	53                   	push   %ebx
c010667a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010667d:	c7 04 24 10 88 10 c0 	movl   $0xc0108810,(%esp)
c0106684:	e8 ba 9c ff ff       	call   c0100343 <cprintf>
    size_t left, right = 0, perm;
c0106689:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106690:	e9 fa 00 00 00       	jmp    c010678f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106698:	89 04 24             	mov    %eax,(%esp)
c010669b:	e8 d0 fe ff ff       	call   c0106570 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01066a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01066a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066a6:	29 d1                	sub    %edx,%ecx
c01066a8:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01066aa:	89 d6                	mov    %edx,%esi
c01066ac:	c1 e6 16             	shl    $0x16,%esi
c01066af:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01066b2:	89 d3                	mov    %edx,%ebx
c01066b4:	c1 e3 16             	shl    $0x16,%ebx
c01066b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066ba:	89 d1                	mov    %edx,%ecx
c01066bc:	c1 e1 16             	shl    $0x16,%ecx
c01066bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01066c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066c5:	29 d7                	sub    %edx,%edi
c01066c7:	89 fa                	mov    %edi,%edx
c01066c9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01066cd:	89 74 24 10          	mov    %esi,0x10(%esp)
c01066d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01066d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01066d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066dd:	c7 04 24 41 88 10 c0 	movl   $0xc0108841,(%esp)
c01066e4:	e8 5a 9c ff ff       	call   c0100343 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01066e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066ec:	c1 e0 0a             	shl    $0xa,%eax
c01066ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01066f2:	eb 54                	jmp    c0106748 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01066f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066f7:	89 04 24             	mov    %eax,(%esp)
c01066fa:	e8 71 fe ff ff       	call   c0106570 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01066ff:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106702:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106705:	29 d1                	sub    %edx,%ecx
c0106707:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106709:	89 d6                	mov    %edx,%esi
c010670b:	c1 e6 0c             	shl    $0xc,%esi
c010670e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106711:	89 d3                	mov    %edx,%ebx
c0106713:	c1 e3 0c             	shl    $0xc,%ebx
c0106716:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106719:	c1 e2 0c             	shl    $0xc,%edx
c010671c:	89 d1                	mov    %edx,%ecx
c010671e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106721:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106724:	29 d7                	sub    %edx,%edi
c0106726:	89 fa                	mov    %edi,%edx
c0106728:	89 44 24 14          	mov    %eax,0x14(%esp)
c010672c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106730:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106734:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106738:	89 54 24 04          	mov    %edx,0x4(%esp)
c010673c:	c7 04 24 60 88 10 c0 	movl   $0xc0108860,(%esp)
c0106743:	e8 fb 9b ff ff       	call   c0100343 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106748:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010674d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106750:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106753:	89 ce                	mov    %ecx,%esi
c0106755:	c1 e6 0a             	shl    $0xa,%esi
c0106758:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010675b:	89 cb                	mov    %ecx,%ebx
c010675d:	c1 e3 0a             	shl    $0xa,%ebx
c0106760:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106763:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106767:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010676a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010676e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106772:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106776:	89 74 24 04          	mov    %esi,0x4(%esp)
c010677a:	89 1c 24             	mov    %ebx,(%esp)
c010677d:	e8 3c fe ff ff       	call   c01065be <get_pgtable_items>
c0106782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106785:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106789:	0f 85 65 ff ff ff    	jne    c01066f4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010678f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106794:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106797:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010679a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010679e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01067a1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01067a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01067a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067ad:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01067b4:	00 
c01067b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01067bc:	e8 fd fd ff ff       	call   c01065be <get_pgtable_items>
c01067c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01067c8:	0f 85 c7 fe ff ff    	jne    c0106695 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01067ce:	c7 04 24 84 88 10 c0 	movl   $0xc0108884,(%esp)
c01067d5:	e8 69 9b ff ff       	call   c0100343 <cprintf>
}
c01067da:	83 c4 4c             	add    $0x4c,%esp
c01067dd:	5b                   	pop    %ebx
c01067de:	5e                   	pop    %esi
c01067df:	5f                   	pop    %edi
c01067e0:	5d                   	pop    %ebp
c01067e1:	c3                   	ret    

c01067e2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01067e2:	55                   	push   %ebp
c01067e3:	89 e5                	mov    %esp,%ebp
c01067e5:	83 ec 58             	sub    $0x58,%esp
c01067e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01067eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01067ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01067f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01067f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01067f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01067fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01067fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0106800:	8b 45 18             	mov    0x18(%ebp),%eax
c0106803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106806:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106809:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010680c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010680f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0106812:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106815:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010681c:	74 1c                	je     c010683a <printnum+0x58>
c010681e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106821:	ba 00 00 00 00       	mov    $0x0,%edx
c0106826:	f7 75 e4             	divl   -0x1c(%ebp)
c0106829:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010682c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010682f:	ba 00 00 00 00       	mov    $0x0,%edx
c0106834:	f7 75 e4             	divl   -0x1c(%ebp)
c0106837:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010683a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010683d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106840:	f7 75 e4             	divl   -0x1c(%ebp)
c0106843:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106846:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106849:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010684c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010684f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106852:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0106855:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106858:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010685b:	8b 45 18             	mov    0x18(%ebp),%eax
c010685e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106863:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106866:	77 56                	ja     c01068be <printnum+0xdc>
c0106868:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010686b:	72 05                	jb     c0106872 <printnum+0x90>
c010686d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0106870:	77 4c                	ja     c01068be <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0106872:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106875:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106878:	8b 45 20             	mov    0x20(%ebp),%eax
c010687b:	89 44 24 18          	mov    %eax,0x18(%esp)
c010687f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106883:	8b 45 18             	mov    0x18(%ebp),%eax
c0106886:	89 44 24 10          	mov    %eax,0x10(%esp)
c010688a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010688d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106890:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106894:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106898:	8b 45 0c             	mov    0xc(%ebp),%eax
c010689b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010689f:	8b 45 08             	mov    0x8(%ebp),%eax
c01068a2:	89 04 24             	mov    %eax,(%esp)
c01068a5:	e8 38 ff ff ff       	call   c01067e2 <printnum>
c01068aa:	eb 1c                	jmp    c01068c8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01068ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01068af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068b3:	8b 45 20             	mov    0x20(%ebp),%eax
c01068b6:	89 04 24             	mov    %eax,(%esp)
c01068b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01068bc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01068be:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01068c2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01068c6:	7f e4                	jg     c01068ac <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01068c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01068cb:	05 38 89 10 c0       	add    $0xc0108938,%eax
c01068d0:	0f b6 00             	movzbl (%eax),%eax
c01068d3:	0f be c0             	movsbl %al,%eax
c01068d6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01068d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068dd:	89 04 24             	mov    %eax,(%esp)
c01068e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01068e3:	ff d0                	call   *%eax
}
c01068e5:	c9                   	leave  
c01068e6:	c3                   	ret    

c01068e7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01068e7:	55                   	push   %ebp
c01068e8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01068ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01068ee:	7e 14                	jle    c0106904 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01068f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01068f3:	8b 00                	mov    (%eax),%eax
c01068f5:	8d 48 08             	lea    0x8(%eax),%ecx
c01068f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01068fb:	89 0a                	mov    %ecx,(%edx)
c01068fd:	8b 50 04             	mov    0x4(%eax),%edx
c0106900:	8b 00                	mov    (%eax),%eax
c0106902:	eb 30                	jmp    c0106934 <getuint+0x4d>
    }
    else if (lflag) {
c0106904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106908:	74 16                	je     c0106920 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010690a:	8b 45 08             	mov    0x8(%ebp),%eax
c010690d:	8b 00                	mov    (%eax),%eax
c010690f:	8d 48 04             	lea    0x4(%eax),%ecx
c0106912:	8b 55 08             	mov    0x8(%ebp),%edx
c0106915:	89 0a                	mov    %ecx,(%edx)
c0106917:	8b 00                	mov    (%eax),%eax
c0106919:	ba 00 00 00 00       	mov    $0x0,%edx
c010691e:	eb 14                	jmp    c0106934 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0106920:	8b 45 08             	mov    0x8(%ebp),%eax
c0106923:	8b 00                	mov    (%eax),%eax
c0106925:	8d 48 04             	lea    0x4(%eax),%ecx
c0106928:	8b 55 08             	mov    0x8(%ebp),%edx
c010692b:	89 0a                	mov    %ecx,(%edx)
c010692d:	8b 00                	mov    (%eax),%eax
c010692f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106934:	5d                   	pop    %ebp
c0106935:	c3                   	ret    

c0106936 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0106936:	55                   	push   %ebp
c0106937:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106939:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010693d:	7e 14                	jle    c0106953 <getint+0x1d>
        return va_arg(*ap, long long);
c010693f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106942:	8b 00                	mov    (%eax),%eax
c0106944:	8d 48 08             	lea    0x8(%eax),%ecx
c0106947:	8b 55 08             	mov    0x8(%ebp),%edx
c010694a:	89 0a                	mov    %ecx,(%edx)
c010694c:	8b 50 04             	mov    0x4(%eax),%edx
c010694f:	8b 00                	mov    (%eax),%eax
c0106951:	eb 28                	jmp    c010697b <getint+0x45>
    }
    else if (lflag) {
c0106953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106957:	74 12                	je     c010696b <getint+0x35>
        return va_arg(*ap, long);
c0106959:	8b 45 08             	mov    0x8(%ebp),%eax
c010695c:	8b 00                	mov    (%eax),%eax
c010695e:	8d 48 04             	lea    0x4(%eax),%ecx
c0106961:	8b 55 08             	mov    0x8(%ebp),%edx
c0106964:	89 0a                	mov    %ecx,(%edx)
c0106966:	8b 00                	mov    (%eax),%eax
c0106968:	99                   	cltd   
c0106969:	eb 10                	jmp    c010697b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010696b:	8b 45 08             	mov    0x8(%ebp),%eax
c010696e:	8b 00                	mov    (%eax),%eax
c0106970:	8d 48 04             	lea    0x4(%eax),%ecx
c0106973:	8b 55 08             	mov    0x8(%ebp),%edx
c0106976:	89 0a                	mov    %ecx,(%edx)
c0106978:	8b 00                	mov    (%eax),%eax
c010697a:	99                   	cltd   
    }
}
c010697b:	5d                   	pop    %ebp
c010697c:	c3                   	ret    

c010697d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010697d:	55                   	push   %ebp
c010697e:	89 e5                	mov    %esp,%ebp
c0106980:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0106983:	8d 45 14             	lea    0x14(%ebp),%eax
c0106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106989:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010698c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106990:	8b 45 10             	mov    0x10(%ebp),%eax
c0106993:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106997:	8b 45 0c             	mov    0xc(%ebp),%eax
c010699a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010699e:	8b 45 08             	mov    0x8(%ebp),%eax
c01069a1:	89 04 24             	mov    %eax,(%esp)
c01069a4:	e8 02 00 00 00       	call   c01069ab <vprintfmt>
    va_end(ap);
}
c01069a9:	c9                   	leave  
c01069aa:	c3                   	ret    

c01069ab <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01069ab:	55                   	push   %ebp
c01069ac:	89 e5                	mov    %esp,%ebp
c01069ae:	56                   	push   %esi
c01069af:	53                   	push   %ebx
c01069b0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01069b3:	eb 18                	jmp    c01069cd <vprintfmt+0x22>
            if (ch == '\0') {
c01069b5:	85 db                	test   %ebx,%ebx
c01069b7:	75 05                	jne    c01069be <vprintfmt+0x13>
                return;
c01069b9:	e9 d1 03 00 00       	jmp    c0106d8f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01069be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069c5:	89 1c 24             	mov    %ebx,(%esp)
c01069c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01069cb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01069cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01069d0:	8d 50 01             	lea    0x1(%eax),%edx
c01069d3:	89 55 10             	mov    %edx,0x10(%ebp)
c01069d6:	0f b6 00             	movzbl (%eax),%eax
c01069d9:	0f b6 d8             	movzbl %al,%ebx
c01069dc:	83 fb 25             	cmp    $0x25,%ebx
c01069df:	75 d4                	jne    c01069b5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01069e1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01069e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01069ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01069f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01069f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069fc:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01069ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a02:	8d 50 01             	lea    0x1(%eax),%edx
c0106a05:	89 55 10             	mov    %edx,0x10(%ebp)
c0106a08:	0f b6 00             	movzbl (%eax),%eax
c0106a0b:	0f b6 d8             	movzbl %al,%ebx
c0106a0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106a11:	83 f8 55             	cmp    $0x55,%eax
c0106a14:	0f 87 44 03 00 00    	ja     c0106d5e <vprintfmt+0x3b3>
c0106a1a:	8b 04 85 5c 89 10 c0 	mov    -0x3fef76a4(,%eax,4),%eax
c0106a21:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106a23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106a27:	eb d6                	jmp    c01069ff <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0106a29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106a2d:	eb d0                	jmp    c01069ff <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a39:	89 d0                	mov    %edx,%eax
c0106a3b:	c1 e0 02             	shl    $0x2,%eax
c0106a3e:	01 d0                	add    %edx,%eax
c0106a40:	01 c0                	add    %eax,%eax
c0106a42:	01 d8                	add    %ebx,%eax
c0106a44:	83 e8 30             	sub    $0x30,%eax
c0106a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0106a4a:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a4d:	0f b6 00             	movzbl (%eax),%eax
c0106a50:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106a53:	83 fb 2f             	cmp    $0x2f,%ebx
c0106a56:	7e 0b                	jle    c0106a63 <vprintfmt+0xb8>
c0106a58:	83 fb 39             	cmp    $0x39,%ebx
c0106a5b:	7f 06                	jg     c0106a63 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106a5d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0106a61:	eb d3                	jmp    c0106a36 <vprintfmt+0x8b>
            goto process_precision;
c0106a63:	eb 33                	jmp    c0106a98 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0106a65:	8b 45 14             	mov    0x14(%ebp),%eax
c0106a68:	8d 50 04             	lea    0x4(%eax),%edx
c0106a6b:	89 55 14             	mov    %edx,0x14(%ebp)
c0106a6e:	8b 00                	mov    (%eax),%eax
c0106a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106a73:	eb 23                	jmp    c0106a98 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0106a75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106a79:	79 0c                	jns    c0106a87 <vprintfmt+0xdc>
                width = 0;
c0106a7b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106a82:	e9 78 ff ff ff       	jmp    c01069ff <vprintfmt+0x54>
c0106a87:	e9 73 ff ff ff       	jmp    c01069ff <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0106a8c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106a93:	e9 67 ff ff ff       	jmp    c01069ff <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0106a98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106a9c:	79 12                	jns    c0106ab0 <vprintfmt+0x105>
                width = precision, precision = -1;
c0106a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106aa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106aa4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106aab:	e9 4f ff ff ff       	jmp    c01069ff <vprintfmt+0x54>
c0106ab0:	e9 4a ff ff ff       	jmp    c01069ff <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106ab5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0106ab9:	e9 41 ff ff ff       	jmp    c01069ff <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106abe:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ac1:	8d 50 04             	lea    0x4(%eax),%edx
c0106ac4:	89 55 14             	mov    %edx,0x14(%ebp)
c0106ac7:	8b 00                	mov    (%eax),%eax
c0106ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106acc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ad0:	89 04 24             	mov    %eax,(%esp)
c0106ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad6:	ff d0                	call   *%eax
            break;
c0106ad8:	e9 ac 02 00 00       	jmp    c0106d89 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106add:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ae0:	8d 50 04             	lea    0x4(%eax),%edx
c0106ae3:	89 55 14             	mov    %edx,0x14(%ebp)
c0106ae6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106ae8:	85 db                	test   %ebx,%ebx
c0106aea:	79 02                	jns    c0106aee <vprintfmt+0x143>
                err = -err;
c0106aec:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106aee:	83 fb 06             	cmp    $0x6,%ebx
c0106af1:	7f 0b                	jg     c0106afe <vprintfmt+0x153>
c0106af3:	8b 34 9d 1c 89 10 c0 	mov    -0x3fef76e4(,%ebx,4),%esi
c0106afa:	85 f6                	test   %esi,%esi
c0106afc:	75 23                	jne    c0106b21 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0106afe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106b02:	c7 44 24 08 49 89 10 	movl   $0xc0108949,0x8(%esp)
c0106b09:	c0 
c0106b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b14:	89 04 24             	mov    %eax,(%esp)
c0106b17:	e8 61 fe ff ff       	call   c010697d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106b1c:	e9 68 02 00 00       	jmp    c0106d89 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0106b21:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106b25:	c7 44 24 08 52 89 10 	movl   $0xc0108952,0x8(%esp)
c0106b2c:	c0 
c0106b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b37:	89 04 24             	mov    %eax,(%esp)
c0106b3a:	e8 3e fe ff ff       	call   c010697d <printfmt>
            }
            break;
c0106b3f:	e9 45 02 00 00       	jmp    c0106d89 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0106b44:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b47:	8d 50 04             	lea    0x4(%eax),%edx
c0106b4a:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b4d:	8b 30                	mov    (%eax),%esi
c0106b4f:	85 f6                	test   %esi,%esi
c0106b51:	75 05                	jne    c0106b58 <vprintfmt+0x1ad>
                p = "(null)";
c0106b53:	be 55 89 10 c0       	mov    $0xc0108955,%esi
            }
            if (width > 0 && padc != '-') {
c0106b58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b5c:	7e 3e                	jle    c0106b9c <vprintfmt+0x1f1>
c0106b5e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106b62:	74 38                	je     c0106b9c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106b64:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0106b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b6e:	89 34 24             	mov    %esi,(%esp)
c0106b71:	e8 15 03 00 00       	call   c0106e8b <strnlen>
c0106b76:	29 c3                	sub    %eax,%ebx
c0106b78:	89 d8                	mov    %ebx,%eax
c0106b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b7d:	eb 17                	jmp    c0106b96 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0106b7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0106b83:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106b86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b8a:	89 04 24             	mov    %eax,(%esp)
c0106b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b90:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106b92:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106b96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b9a:	7f e3                	jg     c0106b7f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106b9c:	eb 38                	jmp    c0106bd6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106b9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106ba2:	74 1f                	je     c0106bc3 <vprintfmt+0x218>
c0106ba4:	83 fb 1f             	cmp    $0x1f,%ebx
c0106ba7:	7e 05                	jle    c0106bae <vprintfmt+0x203>
c0106ba9:	83 fb 7e             	cmp    $0x7e,%ebx
c0106bac:	7e 15                	jle    c0106bc3 <vprintfmt+0x218>
                    putch('?', putdat);
c0106bae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bb5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bbf:	ff d0                	call   *%eax
c0106bc1:	eb 0f                	jmp    c0106bd2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0106bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bca:	89 1c 24             	mov    %ebx,(%esp)
c0106bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd0:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106bd2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106bd6:	89 f0                	mov    %esi,%eax
c0106bd8:	8d 70 01             	lea    0x1(%eax),%esi
c0106bdb:	0f b6 00             	movzbl (%eax),%eax
c0106bde:	0f be d8             	movsbl %al,%ebx
c0106be1:	85 db                	test   %ebx,%ebx
c0106be3:	74 10                	je     c0106bf5 <vprintfmt+0x24a>
c0106be5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106be9:	78 b3                	js     c0106b9e <vprintfmt+0x1f3>
c0106beb:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0106bef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106bf3:	79 a9                	jns    c0106b9e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106bf5:	eb 17                	jmp    c0106c0e <vprintfmt+0x263>
                putch(' ', putdat);
c0106bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bfe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c08:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106c0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106c12:	7f e3                	jg     c0106bf7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0106c14:	e9 70 01 00 00       	jmp    c0106d89 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c20:	8d 45 14             	lea    0x14(%ebp),%eax
c0106c23:	89 04 24             	mov    %eax,(%esp)
c0106c26:	e8 0b fd ff ff       	call   c0106936 <getint>
c0106c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106c37:	85 d2                	test   %edx,%edx
c0106c39:	79 26                	jns    c0106c61 <vprintfmt+0x2b6>
                putch('-', putdat);
c0106c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c42:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0106c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c4c:	ff d0                	call   *%eax
                num = -(long long)num;
c0106c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106c54:	f7 d8                	neg    %eax
c0106c56:	83 d2 00             	adc    $0x0,%edx
c0106c59:	f7 da                	neg    %edx
c0106c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106c61:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106c68:	e9 a8 00 00 00       	jmp    c0106d15 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c74:	8d 45 14             	lea    0x14(%ebp),%eax
c0106c77:	89 04 24             	mov    %eax,(%esp)
c0106c7a:	e8 68 fc ff ff       	call   c01068e7 <getuint>
c0106c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106c85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106c8c:	e9 84 00 00 00       	jmp    c0106d15 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c98:	8d 45 14             	lea    0x14(%ebp),%eax
c0106c9b:	89 04 24             	mov    %eax,(%esp)
c0106c9e:	e8 44 fc ff ff       	call   c01068e7 <getuint>
c0106ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ca6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106ca9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106cb0:	eb 63                	jmp    c0106d15 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0106cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cb9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106cc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cc3:	ff d0                	call   *%eax
            putch('x', putdat);
c0106cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ccc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106cd8:	8b 45 14             	mov    0x14(%ebp),%eax
c0106cdb:	8d 50 04             	lea    0x4(%eax),%edx
c0106cde:	89 55 14             	mov    %edx,0x14(%ebp)
c0106ce1:	8b 00                	mov    (%eax),%eax
c0106ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ce6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106ced:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106cf4:	eb 1f                	jmp    c0106d15 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cfd:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d00:	89 04 24             	mov    %eax,(%esp)
c0106d03:	e8 df fb ff ff       	call   c01068e7 <getuint>
c0106d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106d0e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106d15:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d1c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d23:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106d27:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106d31:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d35:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106d39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d40:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d43:	89 04 24             	mov    %eax,(%esp)
c0106d46:	e8 97 fa ff ff       	call   c01067e2 <printnum>
            break;
c0106d4b:	eb 3c                	jmp    c0106d89 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d54:	89 1c 24             	mov    %ebx,(%esp)
c0106d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d5a:	ff d0                	call   *%eax
            break;
c0106d5c:	eb 2b                	jmp    c0106d89 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d65:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d6f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106d71:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106d75:	eb 04                	jmp    c0106d7b <vprintfmt+0x3d0>
c0106d77:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106d7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d7e:	83 e8 01             	sub    $0x1,%eax
c0106d81:	0f b6 00             	movzbl (%eax),%eax
c0106d84:	3c 25                	cmp    $0x25,%al
c0106d86:	75 ef                	jne    c0106d77 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0106d88:	90                   	nop
        }
    }
c0106d89:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106d8a:	e9 3e fc ff ff       	jmp    c01069cd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0106d8f:	83 c4 40             	add    $0x40,%esp
c0106d92:	5b                   	pop    %ebx
c0106d93:	5e                   	pop    %esi
c0106d94:	5d                   	pop    %ebp
c0106d95:	c3                   	ret    

c0106d96 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106d96:	55                   	push   %ebp
c0106d97:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106d99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d9c:	8b 40 08             	mov    0x8(%eax),%eax
c0106d9f:	8d 50 01             	lea    0x1(%eax),%edx
c0106da2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106da5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106da8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dab:	8b 10                	mov    (%eax),%edx
c0106dad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106db0:	8b 40 04             	mov    0x4(%eax),%eax
c0106db3:	39 c2                	cmp    %eax,%edx
c0106db5:	73 12                	jae    c0106dc9 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106db7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dba:	8b 00                	mov    (%eax),%eax
c0106dbc:	8d 48 01             	lea    0x1(%eax),%ecx
c0106dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106dc2:	89 0a                	mov    %ecx,(%edx)
c0106dc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0106dc7:	88 10                	mov    %dl,(%eax)
    }
}
c0106dc9:	5d                   	pop    %ebp
c0106dca:	c3                   	ret    

c0106dcb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106dcb:	55                   	push   %ebp
c0106dcc:	89 e5                	mov    %esp,%ebp
c0106dce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106dd1:	8d 45 14             	lea    0x14(%ebp),%eax
c0106dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dda:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106dde:	8b 45 10             	mov    0x10(%ebp),%eax
c0106de1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106de5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106de8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0106def:	89 04 24             	mov    %eax,(%esp)
c0106df2:	e8 08 00 00 00       	call   c0106dff <vsnprintf>
c0106df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106dfd:	c9                   	leave  
c0106dfe:	c3                   	ret    

c0106dff <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106dff:	55                   	push   %ebp
c0106e00:	89 e5                	mov    %esp,%ebp
c0106e02:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e0e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e14:	01 d0                	add    %edx,%eax
c0106e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106e24:	74 0a                	je     c0106e30 <vsnprintf+0x31>
c0106e26:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e2c:	39 c2                	cmp    %eax,%edx
c0106e2e:	76 07                	jbe    c0106e37 <vsnprintf+0x38>
        return -E_INVAL;
c0106e30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106e35:	eb 2a                	jmp    c0106e61 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106e37:	8b 45 14             	mov    0x14(%ebp),%eax
c0106e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e3e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e45:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106e48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e4c:	c7 04 24 96 6d 10 c0 	movl   $0xc0106d96,(%esp)
c0106e53:	e8 53 fb ff ff       	call   c01069ab <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e5b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e61:	c9                   	leave  
c0106e62:	c3                   	ret    

c0106e63 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0106e63:	55                   	push   %ebp
c0106e64:	89 e5                	mov    %esp,%ebp
c0106e66:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106e69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0106e70:	eb 04                	jmp    c0106e76 <strlen+0x13>
        cnt ++;
c0106e72:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0106e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e79:	8d 50 01             	lea    0x1(%eax),%edx
c0106e7c:	89 55 08             	mov    %edx,0x8(%ebp)
c0106e7f:	0f b6 00             	movzbl (%eax),%eax
c0106e82:	84 c0                	test   %al,%al
c0106e84:	75 ec                	jne    c0106e72 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0106e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106e89:	c9                   	leave  
c0106e8a:	c3                   	ret    

c0106e8b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0106e8b:	55                   	push   %ebp
c0106e8c:	89 e5                	mov    %esp,%ebp
c0106e8e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0106e98:	eb 04                	jmp    c0106e9e <strnlen+0x13>
        cnt ++;
c0106e9a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0106e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ea1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106ea4:	73 10                	jae    c0106eb6 <strnlen+0x2b>
c0106ea6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ea9:	8d 50 01             	lea    0x1(%eax),%edx
c0106eac:	89 55 08             	mov    %edx,0x8(%ebp)
c0106eaf:	0f b6 00             	movzbl (%eax),%eax
c0106eb2:	84 c0                	test   %al,%al
c0106eb4:	75 e4                	jne    c0106e9a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0106eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106eb9:	c9                   	leave  
c0106eba:	c3                   	ret    

c0106ebb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0106ebb:	55                   	push   %ebp
c0106ebc:	89 e5                	mov    %esp,%ebp
c0106ebe:	57                   	push   %edi
c0106ebf:	56                   	push   %esi
c0106ec0:	83 ec 20             	sub    $0x20,%esp
c0106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0106ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ed5:	89 d1                	mov    %edx,%ecx
c0106ed7:	89 c2                	mov    %eax,%edx
c0106ed9:	89 ce                	mov    %ecx,%esi
c0106edb:	89 d7                	mov    %edx,%edi
c0106edd:	ac                   	lods   %ds:(%esi),%al
c0106ede:	aa                   	stos   %al,%es:(%edi)
c0106edf:	84 c0                	test   %al,%al
c0106ee1:	75 fa                	jne    c0106edd <strcpy+0x22>
c0106ee3:	89 fa                	mov    %edi,%edx
c0106ee5:	89 f1                	mov    %esi,%ecx
c0106ee7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106eea:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106eed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0106ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0106ef3:	83 c4 20             	add    $0x20,%esp
c0106ef6:	5e                   	pop    %esi
c0106ef7:	5f                   	pop    %edi
c0106ef8:	5d                   	pop    %ebp
c0106ef9:	c3                   	ret    

c0106efa <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0106efa:	55                   	push   %ebp
c0106efb:	89 e5                	mov    %esp,%ebp
c0106efd:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0106f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0106f06:	eb 21                	jmp    c0106f29 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0106f08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f0b:	0f b6 10             	movzbl (%eax),%edx
c0106f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f11:	88 10                	mov    %dl,(%eax)
c0106f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f16:	0f b6 00             	movzbl (%eax),%eax
c0106f19:	84 c0                	test   %al,%al
c0106f1b:	74 04                	je     c0106f21 <strncpy+0x27>
            src ++;
c0106f1d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0106f21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106f25:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0106f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106f2d:	75 d9                	jne    c0106f08 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0106f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106f32:	c9                   	leave  
c0106f33:	c3                   	ret    

c0106f34 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0106f34:	55                   	push   %ebp
c0106f35:	89 e5                	mov    %esp,%ebp
c0106f37:	57                   	push   %edi
c0106f38:	56                   	push   %esi
c0106f39:	83 ec 20             	sub    $0x20,%esp
c0106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106f42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0106f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f4e:	89 d1                	mov    %edx,%ecx
c0106f50:	89 c2                	mov    %eax,%edx
c0106f52:	89 ce                	mov    %ecx,%esi
c0106f54:	89 d7                	mov    %edx,%edi
c0106f56:	ac                   	lods   %ds:(%esi),%al
c0106f57:	ae                   	scas   %es:(%edi),%al
c0106f58:	75 08                	jne    c0106f62 <strcmp+0x2e>
c0106f5a:	84 c0                	test   %al,%al
c0106f5c:	75 f8                	jne    c0106f56 <strcmp+0x22>
c0106f5e:	31 c0                	xor    %eax,%eax
c0106f60:	eb 04                	jmp    c0106f66 <strcmp+0x32>
c0106f62:	19 c0                	sbb    %eax,%eax
c0106f64:	0c 01                	or     $0x1,%al
c0106f66:	89 fa                	mov    %edi,%edx
c0106f68:	89 f1                	mov    %esi,%ecx
c0106f6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106f6d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106f70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0106f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0106f76:	83 c4 20             	add    $0x20,%esp
c0106f79:	5e                   	pop    %esi
c0106f7a:	5f                   	pop    %edi
c0106f7b:	5d                   	pop    %ebp
c0106f7c:	c3                   	ret    

c0106f7d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0106f7d:	55                   	push   %ebp
c0106f7e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0106f80:	eb 0c                	jmp    c0106f8e <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0106f82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106f86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106f8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0106f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106f92:	74 1a                	je     c0106fae <strncmp+0x31>
c0106f94:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f97:	0f b6 00             	movzbl (%eax),%eax
c0106f9a:	84 c0                	test   %al,%al
c0106f9c:	74 10                	je     c0106fae <strncmp+0x31>
c0106f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fa1:	0f b6 10             	movzbl (%eax),%edx
c0106fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fa7:	0f b6 00             	movzbl (%eax),%eax
c0106faa:	38 c2                	cmp    %al,%dl
c0106fac:	74 d4                	je     c0106f82 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106fb2:	74 18                	je     c0106fcc <strncmp+0x4f>
c0106fb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fb7:	0f b6 00             	movzbl (%eax),%eax
c0106fba:	0f b6 d0             	movzbl %al,%edx
c0106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fc0:	0f b6 00             	movzbl (%eax),%eax
c0106fc3:	0f b6 c0             	movzbl %al,%eax
c0106fc6:	29 c2                	sub    %eax,%edx
c0106fc8:	89 d0                	mov    %edx,%eax
c0106fca:	eb 05                	jmp    c0106fd1 <strncmp+0x54>
c0106fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fd1:	5d                   	pop    %ebp
c0106fd2:	c3                   	ret    

c0106fd3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0106fd3:	55                   	push   %ebp
c0106fd4:	89 e5                	mov    %esp,%ebp
c0106fd6:	83 ec 04             	sub    $0x4,%esp
c0106fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fdc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0106fdf:	eb 14                	jmp    c0106ff5 <strchr+0x22>
        if (*s == c) {
c0106fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fe4:	0f b6 00             	movzbl (%eax),%eax
c0106fe7:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0106fea:	75 05                	jne    c0106ff1 <strchr+0x1e>
            return (char *)s;
c0106fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fef:	eb 13                	jmp    c0107004 <strchr+0x31>
        }
        s ++;
c0106ff1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0106ff5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ff8:	0f b6 00             	movzbl (%eax),%eax
c0106ffb:	84 c0                	test   %al,%al
c0106ffd:	75 e2                	jne    c0106fe1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0106fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107004:	c9                   	leave  
c0107005:	c3                   	ret    

c0107006 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0107006:	55                   	push   %ebp
c0107007:	89 e5                	mov    %esp,%ebp
c0107009:	83 ec 04             	sub    $0x4,%esp
c010700c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010700f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107012:	eb 11                	jmp    c0107025 <strfind+0x1f>
        if (*s == c) {
c0107014:	8b 45 08             	mov    0x8(%ebp),%eax
c0107017:	0f b6 00             	movzbl (%eax),%eax
c010701a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010701d:	75 02                	jne    c0107021 <strfind+0x1b>
            break;
c010701f:	eb 0e                	jmp    c010702f <strfind+0x29>
        }
        s ++;
c0107021:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0107025:	8b 45 08             	mov    0x8(%ebp),%eax
c0107028:	0f b6 00             	movzbl (%eax),%eax
c010702b:	84 c0                	test   %al,%al
c010702d:	75 e5                	jne    c0107014 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010702f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107032:	c9                   	leave  
c0107033:	c3                   	ret    

c0107034 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0107034:	55                   	push   %ebp
c0107035:	89 e5                	mov    %esp,%ebp
c0107037:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010703a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0107041:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107048:	eb 04                	jmp    c010704e <strtol+0x1a>
        s ++;
c010704a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010704e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107051:	0f b6 00             	movzbl (%eax),%eax
c0107054:	3c 20                	cmp    $0x20,%al
c0107056:	74 f2                	je     c010704a <strtol+0x16>
c0107058:	8b 45 08             	mov    0x8(%ebp),%eax
c010705b:	0f b6 00             	movzbl (%eax),%eax
c010705e:	3c 09                	cmp    $0x9,%al
c0107060:	74 e8                	je     c010704a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0107062:	8b 45 08             	mov    0x8(%ebp),%eax
c0107065:	0f b6 00             	movzbl (%eax),%eax
c0107068:	3c 2b                	cmp    $0x2b,%al
c010706a:	75 06                	jne    c0107072 <strtol+0x3e>
        s ++;
c010706c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107070:	eb 15                	jmp    c0107087 <strtol+0x53>
    }
    else if (*s == '-') {
c0107072:	8b 45 08             	mov    0x8(%ebp),%eax
c0107075:	0f b6 00             	movzbl (%eax),%eax
c0107078:	3c 2d                	cmp    $0x2d,%al
c010707a:	75 0b                	jne    c0107087 <strtol+0x53>
        s ++, neg = 1;
c010707c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107080:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0107087:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010708b:	74 06                	je     c0107093 <strtol+0x5f>
c010708d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0107091:	75 24                	jne    c01070b7 <strtol+0x83>
c0107093:	8b 45 08             	mov    0x8(%ebp),%eax
c0107096:	0f b6 00             	movzbl (%eax),%eax
c0107099:	3c 30                	cmp    $0x30,%al
c010709b:	75 1a                	jne    c01070b7 <strtol+0x83>
c010709d:	8b 45 08             	mov    0x8(%ebp),%eax
c01070a0:	83 c0 01             	add    $0x1,%eax
c01070a3:	0f b6 00             	movzbl (%eax),%eax
c01070a6:	3c 78                	cmp    $0x78,%al
c01070a8:	75 0d                	jne    c01070b7 <strtol+0x83>
        s += 2, base = 16;
c01070aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01070ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01070b5:	eb 2a                	jmp    c01070e1 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01070b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070bb:	75 17                	jne    c01070d4 <strtol+0xa0>
c01070bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01070c0:	0f b6 00             	movzbl (%eax),%eax
c01070c3:	3c 30                	cmp    $0x30,%al
c01070c5:	75 0d                	jne    c01070d4 <strtol+0xa0>
        s ++, base = 8;
c01070c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01070cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01070d2:	eb 0d                	jmp    c01070e1 <strtol+0xad>
    }
    else if (base == 0) {
c01070d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070d8:	75 07                	jne    c01070e1 <strtol+0xad>
        base = 10;
c01070da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01070e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01070e4:	0f b6 00             	movzbl (%eax),%eax
c01070e7:	3c 2f                	cmp    $0x2f,%al
c01070e9:	7e 1b                	jle    c0107106 <strtol+0xd2>
c01070eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01070ee:	0f b6 00             	movzbl (%eax),%eax
c01070f1:	3c 39                	cmp    $0x39,%al
c01070f3:	7f 11                	jg     c0107106 <strtol+0xd2>
            dig = *s - '0';
c01070f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01070f8:	0f b6 00             	movzbl (%eax),%eax
c01070fb:	0f be c0             	movsbl %al,%eax
c01070fe:	83 e8 30             	sub    $0x30,%eax
c0107101:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107104:	eb 48                	jmp    c010714e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0107106:	8b 45 08             	mov    0x8(%ebp),%eax
c0107109:	0f b6 00             	movzbl (%eax),%eax
c010710c:	3c 60                	cmp    $0x60,%al
c010710e:	7e 1b                	jle    c010712b <strtol+0xf7>
c0107110:	8b 45 08             	mov    0x8(%ebp),%eax
c0107113:	0f b6 00             	movzbl (%eax),%eax
c0107116:	3c 7a                	cmp    $0x7a,%al
c0107118:	7f 11                	jg     c010712b <strtol+0xf7>
            dig = *s - 'a' + 10;
c010711a:	8b 45 08             	mov    0x8(%ebp),%eax
c010711d:	0f b6 00             	movzbl (%eax),%eax
c0107120:	0f be c0             	movsbl %al,%eax
c0107123:	83 e8 57             	sub    $0x57,%eax
c0107126:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107129:	eb 23                	jmp    c010714e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010712b:	8b 45 08             	mov    0x8(%ebp),%eax
c010712e:	0f b6 00             	movzbl (%eax),%eax
c0107131:	3c 40                	cmp    $0x40,%al
c0107133:	7e 3d                	jle    c0107172 <strtol+0x13e>
c0107135:	8b 45 08             	mov    0x8(%ebp),%eax
c0107138:	0f b6 00             	movzbl (%eax),%eax
c010713b:	3c 5a                	cmp    $0x5a,%al
c010713d:	7f 33                	jg     c0107172 <strtol+0x13e>
            dig = *s - 'A' + 10;
c010713f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107142:	0f b6 00             	movzbl (%eax),%eax
c0107145:	0f be c0             	movsbl %al,%eax
c0107148:	83 e8 37             	sub    $0x37,%eax
c010714b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010714e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107151:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107154:	7c 02                	jl     c0107158 <strtol+0x124>
            break;
c0107156:	eb 1a                	jmp    c0107172 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0107158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010715c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010715f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0107163:	89 c2                	mov    %eax,%edx
c0107165:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107168:	01 d0                	add    %edx,%eax
c010716a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010716d:	e9 6f ff ff ff       	jmp    c01070e1 <strtol+0xad>

    if (endptr) {
c0107172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107176:	74 08                	je     c0107180 <strtol+0x14c>
        *endptr = (char *) s;
c0107178:	8b 45 0c             	mov    0xc(%ebp),%eax
c010717b:	8b 55 08             	mov    0x8(%ebp),%edx
c010717e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0107180:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107184:	74 07                	je     c010718d <strtol+0x159>
c0107186:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107189:	f7 d8                	neg    %eax
c010718b:	eb 03                	jmp    c0107190 <strtol+0x15c>
c010718d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0107190:	c9                   	leave  
c0107191:	c3                   	ret    

c0107192 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0107192:	55                   	push   %ebp
c0107193:	89 e5                	mov    %esp,%ebp
c0107195:	57                   	push   %edi
c0107196:	83 ec 24             	sub    $0x24,%esp
c0107199:	8b 45 0c             	mov    0xc(%ebp),%eax
c010719c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010719f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01071a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01071a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01071a9:	88 45 f7             	mov    %al,-0x9(%ebp)
c01071ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01071af:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01071b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01071b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01071b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01071bc:	89 d7                	mov    %edx,%edi
c01071be:	f3 aa                	rep stos %al,%es:(%edi)
c01071c0:	89 fa                	mov    %edi,%edx
c01071c2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01071c5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01071c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01071cb:	83 c4 24             	add    $0x24,%esp
c01071ce:	5f                   	pop    %edi
c01071cf:	5d                   	pop    %ebp
c01071d0:	c3                   	ret    

c01071d1 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01071d1:	55                   	push   %ebp
c01071d2:	89 e5                	mov    %esp,%ebp
c01071d4:	57                   	push   %edi
c01071d5:	56                   	push   %esi
c01071d6:	53                   	push   %ebx
c01071d7:	83 ec 30             	sub    $0x30,%esp
c01071da:	8b 45 08             	mov    0x8(%ebp),%eax
c01071dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01071e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01071e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01071e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01071ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01071f2:	73 42                	jae    c0107236 <memmove+0x65>
c01071f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01071fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107200:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107203:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107206:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107209:	c1 e8 02             	shr    $0x2,%eax
c010720c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010720e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107211:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107214:	89 d7                	mov    %edx,%edi
c0107216:	89 c6                	mov    %eax,%esi
c0107218:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010721a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010721d:	83 e1 03             	and    $0x3,%ecx
c0107220:	74 02                	je     c0107224 <memmove+0x53>
c0107222:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107224:	89 f0                	mov    %esi,%eax
c0107226:	89 fa                	mov    %edi,%edx
c0107228:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010722b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010722e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0107231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107234:	eb 36                	jmp    c010726c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0107236:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107239:	8d 50 ff             	lea    -0x1(%eax),%edx
c010723c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010723f:	01 c2                	add    %eax,%edx
c0107241:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107244:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0107247:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010724a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010724d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107250:	89 c1                	mov    %eax,%ecx
c0107252:	89 d8                	mov    %ebx,%eax
c0107254:	89 d6                	mov    %edx,%esi
c0107256:	89 c7                	mov    %eax,%edi
c0107258:	fd                   	std    
c0107259:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010725b:	fc                   	cld    
c010725c:	89 f8                	mov    %edi,%eax
c010725e:	89 f2                	mov    %esi,%edx
c0107260:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0107263:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0107266:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0107269:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010726c:	83 c4 30             	add    $0x30,%esp
c010726f:	5b                   	pop    %ebx
c0107270:	5e                   	pop    %esi
c0107271:	5f                   	pop    %edi
c0107272:	5d                   	pop    %ebp
c0107273:	c3                   	ret    

c0107274 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0107274:	55                   	push   %ebp
c0107275:	89 e5                	mov    %esp,%ebp
c0107277:	57                   	push   %edi
c0107278:	56                   	push   %esi
c0107279:	83 ec 20             	sub    $0x20,%esp
c010727c:	8b 45 08             	mov    0x8(%ebp),%eax
c010727f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107282:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107285:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107288:	8b 45 10             	mov    0x10(%ebp),%eax
c010728b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010728e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107291:	c1 e8 02             	shr    $0x2,%eax
c0107294:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0107296:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107299:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010729c:	89 d7                	mov    %edx,%edi
c010729e:	89 c6                	mov    %eax,%esi
c01072a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01072a2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01072a5:	83 e1 03             	and    $0x3,%ecx
c01072a8:	74 02                	je     c01072ac <memcpy+0x38>
c01072aa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01072ac:	89 f0                	mov    %esi,%eax
c01072ae:	89 fa                	mov    %edi,%edx
c01072b0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01072b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01072b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01072bc:	83 c4 20             	add    $0x20,%esp
c01072bf:	5e                   	pop    %esi
c01072c0:	5f                   	pop    %edi
c01072c1:	5d                   	pop    %ebp
c01072c2:	c3                   	ret    

c01072c3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01072c3:	55                   	push   %ebp
c01072c4:	89 e5                	mov    %esp,%ebp
c01072c6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01072c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01072cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01072cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01072d5:	eb 30                	jmp    c0107307 <memcmp+0x44>
        if (*s1 != *s2) {
c01072d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072da:	0f b6 10             	movzbl (%eax),%edx
c01072dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01072e0:	0f b6 00             	movzbl (%eax),%eax
c01072e3:	38 c2                	cmp    %al,%dl
c01072e5:	74 18                	je     c01072ff <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01072e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072ea:	0f b6 00             	movzbl (%eax),%eax
c01072ed:	0f b6 d0             	movzbl %al,%edx
c01072f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01072f3:	0f b6 00             	movzbl (%eax),%eax
c01072f6:	0f b6 c0             	movzbl %al,%eax
c01072f9:	29 c2                	sub    %eax,%edx
c01072fb:	89 d0                	mov    %edx,%eax
c01072fd:	eb 1a                	jmp    c0107319 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01072ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0107303:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0107307:	8b 45 10             	mov    0x10(%ebp),%eax
c010730a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010730d:	89 55 10             	mov    %edx,0x10(%ebp)
c0107310:	85 c0                	test   %eax,%eax
c0107312:	75 c3                	jne    c01072d7 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0107314:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107319:	c9                   	leave  
c010731a:	c3                   	ret    
