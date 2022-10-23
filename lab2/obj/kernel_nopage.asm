
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 a0 11 40 	lgdtl  0x4011a018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 a0 11 00       	mov    $0x11a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba c4 b9 11 00       	mov    $0x11b9c4,%edx
  100035:	b8 36 aa 11 00       	mov    $0x11aa36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 aa 11 00 	movl   $0x11aa36,(%esp)
  100051:	e8 3c 71 00 00       	call   107192 <memset>

    cons_init();                // init the console
  100056:	e8 7a 15 00 00       	call   1015d5 <cons_init>

    const char *message = "(LITANG.DINGZHEN) OS is loading ...";
  10005b:	c7 45 f4 20 73 10 00 	movl   $0x107320,-0xc(%ebp)
    cprintf("\n%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 44 73 10 00 	movl   $0x107344,(%esp)
  100070:	e8 ce 02 00 00       	call   100343 <cprintf>

    print_kerninfo();
  100075:	e8 fd 07 00 00       	call   100877 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 20 56 00 00       	call   1056a4 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b5 16 00 00       	call   10173e <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 07 18 00 00       	call   101895 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f8 0c 00 00       	call   100d8b <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 14 16 00 00       	call   1016ac <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 01 0c 00 00       	call   100cbd <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 4a 73 10 00 	movl   $0x10734a,(%esp)
  10015c:	e8 e2 01 00 00       	call   100343 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 58 73 10 00 	movl   $0x107358,(%esp)
  10017c:	e8 c2 01 00 00       	call   100343 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 66 73 10 00 	movl   $0x107366,(%esp)
  10019c:	e8 a2 01 00 00       	call   100343 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 74 73 10 00 	movl   $0x107374,(%esp)
  1001bc:	e8 82 01 00 00       	call   100343 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 82 73 10 00 	movl   $0x107382,(%esp)
  1001dc:	e8 62 01 00 00       	call   100343 <cprintf>
    round ++;
  1001e1:	a1 40 aa 11 00       	mov    0x11aa40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 aa 11 00       	mov    %eax,0x11aa40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    asm volatile (
  1001f3:	cd 78                	int    $0x78
  1001f5:	89 ec                	mov    %ebp,%esp
        "int %0\n\t"
        "mov %%ebp, %%esp" :: "i"(T_SWITCH_TOU)
    );
}
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
    asm volatile (
  1001fc:	cd 79                	int    $0x79
  1001fe:	5c                   	pop    %esp
        "int %0\n\t"
        "pop %%esp" :: "i"(T_SWITCH_TOK)
    );
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
  100204:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100207:	e8 1e ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020c:	c7 04 24 90 73 10 00 	movl   $0x107390,(%esp)
  100213:	e8 2b 01 00 00       	call   100343 <cprintf>
    lab1_switch_to_user();
  100218:	e8 d3 ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021d:	e8 08 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100222:	c7 04 24 b0 73 10 00 	movl   $0x1073b0,(%esp)
  100229:	e8 15 01 00 00       	call   100343 <cprintf>
    lab1_switch_to_kernel();
  10022e:	e8 c6 ff ff ff       	call   1001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100233:	e8 f2 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100238:	c9                   	leave  
  100239:	c3                   	ret    

0010023a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023a:	55                   	push   %ebp
  10023b:	89 e5                	mov    %esp,%ebp
  10023d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100244:	74 13                	je     100259 <readline+0x1f>
        cprintf("%s", prompt);
  100246:	8b 45 08             	mov    0x8(%ebp),%eax
  100249:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024d:	c7 04 24 cf 73 10 00 	movl   $0x1073cf,(%esp)
  100254:	e8 ea 00 00 00       	call   100343 <cprintf>
    }
    int i = 0, c;
  100259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100260:	e8 66 01 00 00       	call   1003cb <getchar>
  100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10026c:	79 07                	jns    100275 <readline+0x3b>
            return NULL;
  10026e:	b8 00 00 00 00       	mov    $0x0,%eax
  100273:	eb 79                	jmp    1002ee <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100275:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100279:	7e 28                	jle    1002a3 <readline+0x69>
  10027b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100282:	7f 1f                	jg     1002a3 <readline+0x69>
            cputchar(c);
  100284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100287:	89 04 24             	mov    %eax,(%esp)
  10028a:	e8 da 00 00 00       	call   100369 <cputchar>
            buf[i ++] = c;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100292:	8d 50 01             	lea    0x1(%eax),%edx
  100295:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10029b:	88 90 60 aa 11 00    	mov    %dl,0x11aa60(%eax)
  1002a1:	eb 46                	jmp    1002e9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a7:	75 17                	jne    1002c0 <readline+0x86>
  1002a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ad:	7e 11                	jle    1002c0 <readline+0x86>
            cputchar(c);
  1002af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b2:	89 04 24             	mov    %eax,(%esp)
  1002b5:	e8 af 00 00 00       	call   100369 <cputchar>
            i --;
  1002ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002be:	eb 29                	jmp    1002e9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c4:	74 06                	je     1002cc <readline+0x92>
  1002c6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002ca:	75 1d                	jne    1002e9 <readline+0xaf>
            cputchar(c);
  1002cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002cf:	89 04 24             	mov    %eax,(%esp)
  1002d2:	e8 92 00 00 00       	call   100369 <cputchar>
            buf[i] = '\0';
  1002d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002da:	05 60 aa 11 00       	add    $0x11aa60,%eax
  1002df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e2:	b8 60 aa 11 00       	mov    $0x11aa60,%eax
  1002e7:	eb 05                	jmp    1002ee <readline+0xb4>
        }
    }
  1002e9:	e9 72 ff ff ff       	jmp    100260 <readline+0x26>
}
  1002ee:	c9                   	leave  
  1002ef:	c3                   	ret    

001002f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f0:	55                   	push   %ebp
  1002f1:	89 e5                	mov    %esp,%ebp
  1002f3:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f9:	89 04 24             	mov    %eax,(%esp)
  1002fc:	e8 00 13 00 00       	call   101601 <cons_putc>
    (*cnt) ++;
  100301:	8b 45 0c             	mov    0xc(%ebp),%eax
  100304:	8b 00                	mov    (%eax),%eax
  100306:	8d 50 01             	lea    0x1(%eax),%edx
  100309:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030c:	89 10                	mov    %edx,(%eax)
}
  10030e:	c9                   	leave  
  10030f:	c3                   	ret    

00100310 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100310:	55                   	push   %ebp
  100311:	89 e5                	mov    %esp,%ebp
  100313:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10031d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100320:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100324:	8b 45 08             	mov    0x8(%ebp),%eax
  100327:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10032e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100332:	c7 04 24 f0 02 10 00 	movl   $0x1002f0,(%esp)
  100339:	e8 6d 66 00 00       	call   1069ab <vprintfmt>
    return cnt;
  10033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100341:	c9                   	leave  
  100342:	c3                   	ret    

00100343 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100343:	55                   	push   %ebp
  100344:	89 e5                	mov    %esp,%ebp
  100346:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100349:	8d 45 0c             	lea    0xc(%ebp),%eax
  10034c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10034f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100352:	89 44 24 04          	mov    %eax,0x4(%esp)
  100356:	8b 45 08             	mov    0x8(%ebp),%eax
  100359:	89 04 24             	mov    %eax,(%esp)
  10035c:	e8 af ff ff ff       	call   100310 <vcprintf>
  100361:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100364:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100367:	c9                   	leave  
  100368:	c3                   	ret    

00100369 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100369:	55                   	push   %ebp
  10036a:	89 e5                	mov    %esp,%ebp
  10036c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10036f:	8b 45 08             	mov    0x8(%ebp),%eax
  100372:	89 04 24             	mov    %eax,(%esp)
  100375:	e8 87 12 00 00       	call   101601 <cons_putc>
}
  10037a:	c9                   	leave  
  10037b:	c3                   	ret    

0010037c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10037c:	55                   	push   %ebp
  10037d:	89 e5                	mov    %esp,%ebp
  10037f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100382:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100389:	eb 13                	jmp    10039e <cputs+0x22>
        cputch(c, &cnt);
  10038b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10038f:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100392:	89 54 24 04          	mov    %edx,0x4(%esp)
  100396:	89 04 24             	mov    %eax,(%esp)
  100399:	e8 52 ff ff ff       	call   1002f0 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10039e:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a1:	8d 50 01             	lea    0x1(%eax),%edx
  1003a4:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a7:	0f b6 00             	movzbl (%eax),%eax
  1003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b1:	75 d8                	jne    10038b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ba:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c1:	e8 2a ff ff ff       	call   1002f0 <cputch>
    return cnt;
  1003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c9:	c9                   	leave  
  1003ca:	c3                   	ret    

001003cb <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d1:	e8 67 12 00 00       	call   10163d <cons_getc>
  1003d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003dd:	74 f2                	je     1003d1 <getchar+0x6>
        /* do nothing */;
    return c;
  1003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e2:	c9                   	leave  
  1003e3:	c3                   	ret    

001003e4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e4:	55                   	push   %ebp
  1003e5:	89 e5                	mov    %esp,%ebp
  1003e7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003ed:	8b 00                	mov    (%eax),%eax
  1003ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f5:	8b 00                	mov    (%eax),%eax
  1003f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100401:	e9 d2 00 00 00       	jmp    1004d8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100406:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100409:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	89 c2                	mov    %eax,%edx
  100410:	c1 ea 1f             	shr    $0x1f,%edx
  100413:	01 d0                	add    %edx,%eax
  100415:	d1 f8                	sar    %eax
  100417:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10041d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100420:	eb 04                	jmp    100426 <stab_binsearch+0x42>
            m --;
  100422:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100429:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10042c:	7c 1f                	jl     10044d <stab_binsearch+0x69>
  10042e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100431:	89 d0                	mov    %edx,%eax
  100433:	01 c0                	add    %eax,%eax
  100435:	01 d0                	add    %edx,%eax
  100437:	c1 e0 02             	shl    $0x2,%eax
  10043a:	89 c2                	mov    %eax,%edx
  10043c:	8b 45 08             	mov    0x8(%ebp),%eax
  10043f:	01 d0                	add    %edx,%eax
  100441:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100445:	0f b6 c0             	movzbl %al,%eax
  100448:	3b 45 14             	cmp    0x14(%ebp),%eax
  10044b:	75 d5                	jne    100422 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100453:	7d 0b                	jge    100460 <stab_binsearch+0x7c>
            l = true_m + 1;
  100455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100458:	83 c0 01             	add    $0x1,%eax
  10045b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10045e:	eb 78                	jmp    1004d8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100460:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100467:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046a:	89 d0                	mov    %edx,%eax
  10046c:	01 c0                	add    %eax,%eax
  10046e:	01 d0                	add    %edx,%eax
  100470:	c1 e0 02             	shl    $0x2,%eax
  100473:	89 c2                	mov    %eax,%edx
  100475:	8b 45 08             	mov    0x8(%ebp),%eax
  100478:	01 d0                	add    %edx,%eax
  10047a:	8b 40 08             	mov    0x8(%eax),%eax
  10047d:	3b 45 18             	cmp    0x18(%ebp),%eax
  100480:	73 13                	jae    100495 <stab_binsearch+0xb1>
            *region_left = m;
  100482:	8b 45 0c             	mov    0xc(%ebp),%eax
  100485:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100488:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10048d:	83 c0 01             	add    $0x1,%eax
  100490:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100493:	eb 43                	jmp    1004d8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100498:	89 d0                	mov    %edx,%eax
  10049a:	01 c0                	add    %eax,%eax
  10049c:	01 d0                	add    %edx,%eax
  10049e:	c1 e0 02             	shl    $0x2,%eax
  1004a1:	89 c2                	mov    %eax,%edx
  1004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004a6:	01 d0                	add    %edx,%eax
  1004a8:	8b 40 08             	mov    0x8(%eax),%eax
  1004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004ae:	76 16                	jbe    1004c6 <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004be:	83 e8 01             	sub    $0x1,%eax
  1004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c4:	eb 12                	jmp    1004d8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004de:	0f 8e 22 ff ff ff    	jle    100406 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e8:	75 0f                	jne    1004f9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ed:	8b 00                	mov    (%eax),%eax
  1004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	89 10                	mov    %edx,(%eax)
  1004f7:	eb 3f                	jmp    100538 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fc:	8b 00                	mov    (%eax),%eax
  1004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100501:	eb 04                	jmp    100507 <stab_binsearch+0x123>
  100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100507:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050a:	8b 00                	mov    (%eax),%eax
  10050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050f:	7d 1f                	jge    100530 <stab_binsearch+0x14c>
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 d0                	mov    %edx,%eax
  100516:	01 c0                	add    %eax,%eax
  100518:	01 d0                	add    %edx,%eax
  10051a:	c1 e0 02             	shl    $0x2,%eax
  10051d:	89 c2                	mov    %eax,%edx
  10051f:	8b 45 08             	mov    0x8(%ebp),%eax
  100522:	01 d0                	add    %edx,%eax
  100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100528:	0f b6 c0             	movzbl %al,%eax
  10052b:	3b 45 14             	cmp    0x14(%ebp),%eax
  10052e:	75 d3                	jne    100503 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100530:	8b 45 0c             	mov    0xc(%ebp),%eax
  100533:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100536:	89 10                	mov    %edx,(%eax)
    }
}
  100538:	c9                   	leave  
  100539:	c3                   	ret    

0010053a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053a:	55                   	push   %ebp
  10053b:	89 e5                	mov    %esp,%ebp
  10053d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100540:	8b 45 0c             	mov    0xc(%ebp),%eax
  100543:	c7 00 d4 73 10 00    	movl   $0x1073d4,(%eax)
    info->eip_line = 0;
  100549:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100553:	8b 45 0c             	mov    0xc(%ebp),%eax
  100556:	c7 40 08 d4 73 10 00 	movl   $0x1073d4,0x8(%eax)
    info->eip_fn_namelen = 9;
  10055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100560:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100567:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056a:	8b 55 08             	mov    0x8(%ebp),%edx
  10056d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100570:	8b 45 0c             	mov    0xc(%ebp),%eax
  100573:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057a:	c7 45 f4 b4 8a 10 00 	movl   $0x108ab4,-0xc(%ebp)
    stab_end = __STAB_END__;
  100581:	c7 45 f0 4c 4c 11 00 	movl   $0x114c4c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100588:	c7 45 ec 4d 4c 11 00 	movl   $0x114c4d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10058f:	c7 45 e8 9e 77 11 00 	movl   $0x11779e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100599:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10059c:	76 0d                	jbe    1005ab <debuginfo_eip+0x71>
  10059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a1:	83 e8 01             	sub    $0x1,%eax
  1005a4:	0f b6 00             	movzbl (%eax),%eax
  1005a7:	84 c0                	test   %al,%al
  1005a9:	74 0a                	je     1005b5 <debuginfo_eip+0x7b>
        return -1;
  1005ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b0:	e9 c0 02 00 00       	jmp    100875 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c2:	29 c2                	sub    %eax,%edx
  1005c4:	89 d0                	mov    %edx,%eax
  1005c6:	c1 f8 02             	sar    $0x2,%eax
  1005c9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005cf:	83 e8 01             	sub    $0x1,%eax
  1005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005dc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e3:	00 
  1005e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f5:	89 04 24             	mov    %eax,(%esp)
  1005f8:	e8 e7 fd ff ff       	call   1003e4 <stab_binsearch>
    if (lfile == 0)
  1005fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100600:	85 c0                	test   %eax,%eax
  100602:	75 0a                	jne    10060e <debuginfo_eip+0xd4>
        return -1;
  100604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100609:	e9 67 02 00 00       	jmp    100875 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10060e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100617:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061a:	8b 45 08             	mov    0x8(%ebp),%eax
  10061d:	89 44 24 10          	mov    %eax,0x10(%esp)
  100621:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100628:	00 
  100629:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10062c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100630:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100633:	89 44 24 04          	mov    %eax,0x4(%esp)
  100637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063a:	89 04 24             	mov    %eax,(%esp)
  10063d:	e8 a2 fd ff ff       	call   1003e4 <stab_binsearch>

    if (lfun <= rfun) {
  100642:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100648:	39 c2                	cmp    %eax,%edx
  10064a:	7f 7c                	jg     1006c8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10064f:	89 c2                	mov    %eax,%edx
  100651:	89 d0                	mov    %edx,%eax
  100653:	01 c0                	add    %eax,%eax
  100655:	01 d0                	add    %edx,%eax
  100657:	c1 e0 02             	shl    $0x2,%eax
  10065a:	89 c2                	mov    %eax,%edx
  10065c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065f:	01 d0                	add    %edx,%eax
  100661:	8b 10                	mov    (%eax),%edx
  100663:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100669:	29 c1                	sub    %eax,%ecx
  10066b:	89 c8                	mov    %ecx,%eax
  10066d:	39 c2                	cmp    %eax,%edx
  10066f:	73 22                	jae    100693 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100671:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100674:	89 c2                	mov    %eax,%edx
  100676:	89 d0                	mov    %edx,%eax
  100678:	01 c0                	add    %eax,%eax
  10067a:	01 d0                	add    %edx,%eax
  10067c:	c1 e0 02             	shl    $0x2,%eax
  10067f:	89 c2                	mov    %eax,%edx
  100681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100684:	01 d0                	add    %edx,%eax
  100686:	8b 10                	mov    (%eax),%edx
  100688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10068b:	01 c2                	add    %eax,%edx
  10068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100690:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100693:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100696:	89 c2                	mov    %eax,%edx
  100698:	89 d0                	mov    %edx,%eax
  10069a:	01 c0                	add    %eax,%eax
  10069c:	01 d0                	add    %edx,%eax
  10069e:	c1 e0 02             	shl    $0x2,%eax
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006a6:	01 d0                	add    %edx,%eax
  1006a8:	8b 50 08             	mov    0x8(%eax),%edx
  1006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ae:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b4:	8b 40 10             	mov    0x10(%eax),%eax
  1006b7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006c6:	eb 15                	jmp    1006dd <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1006ce:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006da:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e0:	8b 40 08             	mov    0x8(%eax),%eax
  1006e3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ea:	00 
  1006eb:	89 04 24             	mov    %eax,(%esp)
  1006ee:	e8 13 69 00 00       	call   107006 <strfind>
  1006f3:	89 c2                	mov    %eax,%edx
  1006f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f8:	8b 40 08             	mov    0x8(%eax),%eax
  1006fb:	29 c2                	sub    %eax,%edx
  1006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100700:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100703:	8b 45 08             	mov    0x8(%ebp),%eax
  100706:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100711:	00 
  100712:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100715:	89 44 24 08          	mov    %eax,0x8(%esp)
  100719:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10071c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100723:	89 04 24             	mov    %eax,(%esp)
  100726:	e8 b9 fc ff ff       	call   1003e4 <stab_binsearch>
    if (lline <= rline) {
  10072b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	39 c2                	cmp    %eax,%edx
  100733:	7f 24                	jg     100759 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100735:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10074e:	0f b7 d0             	movzwl %ax,%edx
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100757:	eb 13                	jmp    10076c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10075e:	e9 12 01 00 00       	jmp    100875 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100766:	83 e8 01             	sub    $0x1,%eax
  100769:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10076c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100772:	39 c2                	cmp    %eax,%edx
  100774:	7c 56                	jl     1007cc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100776:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100779:	89 c2                	mov    %eax,%edx
  10077b:	89 d0                	mov    %edx,%eax
  10077d:	01 c0                	add    %eax,%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	c1 e0 02             	shl    $0x2,%eax
  100784:	89 c2                	mov    %eax,%edx
  100786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100789:	01 d0                	add    %edx,%eax
  10078b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078f:	3c 84                	cmp    $0x84,%al
  100791:	74 39                	je     1007cc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100796:	89 c2                	mov    %eax,%edx
  100798:	89 d0                	mov    %edx,%eax
  10079a:	01 c0                	add    %eax,%eax
  10079c:	01 d0                	add    %edx,%eax
  10079e:	c1 e0 02             	shl    $0x2,%eax
  1007a1:	89 c2                	mov    %eax,%edx
  1007a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a6:	01 d0                	add    %edx,%eax
  1007a8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ac:	3c 64                	cmp    $0x64,%al
  1007ae:	75 b3                	jne    100763 <debuginfo_eip+0x229>
  1007b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	89 d0                	mov    %edx,%eax
  1007b7:	01 c0                	add    %eax,%eax
  1007b9:	01 d0                	add    %edx,%eax
  1007bb:	c1 e0 02             	shl    $0x2,%eax
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c3:	01 d0                	add    %edx,%eax
  1007c5:	8b 40 08             	mov    0x8(%eax),%eax
  1007c8:	85 c0                	test   %eax,%eax
  1007ca:	74 97                	je     100763 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7c 46                	jl     10081c <debuginfo_eip+0x2e2>
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	8b 10                	mov    (%eax),%edx
  1007ed:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f3:	29 c1                	sub    %eax,%ecx
  1007f5:	89 c8                	mov    %ecx,%eax
  1007f7:	39 c2                	cmp    %eax,%edx
  1007f9:	73 21                	jae    10081c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	89 d0                	mov    %edx,%eax
  100802:	01 c0                	add    %eax,%eax
  100804:	01 d0                	add    %edx,%eax
  100806:	c1 e0 02             	shl    $0x2,%eax
  100809:	89 c2                	mov    %eax,%edx
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	01 d0                	add    %edx,%eax
  100810:	8b 10                	mov    (%eax),%edx
  100812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100815:	01 c2                	add    %eax,%edx
  100817:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10081c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10081f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7d 4a                	jge    100870 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100829:	83 c0 01             	add    $0x1,%eax
  10082c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10082f:	eb 18                	jmp    100849 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100831:	8b 45 0c             	mov    0xc(%ebp),%eax
  100834:	8b 40 14             	mov    0x14(%eax),%eax
  100837:	8d 50 01             	lea    0x1(%eax),%edx
  10083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100843:	83 c0 01             	add    $0x1,%eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7d 1d                	jge    100870 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c a0                	cmp    $0xa0,%al
  10086e:	74 c1                	je     100831 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100875:	c9                   	leave  
  100876:	c3                   	ret    

00100877 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100877:	55                   	push   %ebp
  100878:	89 e5                	mov    %esp,%ebp
  10087a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10087d:	c7 04 24 de 73 10 00 	movl   $0x1073de,(%esp)
  100884:	e8 ba fa ff ff       	call   100343 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100889:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100890:	00 
  100891:	c7 04 24 f7 73 10 00 	movl   $0x1073f7,(%esp)
  100898:	e8 a6 fa ff ff       	call   100343 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089d:	c7 44 24 04 1b 73 10 	movl   $0x10731b,0x4(%esp)
  1008a4:	00 
  1008a5:	c7 04 24 0f 74 10 00 	movl   $0x10740f,(%esp)
  1008ac:	e8 92 fa ff ff       	call   100343 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b1:	c7 44 24 04 36 aa 11 	movl   $0x11aa36,0x4(%esp)
  1008b8:	00 
  1008b9:	c7 04 24 27 74 10 00 	movl   $0x107427,(%esp)
  1008c0:	e8 7e fa ff ff       	call   100343 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c5:	c7 44 24 04 c4 b9 11 	movl   $0x11b9c4,0x4(%esp)
  1008cc:	00 
  1008cd:	c7 04 24 3f 74 10 00 	movl   $0x10743f,(%esp)
  1008d4:	e8 6a fa ff ff       	call   100343 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d9:	b8 c4 b9 11 00       	mov    $0x11b9c4,%eax
  1008de:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e9:	29 c2                	sub    %eax,%edx
  1008eb:	89 d0                	mov    %edx,%eax
  1008ed:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f3:	85 c0                	test   %eax,%eax
  1008f5:	0f 48 c2             	cmovs  %edx,%eax
  1008f8:	c1 f8 0a             	sar    $0xa,%eax
  1008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ff:	c7 04 24 58 74 10 00 	movl   $0x107458,(%esp)
  100906:	e8 38 fa ff ff       	call   100343 <cprintf>
}
  10090b:	c9                   	leave  
  10090c:	c3                   	ret    

0010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
int
print_debuginfo(uintptr_t eip) {
  10090d:	55                   	push   %ebp
  10090e:	89 e5                	mov    %esp,%ebp
  100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091d:	8b 45 08             	mov    0x8(%ebp),%eax
  100920:	89 04 24             	mov    %eax,(%esp)
  100923:	e8 12 fc ff ff       	call   10053a <debuginfo_eip>
  100928:	85 c0                	test   %eax,%eax
  10092a:	74 1a                	je     100946 <print_debuginfo+0x39>
        cprintf("    <UNKNOWN>: -- 0x%08x --\n", eip);
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100933:	c7 04 24 82 74 10 00 	movl   $0x107482,(%esp)
  10093a:	e8 04 fa ff ff       	call   100343 <cprintf>
        return 1;
  10093f:	b8 01 00 00 00       	mov    $0x1,%eax
  100944:	eb 72                	jmp    1009b8 <print_debuginfo+0xab>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x5e>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        return 1;
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x42>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 9f 74 10 00 	movl   $0x10749f,(%esp)
  1009ae:	e8 90 f9 ff ff       	call   100343 <cprintf>
                fnname, eip - info.eip_fn_addr);
        return 0;
  1009b3:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009c0:	8b 45 04             	mov    0x4(%ebp),%eax
  1009c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c9:	c9                   	leave  
  1009ca:	c3                   	ret    

001009cb <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009cb:	55                   	push   %ebp
  1009cc:	89 e5                	mov    %esp,%ebp
  1009ce:	53                   	push   %ebx
  1009cf:	83 ec 34             	sub    $0x34,%esp
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    int i;
    uintptr_t current_eip = read_eip();
  1009d2:	e8 e3 ff ff ff       	call   1009ba <read_eip>
  1009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009da:	89 e8                	mov    %ebp,%eax
  1009dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  1009df:	8b 45 e8             	mov    -0x18(%ebp),%eax
    uintptr_t current_ebp = read_ebp();
  1009e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
  1009e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ec:	e9 81 00 00 00       	jmp    100a72 <print_stackframe+0xa7>
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
  1009f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ff:	c7 04 24 b1 74 10 00 	movl   $0x1074b1,(%esp)
  100a06:	e8 38 f9 ff ff       	call   100343 <cprintf>
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
            *((uintptr_t *)current_ebp + 5));
  100a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a0e:	83 c0 14             	add    $0x14,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
  100a11:	8b 18                	mov    (%eax),%ebx
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
  100a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a16:	83 c0 10             	add    $0x10,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
  100a19:	8b 08                	mov    (%eax),%ecx
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
  100a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a1e:	83 c0 0c             	add    $0xc,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
  100a21:	8b 10                	mov    (%eax),%edx
            *((uintptr_t *)current_ebp + 2),
  100a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a26:	83 c0 08             	add    $0x8,%eax
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("EBP:0x%08x EIP:0x%08x ", current_ebp, current_eip);
        cprintf("ARGS:0x%08x 0x%08x 0x%08x 0x%08x\n", 
  100a29:	8b 00                	mov    (%eax),%eax
  100a2b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a33:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3b:	c7 04 24 c8 74 10 00 	movl   $0x1074c8,(%esp)
  100a42:	e8 fc f8 ff ff       	call   100343 <cprintf>
            *((uintptr_t *)current_ebp + 2),
            *((uintptr_t *)current_ebp + 3),
            *((uintptr_t *)current_ebp + 4),
            *((uintptr_t *)current_ebp + 5));
        if (print_debuginfo(current_eip - 1)) {
  100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4a:	83 e8 01             	sub    $0x1,%eax
  100a4d:	89 04 24             	mov    %eax,(%esp)
  100a50:	e8 b8 fe ff ff       	call   10090d <print_debuginfo>
  100a55:	85 c0                	test   %eax,%eax
  100a57:	74 02                	je     100a5b <print_stackframe+0x90>
            break;
  100a59:	eb 21                	jmp    100a7c <print_stackframe+0xb1>
        }
        current_eip = *((uintptr_t *)current_ebp + 1);
  100a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a5e:	83 c0 04             	add    $0x4,%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
        current_ebp = *((uintptr_t *)current_ebp);
  100a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a69:	8b 00                	mov    (%eax),%eax
  100a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    int i;
    uintptr_t current_eip = read_eip();
    uintptr_t current_ebp = read_ebp();
    for (i = 0; i < STACKFRAME_DEPTH; i++) {
  100a6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a72:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  100a76:	0f 8e 75 ff ff ff    	jle    1009f1 <print_stackframe+0x26>
            break;
        }
        current_eip = *((uintptr_t *)current_ebp + 1);
        current_ebp = *((uintptr_t *)current_ebp);
    }
  100a7c:	83 c4 34             	add    $0x34,%esp
  100a7f:	5b                   	pop    %ebx
  100a80:	5d                   	pop    %ebp
  100a81:	c3                   	ret    

00100a82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a82:	55                   	push   %ebp
  100a83:	89 e5                	mov    %esp,%ebp
  100a85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8f:	eb 0c                	jmp    100a9d <parse+0x1b>
            *buf ++ = '\0';
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	8d 50 01             	lea    0x1(%eax),%edx
  100a97:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa0:	0f b6 00             	movzbl (%eax),%eax
  100aa3:	84 c0                	test   %al,%al
  100aa5:	74 1d                	je     100ac4 <parse+0x42>
  100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaa:	0f b6 00             	movzbl (%eax),%eax
  100aad:	0f be c0             	movsbl %al,%eax
  100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab4:	c7 04 24 6c 75 10 00 	movl   $0x10756c,(%esp)
  100abb:	e8 13 65 00 00       	call   106fd3 <strchr>
  100ac0:	85 c0                	test   %eax,%eax
  100ac2:	75 cd                	jne    100a91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac7:	0f b6 00             	movzbl (%eax),%eax
  100aca:	84 c0                	test   %al,%al
  100acc:	75 02                	jne    100ad0 <parse+0x4e>
            break;
  100ace:	eb 67                	jmp    100b37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad4:	75 14                	jne    100aea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100add:	00 
  100ade:	c7 04 24 71 75 10 00 	movl   $0x107571,(%esp)
  100ae5:	e8 59 f8 ff ff       	call   100343 <cprintf>
        }
        argv[argc ++] = buf;
  100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aed:	8d 50 01             	lea    0x1(%eax),%edx
  100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afd:	01 c2                	add    %eax,%edx
  100aff:	8b 45 08             	mov    0x8(%ebp),%eax
  100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b04:	eb 04                	jmp    100b0a <parse+0x88>
            buf ++;
  100b06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	0f b6 00             	movzbl (%eax),%eax
  100b10:	84 c0                	test   %al,%al
  100b12:	74 1d                	je     100b31 <parse+0xaf>
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	0f be c0             	movsbl %al,%eax
  100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b21:	c7 04 24 6c 75 10 00 	movl   $0x10756c,(%esp)
  100b28:	e8 a6 64 00 00       	call   106fd3 <strchr>
  100b2d:	85 c0                	test   %eax,%eax
  100b2f:	74 d5                	je     100b06 <parse+0x84>
            buf ++;
        }
    }
  100b31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b32:	e9 66 ff ff ff       	jmp    100a9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3a:	c9                   	leave  
  100b3b:	c3                   	ret    

00100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3c:	55                   	push   %ebp
  100b3d:	89 e5                	mov    %esp,%ebp
  100b3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b42:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b49:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4c:	89 04 24             	mov    %eax,(%esp)
  100b4f:	e8 2e ff ff ff       	call   100a82 <parse>
  100b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5b:	75 0a                	jne    100b67 <runcmd+0x2b>
        return 0;
  100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b62:	e9 85 00 00 00       	jmp    100bec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6e:	eb 5c                	jmp    100bcc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b76:	89 d0                	mov    %edx,%eax
  100b78:	01 c0                	add    %eax,%eax
  100b7a:	01 d0                	add    %edx,%eax
  100b7c:	c1 e0 02             	shl    $0x2,%eax
  100b7f:	05 20 a0 11 00       	add    $0x11a020,%eax
  100b84:	8b 00                	mov    (%eax),%eax
  100b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8a:	89 04 24             	mov    %eax,(%esp)
  100b8d:	e8 a2 63 00 00       	call   106f34 <strcmp>
  100b92:	85 c0                	test   %eax,%eax
  100b94:	75 32                	jne    100bc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b99:	89 d0                	mov    %edx,%eax
  100b9b:	01 c0                	add    %eax,%eax
  100b9d:	01 d0                	add    %edx,%eax
  100b9f:	c1 e0 02             	shl    $0x2,%eax
  100ba2:	05 20 a0 11 00       	add    $0x11a020,%eax
  100ba7:	8b 40 08             	mov    0x8(%eax),%eax
  100baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bad:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bba:	83 c2 04             	add    $0x4,%edx
  100bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc1:	89 0c 24             	mov    %ecx,(%esp)
  100bc4:	ff d0                	call   *%eax
  100bc6:	eb 24                	jmp    100bec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcf:	83 f8 02             	cmp    $0x2,%eax
  100bd2:	76 9c                	jbe    100b70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdb:	c7 04 24 8f 75 10 00 	movl   $0x10758f,(%esp)
  100be2:	e8 5c f7 ff ff       	call   100343 <cprintf>
    return 0;
  100be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bec:	c9                   	leave  
  100bed:	c3                   	ret    

00100bee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bee:	55                   	push   %ebp
  100bef:	89 e5                	mov    %esp,%ebp
  100bf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf4:	c7 04 24 a8 75 10 00 	movl   $0x1075a8,(%esp)
  100bfb:	e8 43 f7 ff ff       	call   100343 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c00:	c7 04 24 d0 75 10 00 	movl   $0x1075d0,(%esp)
  100c07:	e8 37 f7 ff ff       	call   100343 <cprintf>

    if (tf != NULL) {
  100c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c10:	74 0b                	je     100c1d <kmonitor+0x2f>
        print_trapframe(tf);
  100c12:	8b 45 08             	mov    0x8(%ebp),%eax
  100c15:	89 04 24             	mov    %eax,(%esp)
  100c18:	e8 30 0e 00 00       	call   101a4d <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1d:	c7 04 24 f5 75 10 00 	movl   $0x1075f5,(%esp)
  100c24:	e8 11 f6 ff ff       	call   10023a <readline>
  100c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c30:	74 18                	je     100c4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c32:	8b 45 08             	mov    0x8(%ebp),%eax
  100c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3c:	89 04 24             	mov    %eax,(%esp)
  100c3f:	e8 f8 fe ff ff       	call   100b3c <runcmd>
  100c44:	85 c0                	test   %eax,%eax
  100c46:	79 02                	jns    100c4a <kmonitor+0x5c>
                break;
  100c48:	eb 02                	jmp    100c4c <kmonitor+0x5e>
            }
        }
    }
  100c4a:	eb d1                	jmp    100c1d <kmonitor+0x2f>
}
  100c4c:	c9                   	leave  
  100c4d:	c3                   	ret    

00100c4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4e:	55                   	push   %ebp
  100c4f:	89 e5                	mov    %esp,%ebp
  100c51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5b:	eb 3f                	jmp    100c9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c60:	89 d0                	mov    %edx,%eax
  100c62:	01 c0                	add    %eax,%eax
  100c64:	01 d0                	add    %edx,%eax
  100c66:	c1 e0 02             	shl    $0x2,%eax
  100c69:	05 20 a0 11 00       	add    $0x11a020,%eax
  100c6e:	8b 48 04             	mov    0x4(%eax),%ecx
  100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c74:	89 d0                	mov    %edx,%eax
  100c76:	01 c0                	add    %eax,%eax
  100c78:	01 d0                	add    %edx,%eax
  100c7a:	c1 e0 02             	shl    $0x2,%eax
  100c7d:	05 20 a0 11 00       	add    $0x11a020,%eax
  100c82:	8b 00                	mov    (%eax),%eax
  100c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8c:	c7 04 24 f9 75 10 00 	movl   $0x1075f9,(%esp)
  100c93:	e8 ab f6 ff ff       	call   100343 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9f:	83 f8 02             	cmp    $0x2,%eax
  100ca2:	76 b9                	jbe    100c5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	c9                   	leave  
  100caa:	c3                   	ret    

00100cab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb1:	e8 c1 fb ff ff       	call   100877 <print_kerninfo>
    return 0;
  100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbb:	c9                   	leave  
  100cbc:	c3                   	ret    

00100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc3:	e8 03 fd ff ff       	call   1009cb <print_stackframe>
    return 0;
  100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccd:	c9                   	leave  
  100cce:	c3                   	ret    

00100ccf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccf:	55                   	push   %ebp
  100cd0:	89 e5                	mov    %esp,%ebp
  100cd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd5:	a1 60 ae 11 00       	mov    0x11ae60,%eax
  100cda:	85 c0                	test   %eax,%eax
  100cdc:	74 02                	je     100ce0 <__panic+0x11>
        goto panic_dead;
  100cde:	eb 48                	jmp    100d28 <__panic+0x59>
    }
    is_panic = 1;
  100ce0:	c7 05 60 ae 11 00 01 	movl   $0x1,0x11ae60
  100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cea:	8d 45 14             	lea    0x14(%ebp),%eax
  100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfe:	c7 04 24 02 76 10 00 	movl   $0x107602,(%esp)
  100d05:	e8 39 f6 ff ff       	call   100343 <cprintf>
    vcprintf(fmt, ap);
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d11:	8b 45 10             	mov    0x10(%ebp),%eax
  100d14:	89 04 24             	mov    %eax,(%esp)
  100d17:	e8 f4 f5 ff ff       	call   100310 <vcprintf>
    cprintf("\n");
  100d1c:	c7 04 24 1e 76 10 00 	movl   $0x10761e,(%esp)
  100d23:	e8 1b f6 ff ff       	call   100343 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d28:	e8 85 09 00 00       	call   1016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d34:	e8 b5 fe ff ff       	call   100bee <kmonitor>
    }
  100d39:	eb f2                	jmp    100d2d <__panic+0x5e>

00100d3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3b:	55                   	push   %ebp
  100d3c:	89 e5                	mov    %esp,%ebp
  100d3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d41:	8d 45 14             	lea    0x14(%ebp),%eax
  100d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d55:	c7 04 24 20 76 10 00 	movl   $0x107620,(%esp)
  100d5c:	e8 e2 f5 ff ff       	call   100343 <cprintf>
    vcprintf(fmt, ap);
  100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d68:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6b:	89 04 24             	mov    %eax,(%esp)
  100d6e:	e8 9d f5 ff ff       	call   100310 <vcprintf>
    cprintf("\n");
  100d73:	c7 04 24 1e 76 10 00 	movl   $0x10761e,(%esp)
  100d7a:	e8 c4 f5 ff ff       	call   100343 <cprintf>
    va_end(ap);
}
  100d7f:	c9                   	leave  
  100d80:	c3                   	ret    

00100d81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d81:	55                   	push   %ebp
  100d82:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d84:	a1 60 ae 11 00       	mov    0x11ae60,%eax
}
  100d89:	5d                   	pop    %ebp
  100d8a:	c3                   	ret    

00100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8b:	55                   	push   %ebp
  100d8c:	89 e5                	mov    %esp,%ebp
  100d8e:	83 ec 28             	sub    $0x28,%esp
  100d91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da3:	ee                   	out    %al,(%dx)
  100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db6:	ee                   	out    %al,(%dx)
  100db7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dca:	c7 05 4c b9 11 00 00 	movl   $0x0,0x11b94c
  100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd4:	c7 04 24 3e 76 10 00 	movl   $0x10763e,(%esp)
  100ddb:	e8 63 f5 ff ff       	call   100343 <cprintf>
    pic_enable(IRQ_TIMER);
  100de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de7:	e8 24 09 00 00       	call   101710 <pic_enable>
}
  100dec:	c9                   	leave  
  100ded:	c3                   	ret    

00100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dee:	55                   	push   %ebp
  100def:	89 e5                	mov    %esp,%ebp
  100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df4:	9c                   	pushf  
  100df5:	58                   	pop    %eax
  100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfc:	25 00 02 00 00       	and    $0x200,%eax
  100e01:	85 c0                	test   %eax,%eax
  100e03:	74 0c                	je     100e11 <__intr_save+0x23>
        intr_disable();
  100e05:	e8 a8 08 00 00       	call   1016b2 <intr_disable>
        return 1;
  100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0f:	eb 05                	jmp    100e16 <__intr_save+0x28>
    }
    return 0;
  100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e16:	c9                   	leave  
  100e17:	c3                   	ret    

00100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e18:	55                   	push   %ebp
  100e19:	89 e5                	mov    %esp,%ebp
  100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e22:	74 05                	je     100e29 <__intr_restore+0x11>
        intr_enable();
  100e24:	e8 83 08 00 00       	call   1016ac <intr_enable>
    }
}
  100e29:	c9                   	leave  
  100e2a:	c3                   	ret    

00100e2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2b:	55                   	push   %ebp
  100e2c:	89 e5                	mov    %esp,%ebp
  100e2e:	83 ec 10             	sub    $0x10,%esp
  100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3b:	89 c2                	mov    %eax,%edx
  100e3d:	ec                   	in     (%dx),%al
  100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6b:	89 c2                	mov    %eax,%edx
  100e6d:	ec                   	in     (%dx),%al
  100e6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e71:	c9                   	leave  
  100e72:	c3                   	ret    

00100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e73:	55                   	push   %ebp
  100e74:	89 e5                	mov    %esp,%ebp
  100e76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e83:	0f b7 00             	movzwl (%eax),%eax
  100e86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	0f b7 00             	movzwl (%eax),%eax
  100e98:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9c:	74 12                	je     100eb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea5:	66 c7 05 86 ae 11 00 	movw   $0x3b4,0x11ae86
  100eac:	b4 03 
  100eae:	eb 13                	jmp    100ec3 <cga_init+0x50>
    } else {
        *cp = was;
  100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eba:	66 c7 05 86 ae 11 00 	movw   $0x3d4,0x11ae86
  100ec1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec3:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100eca:	0f b7 c0             	movzwl %ax,%eax
  100ecd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ede:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100ee5:	83 c0 01             	add    $0x1,%eax
  100ee8:	0f b7 c0             	movzwl %ax,%eax
  100eeb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef3:	89 c2                	mov    %eax,%edx
  100ef5:	ec                   	in     (%dx),%al
  100ef6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efd:	0f b6 c0             	movzbl %al,%eax
  100f00:	c1 e0 08             	shl    $0x8,%eax
  100f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f06:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100f0d:	0f b7 c0             	movzwl %ax,%eax
  100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f14:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f18:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f21:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  100f28:	83 c0 01             	add    $0x1,%eax
  100f2b:	0f b7 c0             	movzwl %ax,%eax
  100f2e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f32:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f36:	89 c2                	mov    %eax,%edx
  100f38:	ec                   	in     (%dx),%al
  100f39:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f40:	0f b6 c0             	movzbl %al,%eax
  100f43:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f49:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    crt_pos = pos;
  100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f51:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
}
  100f57:	c9                   	leave  
  100f58:	c3                   	ret    

00100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f59:	55                   	push   %ebp
  100f5a:	89 e5                	mov    %esp,%ebp
  100f5c:	83 ec 48             	sub    $0x48,%esp
  100f5f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f65:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f69:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f78:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
  100f85:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f8b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f93:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f97:	ee                   	out    %al,(%dx)
  100f98:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
  100fab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbd:	ee                   	out    %al,(%dx)
  100fbe:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd0:	ee                   	out    %al,(%dx)
  100fd1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fdb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe3:	ee                   	out    %al,(%dx)
  100fe4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff8:	3c ff                	cmp    $0xff,%al
  100ffa:	0f 95 c0             	setne  %al
  100ffd:	0f b6 c0             	movzbl %al,%eax
  101000:	a3 88 ae 11 00       	mov    %eax,0x11ae88
  101005:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101015:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10101b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101f:	89 c2                	mov    %eax,%edx
  101021:	ec                   	in     (%dx),%al
  101022:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101025:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  10102a:	85 c0                	test   %eax,%eax
  10102c:	74 0c                	je     10103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101035:	e8 d6 06 00 00       	call   101710 <pic_enable>
    }
}
  10103a:	c9                   	leave  
  10103b:	c3                   	ret    

0010103c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103c:	55                   	push   %ebp
  10103d:	89 e5                	mov    %esp,%ebp
  10103f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101049:	eb 09                	jmp    101054 <lpt_putc_sub+0x18>
        delay();
  10104b:	e8 db fd ff ff       	call   100e2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101050:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105e:	89 c2                	mov    %eax,%edx
  101060:	ec                   	in     (%dx),%al
  101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101068:	84 c0                	test   %al,%al
  10106a:	78 09                	js     101075 <lpt_putc_sub+0x39>
  10106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101073:	7e d6                	jle    10104b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101075:	8b 45 08             	mov    0x8(%ebp),%eax
  101078:	0f b6 c0             	movzbl %al,%eax
  10107b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101081:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101084:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101088:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108c:	ee                   	out    %al,(%dx)
  10108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109f:	ee                   	out    %al,(%dx)
  1010a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b3:	c9                   	leave  
  1010b4:	c3                   	ret    

001010b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b5:	55                   	push   %ebp
  1010b6:	89 e5                	mov    %esp,%ebp
  1010b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bf:	74 0d                	je     1010ce <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c4:	89 04 24             	mov    %eax,(%esp)
  1010c7:	e8 70 ff ff ff       	call   10103c <lpt_putc_sub>
  1010cc:	eb 24                	jmp    1010f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d5:	e8 62 ff ff ff       	call   10103c <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e1:	e8 56 ff ff ff       	call   10103c <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ed:	e8 4a ff ff ff       	call   10103c <lpt_putc_sub>
    }
}
  1010f2:	c9                   	leave  
  1010f3:	c3                   	ret    

001010f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f4:	55                   	push   %ebp
  1010f5:	89 e5                	mov    %esp,%ebp
  1010f7:	53                   	push   %ebx
  1010f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fe:	b0 00                	mov    $0x0,%al
  101100:	85 c0                	test   %eax,%eax
  101102:	75 07                	jne    10110b <cga_putc+0x17>
        c |= 0x0700;
  101104:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10110b:	8b 45 08             	mov    0x8(%ebp),%eax
  10110e:	0f b6 c0             	movzbl %al,%eax
  101111:	83 f8 0a             	cmp    $0xa,%eax
  101114:	74 4c                	je     101162 <cga_putc+0x6e>
  101116:	83 f8 0d             	cmp    $0xd,%eax
  101119:	74 57                	je     101172 <cga_putc+0x7e>
  10111b:	83 f8 08             	cmp    $0x8,%eax
  10111e:	0f 85 88 00 00 00    	jne    1011ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101124:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  10112b:	66 85 c0             	test   %ax,%ax
  10112e:	74 30                	je     101160 <cga_putc+0x6c>
            crt_pos --;
  101130:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  101137:	83 e8 01             	sub    $0x1,%eax
  10113a:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101140:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101145:	0f b7 15 84 ae 11 00 	movzwl 0x11ae84,%edx
  10114c:	0f b7 d2             	movzwl %dx,%edx
  10114f:	01 d2                	add    %edx,%edx
  101151:	01 c2                	add    %eax,%edx
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	b0 00                	mov    $0x0,%al
  101158:	83 c8 20             	or     $0x20,%eax
  10115b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115e:	eb 72                	jmp    1011d2 <cga_putc+0xde>
  101160:	eb 70                	jmp    1011d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101162:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  101169:	83 c0 50             	add    $0x50,%eax
  10116c:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101172:	0f b7 1d 84 ae 11 00 	movzwl 0x11ae84,%ebx
  101179:	0f b7 0d 84 ae 11 00 	movzwl 0x11ae84,%ecx
  101180:	0f b7 c1             	movzwl %cx,%eax
  101183:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101189:	c1 e8 10             	shr    $0x10,%eax
  10118c:	89 c2                	mov    %eax,%edx
  10118e:	66 c1 ea 06          	shr    $0x6,%dx
  101192:	89 d0                	mov    %edx,%eax
  101194:	c1 e0 02             	shl    $0x2,%eax
  101197:	01 d0                	add    %edx,%eax
  101199:	c1 e0 04             	shl    $0x4,%eax
  10119c:	29 c1                	sub    %eax,%ecx
  10119e:	89 ca                	mov    %ecx,%edx
  1011a0:	89 d8                	mov    %ebx,%eax
  1011a2:	29 d0                	sub    %edx,%eax
  1011a4:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
        break;
  1011aa:	eb 26                	jmp    1011d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ac:	8b 0d 80 ae 11 00    	mov    0x11ae80,%ecx
  1011b2:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1011b9:	8d 50 01             	lea    0x1(%eax),%edx
  1011bc:	66 89 15 84 ae 11 00 	mov    %dx,0x11ae84
  1011c3:	0f b7 c0             	movzwl %ax,%eax
  1011c6:	01 c0                	add    %eax,%eax
  1011c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ce:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d2:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1011d9:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011dd:	76 5b                	jbe    10123a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011df:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1011e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ea:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1011ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f6:	00 
  1011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fb:	89 04 24             	mov    %eax,(%esp)
  1011fe:	e8 ce 5f 00 00       	call   1071d1 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101203:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120a:	eb 15                	jmp    101221 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120c:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101214:	01 d2                	add    %edx,%edx
  101216:	01 d0                	add    %edx,%eax
  101218:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101221:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101228:	7e e2                	jle    10120c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122a:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  101231:	83 e8 50             	sub    $0x50,%eax
  101234:	66 a3 84 ae 11 00    	mov    %ax,0x11ae84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123a:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  101241:	0f b7 c0             	movzwl %ax,%eax
  101244:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101248:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101250:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101254:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101255:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  10125c:	66 c1 e8 08          	shr    $0x8,%ax
  101260:	0f b6 c0             	movzbl %al,%eax
  101263:	0f b7 15 86 ae 11 00 	movzwl 0x11ae86,%edx
  10126a:	83 c2 01             	add    $0x1,%edx
  10126d:	0f b7 d2             	movzwl %dx,%edx
  101270:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101274:	88 45 ed             	mov    %al,-0x13(%ebp)
  101277:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10127b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101280:	0f b7 05 86 ae 11 00 	movzwl 0x11ae86,%eax
  101287:	0f b7 c0             	movzwl %ax,%eax
  10128a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101292:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101296:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129b:	0f b7 05 84 ae 11 00 	movzwl 0x11ae84,%eax
  1012a2:	0f b6 c0             	movzbl %al,%eax
  1012a5:	0f b7 15 86 ae 11 00 	movzwl 0x11ae86,%edx
  1012ac:	83 c2 01             	add    $0x1,%edx
  1012af:	0f b7 d2             	movzwl %dx,%edx
  1012b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c1:	ee                   	out    %al,(%dx)
}
  1012c2:	83 c4 34             	add    $0x34,%esp
  1012c5:	5b                   	pop    %ebx
  1012c6:	5d                   	pop    %ebp
  1012c7:	c3                   	ret    

001012c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c8:	55                   	push   %ebp
  1012c9:	89 e5                	mov    %esp,%ebp
  1012cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d5:	eb 09                	jmp    1012e0 <serial_putc_sub+0x18>
        delay();
  1012d7:	e8 4f fb ff ff       	call   100e2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ea:	89 c2                	mov    %eax,%edx
  1012ec:	ec                   	in     (%dx),%al
  1012ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f4:	0f b6 c0             	movzbl %al,%eax
  1012f7:	83 e0 20             	and    $0x20,%eax
  1012fa:	85 c0                	test   %eax,%eax
  1012fc:	75 09                	jne    101307 <serial_putc_sub+0x3f>
  1012fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101305:	7e d0                	jle    1012d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101307:	8b 45 08             	mov    0x8(%ebp),%eax
  10130a:	0f b6 c0             	movzbl %al,%eax
  10130d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101313:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101316:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10131a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131e:	ee                   	out    %al,(%dx)
}
  10131f:	c9                   	leave  
  101320:	c3                   	ret    

00101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101321:	55                   	push   %ebp
  101322:	89 e5                	mov    %esp,%ebp
  101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132b:	74 0d                	je     10133a <serial_putc+0x19>
        serial_putc_sub(c);
  10132d:	8b 45 08             	mov    0x8(%ebp),%eax
  101330:	89 04 24             	mov    %eax,(%esp)
  101333:	e8 90 ff ff ff       	call   1012c8 <serial_putc_sub>
  101338:	eb 24                	jmp    10135e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101341:	e8 82 ff ff ff       	call   1012c8 <serial_putc_sub>
        serial_putc_sub(' ');
  101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134d:	e8 76 ff ff ff       	call   1012c8 <serial_putc_sub>
        serial_putc_sub('\b');
  101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101359:	e8 6a ff ff ff       	call   1012c8 <serial_putc_sub>
    }
}
  10135e:	c9                   	leave  
  10135f:	c3                   	ret    

00101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101360:	55                   	push   %ebp
  101361:	89 e5                	mov    %esp,%ebp
  101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101366:	eb 33                	jmp    10139b <cons_intr+0x3b>
        if (c != 0) {
  101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136c:	74 2d                	je     10139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136e:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  101373:	8d 50 01             	lea    0x1(%eax),%edx
  101376:	89 15 a4 b0 11 00    	mov    %edx,0x11b0a4
  10137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137f:	88 90 a0 ae 11 00    	mov    %dl,0x11aea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101385:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  10138a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138f:	75 0a                	jne    10139b <cons_intr+0x3b>
                cons.wpos = 0;
  101391:	c7 05 a4 b0 11 00 00 	movl   $0x0,0x11b0a4
  101398:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10139b:	8b 45 08             	mov    0x8(%ebp),%eax
  10139e:	ff d0                	call   *%eax
  1013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a7:	75 bf                	jne    101368 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a9:	c9                   	leave  
  1013aa:	c3                   	ret    

001013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ab:	55                   	push   %ebp
  1013ac:	89 e5                	mov    %esp,%ebp
  1013ae:	83 ec 10             	sub    $0x10,%esp
  1013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	83 e0 01             	and    $0x1,%eax
  1013cb:	85 c0                	test   %eax,%eax
  1013cd:	75 07                	jne    1013d6 <serial_proc_data+0x2b>
        return -1;
  1013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d4:	eb 2a                	jmp    101400 <serial_proc_data+0x55>
  1013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e0:	89 c2                	mov    %eax,%edx
  1013e2:	ec                   	in     (%dx),%al
  1013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ea:	0f b6 c0             	movzbl %al,%eax
  1013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f4:	75 07                	jne    1013fd <serial_proc_data+0x52>
        c = '\b';
  1013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101400:	c9                   	leave  
  101401:	c3                   	ret    

00101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101402:	55                   	push   %ebp
  101403:	89 e5                	mov    %esp,%ebp
  101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101408:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  10140d:	85 c0                	test   %eax,%eax
  10140f:	74 0c                	je     10141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101411:	c7 04 24 ab 13 10 00 	movl   $0x1013ab,(%esp)
  101418:	e8 43 ff ff ff       	call   101360 <cons_intr>
    }
}
  10141d:	c9                   	leave  
  10141e:	c3                   	ret    

0010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141f:	55                   	push   %ebp
  101420:	89 e5                	mov    %esp,%ebp
  101422:	83 ec 38             	sub    $0x38,%esp
  101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142f:	89 c2                	mov    %eax,%edx
  101431:	ec                   	in     (%dx),%al
  101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101439:	0f b6 c0             	movzbl %al,%eax
  10143c:	83 e0 01             	and    $0x1,%eax
  10143f:	85 c0                	test   %eax,%eax
  101441:	75 0a                	jne    10144d <kbd_proc_data+0x2e>
        return -1;
  101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101448:	e9 59 01 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
  10144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101457:	89 c2                	mov    %eax,%edx
  101459:	ec                   	in     (%dx),%al
  10145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101468:	75 17                	jne    101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10146a:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  10146f:	83 c8 40             	or     $0x40,%eax
  101472:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
        return 0;
  101477:	b8 00 00 00 00       	mov    $0x0,%eax
  10147c:	e9 25 01 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101485:	84 c0                	test   %al,%al
  101487:	79 47                	jns    1014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101489:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  10148e:	83 e0 40             	and    $0x40,%eax
  101491:	85 c0                	test   %eax,%eax
  101493:	75 09                	jne    10149e <kbd_proc_data+0x7f>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	83 e0 7f             	and    $0x7f,%eax
  10149c:	eb 04                	jmp    1014a2 <kbd_proc_data+0x83>
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a9:	0f b6 80 60 a0 11 00 	movzbl 0x11a060(%eax),%eax
  1014b0:	83 c8 40             	or     $0x40,%eax
  1014b3:	0f b6 c0             	movzbl %al,%eax
  1014b6:	f7 d0                	not    %eax
  1014b8:	89 c2                	mov    %eax,%edx
  1014ba:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014bf:	21 d0                	and    %edx,%eax
  1014c1:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
        return 0;
  1014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cb:	e9 d6 00 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d0:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014d5:	83 e0 40             	and    $0x40,%eax
  1014d8:	85 c0                	test   %eax,%eax
  1014da:	74 11                	je     1014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e0:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  1014e5:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e8:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
    }

    shift |= shiftcode[data];
  1014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f1:	0f b6 80 60 a0 11 00 	movzbl 0x11a060(%eax),%eax
  1014f8:	0f b6 d0             	movzbl %al,%edx
  1014fb:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101500:	09 d0                	or     %edx,%eax
  101502:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8
    shift ^= togglecode[data];
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	0f b6 80 60 a1 11 00 	movzbl 0x11a160(%eax),%eax
  101512:	0f b6 d0             	movzbl %al,%edx
  101515:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  10151a:	31 d0                	xor    %edx,%eax
  10151c:	a3 a8 b0 11 00       	mov    %eax,0x11b0a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101521:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101526:	83 e0 03             	and    $0x3,%eax
  101529:	8b 14 85 60 a5 11 00 	mov    0x11a560(,%eax,4),%edx
  101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101534:	01 d0                	add    %edx,%eax
  101536:	0f b6 00             	movzbl (%eax),%eax
  101539:	0f b6 c0             	movzbl %al,%eax
  10153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153f:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101544:	83 e0 08             	and    $0x8,%eax
  101547:	85 c0                	test   %eax,%eax
  101549:	74 22                	je     10156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154f:	7e 0c                	jle    10155d <kbd_proc_data+0x13e>
  101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101555:	7f 06                	jg     10155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155b:	eb 10                	jmp    10156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101561:	7e 0a                	jle    10156d <kbd_proc_data+0x14e>
  101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101567:	7f 04                	jg     10156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156d:	a1 a8 b0 11 00       	mov    0x11b0a8,%eax
  101572:	f7 d0                	not    %eax
  101574:	83 e0 06             	and    $0x6,%eax
  101577:	85 c0                	test   %eax,%eax
  101579:	75 28                	jne    1015a3 <kbd_proc_data+0x184>
  10157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101582:	75 1f                	jne    1015a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101584:	c7 04 24 59 76 10 00 	movl   $0x107659,(%esp)
  10158b:	e8 b3 ed ff ff       	call   100343 <cprintf>
  101590:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101596:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10159a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a6:	c9                   	leave  
  1015a7:	c3                   	ret    

001015a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a8:	55                   	push   %ebp
  1015a9:	89 e5                	mov    %esp,%ebp
  1015ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ae:	c7 04 24 1f 14 10 00 	movl   $0x10141f,(%esp)
  1015b5:	e8 a6 fd ff ff       	call   101360 <cons_intr>
}
  1015ba:	c9                   	leave  
  1015bb:	c3                   	ret    

001015bc <kbd_init>:

static void
kbd_init(void) {
  1015bc:	55                   	push   %ebp
  1015bd:	89 e5                	mov    %esp,%ebp
  1015bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c2:	e8 e1 ff ff ff       	call   1015a8 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ce:	e8 3d 01 00 00       	call   101710 <pic_enable>
}
  1015d3:	c9                   	leave  
  1015d4:	c3                   	ret    

001015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015db:	e8 93 f8 ff ff       	call   100e73 <cga_init>
    serial_init();
  1015e0:	e8 74 f9 ff ff       	call   100f59 <serial_init>
    kbd_init();
  1015e5:	e8 d2 ff ff ff       	call   1015bc <kbd_init>
    if (!serial_exists) {
  1015ea:	a1 88 ae 11 00       	mov    0x11ae88,%eax
  1015ef:	85 c0                	test   %eax,%eax
  1015f1:	75 0c                	jne    1015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f3:	c7 04 24 65 76 10 00 	movl   $0x107665,(%esp)
  1015fa:	e8 44 ed ff ff       	call   100343 <cprintf>
    }
}
  1015ff:	c9                   	leave  
  101600:	c3                   	ret    

00101601 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101601:	55                   	push   %ebp
  101602:	89 e5                	mov    %esp,%ebp
  101604:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101607:	e8 e2 f7 ff ff       	call   100dee <__intr_save>
  10160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160f:	8b 45 08             	mov    0x8(%ebp),%eax
  101612:	89 04 24             	mov    %eax,(%esp)
  101615:	e8 9b fa ff ff       	call   1010b5 <lpt_putc>
        cga_putc(c);
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	89 04 24             	mov    %eax,(%esp)
  101620:	e8 cf fa ff ff       	call   1010f4 <cga_putc>
        serial_putc(c);
  101625:	8b 45 08             	mov    0x8(%ebp),%eax
  101628:	89 04 24             	mov    %eax,(%esp)
  10162b:	e8 f1 fc ff ff       	call   101321 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101633:	89 04 24             	mov    %eax,(%esp)
  101636:	e8 dd f7 ff ff       	call   100e18 <__intr_restore>
}
  10163b:	c9                   	leave  
  10163c:	c3                   	ret    

0010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164a:	e8 9f f7 ff ff       	call   100dee <__intr_save>
  10164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101652:	e8 ab fd ff ff       	call   101402 <serial_intr>
        kbd_intr();
  101657:	e8 4c ff ff ff       	call   1015a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165c:	8b 15 a0 b0 11 00    	mov    0x11b0a0,%edx
  101662:	a1 a4 b0 11 00       	mov    0x11b0a4,%eax
  101667:	39 c2                	cmp    %eax,%edx
  101669:	74 31                	je     10169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166b:	a1 a0 b0 11 00       	mov    0x11b0a0,%eax
  101670:	8d 50 01             	lea    0x1(%eax),%edx
  101673:	89 15 a0 b0 11 00    	mov    %edx,0x11b0a0
  101679:	0f b6 80 a0 ae 11 00 	movzbl 0x11aea0(%eax),%eax
  101680:	0f b6 c0             	movzbl %al,%eax
  101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101686:	a1 a0 b0 11 00       	mov    0x11b0a0,%eax
  10168b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101690:	75 0a                	jne    10169c <cons_getc+0x5f>
                cons.rpos = 0;
  101692:	c7 05 a0 b0 11 00 00 	movl   $0x0,0x11b0a0
  101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169f:	89 04 24             	mov    %eax,(%esp)
  1016a2:	e8 71 f7 ff ff       	call   100e18 <__intr_restore>
    return c;
  1016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016af:	fb                   	sti    
    sti();
}
  1016b0:	5d                   	pop    %ebp
  1016b1:	c3                   	ret    

001016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b5:	fa                   	cli    
    cli();
}
  1016b6:	5d                   	pop    %ebp
  1016b7:	c3                   	ret    

001016b8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b8:	55                   	push   %ebp
  1016b9:	89 e5                	mov    %esp,%ebp
  1016bb:	83 ec 14             	sub    $0x14,%esp
  1016be:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c9:	66 a3 70 a5 11 00    	mov    %ax,0x11a570
    if (did_init) {
  1016cf:	a1 ac b0 11 00       	mov    0x11b0ac,%eax
  1016d4:	85 c0                	test   %eax,%eax
  1016d6:	74 36                	je     10170e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016dc:	0f b6 c0             	movzbl %al,%eax
  1016df:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e5:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ec:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f5:	66 c1 e8 08          	shr    $0x8,%ax
  1016f9:	0f b6 c0             	movzbl %al,%eax
  1016fc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101702:	88 45 f9             	mov    %al,-0x7(%ebp)
  101705:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101709:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
    }
}
  10170e:	c9                   	leave  
  10170f:	c3                   	ret    

00101710 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101716:	8b 45 08             	mov    0x8(%ebp),%eax
  101719:	ba 01 00 00 00       	mov    $0x1,%edx
  10171e:	89 c1                	mov    %eax,%ecx
  101720:	d3 e2                	shl    %cl,%edx
  101722:	89 d0                	mov    %edx,%eax
  101724:	f7 d0                	not    %eax
  101726:	89 c2                	mov    %eax,%edx
  101728:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  10172f:	21 d0                	and    %edx,%eax
  101731:	0f b7 c0             	movzwl %ax,%eax
  101734:	89 04 24             	mov    %eax,(%esp)
  101737:	e8 7c ff ff ff       	call   1016b8 <pic_setmask>
}
  10173c:	c9                   	leave  
  10173d:	c3                   	ret    

0010173e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173e:	55                   	push   %ebp
  10173f:	89 e5                	mov    %esp,%ebp
  101741:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101744:	c7 05 ac b0 11 00 01 	movl   $0x1,0x11b0ac
  10174b:	00 00 00 
  10174e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101754:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101767:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10176b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177a:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101782:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178d:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101791:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101795:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a0:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b3:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
  1017c0:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c6:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017ca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ce:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
  1017d3:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d9:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017dd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e5:	ee                   	out    %al,(%dx)
  1017e6:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ec:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
  1017f9:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017ff:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101803:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101807:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10180b:	ee                   	out    %al,(%dx)
  10180c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101812:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101816:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181e:	ee                   	out    %al,(%dx)
  10181f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101825:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101829:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101831:	ee                   	out    %al,(%dx)
  101832:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101838:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101840:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101844:	ee                   	out    %al,(%dx)
  101845:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10184b:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101857:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101858:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  10185f:	66 83 f8 ff          	cmp    $0xffff,%ax
  101863:	74 12                	je     101877 <pic_init+0x139>
        pic_setmask(irq_mask);
  101865:	0f b7 05 70 a5 11 00 	movzwl 0x11a570,%eax
  10186c:	0f b7 c0             	movzwl %ax,%eax
  10186f:	89 04 24             	mov    %eax,(%esp)
  101872:	e8 41 fe ff ff       	call   1016b8 <pic_setmask>
    }
}
  101877:	c9                   	leave  
  101878:	c3                   	ret    

00101879 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101879:	55                   	push   %ebp
  10187a:	89 e5                	mov    %esp,%ebp
  10187c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101886:	00 
  101887:	c7 04 24 a0 76 10 00 	movl   $0x1076a0,(%esp)
  10188e:	e8 b0 ea ff ff       	call   100343 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101893:	c9                   	leave  
  101894:	c3                   	ret    

00101895 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101895:	55                   	push   %ebp
  101896:	89 e5                	mov    %esp,%ebp
  101898:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    // sel means segment selector rather than GDT index
    for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++) {
  10189b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a2:	e9 c3 00 00 00       	jmp    10196a <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018aa:	8b 04 85 00 a6 11 00 	mov    0x11a600(,%eax,4),%eax
  1018b1:	89 c2                	mov    %eax,%edx
  1018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b6:	66 89 14 c5 c0 b0 11 	mov    %dx,0x11b0c0(,%eax,8)
  1018bd:	00 
  1018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c1:	66 c7 04 c5 c2 b0 11 	movw   $0x8,0x11b0c2(,%eax,8)
  1018c8:	00 08 00 
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	0f b6 14 c5 c4 b0 11 	movzbl 0x11b0c4(,%eax,8),%edx
  1018d5:	00 
  1018d6:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d9:	88 14 c5 c4 b0 11 00 	mov    %dl,0x11b0c4(,%eax,8)
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	0f b6 14 c5 c4 b0 11 	movzbl 0x11b0c4(,%eax,8),%edx
  1018ea:	00 
  1018eb:	83 e2 1f             	and    $0x1f,%edx
  1018ee:	88 14 c5 c4 b0 11 00 	mov    %dl,0x11b0c4(,%eax,8)
  1018f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f8:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  1018ff:	00 
  101900:	83 e2 f0             	and    $0xfffffff0,%edx
  101903:	83 ca 0e             	or     $0xe,%edx
  101906:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  101917:	00 
  101918:	83 e2 ef             	and    $0xffffffef,%edx
  10191b:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101925:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  10192c:	00 
  10192d:	83 e2 9f             	and    $0xffffff9f,%edx
  101930:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193a:	0f b6 14 c5 c5 b0 11 	movzbl 0x11b0c5(,%eax,8),%edx
  101941:	00 
  101942:	83 ca 80             	or     $0xffffff80,%edx
  101945:	88 14 c5 c5 b0 11 00 	mov    %dl,0x11b0c5(,%eax,8)
  10194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194f:	8b 04 85 00 a6 11 00 	mov    0x11a600(,%eax,4),%eax
  101956:	c1 e8 10             	shr    $0x10,%eax
  101959:	89 c2                	mov    %eax,%edx
  10195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195e:	66 89 14 c5 c6 b0 11 	mov    %dx,0x11b0c6(,%eax,8)
  101965:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    // sel means segment selector rather than GDT index
    for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++) {
  101966:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196d:	3d ff 00 00 00       	cmp    $0xff,%eax
  101972:	0f 86 2f ff ff ff    	jbe    1018a7 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    // for T_SWITCH_TOU and T_SWITCH_TOK
    // T_SWITCH_TOU is already set from above
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101978:	a1 e4 a7 11 00       	mov    0x11a7e4,%eax
  10197d:	66 a3 88 b4 11 00    	mov    %ax,0x11b488
  101983:	66 c7 05 8a b4 11 00 	movw   $0x8,0x11b48a
  10198a:	08 00 
  10198c:	0f b6 05 8c b4 11 00 	movzbl 0x11b48c,%eax
  101993:	83 e0 e0             	and    $0xffffffe0,%eax
  101996:	a2 8c b4 11 00       	mov    %al,0x11b48c
  10199b:	0f b6 05 8c b4 11 00 	movzbl 0x11b48c,%eax
  1019a2:	83 e0 1f             	and    $0x1f,%eax
  1019a5:	a2 8c b4 11 00       	mov    %al,0x11b48c
  1019aa:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019b1:	83 e0 f0             	and    $0xfffffff0,%eax
  1019b4:	83 c8 0e             	or     $0xe,%eax
  1019b7:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019bc:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019c3:	83 e0 ef             	and    $0xffffffef,%eax
  1019c6:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019cb:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019d2:	83 c8 60             	or     $0x60,%eax
  1019d5:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019da:	0f b6 05 8d b4 11 00 	movzbl 0x11b48d,%eax
  1019e1:	83 c8 80             	or     $0xffffff80,%eax
  1019e4:	a2 8d b4 11 00       	mov    %al,0x11b48d
  1019e9:	a1 e4 a7 11 00       	mov    0x11a7e4,%eax
  1019ee:	c1 e8 10             	shr    $0x10,%eax
  1019f1:	66 a3 8e b4 11 00    	mov    %ax,0x11b48e
  1019f7:	c7 45 f8 80 a5 11 00 	movl   $0x11a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a01:	0f 01 18             	lidtl  (%eax)
    
    lidt(&idt_pd);
}
  101a04:	c9                   	leave  
  101a05:	c3                   	ret    

00101a06 <trapname>:

static const char *
trapname(int trapno) {
  101a06:	55                   	push   %ebp
  101a07:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	83 f8 13             	cmp    $0x13,%eax
  101a0f:	77 0c                	ja     101a1d <trapname+0x17>
        return excnames[trapno];
  101a11:	8b 45 08             	mov    0x8(%ebp),%eax
  101a14:	8b 04 85 00 7a 10 00 	mov    0x107a00(,%eax,4),%eax
  101a1b:	eb 18                	jmp    101a35 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a1d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a21:	7e 0d                	jle    101a30 <trapname+0x2a>
  101a23:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a27:	7f 07                	jg     101a30 <trapname+0x2a>
        return "Hardware Interrupt";
  101a29:	b8 aa 76 10 00       	mov    $0x1076aa,%eax
  101a2e:	eb 05                	jmp    101a35 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a30:	b8 bd 76 10 00       	mov    $0x1076bd,%eax
}
  101a35:	5d                   	pop    %ebp
  101a36:	c3                   	ret    

00101a37 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a37:	55                   	push   %ebp
  101a38:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a41:	66 83 f8 08          	cmp    $0x8,%ax
  101a45:	0f 94 c0             	sete   %al
  101a48:	0f b6 c0             	movzbl %al,%eax
}
  101a4b:	5d                   	pop    %ebp
  101a4c:	c3                   	ret    

00101a4d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a4d:	55                   	push   %ebp
  101a4e:	89 e5                	mov    %esp,%ebp
  101a50:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a53:	8b 45 08             	mov    0x8(%ebp),%eax
  101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5a:	c7 04 24 fe 76 10 00 	movl   $0x1076fe,(%esp)
  101a61:	e8 dd e8 ff ff       	call   100343 <cprintf>
    print_regs(&tf->tf_regs);
  101a66:	8b 45 08             	mov    0x8(%ebp),%eax
  101a69:	89 04 24             	mov    %eax,(%esp)
  101a6c:	e8 a1 01 00 00       	call   101c12 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a71:	8b 45 08             	mov    0x8(%ebp),%eax
  101a74:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a78:	0f b7 c0             	movzwl %ax,%eax
  101a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7f:	c7 04 24 0f 77 10 00 	movl   $0x10770f,(%esp)
  101a86:	e8 b8 e8 ff ff       	call   100343 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a92:	0f b7 c0             	movzwl %ax,%eax
  101a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a99:	c7 04 24 22 77 10 00 	movl   $0x107722,(%esp)
  101aa0:	e8 9e e8 ff ff       	call   100343 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aac:	0f b7 c0             	movzwl %ax,%eax
  101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab3:	c7 04 24 35 77 10 00 	movl   $0x107735,(%esp)
  101aba:	e8 84 e8 ff ff       	call   100343 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101abf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac2:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac6:	0f b7 c0             	movzwl %ax,%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 48 77 10 00 	movl   $0x107748,(%esp)
  101ad4:	e8 6a e8 ff ff       	call   100343 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	8b 40 30             	mov    0x30(%eax),%eax
  101adf:	89 04 24             	mov    %eax,(%esp)
  101ae2:	e8 1f ff ff ff       	call   101a06 <trapname>
  101ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  101aea:	8b 52 30             	mov    0x30(%edx),%edx
  101aed:	89 44 24 08          	mov    %eax,0x8(%esp)
  101af1:	89 54 24 04          	mov    %edx,0x4(%esp)
  101af5:	c7 04 24 5b 77 10 00 	movl   $0x10775b,(%esp)
  101afc:	e8 42 e8 ff ff       	call   100343 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b01:	8b 45 08             	mov    0x8(%ebp),%eax
  101b04:	8b 40 34             	mov    0x34(%eax),%eax
  101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0b:	c7 04 24 6d 77 10 00 	movl   $0x10776d,(%esp)
  101b12:	e8 2c e8 ff ff       	call   100343 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b17:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1a:	8b 40 38             	mov    0x38(%eax),%eax
  101b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b21:	c7 04 24 7c 77 10 00 	movl   $0x10777c,(%esp)
  101b28:	e8 16 e8 ff ff       	call   100343 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b34:	0f b7 c0             	movzwl %ax,%eax
  101b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3b:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  101b42:	e8 fc e7 ff ff       	call   100343 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	8b 40 40             	mov    0x40(%eax),%eax
  101b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b51:	c7 04 24 9e 77 10 00 	movl   $0x10779e,(%esp)
  101b58:	e8 e6 e7 ff ff       	call   100343 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b64:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b6b:	eb 3e                	jmp    101bab <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b70:	8b 50 40             	mov    0x40(%eax),%edx
  101b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b76:	21 d0                	and    %edx,%eax
  101b78:	85 c0                	test   %eax,%eax
  101b7a:	74 28                	je     101ba4 <print_trapframe+0x157>
  101b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b7f:	8b 04 85 a0 a5 11 00 	mov    0x11a5a0(,%eax,4),%eax
  101b86:	85 c0                	test   %eax,%eax
  101b88:	74 1a                	je     101ba4 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8d:	8b 04 85 a0 a5 11 00 	mov    0x11a5a0(,%eax,4),%eax
  101b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b98:	c7 04 24 ad 77 10 00 	movl   $0x1077ad,(%esp)
  101b9f:	e8 9f e7 ff ff       	call   100343 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ba8:	d1 65 f0             	shll   -0x10(%ebp)
  101bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bae:	83 f8 17             	cmp    $0x17,%eax
  101bb1:	76 ba                	jbe    101b6d <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	8b 40 40             	mov    0x40(%eax),%eax
  101bb9:	25 00 30 00 00       	and    $0x3000,%eax
  101bbe:	c1 e8 0c             	shr    $0xc,%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 b1 77 10 00 	movl   $0x1077b1,(%esp)
  101bcc:	e8 72 e7 ff ff       	call   100343 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	89 04 24             	mov    %eax,(%esp)
  101bd7:	e8 5b fe ff ff       	call   101a37 <trap_in_kernel>
  101bdc:	85 c0                	test   %eax,%eax
  101bde:	75 30                	jne    101c10 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be0:	8b 45 08             	mov    0x8(%ebp),%eax
  101be3:	8b 40 44             	mov    0x44(%eax),%eax
  101be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bea:	c7 04 24 ba 77 10 00 	movl   $0x1077ba,(%esp)
  101bf1:	e8 4d e7 ff ff       	call   100343 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf9:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bfd:	0f b7 c0             	movzwl %ax,%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 c9 77 10 00 	movl   $0x1077c9,(%esp)
  101c0b:	e8 33 e7 ff ff       	call   100343 <cprintf>
    }
}
  101c10:	c9                   	leave  
  101c11:	c3                   	ret    

00101c12 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c12:	55                   	push   %ebp
  101c13:	89 e5                	mov    %esp,%ebp
  101c15:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c18:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1b:	8b 00                	mov    (%eax),%eax
  101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c21:	c7 04 24 dc 77 10 00 	movl   $0x1077dc,(%esp)
  101c28:	e8 16 e7 ff ff       	call   100343 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	8b 40 04             	mov    0x4(%eax),%eax
  101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c37:	c7 04 24 eb 77 10 00 	movl   $0x1077eb,(%esp)
  101c3e:	e8 00 e7 ff ff       	call   100343 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c43:	8b 45 08             	mov    0x8(%ebp),%eax
  101c46:	8b 40 08             	mov    0x8(%eax),%eax
  101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4d:	c7 04 24 fa 77 10 00 	movl   $0x1077fa,(%esp)
  101c54:	e8 ea e6 ff ff       	call   100343 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c59:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c63:	c7 04 24 09 78 10 00 	movl   $0x107809,(%esp)
  101c6a:	e8 d4 e6 ff ff       	call   100343 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	8b 40 10             	mov    0x10(%eax),%eax
  101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c79:	c7 04 24 18 78 10 00 	movl   $0x107818,(%esp)
  101c80:	e8 be e6 ff ff       	call   100343 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	8b 40 14             	mov    0x14(%eax),%eax
  101c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8f:	c7 04 24 27 78 10 00 	movl   $0x107827,(%esp)
  101c96:	e8 a8 e6 ff ff       	call   100343 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9e:	8b 40 18             	mov    0x18(%eax),%eax
  101ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca5:	c7 04 24 36 78 10 00 	movl   $0x107836,(%esp)
  101cac:	e8 92 e6 ff ff       	call   100343 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb4:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbb:	c7 04 24 45 78 10 00 	movl   $0x107845,(%esp)
  101cc2:	e8 7c e6 ff ff       	call   100343 <cprintf>
}
  101cc7:	c9                   	leave  
  101cc8:	c3                   	ret    

00101cc9 <trap_dispatch>:

struct trapframe k2u;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc9:	55                   	push   %ebp
  101cca:	89 e5                	mov    %esp,%ebp
  101ccc:	57                   	push   %edi
  101ccd:	56                   	push   %esi
  101cce:	53                   	push   %ebx
  101ccf:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd5:	8b 40 30             	mov    0x30(%eax),%eax
  101cd8:	83 f8 2f             	cmp    $0x2f,%eax
  101cdb:	77 1d                	ja     101cfa <trap_dispatch+0x31>
  101cdd:	83 f8 2e             	cmp    $0x2e,%eax
  101ce0:	0f 83 c7 01 00 00    	jae    101ead <trap_dispatch+0x1e4>
  101ce6:	83 f8 21             	cmp    $0x21,%eax
  101ce9:	74 7f                	je     101d6a <trap_dispatch+0xa1>
  101ceb:	83 f8 24             	cmp    $0x24,%eax
  101cee:	74 51                	je     101d41 <trap_dispatch+0x78>
  101cf0:	83 f8 20             	cmp    $0x20,%eax
  101cf3:	74 1c                	je     101d11 <trap_dispatch+0x48>
  101cf5:	e9 7b 01 00 00       	jmp    101e75 <trap_dispatch+0x1ac>
  101cfa:	83 f8 78             	cmp    $0x78,%eax
  101cfd:	0f 84 a3 00 00 00    	je     101da6 <trap_dispatch+0xdd>
  101d03:	83 f8 79             	cmp    $0x79,%eax
  101d06:	0f 84 19 01 00 00    	je     101e25 <trap_dispatch+0x15c>
  101d0c:	e9 64 01 00 00       	jmp    101e75 <trap_dispatch+0x1ac>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if (ticks == TICK_NUM) {
  101d11:	a1 4c b9 11 00       	mov    0x11b94c,%eax
  101d16:	83 f8 64             	cmp    $0x64,%eax
  101d19:	75 14                	jne    101d2f <trap_dispatch+0x66>
            print_ticks();
  101d1b:	e8 59 fb ff ff       	call   101879 <print_ticks>
            ticks = 0;
  101d20:	c7 05 4c b9 11 00 00 	movl   $0x0,0x11b94c
  101d27:	00 00 00 
        } else {
            ticks++;
        }
        break;
  101d2a:	e9 7f 01 00 00       	jmp    101eae <trap_dispatch+0x1e5>
         */
        if (ticks == TICK_NUM) {
            print_ticks();
            ticks = 0;
        } else {
            ticks++;
  101d2f:	a1 4c b9 11 00       	mov    0x11b94c,%eax
  101d34:	83 c0 01             	add    $0x1,%eax
  101d37:	a3 4c b9 11 00       	mov    %eax,0x11b94c
        }
        break;
  101d3c:	e9 6d 01 00 00       	jmp    101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d41:	e8 f7 f8 ff ff       	call   10163d <cons_getc>
  101d46:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d49:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d4d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d51:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d59:	c7 04 24 54 78 10 00 	movl   $0x107854,(%esp)
  101d60:	e8 de e5 ff ff       	call   100343 <cprintf>
        break;
  101d65:	e9 44 01 00 00       	jmp    101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d6a:	e8 ce f8 ff ff       	call   10163d <cons_getc>
  101d6f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d72:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d76:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 66 78 10 00 	movl   $0x107866,(%esp)
  101d89:	e8 b5 e5 ff ff       	call   100343 <cprintf>
        if (c == '0') {
  101d8e:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101d92:	75 05                	jne    101d99 <trap_dispatch+0xd0>
            goto u2k_loc;
  101d94:	e9 8c 00 00 00       	jmp    101e25 <trap_dispatch+0x15c>
        } else if (c == '3') {
  101d99:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101d9d:	75 02                	jne    101da1 <trap_dispatch+0xd8>
            goto k2u_loc;
  101d9f:	eb 05                	jmp    101da6 <trap_dispatch+0xdd>
        }
        break;
  101da1:	e9 08 01 00 00       	jmp    101eae <trap_dispatch+0x1e5>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
k2u_loc:
        if (tf->tf_cs != USER_CS) {
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dad:	66 83 f8 1b          	cmp    $0x1b,%ax
  101db1:	74 6d                	je     101e20 <trap_dispatch+0x157>
            k2u = *tf;
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	ba 60 b9 11 00       	mov    $0x11b960,%edx
  101dbb:	89 c3                	mov    %eax,%ebx
  101dbd:	b8 13 00 00 00       	mov    $0x13,%eax
  101dc2:	89 d7                	mov    %edx,%edi
  101dc4:	89 de                	mov    %ebx,%esi
  101dc6:	89 c1                	mov    %eax,%ecx
  101dc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            k2u.tf_cs = USER_CS;
  101dca:	66 c7 05 9c b9 11 00 	movw   $0x1b,0x11b99c
  101dd1:	1b 00 
            k2u.tf_ds = k2u.tf_es = k2u.tf_ss = USER_DS;
  101dd3:	66 c7 05 a8 b9 11 00 	movw   $0x23,0x11b9a8
  101dda:	23 00 
  101ddc:	0f b7 05 a8 b9 11 00 	movzwl 0x11b9a8,%eax
  101de3:	66 a3 88 b9 11 00    	mov    %ax,0x11b988
  101de9:	0f b7 05 88 b9 11 00 	movzwl 0x11b988,%eax
  101df0:	66 a3 8c b9 11 00    	mov    %ax,0x11b98c
            k2u.tf_esp = (uint32_t) tf + (sizeof(struct trapframe) - 8);
  101df6:	8b 45 08             	mov    0x8(%ebp),%eax
  101df9:	83 c0 44             	add    $0x44,%eax
  101dfc:	a3 a4 b9 11 00       	mov    %eax,0x11b9a4
            k2u.tf_eflags |= FL_IOPL_3;
  101e01:	a1 a0 b9 11 00       	mov    0x11b9a0,%eax
  101e06:	80 cc 30             	or     $0x30,%ah
  101e09:	a3 a0 b9 11 00       	mov    %eax,0x11b9a0

            *((uint32_t *)tf - 1) = (uint32_t)&k2u;
  101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e11:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e14:	b8 60 b9 11 00       	mov    $0x11b960,%eax
  101e19:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e1b:	e9 8e 00 00 00       	jmp    101eae <trap_dispatch+0x1e5>
  101e20:	e9 89 00 00 00       	jmp    101eae <trap_dispatch+0x1e5>
    case T_SWITCH_TOK:
u2k_loc:
        if (tf->tf_cs != KERNEL_CS) {
  101e25:	8b 45 08             	mov    0x8(%ebp),%eax
  101e28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e2c:	66 83 f8 08          	cmp    $0x8,%ax
  101e30:	74 41                	je     101e73 <trap_dispatch+0x1aa>
            tf->tf_cs = KERNEL_CS;
  101e32:	8b 45 08             	mov    0x8(%ebp),%eax
  101e35:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3e:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101e44:	8b 45 08             	mov    0x8(%ebp),%eax
  101e47:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e52:	8b 45 08             	mov    0x8(%ebp),%eax
  101e55:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e59:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_3;
  101e60:	8b 45 08             	mov    0x8(%ebp),%eax
  101e63:	8b 40 40             	mov    0x40(%eax),%eax
  101e66:	80 e4 cf             	and    $0xcf,%ah
  101e69:	89 c2                	mov    %eax,%edx
  101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6e:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101e71:	eb 3b                	jmp    101eae <trap_dispatch+0x1e5>
  101e73:	eb 39                	jmp    101eae <trap_dispatch+0x1e5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e75:	8b 45 08             	mov    0x8(%ebp),%eax
  101e78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e7c:	0f b7 c0             	movzwl %ax,%eax
  101e7f:	83 e0 03             	and    $0x3,%eax
  101e82:	85 c0                	test   %eax,%eax
  101e84:	75 28                	jne    101eae <trap_dispatch+0x1e5>
            print_trapframe(tf);
  101e86:	8b 45 08             	mov    0x8(%ebp),%eax
  101e89:	89 04 24             	mov    %eax,(%esp)
  101e8c:	e8 bc fb ff ff       	call   101a4d <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e91:	c7 44 24 08 75 78 10 	movl   $0x107875,0x8(%esp)
  101e98:	00 
  101e99:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  101ea0:	00 
  101ea1:	c7 04 24 91 78 10 00 	movl   $0x107891,(%esp)
  101ea8:	e8 22 ee ff ff       	call   100ccf <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ead:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101eae:	83 c4 2c             	add    $0x2c,%esp
  101eb1:	5b                   	pop    %ebx
  101eb2:	5e                   	pop    %esi
  101eb3:	5f                   	pop    %edi
  101eb4:	5d                   	pop    %ebp
  101eb5:	c3                   	ret    

00101eb6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101eb6:	55                   	push   %ebp
  101eb7:	89 e5                	mov    %esp,%ebp
  101eb9:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebf:	89 04 24             	mov    %eax,(%esp)
  101ec2:	e8 02 fe ff ff       	call   101cc9 <trap_dispatch>
}
  101ec7:	c9                   	leave  
  101ec8:	c3                   	ret    

00101ec9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ec9:	1e                   	push   %ds
    pushl %es
  101eca:	06                   	push   %es
    pushl %fs
  101ecb:	0f a0                	push   %fs
    pushl %gs
  101ecd:	0f a8                	push   %gs
    pushal
  101ecf:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ed0:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ed5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ed7:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ed9:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101eda:	e8 d7 ff ff ff       	call   101eb6 <trap>

    # pop the pushed stack pointer
    popl %esp
  101edf:	5c                   	pop    %esp

00101ee0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ee0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ee1:	0f a9                	pop    %gs
    popl %fs
  101ee3:	0f a1                	pop    %fs
    popl %es
  101ee5:	07                   	pop    %es
    popl %ds
  101ee6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101ee7:	83 c4 08             	add    $0x8,%esp
    iret
  101eea:	cf                   	iret   

00101eeb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $0
  101eed:	6a 00                	push   $0x0
  jmp __alltraps
  101eef:	e9 d5 ff ff ff       	jmp    101ec9 <__alltraps>

00101ef4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $1
  101ef6:	6a 01                	push   $0x1
  jmp __alltraps
  101ef8:	e9 cc ff ff ff       	jmp    101ec9 <__alltraps>

00101efd <vector2>:
.globl vector2
vector2:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $2
  101eff:	6a 02                	push   $0x2
  jmp __alltraps
  101f01:	e9 c3 ff ff ff       	jmp    101ec9 <__alltraps>

00101f06 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $3
  101f08:	6a 03                	push   $0x3
  jmp __alltraps
  101f0a:	e9 ba ff ff ff       	jmp    101ec9 <__alltraps>

00101f0f <vector4>:
.globl vector4
vector4:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $4
  101f11:	6a 04                	push   $0x4
  jmp __alltraps
  101f13:	e9 b1 ff ff ff       	jmp    101ec9 <__alltraps>

00101f18 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $5
  101f1a:	6a 05                	push   $0x5
  jmp __alltraps
  101f1c:	e9 a8 ff ff ff       	jmp    101ec9 <__alltraps>

00101f21 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $6
  101f23:	6a 06                	push   $0x6
  jmp __alltraps
  101f25:	e9 9f ff ff ff       	jmp    101ec9 <__alltraps>

00101f2a <vector7>:
.globl vector7
vector7:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $7
  101f2c:	6a 07                	push   $0x7
  jmp __alltraps
  101f2e:	e9 96 ff ff ff       	jmp    101ec9 <__alltraps>

00101f33 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f33:	6a 08                	push   $0x8
  jmp __alltraps
  101f35:	e9 8f ff ff ff       	jmp    101ec9 <__alltraps>

00101f3a <vector9>:
.globl vector9
vector9:
  pushl $9
  101f3a:	6a 09                	push   $0x9
  jmp __alltraps
  101f3c:	e9 88 ff ff ff       	jmp    101ec9 <__alltraps>

00101f41 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f41:	6a 0a                	push   $0xa
  jmp __alltraps
  101f43:	e9 81 ff ff ff       	jmp    101ec9 <__alltraps>

00101f48 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f48:	6a 0b                	push   $0xb
  jmp __alltraps
  101f4a:	e9 7a ff ff ff       	jmp    101ec9 <__alltraps>

00101f4f <vector12>:
.globl vector12
vector12:
  pushl $12
  101f4f:	6a 0c                	push   $0xc
  jmp __alltraps
  101f51:	e9 73 ff ff ff       	jmp    101ec9 <__alltraps>

00101f56 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f56:	6a 0d                	push   $0xd
  jmp __alltraps
  101f58:	e9 6c ff ff ff       	jmp    101ec9 <__alltraps>

00101f5d <vector14>:
.globl vector14
vector14:
  pushl $14
  101f5d:	6a 0e                	push   $0xe
  jmp __alltraps
  101f5f:	e9 65 ff ff ff       	jmp    101ec9 <__alltraps>

00101f64 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $15
  101f66:	6a 0f                	push   $0xf
  jmp __alltraps
  101f68:	e9 5c ff ff ff       	jmp    101ec9 <__alltraps>

00101f6d <vector16>:
.globl vector16
vector16:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $16
  101f6f:	6a 10                	push   $0x10
  jmp __alltraps
  101f71:	e9 53 ff ff ff       	jmp    101ec9 <__alltraps>

00101f76 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f76:	6a 11                	push   $0x11
  jmp __alltraps
  101f78:	e9 4c ff ff ff       	jmp    101ec9 <__alltraps>

00101f7d <vector18>:
.globl vector18
vector18:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $18
  101f7f:	6a 12                	push   $0x12
  jmp __alltraps
  101f81:	e9 43 ff ff ff       	jmp    101ec9 <__alltraps>

00101f86 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $19
  101f88:	6a 13                	push   $0x13
  jmp __alltraps
  101f8a:	e9 3a ff ff ff       	jmp    101ec9 <__alltraps>

00101f8f <vector20>:
.globl vector20
vector20:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $20
  101f91:	6a 14                	push   $0x14
  jmp __alltraps
  101f93:	e9 31 ff ff ff       	jmp    101ec9 <__alltraps>

00101f98 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $21
  101f9a:	6a 15                	push   $0x15
  jmp __alltraps
  101f9c:	e9 28 ff ff ff       	jmp    101ec9 <__alltraps>

00101fa1 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $22
  101fa3:	6a 16                	push   $0x16
  jmp __alltraps
  101fa5:	e9 1f ff ff ff       	jmp    101ec9 <__alltraps>

00101faa <vector23>:
.globl vector23
vector23:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $23
  101fac:	6a 17                	push   $0x17
  jmp __alltraps
  101fae:	e9 16 ff ff ff       	jmp    101ec9 <__alltraps>

00101fb3 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $24
  101fb5:	6a 18                	push   $0x18
  jmp __alltraps
  101fb7:	e9 0d ff ff ff       	jmp    101ec9 <__alltraps>

00101fbc <vector25>:
.globl vector25
vector25:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $25
  101fbe:	6a 19                	push   $0x19
  jmp __alltraps
  101fc0:	e9 04 ff ff ff       	jmp    101ec9 <__alltraps>

00101fc5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $26
  101fc7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fc9:	e9 fb fe ff ff       	jmp    101ec9 <__alltraps>

00101fce <vector27>:
.globl vector27
vector27:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $27
  101fd0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fd2:	e9 f2 fe ff ff       	jmp    101ec9 <__alltraps>

00101fd7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $28
  101fd9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fdb:	e9 e9 fe ff ff       	jmp    101ec9 <__alltraps>

00101fe0 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $29
  101fe2:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fe4:	e9 e0 fe ff ff       	jmp    101ec9 <__alltraps>

00101fe9 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $30
  101feb:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fed:	e9 d7 fe ff ff       	jmp    101ec9 <__alltraps>

00101ff2 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $31
  101ff4:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ff6:	e9 ce fe ff ff       	jmp    101ec9 <__alltraps>

00101ffb <vector32>:
.globl vector32
vector32:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $32
  101ffd:	6a 20                	push   $0x20
  jmp __alltraps
  101fff:	e9 c5 fe ff ff       	jmp    101ec9 <__alltraps>

00102004 <vector33>:
.globl vector33
vector33:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $33
  102006:	6a 21                	push   $0x21
  jmp __alltraps
  102008:	e9 bc fe ff ff       	jmp    101ec9 <__alltraps>

0010200d <vector34>:
.globl vector34
vector34:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $34
  10200f:	6a 22                	push   $0x22
  jmp __alltraps
  102011:	e9 b3 fe ff ff       	jmp    101ec9 <__alltraps>

00102016 <vector35>:
.globl vector35
vector35:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $35
  102018:	6a 23                	push   $0x23
  jmp __alltraps
  10201a:	e9 aa fe ff ff       	jmp    101ec9 <__alltraps>

0010201f <vector36>:
.globl vector36
vector36:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $36
  102021:	6a 24                	push   $0x24
  jmp __alltraps
  102023:	e9 a1 fe ff ff       	jmp    101ec9 <__alltraps>

00102028 <vector37>:
.globl vector37
vector37:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $37
  10202a:	6a 25                	push   $0x25
  jmp __alltraps
  10202c:	e9 98 fe ff ff       	jmp    101ec9 <__alltraps>

00102031 <vector38>:
.globl vector38
vector38:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $38
  102033:	6a 26                	push   $0x26
  jmp __alltraps
  102035:	e9 8f fe ff ff       	jmp    101ec9 <__alltraps>

0010203a <vector39>:
.globl vector39
vector39:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $39
  10203c:	6a 27                	push   $0x27
  jmp __alltraps
  10203e:	e9 86 fe ff ff       	jmp    101ec9 <__alltraps>

00102043 <vector40>:
.globl vector40
vector40:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $40
  102045:	6a 28                	push   $0x28
  jmp __alltraps
  102047:	e9 7d fe ff ff       	jmp    101ec9 <__alltraps>

0010204c <vector41>:
.globl vector41
vector41:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $41
  10204e:	6a 29                	push   $0x29
  jmp __alltraps
  102050:	e9 74 fe ff ff       	jmp    101ec9 <__alltraps>

00102055 <vector42>:
.globl vector42
vector42:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $42
  102057:	6a 2a                	push   $0x2a
  jmp __alltraps
  102059:	e9 6b fe ff ff       	jmp    101ec9 <__alltraps>

0010205e <vector43>:
.globl vector43
vector43:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $43
  102060:	6a 2b                	push   $0x2b
  jmp __alltraps
  102062:	e9 62 fe ff ff       	jmp    101ec9 <__alltraps>

00102067 <vector44>:
.globl vector44
vector44:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $44
  102069:	6a 2c                	push   $0x2c
  jmp __alltraps
  10206b:	e9 59 fe ff ff       	jmp    101ec9 <__alltraps>

00102070 <vector45>:
.globl vector45
vector45:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $45
  102072:	6a 2d                	push   $0x2d
  jmp __alltraps
  102074:	e9 50 fe ff ff       	jmp    101ec9 <__alltraps>

00102079 <vector46>:
.globl vector46
vector46:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $46
  10207b:	6a 2e                	push   $0x2e
  jmp __alltraps
  10207d:	e9 47 fe ff ff       	jmp    101ec9 <__alltraps>

00102082 <vector47>:
.globl vector47
vector47:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $47
  102084:	6a 2f                	push   $0x2f
  jmp __alltraps
  102086:	e9 3e fe ff ff       	jmp    101ec9 <__alltraps>

0010208b <vector48>:
.globl vector48
vector48:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $48
  10208d:	6a 30                	push   $0x30
  jmp __alltraps
  10208f:	e9 35 fe ff ff       	jmp    101ec9 <__alltraps>

00102094 <vector49>:
.globl vector49
vector49:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $49
  102096:	6a 31                	push   $0x31
  jmp __alltraps
  102098:	e9 2c fe ff ff       	jmp    101ec9 <__alltraps>

0010209d <vector50>:
.globl vector50
vector50:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $50
  10209f:	6a 32                	push   $0x32
  jmp __alltraps
  1020a1:	e9 23 fe ff ff       	jmp    101ec9 <__alltraps>

001020a6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $51
  1020a8:	6a 33                	push   $0x33
  jmp __alltraps
  1020aa:	e9 1a fe ff ff       	jmp    101ec9 <__alltraps>

001020af <vector52>:
.globl vector52
vector52:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $52
  1020b1:	6a 34                	push   $0x34
  jmp __alltraps
  1020b3:	e9 11 fe ff ff       	jmp    101ec9 <__alltraps>

001020b8 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $53
  1020ba:	6a 35                	push   $0x35
  jmp __alltraps
  1020bc:	e9 08 fe ff ff       	jmp    101ec9 <__alltraps>

001020c1 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $54
  1020c3:	6a 36                	push   $0x36
  jmp __alltraps
  1020c5:	e9 ff fd ff ff       	jmp    101ec9 <__alltraps>

001020ca <vector55>:
.globl vector55
vector55:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $55
  1020cc:	6a 37                	push   $0x37
  jmp __alltraps
  1020ce:	e9 f6 fd ff ff       	jmp    101ec9 <__alltraps>

001020d3 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $56
  1020d5:	6a 38                	push   $0x38
  jmp __alltraps
  1020d7:	e9 ed fd ff ff       	jmp    101ec9 <__alltraps>

001020dc <vector57>:
.globl vector57
vector57:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $57
  1020de:	6a 39                	push   $0x39
  jmp __alltraps
  1020e0:	e9 e4 fd ff ff       	jmp    101ec9 <__alltraps>

001020e5 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $58
  1020e7:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020e9:	e9 db fd ff ff       	jmp    101ec9 <__alltraps>

001020ee <vector59>:
.globl vector59
vector59:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $59
  1020f0:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020f2:	e9 d2 fd ff ff       	jmp    101ec9 <__alltraps>

001020f7 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $60
  1020f9:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020fb:	e9 c9 fd ff ff       	jmp    101ec9 <__alltraps>

00102100 <vector61>:
.globl vector61
vector61:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $61
  102102:	6a 3d                	push   $0x3d
  jmp __alltraps
  102104:	e9 c0 fd ff ff       	jmp    101ec9 <__alltraps>

00102109 <vector62>:
.globl vector62
vector62:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $62
  10210b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10210d:	e9 b7 fd ff ff       	jmp    101ec9 <__alltraps>

00102112 <vector63>:
.globl vector63
vector63:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $63
  102114:	6a 3f                	push   $0x3f
  jmp __alltraps
  102116:	e9 ae fd ff ff       	jmp    101ec9 <__alltraps>

0010211b <vector64>:
.globl vector64
vector64:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $64
  10211d:	6a 40                	push   $0x40
  jmp __alltraps
  10211f:	e9 a5 fd ff ff       	jmp    101ec9 <__alltraps>

00102124 <vector65>:
.globl vector65
vector65:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $65
  102126:	6a 41                	push   $0x41
  jmp __alltraps
  102128:	e9 9c fd ff ff       	jmp    101ec9 <__alltraps>

0010212d <vector66>:
.globl vector66
vector66:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $66
  10212f:	6a 42                	push   $0x42
  jmp __alltraps
  102131:	e9 93 fd ff ff       	jmp    101ec9 <__alltraps>

00102136 <vector67>:
.globl vector67
vector67:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $67
  102138:	6a 43                	push   $0x43
  jmp __alltraps
  10213a:	e9 8a fd ff ff       	jmp    101ec9 <__alltraps>

0010213f <vector68>:
.globl vector68
vector68:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $68
  102141:	6a 44                	push   $0x44
  jmp __alltraps
  102143:	e9 81 fd ff ff       	jmp    101ec9 <__alltraps>

00102148 <vector69>:
.globl vector69
vector69:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $69
  10214a:	6a 45                	push   $0x45
  jmp __alltraps
  10214c:	e9 78 fd ff ff       	jmp    101ec9 <__alltraps>

00102151 <vector70>:
.globl vector70
vector70:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $70
  102153:	6a 46                	push   $0x46
  jmp __alltraps
  102155:	e9 6f fd ff ff       	jmp    101ec9 <__alltraps>

0010215a <vector71>:
.globl vector71
vector71:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $71
  10215c:	6a 47                	push   $0x47
  jmp __alltraps
  10215e:	e9 66 fd ff ff       	jmp    101ec9 <__alltraps>

00102163 <vector72>:
.globl vector72
vector72:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $72
  102165:	6a 48                	push   $0x48
  jmp __alltraps
  102167:	e9 5d fd ff ff       	jmp    101ec9 <__alltraps>

0010216c <vector73>:
.globl vector73
vector73:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $73
  10216e:	6a 49                	push   $0x49
  jmp __alltraps
  102170:	e9 54 fd ff ff       	jmp    101ec9 <__alltraps>

00102175 <vector74>:
.globl vector74
vector74:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $74
  102177:	6a 4a                	push   $0x4a
  jmp __alltraps
  102179:	e9 4b fd ff ff       	jmp    101ec9 <__alltraps>

0010217e <vector75>:
.globl vector75
vector75:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $75
  102180:	6a 4b                	push   $0x4b
  jmp __alltraps
  102182:	e9 42 fd ff ff       	jmp    101ec9 <__alltraps>

00102187 <vector76>:
.globl vector76
vector76:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $76
  102189:	6a 4c                	push   $0x4c
  jmp __alltraps
  10218b:	e9 39 fd ff ff       	jmp    101ec9 <__alltraps>

00102190 <vector77>:
.globl vector77
vector77:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $77
  102192:	6a 4d                	push   $0x4d
  jmp __alltraps
  102194:	e9 30 fd ff ff       	jmp    101ec9 <__alltraps>

00102199 <vector78>:
.globl vector78
vector78:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $78
  10219b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10219d:	e9 27 fd ff ff       	jmp    101ec9 <__alltraps>

001021a2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $79
  1021a4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021a6:	e9 1e fd ff ff       	jmp    101ec9 <__alltraps>

001021ab <vector80>:
.globl vector80
vector80:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $80
  1021ad:	6a 50                	push   $0x50
  jmp __alltraps
  1021af:	e9 15 fd ff ff       	jmp    101ec9 <__alltraps>

001021b4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $81
  1021b6:	6a 51                	push   $0x51
  jmp __alltraps
  1021b8:	e9 0c fd ff ff       	jmp    101ec9 <__alltraps>

001021bd <vector82>:
.globl vector82
vector82:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $82
  1021bf:	6a 52                	push   $0x52
  jmp __alltraps
  1021c1:	e9 03 fd ff ff       	jmp    101ec9 <__alltraps>

001021c6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $83
  1021c8:	6a 53                	push   $0x53
  jmp __alltraps
  1021ca:	e9 fa fc ff ff       	jmp    101ec9 <__alltraps>

001021cf <vector84>:
.globl vector84
vector84:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $84
  1021d1:	6a 54                	push   $0x54
  jmp __alltraps
  1021d3:	e9 f1 fc ff ff       	jmp    101ec9 <__alltraps>

001021d8 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $85
  1021da:	6a 55                	push   $0x55
  jmp __alltraps
  1021dc:	e9 e8 fc ff ff       	jmp    101ec9 <__alltraps>

001021e1 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $86
  1021e3:	6a 56                	push   $0x56
  jmp __alltraps
  1021e5:	e9 df fc ff ff       	jmp    101ec9 <__alltraps>

001021ea <vector87>:
.globl vector87
vector87:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $87
  1021ec:	6a 57                	push   $0x57
  jmp __alltraps
  1021ee:	e9 d6 fc ff ff       	jmp    101ec9 <__alltraps>

001021f3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $88
  1021f5:	6a 58                	push   $0x58
  jmp __alltraps
  1021f7:	e9 cd fc ff ff       	jmp    101ec9 <__alltraps>

001021fc <vector89>:
.globl vector89
vector89:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $89
  1021fe:	6a 59                	push   $0x59
  jmp __alltraps
  102200:	e9 c4 fc ff ff       	jmp    101ec9 <__alltraps>

00102205 <vector90>:
.globl vector90
vector90:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $90
  102207:	6a 5a                	push   $0x5a
  jmp __alltraps
  102209:	e9 bb fc ff ff       	jmp    101ec9 <__alltraps>

0010220e <vector91>:
.globl vector91
vector91:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $91
  102210:	6a 5b                	push   $0x5b
  jmp __alltraps
  102212:	e9 b2 fc ff ff       	jmp    101ec9 <__alltraps>

00102217 <vector92>:
.globl vector92
vector92:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $92
  102219:	6a 5c                	push   $0x5c
  jmp __alltraps
  10221b:	e9 a9 fc ff ff       	jmp    101ec9 <__alltraps>

00102220 <vector93>:
.globl vector93
vector93:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $93
  102222:	6a 5d                	push   $0x5d
  jmp __alltraps
  102224:	e9 a0 fc ff ff       	jmp    101ec9 <__alltraps>

00102229 <vector94>:
.globl vector94
vector94:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $94
  10222b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10222d:	e9 97 fc ff ff       	jmp    101ec9 <__alltraps>

00102232 <vector95>:
.globl vector95
vector95:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $95
  102234:	6a 5f                	push   $0x5f
  jmp __alltraps
  102236:	e9 8e fc ff ff       	jmp    101ec9 <__alltraps>

0010223b <vector96>:
.globl vector96
vector96:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $96
  10223d:	6a 60                	push   $0x60
  jmp __alltraps
  10223f:	e9 85 fc ff ff       	jmp    101ec9 <__alltraps>

00102244 <vector97>:
.globl vector97
vector97:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $97
  102246:	6a 61                	push   $0x61
  jmp __alltraps
  102248:	e9 7c fc ff ff       	jmp    101ec9 <__alltraps>

0010224d <vector98>:
.globl vector98
vector98:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $98
  10224f:	6a 62                	push   $0x62
  jmp __alltraps
  102251:	e9 73 fc ff ff       	jmp    101ec9 <__alltraps>

00102256 <vector99>:
.globl vector99
vector99:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $99
  102258:	6a 63                	push   $0x63
  jmp __alltraps
  10225a:	e9 6a fc ff ff       	jmp    101ec9 <__alltraps>

0010225f <vector100>:
.globl vector100
vector100:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $100
  102261:	6a 64                	push   $0x64
  jmp __alltraps
  102263:	e9 61 fc ff ff       	jmp    101ec9 <__alltraps>

00102268 <vector101>:
.globl vector101
vector101:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $101
  10226a:	6a 65                	push   $0x65
  jmp __alltraps
  10226c:	e9 58 fc ff ff       	jmp    101ec9 <__alltraps>

00102271 <vector102>:
.globl vector102
vector102:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $102
  102273:	6a 66                	push   $0x66
  jmp __alltraps
  102275:	e9 4f fc ff ff       	jmp    101ec9 <__alltraps>

0010227a <vector103>:
.globl vector103
vector103:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $103
  10227c:	6a 67                	push   $0x67
  jmp __alltraps
  10227e:	e9 46 fc ff ff       	jmp    101ec9 <__alltraps>

00102283 <vector104>:
.globl vector104
vector104:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $104
  102285:	6a 68                	push   $0x68
  jmp __alltraps
  102287:	e9 3d fc ff ff       	jmp    101ec9 <__alltraps>

0010228c <vector105>:
.globl vector105
vector105:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $105
  10228e:	6a 69                	push   $0x69
  jmp __alltraps
  102290:	e9 34 fc ff ff       	jmp    101ec9 <__alltraps>

00102295 <vector106>:
.globl vector106
vector106:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $106
  102297:	6a 6a                	push   $0x6a
  jmp __alltraps
  102299:	e9 2b fc ff ff       	jmp    101ec9 <__alltraps>

0010229e <vector107>:
.globl vector107
vector107:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $107
  1022a0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022a2:	e9 22 fc ff ff       	jmp    101ec9 <__alltraps>

001022a7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $108
  1022a9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022ab:	e9 19 fc ff ff       	jmp    101ec9 <__alltraps>

001022b0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $109
  1022b2:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022b4:	e9 10 fc ff ff       	jmp    101ec9 <__alltraps>

001022b9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $110
  1022bb:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022bd:	e9 07 fc ff ff       	jmp    101ec9 <__alltraps>

001022c2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $111
  1022c4:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022c6:	e9 fe fb ff ff       	jmp    101ec9 <__alltraps>

001022cb <vector112>:
.globl vector112
vector112:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $112
  1022cd:	6a 70                	push   $0x70
  jmp __alltraps
  1022cf:	e9 f5 fb ff ff       	jmp    101ec9 <__alltraps>

001022d4 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $113
  1022d6:	6a 71                	push   $0x71
  jmp __alltraps
  1022d8:	e9 ec fb ff ff       	jmp    101ec9 <__alltraps>

001022dd <vector114>:
.globl vector114
vector114:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $114
  1022df:	6a 72                	push   $0x72
  jmp __alltraps
  1022e1:	e9 e3 fb ff ff       	jmp    101ec9 <__alltraps>

001022e6 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $115
  1022e8:	6a 73                	push   $0x73
  jmp __alltraps
  1022ea:	e9 da fb ff ff       	jmp    101ec9 <__alltraps>

001022ef <vector116>:
.globl vector116
vector116:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $116
  1022f1:	6a 74                	push   $0x74
  jmp __alltraps
  1022f3:	e9 d1 fb ff ff       	jmp    101ec9 <__alltraps>

001022f8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $117
  1022fa:	6a 75                	push   $0x75
  jmp __alltraps
  1022fc:	e9 c8 fb ff ff       	jmp    101ec9 <__alltraps>

00102301 <vector118>:
.globl vector118
vector118:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $118
  102303:	6a 76                	push   $0x76
  jmp __alltraps
  102305:	e9 bf fb ff ff       	jmp    101ec9 <__alltraps>

0010230a <vector119>:
.globl vector119
vector119:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $119
  10230c:	6a 77                	push   $0x77
  jmp __alltraps
  10230e:	e9 b6 fb ff ff       	jmp    101ec9 <__alltraps>

00102313 <vector120>:
.globl vector120
vector120:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $120
  102315:	6a 78                	push   $0x78
  jmp __alltraps
  102317:	e9 ad fb ff ff       	jmp    101ec9 <__alltraps>

0010231c <vector121>:
.globl vector121
vector121:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $121
  10231e:	6a 79                	push   $0x79
  jmp __alltraps
  102320:	e9 a4 fb ff ff       	jmp    101ec9 <__alltraps>

00102325 <vector122>:
.globl vector122
vector122:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $122
  102327:	6a 7a                	push   $0x7a
  jmp __alltraps
  102329:	e9 9b fb ff ff       	jmp    101ec9 <__alltraps>

0010232e <vector123>:
.globl vector123
vector123:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $123
  102330:	6a 7b                	push   $0x7b
  jmp __alltraps
  102332:	e9 92 fb ff ff       	jmp    101ec9 <__alltraps>

00102337 <vector124>:
.globl vector124
vector124:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $124
  102339:	6a 7c                	push   $0x7c
  jmp __alltraps
  10233b:	e9 89 fb ff ff       	jmp    101ec9 <__alltraps>

00102340 <vector125>:
.globl vector125
vector125:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $125
  102342:	6a 7d                	push   $0x7d
  jmp __alltraps
  102344:	e9 80 fb ff ff       	jmp    101ec9 <__alltraps>

00102349 <vector126>:
.globl vector126
vector126:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $126
  10234b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10234d:	e9 77 fb ff ff       	jmp    101ec9 <__alltraps>

00102352 <vector127>:
.globl vector127
vector127:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $127
  102354:	6a 7f                	push   $0x7f
  jmp __alltraps
  102356:	e9 6e fb ff ff       	jmp    101ec9 <__alltraps>

0010235b <vector128>:
.globl vector128
vector128:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $128
  10235d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102362:	e9 62 fb ff ff       	jmp    101ec9 <__alltraps>

00102367 <vector129>:
.globl vector129
vector129:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $129
  102369:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10236e:	e9 56 fb ff ff       	jmp    101ec9 <__alltraps>

00102373 <vector130>:
.globl vector130
vector130:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $130
  102375:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10237a:	e9 4a fb ff ff       	jmp    101ec9 <__alltraps>

0010237f <vector131>:
.globl vector131
vector131:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $131
  102381:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102386:	e9 3e fb ff ff       	jmp    101ec9 <__alltraps>

0010238b <vector132>:
.globl vector132
vector132:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $132
  10238d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102392:	e9 32 fb ff ff       	jmp    101ec9 <__alltraps>

00102397 <vector133>:
.globl vector133
vector133:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $133
  102399:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10239e:	e9 26 fb ff ff       	jmp    101ec9 <__alltraps>

001023a3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $134
  1023a5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023aa:	e9 1a fb ff ff       	jmp    101ec9 <__alltraps>

001023af <vector135>:
.globl vector135
vector135:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $135
  1023b1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023b6:	e9 0e fb ff ff       	jmp    101ec9 <__alltraps>

001023bb <vector136>:
.globl vector136
vector136:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $136
  1023bd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023c2:	e9 02 fb ff ff       	jmp    101ec9 <__alltraps>

001023c7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $137
  1023c9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023ce:	e9 f6 fa ff ff       	jmp    101ec9 <__alltraps>

001023d3 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $138
  1023d5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023da:	e9 ea fa ff ff       	jmp    101ec9 <__alltraps>

001023df <vector139>:
.globl vector139
vector139:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $139
  1023e1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023e6:	e9 de fa ff ff       	jmp    101ec9 <__alltraps>

001023eb <vector140>:
.globl vector140
vector140:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $140
  1023ed:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023f2:	e9 d2 fa ff ff       	jmp    101ec9 <__alltraps>

001023f7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $141
  1023f9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023fe:	e9 c6 fa ff ff       	jmp    101ec9 <__alltraps>

00102403 <vector142>:
.globl vector142
vector142:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $142
  102405:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10240a:	e9 ba fa ff ff       	jmp    101ec9 <__alltraps>

0010240f <vector143>:
.globl vector143
vector143:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $143
  102411:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102416:	e9 ae fa ff ff       	jmp    101ec9 <__alltraps>

0010241b <vector144>:
.globl vector144
vector144:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $144
  10241d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102422:	e9 a2 fa ff ff       	jmp    101ec9 <__alltraps>

00102427 <vector145>:
.globl vector145
vector145:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $145
  102429:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10242e:	e9 96 fa ff ff       	jmp    101ec9 <__alltraps>

00102433 <vector146>:
.globl vector146
vector146:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $146
  102435:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10243a:	e9 8a fa ff ff       	jmp    101ec9 <__alltraps>

0010243f <vector147>:
.globl vector147
vector147:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $147
  102441:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102446:	e9 7e fa ff ff       	jmp    101ec9 <__alltraps>

0010244b <vector148>:
.globl vector148
vector148:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $148
  10244d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102452:	e9 72 fa ff ff       	jmp    101ec9 <__alltraps>

00102457 <vector149>:
.globl vector149
vector149:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $149
  102459:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10245e:	e9 66 fa ff ff       	jmp    101ec9 <__alltraps>

00102463 <vector150>:
.globl vector150
vector150:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $150
  102465:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10246a:	e9 5a fa ff ff       	jmp    101ec9 <__alltraps>

0010246f <vector151>:
.globl vector151
vector151:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $151
  102471:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102476:	e9 4e fa ff ff       	jmp    101ec9 <__alltraps>

0010247b <vector152>:
.globl vector152
vector152:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $152
  10247d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102482:	e9 42 fa ff ff       	jmp    101ec9 <__alltraps>

00102487 <vector153>:
.globl vector153
vector153:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $153
  102489:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10248e:	e9 36 fa ff ff       	jmp    101ec9 <__alltraps>

00102493 <vector154>:
.globl vector154
vector154:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $154
  102495:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10249a:	e9 2a fa ff ff       	jmp    101ec9 <__alltraps>

0010249f <vector155>:
.globl vector155
vector155:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $155
  1024a1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024a6:	e9 1e fa ff ff       	jmp    101ec9 <__alltraps>

001024ab <vector156>:
.globl vector156
vector156:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $156
  1024ad:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024b2:	e9 12 fa ff ff       	jmp    101ec9 <__alltraps>

001024b7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $157
  1024b9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024be:	e9 06 fa ff ff       	jmp    101ec9 <__alltraps>

001024c3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $158
  1024c5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024ca:	e9 fa f9 ff ff       	jmp    101ec9 <__alltraps>

001024cf <vector159>:
.globl vector159
vector159:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $159
  1024d1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024d6:	e9 ee f9 ff ff       	jmp    101ec9 <__alltraps>

001024db <vector160>:
.globl vector160
vector160:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $160
  1024dd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024e2:	e9 e2 f9 ff ff       	jmp    101ec9 <__alltraps>

001024e7 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $161
  1024e9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024ee:	e9 d6 f9 ff ff       	jmp    101ec9 <__alltraps>

001024f3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $162
  1024f5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024fa:	e9 ca f9 ff ff       	jmp    101ec9 <__alltraps>

001024ff <vector163>:
.globl vector163
vector163:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $163
  102501:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102506:	e9 be f9 ff ff       	jmp    101ec9 <__alltraps>

0010250b <vector164>:
.globl vector164
vector164:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $164
  10250d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102512:	e9 b2 f9 ff ff       	jmp    101ec9 <__alltraps>

00102517 <vector165>:
.globl vector165
vector165:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $165
  102519:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10251e:	e9 a6 f9 ff ff       	jmp    101ec9 <__alltraps>

00102523 <vector166>:
.globl vector166
vector166:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $166
  102525:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10252a:	e9 9a f9 ff ff       	jmp    101ec9 <__alltraps>

0010252f <vector167>:
.globl vector167
vector167:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $167
  102531:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102536:	e9 8e f9 ff ff       	jmp    101ec9 <__alltraps>

0010253b <vector168>:
.globl vector168
vector168:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $168
  10253d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102542:	e9 82 f9 ff ff       	jmp    101ec9 <__alltraps>

00102547 <vector169>:
.globl vector169
vector169:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $169
  102549:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10254e:	e9 76 f9 ff ff       	jmp    101ec9 <__alltraps>

00102553 <vector170>:
.globl vector170
vector170:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $170
  102555:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10255a:	e9 6a f9 ff ff       	jmp    101ec9 <__alltraps>

0010255f <vector171>:
.globl vector171
vector171:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $171
  102561:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102566:	e9 5e f9 ff ff       	jmp    101ec9 <__alltraps>

0010256b <vector172>:
.globl vector172
vector172:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $172
  10256d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102572:	e9 52 f9 ff ff       	jmp    101ec9 <__alltraps>

00102577 <vector173>:
.globl vector173
vector173:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $173
  102579:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10257e:	e9 46 f9 ff ff       	jmp    101ec9 <__alltraps>

00102583 <vector174>:
.globl vector174
vector174:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $174
  102585:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10258a:	e9 3a f9 ff ff       	jmp    101ec9 <__alltraps>

0010258f <vector175>:
.globl vector175
vector175:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $175
  102591:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102596:	e9 2e f9 ff ff       	jmp    101ec9 <__alltraps>

0010259b <vector176>:
.globl vector176
vector176:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $176
  10259d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025a2:	e9 22 f9 ff ff       	jmp    101ec9 <__alltraps>

001025a7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $177
  1025a9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025ae:	e9 16 f9 ff ff       	jmp    101ec9 <__alltraps>

001025b3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $178
  1025b5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025ba:	e9 0a f9 ff ff       	jmp    101ec9 <__alltraps>

001025bf <vector179>:
.globl vector179
vector179:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $179
  1025c1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025c6:	e9 fe f8 ff ff       	jmp    101ec9 <__alltraps>

001025cb <vector180>:
.globl vector180
vector180:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $180
  1025cd:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025d2:	e9 f2 f8 ff ff       	jmp    101ec9 <__alltraps>

001025d7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $181
  1025d9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025de:	e9 e6 f8 ff ff       	jmp    101ec9 <__alltraps>

001025e3 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $182
  1025e5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025ea:	e9 da f8 ff ff       	jmp    101ec9 <__alltraps>

001025ef <vector183>:
.globl vector183
vector183:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $183
  1025f1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025f6:	e9 ce f8 ff ff       	jmp    101ec9 <__alltraps>

001025fb <vector184>:
.globl vector184
vector184:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $184
  1025fd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102602:	e9 c2 f8 ff ff       	jmp    101ec9 <__alltraps>

00102607 <vector185>:
.globl vector185
vector185:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $185
  102609:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10260e:	e9 b6 f8 ff ff       	jmp    101ec9 <__alltraps>

00102613 <vector186>:
.globl vector186
vector186:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $186
  102615:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10261a:	e9 aa f8 ff ff       	jmp    101ec9 <__alltraps>

0010261f <vector187>:
.globl vector187
vector187:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $187
  102621:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102626:	e9 9e f8 ff ff       	jmp    101ec9 <__alltraps>

0010262b <vector188>:
.globl vector188
vector188:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $188
  10262d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102632:	e9 92 f8 ff ff       	jmp    101ec9 <__alltraps>

00102637 <vector189>:
.globl vector189
vector189:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $189
  102639:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10263e:	e9 86 f8 ff ff       	jmp    101ec9 <__alltraps>

00102643 <vector190>:
.globl vector190
vector190:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $190
  102645:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10264a:	e9 7a f8 ff ff       	jmp    101ec9 <__alltraps>

0010264f <vector191>:
.globl vector191
vector191:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $191
  102651:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102656:	e9 6e f8 ff ff       	jmp    101ec9 <__alltraps>

0010265b <vector192>:
.globl vector192
vector192:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $192
  10265d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102662:	e9 62 f8 ff ff       	jmp    101ec9 <__alltraps>

00102667 <vector193>:
.globl vector193
vector193:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $193
  102669:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10266e:	e9 56 f8 ff ff       	jmp    101ec9 <__alltraps>

00102673 <vector194>:
.globl vector194
vector194:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $194
  102675:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10267a:	e9 4a f8 ff ff       	jmp    101ec9 <__alltraps>

0010267f <vector195>:
.globl vector195
vector195:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $195
  102681:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102686:	e9 3e f8 ff ff       	jmp    101ec9 <__alltraps>

0010268b <vector196>:
.globl vector196
vector196:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $196
  10268d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102692:	e9 32 f8 ff ff       	jmp    101ec9 <__alltraps>

00102697 <vector197>:
.globl vector197
vector197:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $197
  102699:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10269e:	e9 26 f8 ff ff       	jmp    101ec9 <__alltraps>

001026a3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $198
  1026a5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026aa:	e9 1a f8 ff ff       	jmp    101ec9 <__alltraps>

001026af <vector199>:
.globl vector199
vector199:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $199
  1026b1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026b6:	e9 0e f8 ff ff       	jmp    101ec9 <__alltraps>

001026bb <vector200>:
.globl vector200
vector200:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $200
  1026bd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026c2:	e9 02 f8 ff ff       	jmp    101ec9 <__alltraps>

001026c7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $201
  1026c9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026ce:	e9 f6 f7 ff ff       	jmp    101ec9 <__alltraps>

001026d3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $202
  1026d5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026da:	e9 ea f7 ff ff       	jmp    101ec9 <__alltraps>

001026df <vector203>:
.globl vector203
vector203:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $203
  1026e1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026e6:	e9 de f7 ff ff       	jmp    101ec9 <__alltraps>

001026eb <vector204>:
.globl vector204
vector204:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $204
  1026ed:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026f2:	e9 d2 f7 ff ff       	jmp    101ec9 <__alltraps>

001026f7 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $205
  1026f9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026fe:	e9 c6 f7 ff ff       	jmp    101ec9 <__alltraps>

00102703 <vector206>:
.globl vector206
vector206:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $206
  102705:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10270a:	e9 ba f7 ff ff       	jmp    101ec9 <__alltraps>

0010270f <vector207>:
.globl vector207
vector207:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $207
  102711:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102716:	e9 ae f7 ff ff       	jmp    101ec9 <__alltraps>

0010271b <vector208>:
.globl vector208
vector208:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $208
  10271d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102722:	e9 a2 f7 ff ff       	jmp    101ec9 <__alltraps>

00102727 <vector209>:
.globl vector209
vector209:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $209
  102729:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10272e:	e9 96 f7 ff ff       	jmp    101ec9 <__alltraps>

00102733 <vector210>:
.globl vector210
vector210:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $210
  102735:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10273a:	e9 8a f7 ff ff       	jmp    101ec9 <__alltraps>

0010273f <vector211>:
.globl vector211
vector211:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $211
  102741:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102746:	e9 7e f7 ff ff       	jmp    101ec9 <__alltraps>

0010274b <vector212>:
.globl vector212
vector212:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $212
  10274d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102752:	e9 72 f7 ff ff       	jmp    101ec9 <__alltraps>

00102757 <vector213>:
.globl vector213
vector213:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $213
  102759:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10275e:	e9 66 f7 ff ff       	jmp    101ec9 <__alltraps>

00102763 <vector214>:
.globl vector214
vector214:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $214
  102765:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10276a:	e9 5a f7 ff ff       	jmp    101ec9 <__alltraps>

0010276f <vector215>:
.globl vector215
vector215:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $215
  102771:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102776:	e9 4e f7 ff ff       	jmp    101ec9 <__alltraps>

0010277b <vector216>:
.globl vector216
vector216:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $216
  10277d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102782:	e9 42 f7 ff ff       	jmp    101ec9 <__alltraps>

00102787 <vector217>:
.globl vector217
vector217:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $217
  102789:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10278e:	e9 36 f7 ff ff       	jmp    101ec9 <__alltraps>

00102793 <vector218>:
.globl vector218
vector218:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $218
  102795:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10279a:	e9 2a f7 ff ff       	jmp    101ec9 <__alltraps>

0010279f <vector219>:
.globl vector219
vector219:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $219
  1027a1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027a6:	e9 1e f7 ff ff       	jmp    101ec9 <__alltraps>

001027ab <vector220>:
.globl vector220
vector220:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $220
  1027ad:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027b2:	e9 12 f7 ff ff       	jmp    101ec9 <__alltraps>

001027b7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $221
  1027b9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027be:	e9 06 f7 ff ff       	jmp    101ec9 <__alltraps>

001027c3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $222
  1027c5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027ca:	e9 fa f6 ff ff       	jmp    101ec9 <__alltraps>

001027cf <vector223>:
.globl vector223
vector223:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $223
  1027d1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027d6:	e9 ee f6 ff ff       	jmp    101ec9 <__alltraps>

001027db <vector224>:
.globl vector224
vector224:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $224
  1027dd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027e2:	e9 e2 f6 ff ff       	jmp    101ec9 <__alltraps>

001027e7 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $225
  1027e9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027ee:	e9 d6 f6 ff ff       	jmp    101ec9 <__alltraps>

001027f3 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $226
  1027f5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027fa:	e9 ca f6 ff ff       	jmp    101ec9 <__alltraps>

001027ff <vector227>:
.globl vector227
vector227:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $227
  102801:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102806:	e9 be f6 ff ff       	jmp    101ec9 <__alltraps>

0010280b <vector228>:
.globl vector228
vector228:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $228
  10280d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102812:	e9 b2 f6 ff ff       	jmp    101ec9 <__alltraps>

00102817 <vector229>:
.globl vector229
vector229:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $229
  102819:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10281e:	e9 a6 f6 ff ff       	jmp    101ec9 <__alltraps>

00102823 <vector230>:
.globl vector230
vector230:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $230
  102825:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10282a:	e9 9a f6 ff ff       	jmp    101ec9 <__alltraps>

0010282f <vector231>:
.globl vector231
vector231:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $231
  102831:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102836:	e9 8e f6 ff ff       	jmp    101ec9 <__alltraps>

0010283b <vector232>:
.globl vector232
vector232:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $232
  10283d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102842:	e9 82 f6 ff ff       	jmp    101ec9 <__alltraps>

00102847 <vector233>:
.globl vector233
vector233:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $233
  102849:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10284e:	e9 76 f6 ff ff       	jmp    101ec9 <__alltraps>

00102853 <vector234>:
.globl vector234
vector234:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $234
  102855:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10285a:	e9 6a f6 ff ff       	jmp    101ec9 <__alltraps>

0010285f <vector235>:
.globl vector235
vector235:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $235
  102861:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102866:	e9 5e f6 ff ff       	jmp    101ec9 <__alltraps>

0010286b <vector236>:
.globl vector236
vector236:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $236
  10286d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102872:	e9 52 f6 ff ff       	jmp    101ec9 <__alltraps>

00102877 <vector237>:
.globl vector237
vector237:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $237
  102879:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10287e:	e9 46 f6 ff ff       	jmp    101ec9 <__alltraps>

00102883 <vector238>:
.globl vector238
vector238:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $238
  102885:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10288a:	e9 3a f6 ff ff       	jmp    101ec9 <__alltraps>

0010288f <vector239>:
.globl vector239
vector239:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $239
  102891:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102896:	e9 2e f6 ff ff       	jmp    101ec9 <__alltraps>

0010289b <vector240>:
.globl vector240
vector240:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $240
  10289d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028a2:	e9 22 f6 ff ff       	jmp    101ec9 <__alltraps>

001028a7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $241
  1028a9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028ae:	e9 16 f6 ff ff       	jmp    101ec9 <__alltraps>

001028b3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $242
  1028b5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028ba:	e9 0a f6 ff ff       	jmp    101ec9 <__alltraps>

001028bf <vector243>:
.globl vector243
vector243:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $243
  1028c1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028c6:	e9 fe f5 ff ff       	jmp    101ec9 <__alltraps>

001028cb <vector244>:
.globl vector244
vector244:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $244
  1028cd:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028d2:	e9 f2 f5 ff ff       	jmp    101ec9 <__alltraps>

001028d7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $245
  1028d9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028de:	e9 e6 f5 ff ff       	jmp    101ec9 <__alltraps>

001028e3 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $246
  1028e5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028ea:	e9 da f5 ff ff       	jmp    101ec9 <__alltraps>

001028ef <vector247>:
.globl vector247
vector247:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $247
  1028f1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028f6:	e9 ce f5 ff ff       	jmp    101ec9 <__alltraps>

001028fb <vector248>:
.globl vector248
vector248:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $248
  1028fd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102902:	e9 c2 f5 ff ff       	jmp    101ec9 <__alltraps>

00102907 <vector249>:
.globl vector249
vector249:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $249
  102909:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10290e:	e9 b6 f5 ff ff       	jmp    101ec9 <__alltraps>

00102913 <vector250>:
.globl vector250
vector250:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $250
  102915:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10291a:	e9 aa f5 ff ff       	jmp    101ec9 <__alltraps>

0010291f <vector251>:
.globl vector251
vector251:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $251
  102921:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102926:	e9 9e f5 ff ff       	jmp    101ec9 <__alltraps>

0010292b <vector252>:
.globl vector252
vector252:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $252
  10292d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102932:	e9 92 f5 ff ff       	jmp    101ec9 <__alltraps>

00102937 <vector253>:
.globl vector253
vector253:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $253
  102939:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10293e:	e9 86 f5 ff ff       	jmp    101ec9 <__alltraps>

00102943 <vector254>:
.globl vector254
vector254:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $254
  102945:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10294a:	e9 7a f5 ff ff       	jmp    101ec9 <__alltraps>

0010294f <vector255>:
.globl vector255
vector255:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $255
  102951:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102956:	e9 6e f5 ff ff       	jmp    101ec9 <__alltraps>

0010295b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10295b:	55                   	push   %ebp
  10295c:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10295e:	8b 55 08             	mov    0x8(%ebp),%edx
  102961:	a1 c0 b9 11 00       	mov    0x11b9c0,%eax
  102966:	29 c2                	sub    %eax,%edx
  102968:	89 d0                	mov    %edx,%eax
  10296a:	c1 f8 02             	sar    $0x2,%eax
  10296d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102973:	5d                   	pop    %ebp
  102974:	c3                   	ret    

00102975 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102975:	55                   	push   %ebp
  102976:	89 e5                	mov    %esp,%ebp
  102978:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10297b:	8b 45 08             	mov    0x8(%ebp),%eax
  10297e:	89 04 24             	mov    %eax,(%esp)
  102981:	e8 d5 ff ff ff       	call   10295b <page2ppn>
  102986:	c1 e0 0c             	shl    $0xc,%eax
}
  102989:	c9                   	leave  
  10298a:	c3                   	ret    

0010298b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10298b:	55                   	push   %ebp
  10298c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10298e:	8b 45 08             	mov    0x8(%ebp),%eax
  102991:	8b 00                	mov    (%eax),%eax
}
  102993:	5d                   	pop    %ebp
  102994:	c3                   	ret    

00102995 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102995:	55                   	push   %ebp
  102996:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102998:	8b 45 08             	mov    0x8(%ebp),%eax
  10299b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10299e:	89 10                	mov    %edx,(%eax)
}
  1029a0:	5d                   	pop    %ebp
  1029a1:	c3                   	ret    

001029a2 <buddy_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
buddy_init(void) {
  1029a2:	55                   	push   %ebp
  1029a3:	89 e5                	mov    %esp,%ebp
  1029a5:	83 ec 10             	sub    $0x10,%esp
  1029a8:	c7 45 fc ac b9 11 00 	movl   $0x11b9ac,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1029b5:	89 50 04             	mov    %edx,0x4(%eax)
  1029b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029bb:	8b 50 04             	mov    0x4(%eax),%edx
  1029be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029c1:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1029c3:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  1029ca:	00 00 00 
}
  1029cd:	c9                   	leave  
  1029ce:	c3                   	ret    

001029cf <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {    
  1029cf:	55                   	push   %ebp
  1029d0:	89 e5                	mov    %esp,%ebp
  1029d2:	83 ec 68             	sub    $0x68,%esp
    cprintf("Memmap: 0x%x, size %d\n", base, n);
  1029d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1029df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029e3:	c7 04 24 50 7a 10 00 	movl   $0x107a50,(%esp)
  1029ea:	e8 54 d9 ff ff       	call   100343 <cprintf>
    // n must be a positive number
    assert(n > 0);
  1029ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029f3:	75 24                	jne    102a19 <buddy_init_memmap+0x4a>
  1029f5:	c7 44 24 0c 67 7a 10 	movl   $0x107a67,0xc(%esp)
  1029fc:	00 
  1029fd:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102a04:	00 
  102a05:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  102a0c:	00 
  102a0d:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102a14:	e8 b6 e2 ff ff       	call   100ccf <__panic>

    struct Page *ptr = base;
  102a19:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ptr < base + n; ptr++) {
  102a1f:	e9 a3 00 00 00       	jmp    102ac7 <buddy_init_memmap+0xf8>
        assert(PageReserved(ptr));
  102a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a27:	83 c0 04             	add    $0x4,%eax
  102a2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a3a:	0f a3 10             	bt     %edx,(%eax)
  102a3d:	19 c0                	sbb    %eax,%eax
  102a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a46:	0f 95 c0             	setne  %al
  102a49:	0f b6 c0             	movzbl %al,%eax
  102a4c:	85 c0                	test   %eax,%eax
  102a4e:	75 24                	jne    102a74 <buddy_init_memmap+0xa5>
  102a50:	c7 44 24 0c 96 7a 10 	movl   $0x107a96,0xc(%esp)
  102a57:	00 
  102a58:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102a5f:	00 
  102a60:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  102a67:	00 
  102a68:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102a6f:	e8 5b e2 ff ff       	call   100ccf <__panic>
        // clear flags
        ClearPageProperty(ptr);
  102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a77:	83 c0 04             	add    $0x4,%eax
  102a7a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a81:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a8a:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
  102a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a90:	83 c0 04             	add    $0x4,%eax
  102a93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102aa0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102aa3:	0f b3 10             	btr    %edx,(%eax)
        // no reference
        set_page_ref(ptr, 0);
  102aa6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102aad:	00 
  102aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab1:	89 04 24             	mov    %eax,(%esp)
  102ab4:	e8 dc fe ff ff       	call   102995 <set_page_ref>
        ptr->property = 0;
  102ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102abc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    cprintf("Memmap: 0x%x, size %d\n", base, n);
    // n must be a positive number
    assert(n > 0);

    struct Page *ptr = base;
    for (; ptr < base + n; ptr++) {
  102ac3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aca:	89 d0                	mov    %edx,%eax
  102acc:	c1 e0 02             	shl    $0x2,%eax
  102acf:	01 d0                	add    %edx,%eax
  102ad1:	c1 e0 02             	shl    $0x2,%eax
  102ad4:	89 c2                	mov    %eax,%edx
  102ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad9:	01 d0                	add    %edx,%eax
  102adb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ade:	0f 87 40 ff ff ff    	ja     102a24 <buddy_init_memmap+0x55>
        // no reference
        set_page_ref(ptr, 0);
        ptr->property = 0;
    }
    // set bit and property of the first page
    SetPageProperty(base);
  102ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae7:	83 c0 04             	add    $0x4,%eax
  102aea:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102af1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102af4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102af7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102afa:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102afd:	8b 45 08             	mov    0x8(%ebp),%eax
  102b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b03:	89 50 08             	mov    %edx,0x8(%eax)
    
    nr_free += n;
  102b06:	8b 15 b4 b9 11 00    	mov    0x11b9b4,%edx
  102b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b0f:	01 d0                	add    %edx,%eax
  102b11:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4
    list_add(&free_list, &(base->page_link));
  102b16:	8b 45 08             	mov    0x8(%ebp),%eax
  102b19:	83 c0 0c             	add    $0xc,%eax
  102b1c:	c7 45 cc ac b9 11 00 	movl   $0x11b9ac,-0x34(%ebp)
  102b23:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b29:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b35:	8b 40 04             	mov    0x4(%eax),%eax
  102b38:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b3b:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102b3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b41:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102b44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b47:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b4a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b4d:	89 10                	mov    %edx,(%eax)
  102b4f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b52:	8b 10                	mov    (%eax),%edx
  102b54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b57:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b5a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b5d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102b60:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b63:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b66:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b69:	89 10                	mov    %edx,(%eax)
}
  102b6b:	c9                   	leave  
  102b6c:	c3                   	ret    

00102b6d <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
  102b6d:	55                   	push   %ebp
  102b6e:	89 e5                	mov    %esp,%ebp
    return NULL;
  102b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b75:	5d                   	pop    %ebp
  102b76:	c3                   	ret    

00102b77 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  102b77:	55                   	push   %ebp
  102b78:	89 e5                	mov    %esp,%ebp
    return;
  102b7a:	90                   	nop
}
  102b7b:	5d                   	pop    %ebp
  102b7c:	c3                   	ret    

00102b7d <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  102b7d:	55                   	push   %ebp
  102b7e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102b80:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
}
  102b85:	5d                   	pop    %ebp
  102b86:	c3                   	ret    

00102b87 <output_free_list>:

static void
output_free_list(void) {
  102b87:	55                   	push   %ebp
  102b88:	89 e5                	mov    %esp,%ebp
  102b8a:	57                   	push   %edi
  102b8b:	56                   	push   %esi
  102b8c:	53                   	push   %ebx
  102b8d:	83 ec 5c             	sub    $0x5c,%esp
    int index = 0;
  102b90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    struct Page *p = NULL;
  102b97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    list_entry_t *le = &free_list;
  102b9e:	c7 45 e0 ac b9 11 00 	movl   $0x11b9ac,-0x20(%ebp)
    cprintf("free_list: NR_FREE %d\n", nr_free);
  102ba5:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  102baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bae:	c7 04 24 a8 7a 10 00 	movl   $0x107aa8,(%esp)
  102bb5:	e8 89 d7 ff ff       	call   100343 <cprintf>
    while ((le = list_next(le)) != &free_list) {
  102bba:	e9 98 00 00 00       	jmp    102c57 <output_free_list+0xd0>
        p = le2page(le, page_link);
  102bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bc2:	83 e8 0c             	sub    $0xc,%eax
  102bc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
  102bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bcb:	83 c0 04             	add    $0x4,%eax
  102bce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bdb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bde:	0f a3 10             	bt     %edx,(%eax)
  102be1:	19 c0                	sbb    %eax,%eax
  102be3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  102be6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  102bea:	0f 95 c0             	setne  %al
  102bed:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
  102bf0:	89 c6                	mov    %eax,%esi
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
  102bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bf5:	83 c0 04             	add    $0x4,%eax
  102bf8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  102bff:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c02:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c05:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c08:	0f a3 10             	bt     %edx,(%eax)
  102c0b:	19 c0                	sbb    %eax,%eax
  102c0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  102c10:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  102c14:	0f 95 c0             	setne  %al
  102c17:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
  102c1a:	89 c3                	mov    %eax,%ebx
  102c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c1f:	8b 48 08             	mov    0x8(%eax),%ecx
  102c22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c25:	8b 10                	mov    (%eax),%edx
  102c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c2a:	8d 78 01             	lea    0x1(%eax),%edi
  102c2d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  102c30:	89 74 24 18          	mov    %esi,0x18(%esp)
  102c34:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  102c38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  102c3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102c40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c43:	89 54 24 08          	mov    %edx,0x8(%esp)
  102c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4b:	c7 04 24 c0 7a 10 00 	movl   $0x107ac0,(%esp)
  102c52:	e8 ec d6 ff ff       	call   100343 <cprintf>
  102c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c5a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c60:	8b 40 04             	mov    0x4(%eax),%eax
output_free_list(void) {
    int index = 0;
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
  102c63:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c66:	81 7d e0 ac b9 11 00 	cmpl   $0x11b9ac,-0x20(%ebp)
  102c6d:	0f 85 4c ff ff ff    	jne    102bbf <output_free_list+0x38>
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
    }
}
  102c73:	83 c4 5c             	add    $0x5c,%esp
  102c76:	5b                   	pop    %ebx
  102c77:	5e                   	pop    %esi
  102c78:	5f                   	pop    %edi
  102c79:	5d                   	pop    %ebp
  102c7a:	c3                   	ret    

00102c7b <basic_check>:

static void
basic_check(void) {
  102c7b:	55                   	push   %ebp
  102c7c:	89 e5                	mov    %esp,%ebp
  102c7e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c9b:	e8 bb 23 00 00       	call   10505b <alloc_pages>
  102ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102ca7:	75 24                	jne    102ccd <basic_check+0x52>
  102ca9:	c7 44 24 0c 05 7b 10 	movl   $0x107b05,0xc(%esp)
  102cb0:	00 
  102cb1:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102cb8:	00 
  102cb9:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  102cc0:	00 
  102cc1:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102cc8:	e8 02 e0 ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ccd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102cd4:	e8 82 23 00 00       	call   10505b <alloc_pages>
  102cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ce0:	75 24                	jne    102d06 <basic_check+0x8b>
  102ce2:	c7 44 24 0c 21 7b 10 	movl   $0x107b21,0xc(%esp)
  102ce9:	00 
  102cea:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102cf1:	00 
  102cf2:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  102cf9:	00 
  102cfa:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102d01:	e8 c9 df ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  102d06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d0d:	e8 49 23 00 00       	call   10505b <alloc_pages>
  102d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102d19:	75 24                	jne    102d3f <basic_check+0xc4>
  102d1b:	c7 44 24 0c 3d 7b 10 	movl   $0x107b3d,0xc(%esp)
  102d22:	00 
  102d23:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102d2a:	00 
  102d2b:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  102d32:	00 
  102d33:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102d3a:	e8 90 df ff ff       	call   100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d45:	74 10                	je     102d57 <basic_check+0xdc>
  102d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d4d:	74 08                	je     102d57 <basic_check+0xdc>
  102d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d55:	75 24                	jne    102d7b <basic_check+0x100>
  102d57:	c7 44 24 0c 5c 7b 10 	movl   $0x107b5c,0xc(%esp)
  102d5e:	00 
  102d5f:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102d66:	00 
  102d67:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
  102d6e:	00 
  102d6f:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102d76:	e8 54 df ff ff       	call   100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d7e:	89 04 24             	mov    %eax,(%esp)
  102d81:	e8 05 fc ff ff       	call   10298b <page_ref>
  102d86:	85 c0                	test   %eax,%eax
  102d88:	75 1e                	jne    102da8 <basic_check+0x12d>
  102d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d8d:	89 04 24             	mov    %eax,(%esp)
  102d90:	e8 f6 fb ff ff       	call   10298b <page_ref>
  102d95:	85 c0                	test   %eax,%eax
  102d97:	75 0f                	jne    102da8 <basic_check+0x12d>
  102d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9c:	89 04 24             	mov    %eax,(%esp)
  102d9f:	e8 e7 fb ff ff       	call   10298b <page_ref>
  102da4:	85 c0                	test   %eax,%eax
  102da6:	74 24                	je     102dcc <basic_check+0x151>
  102da8:	c7 44 24 0c 80 7b 10 	movl   $0x107b80,0xc(%esp)
  102daf:	00 
  102db0:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102db7:	00 
  102db8:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  102dbf:	00 
  102dc0:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102dc7:	e8 03 df ff ff       	call   100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dcf:	89 04 24             	mov    %eax,(%esp)
  102dd2:	e8 9e fb ff ff       	call   102975 <page2pa>
  102dd7:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  102ddd:	c1 e2 0c             	shl    $0xc,%edx
  102de0:	39 d0                	cmp    %edx,%eax
  102de2:	72 24                	jb     102e08 <basic_check+0x18d>
  102de4:	c7 44 24 0c bc 7b 10 	movl   $0x107bbc,0xc(%esp)
  102deb:	00 
  102dec:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102df3:	00 
  102df4:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  102dfb:	00 
  102dfc:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102e03:	e8 c7 de ff ff       	call   100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0b:	89 04 24             	mov    %eax,(%esp)
  102e0e:	e8 62 fb ff ff       	call   102975 <page2pa>
  102e13:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  102e19:	c1 e2 0c             	shl    $0xc,%edx
  102e1c:	39 d0                	cmp    %edx,%eax
  102e1e:	72 24                	jb     102e44 <basic_check+0x1c9>
  102e20:	c7 44 24 0c d9 7b 10 	movl   $0x107bd9,0xc(%esp)
  102e27:	00 
  102e28:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102e2f:	00 
  102e30:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  102e37:	00 
  102e38:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102e3f:	e8 8b de ff ff       	call   100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e47:	89 04 24             	mov    %eax,(%esp)
  102e4a:	e8 26 fb ff ff       	call   102975 <page2pa>
  102e4f:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  102e55:	c1 e2 0c             	shl    $0xc,%edx
  102e58:	39 d0                	cmp    %edx,%eax
  102e5a:	72 24                	jb     102e80 <basic_check+0x205>
  102e5c:	c7 44 24 0c f6 7b 10 	movl   $0x107bf6,0xc(%esp)
  102e63:	00 
  102e64:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102e6b:	00 
  102e6c:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  102e73:	00 
  102e74:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102e7b:	e8 4f de ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  102e80:	a1 ac b9 11 00       	mov    0x11b9ac,%eax
  102e85:	8b 15 b0 b9 11 00    	mov    0x11b9b0,%edx
  102e8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e8e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e91:	c7 45 e0 ac b9 11 00 	movl   $0x11b9ac,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102e9e:	89 50 04             	mov    %edx,0x4(%eax)
  102ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ea4:	8b 50 04             	mov    0x4(%eax),%edx
  102ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eaa:	89 10                	mov    %edx,(%eax)
  102eac:	c7 45 dc ac b9 11 00 	movl   $0x11b9ac,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102eb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102eb6:	8b 40 04             	mov    0x4(%eax),%eax
  102eb9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102ebc:	0f 94 c0             	sete   %al
  102ebf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102ec2:	85 c0                	test   %eax,%eax
  102ec4:	75 24                	jne    102eea <basic_check+0x26f>
  102ec6:	c7 44 24 0c 13 7c 10 	movl   $0x107c13,0xc(%esp)
  102ecd:	00 
  102ece:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102ed5:	00 
  102ed6:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  102edd:	00 
  102ede:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102ee5:	e8 e5 dd ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  102eea:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  102eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102ef2:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  102ef9:	00 00 00 

    assert(alloc_page() == NULL);
  102efc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f03:	e8 53 21 00 00       	call   10505b <alloc_pages>
  102f08:	85 c0                	test   %eax,%eax
  102f0a:	74 24                	je     102f30 <basic_check+0x2b5>
  102f0c:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  102f13:	00 
  102f14:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102f1b:	00 
  102f1c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  102f23:	00 
  102f24:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102f2b:	e8 9f dd ff ff       	call   100ccf <__panic>

    free_page(p0);
  102f30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102f37:	00 
  102f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f3b:	89 04 24             	mov    %eax,(%esp)
  102f3e:	e8 50 21 00 00       	call   105093 <free_pages>
    free_page(p1);
  102f43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102f4a:	00 
  102f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f4e:	89 04 24             	mov    %eax,(%esp)
  102f51:	e8 3d 21 00 00       	call   105093 <free_pages>
    free_page(p2);
  102f56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102f5d:	00 
  102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f61:	89 04 24             	mov    %eax,(%esp)
  102f64:	e8 2a 21 00 00       	call   105093 <free_pages>
    assert(nr_free == 3);
  102f69:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  102f6e:	83 f8 03             	cmp    $0x3,%eax
  102f71:	74 24                	je     102f97 <basic_check+0x31c>
  102f73:	c7 44 24 0c 3f 7c 10 	movl   $0x107c3f,0xc(%esp)
  102f7a:	00 
  102f7b:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102f82:	00 
  102f83:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102f8a:	00 
  102f8b:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102f92:	e8 38 dd ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
  102f97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f9e:	e8 b8 20 00 00       	call   10505b <alloc_pages>
  102fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102faa:	75 24                	jne    102fd0 <basic_check+0x355>
  102fac:	c7 44 24 0c 05 7b 10 	movl   $0x107b05,0xc(%esp)
  102fb3:	00 
  102fb4:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102fbb:	00 
  102fbc:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  102fc3:	00 
  102fc4:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  102fcb:	e8 ff dc ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  102fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fd7:	e8 7f 20 00 00       	call   10505b <alloc_pages>
  102fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fe3:	75 24                	jne    103009 <basic_check+0x38e>
  102fe5:	c7 44 24 0c 21 7b 10 	movl   $0x107b21,0xc(%esp)
  102fec:	00 
  102fed:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  102ff4:	00 
  102ff5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  102ffc:	00 
  102ffd:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103004:	e8 c6 dc ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  103009:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103010:	e8 46 20 00 00       	call   10505b <alloc_pages>
  103015:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10301c:	75 24                	jne    103042 <basic_check+0x3c7>
  10301e:	c7 44 24 0c 3d 7b 10 	movl   $0x107b3d,0xc(%esp)
  103025:	00 
  103026:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  10302d:	00 
  10302e:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  103035:	00 
  103036:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  10303d:	e8 8d dc ff ff       	call   100ccf <__panic>

    assert(alloc_page() == NULL);
  103042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103049:	e8 0d 20 00 00       	call   10505b <alloc_pages>
  10304e:	85 c0                	test   %eax,%eax
  103050:	74 24                	je     103076 <basic_check+0x3fb>
  103052:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  103059:	00 
  10305a:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103061:	00 
  103062:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  103069:	00 
  10306a:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103071:	e8 59 dc ff ff       	call   100ccf <__panic>

    free_page(p0);
  103076:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10307d:	00 
  10307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103081:	89 04 24             	mov    %eax,(%esp)
  103084:	e8 0a 20 00 00       	call   105093 <free_pages>
  103089:	c7 45 d8 ac b9 11 00 	movl   $0x11b9ac,-0x28(%ebp)
  103090:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103093:	8b 40 04             	mov    0x4(%eax),%eax
  103096:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103099:	0f 94 c0             	sete   %al
  10309c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10309f:	85 c0                	test   %eax,%eax
  1030a1:	74 24                	je     1030c7 <basic_check+0x44c>
  1030a3:	c7 44 24 0c 4c 7c 10 	movl   $0x107c4c,0xc(%esp)
  1030aa:	00 
  1030ab:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1030b2:	00 
  1030b3:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  1030ba:	00 
  1030bb:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1030c2:	e8 08 dc ff ff       	call   100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1030c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030ce:	e8 88 1f 00 00       	call   10505b <alloc_pages>
  1030d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1030dc:	74 24                	je     103102 <basic_check+0x487>
  1030de:	c7 44 24 0c 64 7c 10 	movl   $0x107c64,0xc(%esp)
  1030e5:	00 
  1030e6:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1030ed:	00 
  1030ee:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  1030f5:	00 
  1030f6:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1030fd:	e8 cd db ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  103102:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103109:	e8 4d 1f 00 00       	call   10505b <alloc_pages>
  10310e:	85 c0                	test   %eax,%eax
  103110:	74 24                	je     103136 <basic_check+0x4bb>
  103112:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  103119:	00 
  10311a:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103121:	00 
  103122:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  103129:	00 
  10312a:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103131:	e8 99 db ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  103136:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  10313b:	85 c0                	test   %eax,%eax
  10313d:	74 24                	je     103163 <basic_check+0x4e8>
  10313f:	c7 44 24 0c 7d 7c 10 	movl   $0x107c7d,0xc(%esp)
  103146:	00 
  103147:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  10314e:	00 
  10314f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  103156:	00 
  103157:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  10315e:	e8 6c db ff ff       	call   100ccf <__panic>
    free_list = free_list_store;
  103163:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103166:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103169:	a3 ac b9 11 00       	mov    %eax,0x11b9ac
  10316e:	89 15 b0 b9 11 00    	mov    %edx,0x11b9b0
    nr_free = nr_free_store;
  103174:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103177:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4

    free_page(p);
  10317c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103183:	00 
  103184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103187:	89 04 24             	mov    %eax,(%esp)
  10318a:	e8 04 1f 00 00       	call   105093 <free_pages>
    free_page(p1);
  10318f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103196:	00 
  103197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319a:	89 04 24             	mov    %eax,(%esp)
  10319d:	e8 f1 1e 00 00       	call   105093 <free_pages>
    free_page(p2);
  1031a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031a9:	00 
  1031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031ad:	89 04 24             	mov    %eax,(%esp)
  1031b0:	e8 de 1e 00 00       	call   105093 <free_pages>
}
  1031b5:	c9                   	leave  
  1031b6:	c3                   	ret    

001031b7 <buddy_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_check(void) {
  1031b7:	55                   	push   %ebp
  1031b8:	89 e5                	mov    %esp,%ebp
  1031ba:	53                   	push   %ebx
  1031bb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1031c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1031c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1031cf:	c7 45 ec ac b9 11 00 	movl   $0x11b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1031d6:	eb 6b                	jmp    103243 <buddy_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031db:	83 e8 0c             	sub    $0xc,%eax
  1031de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031e4:	83 c0 04             	add    $0x4,%eax
  1031e7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1031ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1031f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1031f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1031f7:	0f a3 10             	bt     %edx,(%eax)
  1031fa:	19 c0                	sbb    %eax,%eax
  1031fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1031ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103203:	0f 95 c0             	setne  %al
  103206:	0f b6 c0             	movzbl %al,%eax
  103209:	85 c0                	test   %eax,%eax
  10320b:	75 24                	jne    103231 <buddy_check+0x7a>
  10320d:	c7 44 24 0c 8a 7c 10 	movl   $0x107c8a,0xc(%esp)
  103214:	00 
  103215:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  10321c:	00 
  10321d:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  103224:	00 
  103225:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  10322c:	e8 9e da ff ff       	call   100ccf <__panic>
        count ++, total += p->property;
  103231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103238:	8b 50 08             	mov    0x8(%eax),%edx
  10323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10323e:	01 d0                	add    %edx,%eax
  103240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103246:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103249:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10324c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10324f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103252:	81 7d ec ac b9 11 00 	cmpl   $0x11b9ac,-0x14(%ebp)
  103259:	0f 85 79 ff ff ff    	jne    1031d8 <buddy_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10325f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103262:	e8 5e 1e 00 00       	call   1050c5 <nr_free_pages>
  103267:	39 c3                	cmp    %eax,%ebx
  103269:	74 24                	je     10328f <buddy_check+0xd8>
  10326b:	c7 44 24 0c 9a 7c 10 	movl   $0x107c9a,0xc(%esp)
  103272:	00 
  103273:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  10327a:	00 
  10327b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  103282:	00 
  103283:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  10328a:	e8 40 da ff ff       	call   100ccf <__panic>

    basic_check();
  10328f:	e8 e7 f9 ff ff       	call   102c7b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103294:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10329b:	e8 bb 1d 00 00       	call   10505b <alloc_pages>
  1032a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1032a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032a7:	75 24                	jne    1032cd <buddy_check+0x116>
  1032a9:	c7 44 24 0c b3 7c 10 	movl   $0x107cb3,0xc(%esp)
  1032b0:	00 
  1032b1:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1032b8:	00 
  1032b9:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  1032c0:	00 
  1032c1:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1032c8:	e8 02 da ff ff       	call   100ccf <__panic>
    assert(!PageProperty(p0));
  1032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032d0:	83 c0 04             	add    $0x4,%eax
  1032d3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1032da:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1032dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1032e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1032e3:	0f a3 10             	bt     %edx,(%eax)
  1032e6:	19 c0                	sbb    %eax,%eax
  1032e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1032eb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1032ef:	0f 95 c0             	setne  %al
  1032f2:	0f b6 c0             	movzbl %al,%eax
  1032f5:	85 c0                	test   %eax,%eax
  1032f7:	74 24                	je     10331d <buddy_check+0x166>
  1032f9:	c7 44 24 0c be 7c 10 	movl   $0x107cbe,0xc(%esp)
  103300:	00 
  103301:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103308:	00 
  103309:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  103310:	00 
  103311:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103318:	e8 b2 d9 ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  10331d:	a1 ac b9 11 00       	mov    0x11b9ac,%eax
  103322:	8b 15 b0 b9 11 00    	mov    0x11b9b0,%edx
  103328:	89 45 80             	mov    %eax,-0x80(%ebp)
  10332b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10332e:	c7 45 b4 ac b9 11 00 	movl   $0x11b9ac,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103335:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103338:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10333b:	89 50 04             	mov    %edx,0x4(%eax)
  10333e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103341:	8b 50 04             	mov    0x4(%eax),%edx
  103344:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103347:	89 10                	mov    %edx,(%eax)
  103349:	c7 45 b0 ac b9 11 00 	movl   $0x11b9ac,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103350:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103353:	8b 40 04             	mov    0x4(%eax),%eax
  103356:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103359:	0f 94 c0             	sete   %al
  10335c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10335f:	85 c0                	test   %eax,%eax
  103361:	75 24                	jne    103387 <buddy_check+0x1d0>
  103363:	c7 44 24 0c 13 7c 10 	movl   $0x107c13,0xc(%esp)
  10336a:	00 
  10336b:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103372:	00 
  103373:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  10337a:	00 
  10337b:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103382:	e8 48 d9 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  103387:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10338e:	e8 c8 1c 00 00       	call   10505b <alloc_pages>
  103393:	85 c0                	test   %eax,%eax
  103395:	74 24                	je     1033bb <buddy_check+0x204>
  103397:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  10339e:	00 
  10339f:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1033a6:	00 
  1033a7:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  1033ae:	00 
  1033af:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1033b6:	e8 14 d9 ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  1033bb:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  1033c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1033c3:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  1033ca:	00 00 00 

    free_pages(p0 + 2, 3);
  1033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033d0:	83 c0 28             	add    $0x28,%eax
  1033d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1033da:	00 
  1033db:	89 04 24             	mov    %eax,(%esp)
  1033de:	e8 b0 1c 00 00       	call   105093 <free_pages>
    assert(alloc_pages(4) == NULL);
  1033e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1033ea:	e8 6c 1c 00 00       	call   10505b <alloc_pages>
  1033ef:	85 c0                	test   %eax,%eax
  1033f1:	74 24                	je     103417 <buddy_check+0x260>
  1033f3:	c7 44 24 0c d0 7c 10 	movl   $0x107cd0,0xc(%esp)
  1033fa:	00 
  1033fb:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103402:	00 
  103403:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  10340a:	00 
  10340b:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103412:	e8 b8 d8 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10341a:	83 c0 28             	add    $0x28,%eax
  10341d:	83 c0 04             	add    $0x4,%eax
  103420:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103427:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10342a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10342d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103430:	0f a3 10             	bt     %edx,(%eax)
  103433:	19 c0                	sbb    %eax,%eax
  103435:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103438:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10343c:	0f 95 c0             	setne  %al
  10343f:	0f b6 c0             	movzbl %al,%eax
  103442:	85 c0                	test   %eax,%eax
  103444:	74 0e                	je     103454 <buddy_check+0x29d>
  103446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103449:	83 c0 28             	add    $0x28,%eax
  10344c:	8b 40 08             	mov    0x8(%eax),%eax
  10344f:	83 f8 03             	cmp    $0x3,%eax
  103452:	74 24                	je     103478 <buddy_check+0x2c1>
  103454:	c7 44 24 0c e8 7c 10 	movl   $0x107ce8,0xc(%esp)
  10345b:	00 
  10345c:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103463:	00 
  103464:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  10346b:	00 
  10346c:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103473:	e8 57 d8 ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103478:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10347f:	e8 d7 1b 00 00       	call   10505b <alloc_pages>
  103484:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103487:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10348b:	75 24                	jne    1034b1 <buddy_check+0x2fa>
  10348d:	c7 44 24 0c 14 7d 10 	movl   $0x107d14,0xc(%esp)
  103494:	00 
  103495:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  10349c:	00 
  10349d:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  1034a4:	00 
  1034a5:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1034ac:	e8 1e d8 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  1034b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034b8:	e8 9e 1b 00 00       	call   10505b <alloc_pages>
  1034bd:	85 c0                	test   %eax,%eax
  1034bf:	74 24                	je     1034e5 <buddy_check+0x32e>
  1034c1:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  1034c8:	00 
  1034c9:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1034d0:	00 
  1034d1:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  1034d8:	00 
  1034d9:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1034e0:	e8 ea d7 ff ff       	call   100ccf <__panic>
    assert(p0 + 2 == p1);
  1034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e8:	83 c0 28             	add    $0x28,%eax
  1034eb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1034ee:	74 24                	je     103514 <buddy_check+0x35d>
  1034f0:	c7 44 24 0c 32 7d 10 	movl   $0x107d32,0xc(%esp)
  1034f7:	00 
  1034f8:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1034ff:	00 
  103500:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  103507:	00 
  103508:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  10350f:	e8 bb d7 ff ff       	call   100ccf <__panic>

    p2 = p0 + 1;
  103514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103517:	83 c0 14             	add    $0x14,%eax
  10351a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  10351d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103524:	00 
  103525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103528:	89 04 24             	mov    %eax,(%esp)
  10352b:	e8 63 1b 00 00       	call   105093 <free_pages>
    free_pages(p1, 3);
  103530:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103537:	00 
  103538:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10353b:	89 04 24             	mov    %eax,(%esp)
  10353e:	e8 50 1b 00 00       	call   105093 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103546:	83 c0 04             	add    $0x4,%eax
  103549:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103550:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103553:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103556:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103559:	0f a3 10             	bt     %edx,(%eax)
  10355c:	19 c0                	sbb    %eax,%eax
  10355e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103561:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103565:	0f 95 c0             	setne  %al
  103568:	0f b6 c0             	movzbl %al,%eax
  10356b:	85 c0                	test   %eax,%eax
  10356d:	74 0b                	je     10357a <buddy_check+0x3c3>
  10356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103572:	8b 40 08             	mov    0x8(%eax),%eax
  103575:	83 f8 01             	cmp    $0x1,%eax
  103578:	74 24                	je     10359e <buddy_check+0x3e7>
  10357a:	c7 44 24 0c 40 7d 10 	movl   $0x107d40,0xc(%esp)
  103581:	00 
  103582:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103589:	00 
  10358a:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  103591:	00 
  103592:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103599:	e8 31 d7 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10359e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1035a1:	83 c0 04             	add    $0x4,%eax
  1035a4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1035ab:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035ae:	8b 45 90             	mov    -0x70(%ebp),%eax
  1035b1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1035b4:	0f a3 10             	bt     %edx,(%eax)
  1035b7:	19 c0                	sbb    %eax,%eax
  1035b9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1035bc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1035c0:	0f 95 c0             	setne  %al
  1035c3:	0f b6 c0             	movzbl %al,%eax
  1035c6:	85 c0                	test   %eax,%eax
  1035c8:	74 0b                	je     1035d5 <buddy_check+0x41e>
  1035ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1035cd:	8b 40 08             	mov    0x8(%eax),%eax
  1035d0:	83 f8 03             	cmp    $0x3,%eax
  1035d3:	74 24                	je     1035f9 <buddy_check+0x442>
  1035d5:	c7 44 24 0c 68 7d 10 	movl   $0x107d68,0xc(%esp)
  1035dc:	00 
  1035dd:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1035e4:	00 
  1035e5:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  1035ec:	00 
  1035ed:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1035f4:	e8 d6 d6 ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1035f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103600:	e8 56 1a 00 00       	call   10505b <alloc_pages>
  103605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10360b:	83 e8 14             	sub    $0x14,%eax
  10360e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103611:	74 24                	je     103637 <buddy_check+0x480>
  103613:	c7 44 24 0c 8e 7d 10 	movl   $0x107d8e,0xc(%esp)
  10361a:	00 
  10361b:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103622:	00 
  103623:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  10362a:	00 
  10362b:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103632:	e8 98 d6 ff ff       	call   100ccf <__panic>
    free_page(p0);
  103637:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10363e:	00 
  10363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103642:	89 04 24             	mov    %eax,(%esp)
  103645:	e8 49 1a 00 00       	call   105093 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10364a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103651:	e8 05 1a 00 00       	call   10505b <alloc_pages>
  103656:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103659:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10365c:	83 c0 14             	add    $0x14,%eax
  10365f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103662:	74 24                	je     103688 <buddy_check+0x4d1>
  103664:	c7 44 24 0c ac 7d 10 	movl   $0x107dac,0xc(%esp)
  10366b:	00 
  10366c:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103673:	00 
  103674:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  10367b:	00 
  10367c:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103683:	e8 47 d6 ff ff       	call   100ccf <__panic>

    free_pages(p0, 2);
  103688:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10368f:	00 
  103690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103693:	89 04 24             	mov    %eax,(%esp)
  103696:	e8 f8 19 00 00       	call   105093 <free_pages>
    free_page(p2);
  10369b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036a2:	00 
  1036a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1036a6:	89 04 24             	mov    %eax,(%esp)
  1036a9:	e8 e5 19 00 00       	call   105093 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1036ae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1036b5:	e8 a1 19 00 00       	call   10505b <alloc_pages>
  1036ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1036bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1036c1:	75 24                	jne    1036e7 <buddy_check+0x530>
  1036c3:	c7 44 24 0c cc 7d 10 	movl   $0x107dcc,0xc(%esp)
  1036ca:	00 
  1036cb:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1036d2:	00 
  1036d3:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  1036da:	00 
  1036db:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1036e2:	e8 e8 d5 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  1036e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036ee:	e8 68 19 00 00       	call   10505b <alloc_pages>
  1036f3:	85 c0                	test   %eax,%eax
  1036f5:	74 24                	je     10371b <buddy_check+0x564>
  1036f7:	c7 44 24 0c 2a 7c 10 	movl   $0x107c2a,0xc(%esp)
  1036fe:	00 
  1036ff:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103706:	00 
  103707:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  10370e:	00 
  10370f:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103716:	e8 b4 d5 ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  10371b:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  103720:	85 c0                	test   %eax,%eax
  103722:	74 24                	je     103748 <buddy_check+0x591>
  103724:	c7 44 24 0c 7d 7c 10 	movl   $0x107c7d,0xc(%esp)
  10372b:	00 
  10372c:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  103733:	00 
  103734:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  10373b:	00 
  10373c:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103743:	e8 87 d5 ff ff       	call   100ccf <__panic>
    nr_free = nr_free_store;
  103748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10374b:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4

    free_list = free_list_store;
  103750:	8b 45 80             	mov    -0x80(%ebp),%eax
  103753:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103756:	a3 ac b9 11 00       	mov    %eax,0x11b9ac
  10375b:	89 15 b0 b9 11 00    	mov    %edx,0x11b9b0
    free_pages(p0, 5);
  103761:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103768:	00 
  103769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10376c:	89 04 24             	mov    %eax,(%esp)
  10376f:	e8 1f 19 00 00       	call   105093 <free_pages>

    le = &free_list;
  103774:	c7 45 ec ac b9 11 00 	movl   $0x11b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10377b:	eb 1d                	jmp    10379a <buddy_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  10377d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103780:	83 e8 0c             	sub    $0xc,%eax
  103783:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103786:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10378a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10378d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103790:	8b 40 08             	mov    0x8(%eax),%eax
  103793:	29 c2                	sub    %eax,%edx
  103795:	89 d0                	mov    %edx,%eax
  103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10379a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10379d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1037a0:	8b 45 88             	mov    -0x78(%ebp),%eax
  1037a3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1037a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037a9:	81 7d ec ac b9 11 00 	cmpl   $0x11b9ac,-0x14(%ebp)
  1037b0:	75 cb                	jne    10377d <buddy_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1037b6:	74 24                	je     1037dc <buddy_check+0x625>
  1037b8:	c7 44 24 0c ea 7d 10 	movl   $0x107dea,0xc(%esp)
  1037bf:	00 
  1037c0:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1037c7:	00 
  1037c8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1037cf:	00 
  1037d0:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  1037d7:	e8 f3 d4 ff ff       	call   100ccf <__panic>
    assert(total == 0);
  1037dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037e0:	74 24                	je     103806 <buddy_check+0x64f>
  1037e2:	c7 44 24 0c f5 7d 10 	movl   $0x107df5,0xc(%esp)
  1037e9:	00 
  1037ea:	c7 44 24 08 6d 7a 10 	movl   $0x107a6d,0x8(%esp)
  1037f1:	00 
  1037f2:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  1037f9:	00 
  1037fa:	c7 04 24 82 7a 10 00 	movl   $0x107a82,(%esp)
  103801:	e8 c9 d4 ff ff       	call   100ccf <__panic>
}
  103806:	81 c4 94 00 00 00    	add    $0x94,%esp
  10380c:	5b                   	pop    %ebx
  10380d:	5d                   	pop    %ebp
  10380e:	c3                   	ret    

0010380f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10380f:	55                   	push   %ebp
  103810:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103812:	8b 55 08             	mov    0x8(%ebp),%edx
  103815:	a1 c0 b9 11 00       	mov    0x11b9c0,%eax
  10381a:	29 c2                	sub    %eax,%edx
  10381c:	89 d0                	mov    %edx,%eax
  10381e:	c1 f8 02             	sar    $0x2,%eax
  103821:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103827:	5d                   	pop    %ebp
  103828:	c3                   	ret    

00103829 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103829:	55                   	push   %ebp
  10382a:	89 e5                	mov    %esp,%ebp
  10382c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10382f:	8b 45 08             	mov    0x8(%ebp),%eax
  103832:	89 04 24             	mov    %eax,(%esp)
  103835:	e8 d5 ff ff ff       	call   10380f <page2ppn>
  10383a:	c1 e0 0c             	shl    $0xc,%eax
}
  10383d:	c9                   	leave  
  10383e:	c3                   	ret    

0010383f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10383f:	55                   	push   %ebp
  103840:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103842:	8b 45 08             	mov    0x8(%ebp),%eax
  103845:	8b 00                	mov    (%eax),%eax
}
  103847:	5d                   	pop    %ebp
  103848:	c3                   	ret    

00103849 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103849:	55                   	push   %ebp
  10384a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10384c:	8b 45 08             	mov    0x8(%ebp),%eax
  10384f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103852:	89 10                	mov    %edx,(%eax)
}
  103854:	5d                   	pop    %ebp
  103855:	c3                   	ret    

00103856 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  103856:	55                   	push   %ebp
  103857:	89 e5                	mov    %esp,%ebp
  103859:	83 ec 10             	sub    $0x10,%esp
  10385c:	c7 45 fc ac b9 11 00 	movl   $0x11b9ac,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103866:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103869:	89 50 04             	mov    %edx,0x4(%eax)
  10386c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10386f:	8b 50 04             	mov    0x4(%eax),%edx
  103872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103875:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  103877:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  10387e:	00 00 00 
}
  103881:	c9                   	leave  
  103882:	c3                   	ret    

00103883 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {    
  103883:	55                   	push   %ebp
  103884:	89 e5                	mov    %esp,%ebp
  103886:	83 ec 68             	sub    $0x68,%esp
    cprintf("Memmap: 0x%x, size %d\n", base, n);
  103889:	8b 45 0c             	mov    0xc(%ebp),%eax
  10388c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103890:	8b 45 08             	mov    0x8(%ebp),%eax
  103893:	89 44 24 04          	mov    %eax,0x4(%esp)
  103897:	c7 04 24 30 7e 10 00 	movl   $0x107e30,(%esp)
  10389e:	e8 a0 ca ff ff       	call   100343 <cprintf>
    // n must be a positive number
    assert(n > 0);
  1038a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1038a7:	75 24                	jne    1038cd <default_init_memmap+0x4a>
  1038a9:	c7 44 24 0c 47 7e 10 	movl   $0x107e47,0xc(%esp)
  1038b0:	00 
  1038b1:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1038b8:	00 
  1038b9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1038c0:	00 
  1038c1:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1038c8:	e8 02 d4 ff ff       	call   100ccf <__panic>

    struct Page *ptr = base;
  1038cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1038d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ptr < base + n; ptr++) {
  1038d3:	e9 a3 00 00 00       	jmp    10397b <default_init_memmap+0xf8>
        assert(PageReserved(ptr));
  1038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038db:	83 c0 04             	add    $0x4,%eax
  1038de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1038e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1038e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1038ee:	0f a3 10             	bt     %edx,(%eax)
  1038f1:	19 c0                	sbb    %eax,%eax
  1038f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1038f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1038fa:	0f 95 c0             	setne  %al
  1038fd:	0f b6 c0             	movzbl %al,%eax
  103900:	85 c0                	test   %eax,%eax
  103902:	75 24                	jne    103928 <default_init_memmap+0xa5>
  103904:	c7 44 24 0c 78 7e 10 	movl   $0x107e78,0xc(%esp)
  10390b:	00 
  10390c:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  103913:	00 
  103914:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  10391b:	00 
  10391c:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  103923:	e8 a7 d3 ff ff       	call   100ccf <__panic>
        // clear flags
        ClearPageProperty(ptr);
  103928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10392b:	83 c0 04             	add    $0x4,%eax
  10392e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  103935:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10393b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10393e:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
  103941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103944:	83 c0 04             	add    $0x4,%eax
  103947:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10394e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103951:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103954:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103957:	0f b3 10             	btr    %edx,(%eax)
        // no reference
        set_page_ref(ptr, 0);
  10395a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103961:	00 
  103962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103965:	89 04 24             	mov    %eax,(%esp)
  103968:	e8 dc fe ff ff       	call   103849 <set_page_ref>
        ptr->property = 0;
  10396d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103970:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    cprintf("Memmap: 0x%x, size %d\n", base, n);
    // n must be a positive number
    assert(n > 0);

    struct Page *ptr = base;
    for (; ptr < base + n; ptr++) {
  103977:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10397b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10397e:	89 d0                	mov    %edx,%eax
  103980:	c1 e0 02             	shl    $0x2,%eax
  103983:	01 d0                	add    %edx,%eax
  103985:	c1 e0 02             	shl    $0x2,%eax
  103988:	89 c2                	mov    %eax,%edx
  10398a:	8b 45 08             	mov    0x8(%ebp),%eax
  10398d:	01 d0                	add    %edx,%eax
  10398f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103992:	0f 87 40 ff ff ff    	ja     1038d8 <default_init_memmap+0x55>
        // no reference
        set_page_ref(ptr, 0);
        ptr->property = 0;
    }
    // set bit and property of the first page
    SetPageProperty(base);
  103998:	8b 45 08             	mov    0x8(%ebp),%eax
  10399b:	83 c0 04             	add    $0x4,%eax
  10399e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1039a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1039a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1039ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1039ae:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  1039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1039b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1039b7:	89 50 08             	mov    %edx,0x8(%eax)
    
    nr_free += n;
  1039ba:	8b 15 b4 b9 11 00    	mov    0x11b9b4,%edx
  1039c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039c3:	01 d0                	add    %edx,%eax
  1039c5:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4
    list_add(&free_list, &(base->page_link));
  1039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cd:	83 c0 0c             	add    $0xc,%eax
  1039d0:	c7 45 cc ac b9 11 00 	movl   $0x11b9ac,-0x34(%ebp)
  1039d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1039da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1039dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1039e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1039e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1039e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1039e9:	8b 40 04             	mov    0x4(%eax),%eax
  1039ec:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1039ef:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1039f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1039f5:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1039f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1039fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1039fe:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103a01:	89 10                	mov    %edx,(%eax)
  103a03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103a06:	8b 10                	mov    (%eax),%edx
  103a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103a0b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103a0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103a11:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103a14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103a17:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103a1a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103a1d:	89 10                	mov    %edx,(%eax)
}
  103a1f:	c9                   	leave  
  103a20:	c3                   	ret    

00103a21 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  103a21:	55                   	push   %ebp
  103a22:	89 e5                	mov    %esp,%ebp
  103a24:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  103a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103a2b:	75 24                	jne    103a51 <default_alloc_pages+0x30>
  103a2d:	c7 44 24 0c 47 7e 10 	movl   $0x107e47,0xc(%esp)
  103a34:	00 
  103a35:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  103a3c:	00 
  103a3d:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  103a44:	00 
  103a45:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  103a4c:	e8 7e d2 ff ff       	call   100ccf <__panic>
    if (n > nr_free) {
  103a51:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  103a56:	3b 45 08             	cmp    0x8(%ebp),%eax
  103a59:	73 0a                	jae    103a65 <default_alloc_pages+0x44>
        return NULL;
  103a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  103a60:	e9 7b 01 00 00       	jmp    103be0 <default_alloc_pages+0x1bf>
    }

    struct Page *p = NULL;
  103a65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103a6c:	c7 45 f4 ac b9 11 00 	movl   $0x11b9ac,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103a73:	eb 21                	jmp    103a96 <default_alloc_pages+0x75>
        p = le2page(le, page_link);
  103a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a78:	83 e8 0c             	sub    $0xc,%eax
  103a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->property >= n) {
  103a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a81:	8b 40 08             	mov    0x8(%eax),%eax
  103a84:	3b 45 08             	cmp    0x8(%ebp),%eax
  103a87:	72 0d                	jb     103a96 <default_alloc_pages+0x75>
            goto can_alloc;
  103a89:	90                   	nop
        }
    }
    return NULL;
can_alloc:
    if (p != NULL) {
  103a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a8e:	0f 84 49 01 00 00    	je     103bdd <default_alloc_pages+0x1bc>
  103a94:	eb 22                	jmp    103ab8 <default_alloc_pages+0x97>
  103a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a99:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a9f:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aa5:	81 7d f4 ac b9 11 00 	cmpl   $0x11b9ac,-0xc(%ebp)
  103aac:	75 c7                	jne    103a75 <default_alloc_pages+0x54>
        p = le2page(le, page_link);
        if (p->property >= n) {
            goto can_alloc;
        }
    }
    return NULL;
  103aae:	b8 00 00 00 00       	mov    $0x0,%eax
  103ab3:	e9 28 01 00 00       	jmp    103be0 <default_alloc_pages+0x1bf>
can_alloc:
    if (p != NULL) {
        list_entry_t *tmp = list_next(&(p->page_link));
  103ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103abb:	83 c0 0c             	add    $0xc,%eax
  103abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ac4:	8b 40 04             	mov    0x4(%eax),%eax
  103ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // adjust the free block list
        list_del(&(p->page_link));
  103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103acd:	83 c0 0c             	add    $0xc,%eax
  103ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ad6:	8b 40 04             	mov    0x4(%eax),%eax
  103ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103adc:	8b 12                	mov    (%edx),%edx
  103ade:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103ae4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ae7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103aea:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103aed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103af3:	89 10                	mov    %edx,(%eax)
        if (p->property > n) {
  103af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103af8:	8b 40 08             	mov    0x8(%eax),%eax
  103afb:	3b 45 08             	cmp    0x8(%ebp),%eax
  103afe:	0f 86 a2 00 00 00    	jbe    103ba6 <default_alloc_pages+0x185>
            // set head page of the new free bloc
            SetPageProperty(p + n);
  103b04:	8b 55 08             	mov    0x8(%ebp),%edx
  103b07:	89 d0                	mov    %edx,%eax
  103b09:	c1 e0 02             	shl    $0x2,%eax
  103b0c:	01 d0                	add    %edx,%eax
  103b0e:	c1 e0 02             	shl    $0x2,%eax
  103b11:	89 c2                	mov    %eax,%edx
  103b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b16:	01 d0                	add    %edx,%eax
  103b18:	83 c0 04             	add    $0x4,%eax
  103b1b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  103b22:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103b28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103b2b:	0f ab 10             	bts    %edx,(%eax)
            (p + n)->property = p->property - n;
  103b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  103b31:	89 d0                	mov    %edx,%eax
  103b33:	c1 e0 02             	shl    $0x2,%eax
  103b36:	01 d0                	add    %edx,%eax
  103b38:	c1 e0 02             	shl    $0x2,%eax
  103b3b:	89 c2                	mov    %eax,%edx
  103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b40:	01 c2                	add    %eax,%edx
  103b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b45:	8b 40 08             	mov    0x8(%eax),%eax
  103b48:	2b 45 08             	sub    0x8(%ebp),%eax
  103b4b:	89 42 08             	mov    %eax,0x8(%edx)
            list_add_before(tmp, &((p+n)->page_link));
  103b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  103b51:	89 d0                	mov    %edx,%eax
  103b53:	c1 e0 02             	shl    $0x2,%eax
  103b56:	01 d0                	add    %edx,%eax
  103b58:	c1 e0 02             	shl    $0x2,%eax
  103b5b:	89 c2                	mov    %eax,%edx
  103b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b60:	01 d0                	add    %edx,%eax
  103b62:	8d 50 0c             	lea    0xc(%eax),%edx
  103b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b68:	89 45 cc             	mov    %eax,-0x34(%ebp)
  103b6b:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103b6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103b71:	8b 00                	mov    (%eax),%eax
  103b73:	8b 55 c8             	mov    -0x38(%ebp),%edx
  103b76:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  103b79:	89 45 c0             	mov    %eax,-0x40(%ebp)
  103b7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103b7f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103b82:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103b85:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103b88:	89 10                	mov    %edx,(%eax)
  103b8a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103b8d:	8b 10                	mov    (%eax),%edx
  103b8f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103b92:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103b95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103b98:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103b9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103b9e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ba1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103ba4:	89 10                	mov    %edx,(%eax)
        }
        // set bits of the allocated pages
        ClearPageProperty(p);
  103ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ba9:	83 c0 04             	add    $0x4,%eax
  103bac:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  103bb3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103bb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103bb9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103bbc:	0f b3 10             	btr    %edx,(%eax)
        p->property -= n; 
  103bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bc2:	8b 40 08             	mov    0x8(%eax),%eax
  103bc5:	2b 45 08             	sub    0x8(%ebp),%eax
  103bc8:	89 c2                	mov    %eax,%edx
  103bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bcd:	89 50 08             	mov    %edx,0x8(%eax)
        nr_free -= n;
  103bd0:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  103bd5:	2b 45 08             	sub    0x8(%ebp),%eax
  103bd8:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4
    }
    return p;
  103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103be0:	c9                   	leave  
  103be1:	c3                   	ret    

00103be2 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  103be2:	55                   	push   %ebp
  103be3:	89 e5                	mov    %esp,%ebp
  103be5:	81 ec d8 00 00 00    	sub    $0xd8,%esp
    assert(n > 0);
  103beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103bef:	75 24                	jne    103c15 <default_free_pages+0x33>
  103bf1:	c7 44 24 0c 47 7e 10 	movl   $0x107e47,0xc(%esp)
  103bf8:	00 
  103bf9:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  103c00:	00 
  103c01:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  103c08:	00 
  103c09:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  103c10:	e8 ba d0 ff ff       	call   100ccf <__panic>
    struct Page *ptr = base, *next = NULL;
  103c15:	8b 45 08             	mov    0x8(%ebp),%eax
  103c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (; ptr < base + n; ptr++) {
  103c22:	e9 c5 00 00 00       	jmp    103cec <default_free_pages+0x10a>
        // reset all pages that needs to be free
        assert(!PageReserved(ptr) && !PageProperty(ptr));
  103c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c2a:	83 c0 04             	add    $0x4,%eax
  103c2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  103c34:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103c3d:	0f a3 10             	bt     %edx,(%eax)
  103c40:	19 c0                	sbb    %eax,%eax
  103c42:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  103c45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103c49:	0f 95 c0             	setne  %al
  103c4c:	0f b6 c0             	movzbl %al,%eax
  103c4f:	85 c0                	test   %eax,%eax
  103c51:	75 2c                	jne    103c7f <default_free_pages+0x9d>
  103c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c56:	83 c0 04             	add    $0x4,%eax
  103c59:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  103c60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103c66:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103c69:	0f a3 10             	bt     %edx,(%eax)
  103c6c:	19 c0                	sbb    %eax,%eax
  103c6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  103c71:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  103c75:	0f 95 c0             	setne  %al
  103c78:	0f b6 c0             	movzbl %al,%eax
  103c7b:	85 c0                	test   %eax,%eax
  103c7d:	74 24                	je     103ca3 <default_free_pages+0xc1>
  103c7f:	c7 44 24 0c 8c 7e 10 	movl   $0x107e8c,0xc(%esp)
  103c86:	00 
  103c87:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  103c8e:	00 
  103c8f:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  103c96:	00 
  103c97:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  103c9e:	e8 2c d0 ff ff       	call   100ccf <__panic>
        ClearPageProperty(ptr);
  103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ca6:	83 c0 04             	add    $0x4,%eax
  103ca9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  103cb0:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103cb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103cb6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103cb9:	0f b3 10             	btr    %edx,(%eax)
        ClearPageReserved(ptr);
  103cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cbf:	83 c0 04             	add    $0x4,%eax
  103cc2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  103cc9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  103ccc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103ccf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103cd2:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(ptr, 0);
  103cd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cdc:	00 
  103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce0:	89 04 24             	mov    %eax,(%esp)
  103ce3:	e8 61 fb ff ff       	call   103849 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *ptr = base, *next = NULL;
    for (; ptr < base + n; ptr++) {
  103ce8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  103cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cef:	89 d0                	mov    %edx,%eax
  103cf1:	c1 e0 02             	shl    $0x2,%eax
  103cf4:	01 d0                	add    %edx,%eax
  103cf6:	c1 e0 02             	shl    $0x2,%eax
  103cf9:	89 c2                	mov    %eax,%edx
  103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  103cfe:	01 d0                	add    %edx,%eax
  103d00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d03:	0f 87 1e ff ff ff    	ja     103c27 <default_free_pages+0x45>
        ClearPageProperty(ptr);
        ClearPageReserved(ptr);
        set_page_ref(ptr, 0);
    }
    // reset head page of the block
    base->property = n;
  103d09:	8b 45 08             	mov    0x8(%ebp),%eax
  103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  103d12:	8b 45 08             	mov    0x8(%ebp),%eax
  103d15:	83 c0 04             	add    $0x4,%eax
  103d18:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  103d1f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103d22:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d25:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d28:	0f ab 10             	bts    %edx,(%eax)
    // check if this block can be merged with another block
    list_entry_t *le = &free_list, *tmp = NULL;
  103d2b:	c7 45 f0 ac b9 11 00 	movl   $0x11b9ac,-0x10(%ebp)
  103d32:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103d39:	e9 b1 02 00 00       	jmp    103fef <default_free_pages+0x40d>
        ptr = le2page(le, page_link);
  103d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d41:	83 e8 0c             	sub    $0xc,%eax
  103d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptr + ptr->property == base) {
  103d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d4a:	8b 50 08             	mov    0x8(%eax),%edx
  103d4d:	89 d0                	mov    %edx,%eax
  103d4f:	c1 e0 02             	shl    $0x2,%eax
  103d52:	01 d0                	add    %edx,%eax
  103d54:	c1 e0 02             	shl    $0x2,%eax
  103d57:	89 c2                	mov    %eax,%edx
  103d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d5c:	01 d0                	add    %edx,%eax
  103d5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  103d61:	0f 85 cc 00 00 00    	jne    103e33 <default_free_pages+0x251>
            // merge after this block
            ptr->property += base->property;
  103d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d6a:	8b 50 08             	mov    0x8(%eax),%edx
  103d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d70:	8b 40 08             	mov    0x8(%eax),%eax
  103d73:	01 c2                	add    %eax,%edx
  103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d78:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  103d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d7e:	83 c0 04             	add    $0x4,%eax
  103d81:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  103d88:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103d8b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103d8e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103d91:	0f b3 10             	btr    %edx,(%eax)
            // check if next block can also be merged
            tmp = list_next(&(ptr->page_link));
  103d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d97:	83 c0 0c             	add    $0xc,%eax
  103d9a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103d9d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103da0:	8b 40 04             	mov    0x4(%eax),%eax
  103da3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            next = le2page(tmp, page_link);
  103da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103da9:	83 e8 0c             	sub    $0xc,%eax
  103dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (tmp != &free_list && base + base->property == next) {
  103daf:	81 7d e8 ac b9 11 00 	cmpl   $0x11b9ac,-0x18(%ebp)
  103db6:	74 76                	je     103e2e <default_free_pages+0x24c>
  103db8:	8b 45 08             	mov    0x8(%ebp),%eax
  103dbb:	8b 50 08             	mov    0x8(%eax),%edx
  103dbe:	89 d0                	mov    %edx,%eax
  103dc0:	c1 e0 02             	shl    $0x2,%eax
  103dc3:	01 d0                	add    %edx,%eax
  103dc5:	c1 e0 02             	shl    $0x2,%eax
  103dc8:	89 c2                	mov    %eax,%edx
  103dca:	8b 45 08             	mov    0x8(%ebp),%eax
  103dcd:	01 d0                	add    %edx,%eax
  103dcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103dd2:	75 5a                	jne    103e2e <default_free_pages+0x24c>
                ptr->property += next->property;
  103dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dd7:	8b 50 08             	mov    0x8(%eax),%edx
  103dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ddd:	8b 40 08             	mov    0x8(%eax),%eax
  103de0:	01 c2                	add    %eax,%edx
  103de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103de5:	89 50 08             	mov    %edx,0x8(%eax)
                ClearPageProperty(next);
  103de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103deb:	83 c0 04             	add    $0x4,%eax
  103dee:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  103df5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103df8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103dfb:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103dfe:	0f b3 10             	btr    %edx,(%eax)
  103e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103e04:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103e07:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103e0a:	8b 40 04             	mov    0x4(%eax),%eax
  103e0d:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103e10:	8b 12                	mov    (%edx),%edx
  103e12:	89 55 9c             	mov    %edx,-0x64(%ebp)
  103e15:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103e18:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103e1b:	8b 55 98             	mov    -0x68(%ebp),%edx
  103e1e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103e21:	8b 45 98             	mov    -0x68(%ebp),%eax
  103e24:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103e27:	89 10                	mov    %edx,(%eax)
                list_del(tmp);
            }
            goto done;
  103e29:	e9 5b 02 00 00       	jmp    104089 <default_free_pages+0x4a7>
  103e2e:	e9 56 02 00 00       	jmp    104089 <default_free_pages+0x4a7>
        } else if (base + base->property == ptr) {
  103e33:	8b 45 08             	mov    0x8(%ebp),%eax
  103e36:	8b 50 08             	mov    0x8(%eax),%edx
  103e39:	89 d0                	mov    %edx,%eax
  103e3b:	c1 e0 02             	shl    $0x2,%eax
  103e3e:	01 d0                	add    %edx,%eax
  103e40:	c1 e0 02             	shl    $0x2,%eax
  103e43:	89 c2                	mov    %eax,%edx
  103e45:	8b 45 08             	mov    0x8(%ebp),%eax
  103e48:	01 d0                	add    %edx,%eax
  103e4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103e4d:	0f 85 e6 00 00 00    	jne    103f39 <default_free_pages+0x357>
            // merge before this block
            base->property += ptr->property;
  103e53:	8b 45 08             	mov    0x8(%ebp),%eax
  103e56:	8b 50 08             	mov    0x8(%eax),%edx
  103e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e5c:	8b 40 08             	mov    0x8(%eax),%eax
  103e5f:	01 c2                	add    %eax,%edx
  103e61:	8b 45 08             	mov    0x8(%ebp),%eax
  103e64:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(ptr);
  103e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e6a:	83 c0 04             	add    $0x4,%eax
  103e6d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103e74:	89 45 90             	mov    %eax,-0x70(%ebp)
  103e77:	8b 45 90             	mov    -0x70(%ebp),%eax
  103e7a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103e7d:	0f b3 10             	btr    %edx,(%eax)
            // need to set up free_list
            tmp = list_next(&(ptr->page_link));
  103e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e83:	83 c0 0c             	add    $0xc,%eax
  103e86:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103e89:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103e8c:	8b 40 04             	mov    0x4(%eax),%eax
  103e8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            list_del(&(ptr->page_link));
  103e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e95:	83 c0 0c             	add    $0xc,%eax
  103e98:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103e9b:	8b 45 88             	mov    -0x78(%ebp),%eax
  103e9e:	8b 40 04             	mov    0x4(%eax),%eax
  103ea1:	8b 55 88             	mov    -0x78(%ebp),%edx
  103ea4:	8b 12                	mov    (%edx),%edx
  103ea6:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103ea9:	89 45 80             	mov    %eax,-0x80(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103eac:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103eaf:	8b 55 80             	mov    -0x80(%ebp),%edx
  103eb2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103eb5:	8b 45 80             	mov    -0x80(%ebp),%eax
  103eb8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103ebb:	89 10                	mov    %edx,(%eax)
            list_add_before(tmp, &(base->page_link));
  103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  103ec0:	8d 50 0c             	lea    0xc(%eax),%edx
  103ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103ec6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103ecc:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103ed2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103ed8:	8b 00                	mov    (%eax),%eax
  103eda:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  103ee0:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
  103ee6:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  103eec:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103ef2:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103ef8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  103efe:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  103f04:	89 10                	mov    %edx,(%eax)
  103f06:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  103f0c:	8b 10                	mov    (%eax),%edx
  103f0e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  103f14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103f17:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  103f1d:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  103f23:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103f26:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  103f2c:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  103f32:	89 10                	mov    %edx,(%eax)
            goto done;
  103f34:	e9 50 01 00 00       	jmp    104089 <default_free_pages+0x4a7>
        } else if (ptr > base) {
  103f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  103f3f:	0f 86 aa 00 00 00    	jbe    103fef <default_free_pages+0x40d>
            tmp = list_prev(&(ptr->page_link));
  103f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f48:	83 c0 0c             	add    $0xc,%eax
  103f4b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  103f51:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  103f57:	8b 00                	mov    (%eax),%eax
  103f59:	89 45 e8             	mov    %eax,-0x18(%ebp)
            // addr boundary check
            if (tmp == &free_list || le2page(tmp, page_link) < ptr) {
  103f5c:	81 7d e8 ac b9 11 00 	cmpl   $0x11b9ac,-0x18(%ebp)
  103f63:	74 0b                	je     103f70 <default_free_pages+0x38e>
  103f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103f68:	83 e8 0c             	sub    $0xc,%eax
  103f6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103f6e:	73 7f                	jae    103fef <default_free_pages+0x40d>
                // independent block donot need to merge, just simply insert
                list_add_before(&(ptr->page_link), &(base->page_link));
  103f70:	8b 45 08             	mov    0x8(%ebp),%eax
  103f73:	83 c0 0c             	add    $0xc,%eax
  103f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f79:	83 c2 0c             	add    $0xc,%edx
  103f7c:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
  103f82:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103f88:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  103f8e:	8b 00                	mov    (%eax),%eax
  103f90:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  103f96:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  103f9c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  103fa2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  103fa8:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103fae:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  103fb4:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  103fba:	89 10                	mov    %edx,(%eax)
  103fbc:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  103fc2:	8b 10                	mov    (%eax),%edx
  103fc4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  103fca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103fcd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  103fd3:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  103fd9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103fdc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  103fe2:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  103fe8:	89 10                	mov    %edx,(%eax)
                goto done;
  103fea:	e9 9a 00 00 00       	jmp    104089 <default_free_pages+0x4a7>
  103fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ff2:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103ff8:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  103ffe:	8b 40 04             	mov    0x4(%eax),%eax
    // reset head page of the block
    base->property = n;
    SetPageProperty(base);
    // check if this block can be merged with another block
    list_entry_t *le = &free_list, *tmp = NULL;
    while ((le = list_next(le)) != &free_list) {
  104001:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104004:	81 7d f0 ac b9 11 00 	cmpl   $0x11b9ac,-0x10(%ebp)
  10400b:	0f 85 2d fd ff ff    	jne    103d3e <default_free_pages+0x15c>
            }
        }
    }
    // this block cannot be merged with any blocks, and it has the biggest addr
    // then insert to the end of the list
    list_add_before(&free_list, &(base->page_link));
  104011:	8b 45 08             	mov    0x8(%ebp),%eax
  104014:	83 c0 0c             	add    $0xc,%eax
  104017:	c7 85 4c ff ff ff ac 	movl   $0x11b9ac,-0xb4(%ebp)
  10401e:	b9 11 00 
  104021:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104027:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  10402d:	8b 00                	mov    (%eax),%eax
  10402f:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  104035:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
  10403b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  104041:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  104047:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10404d:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  104053:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  104059:	89 10                	mov    %edx,(%eax)
  10405b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  104061:	8b 10                	mov    (%eax),%edx
  104063:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  104069:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10406c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  104072:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  104078:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10407b:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  104081:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  104087:	89 10                	mov    %edx,(%eax)
done:
    nr_free += n;
  104089:	8b 15 b4 b9 11 00    	mov    0x11b9b4,%edx
  10408f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104092:	01 d0                	add    %edx,%eax
  104094:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4
}
  104099:	c9                   	leave  
  10409a:	c3                   	ret    

0010409b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10409b:	55                   	push   %ebp
  10409c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10409e:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
}
  1040a3:	5d                   	pop    %ebp
  1040a4:	c3                   	ret    

001040a5 <output_free_list>:

static void
output_free_list(void) {
  1040a5:	55                   	push   %ebp
  1040a6:	89 e5                	mov    %esp,%ebp
  1040a8:	57                   	push   %edi
  1040a9:	56                   	push   %esi
  1040aa:	53                   	push   %ebx
  1040ab:	83 ec 5c             	sub    $0x5c,%esp
    int index = 0;
  1040ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    struct Page *p = NULL;
  1040b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    list_entry_t *le = &free_list;
  1040bc:	c7 45 e0 ac b9 11 00 	movl   $0x11b9ac,-0x20(%ebp)
    cprintf("free_list: NR_FREE %d\n", nr_free);
  1040c3:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  1040c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040cc:	c7 04 24 b5 7e 10 00 	movl   $0x107eb5,(%esp)
  1040d3:	e8 6b c2 ff ff       	call   100343 <cprintf>
    while ((le = list_next(le)) != &free_list) {
  1040d8:	e9 98 00 00 00       	jmp    104175 <output_free_list+0xd0>
        p = le2page(le, page_link);
  1040dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040e0:	83 e8 0c             	sub    $0xc,%eax
  1040e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
  1040e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040e9:	83 c0 04             	add    $0x4,%eax
  1040ec:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  1040f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1040f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1040fc:	0f a3 10             	bt     %edx,(%eax)
  1040ff:	19 c0                	sbb    %eax,%eax
  104101:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  104104:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  104108:	0f 95 c0             	setne  %al
  10410b:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
  10410e:	89 c6                	mov    %eax,%esi
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
  104110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104113:	83 c0 04             	add    $0x4,%eax
  104116:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  10411d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104120:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104123:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104126:	0f a3 10             	bt     %edx,(%eax)
  104129:	19 c0                	sbb    %eax,%eax
  10412b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  10412e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104132:	0f 95 c0             	setne  %al
  104135:	0f b6 c0             	movzbl %al,%eax
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
  104138:	89 c3                	mov    %eax,%ebx
  10413a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10413d:	8b 48 08             	mov    0x8(%eax),%ecx
  104140:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104143:	8b 10                	mov    (%eax),%edx
  104145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104148:	8d 78 01             	lea    0x1(%eax),%edi
  10414b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  10414e:	89 74 24 18          	mov    %esi,0x18(%esp)
  104152:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  104156:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10415a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10415e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104161:	89 54 24 08          	mov    %edx,0x8(%esp)
  104165:	89 44 24 04          	mov    %eax,0x4(%esp)
  104169:	c7 04 24 cc 7e 10 00 	movl   $0x107ecc,(%esp)
  104170:	e8 ce c1 ff ff       	call   100343 <cprintf>
  104175:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104178:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10417b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10417e:	8b 40 04             	mov    0x4(%eax),%eax
output_free_list(void) {
    int index = 0;
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    cprintf("free_list: NR_FREE %d\n", nr_free);
    while ((le = list_next(le)) != &free_list) {
  104181:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104184:	81 7d e0 ac b9 11 00 	cmpl   $0x11b9ac,-0x20(%ebp)
  10418b:	0f 85 4c ff ff ff    	jne    1040dd <output_free_list+0x38>
        p = le2page(le, page_link);
        cprintf("  [%02d:%p] ref: %d, property: %u, PG_reserved: %d, PG_property: %d\n",
            index++, p, p->ref, p->property, PageReserved(p), PageProperty(p));
    }
}
  104191:	83 c4 5c             	add    $0x5c,%esp
  104194:	5b                   	pop    %ebx
  104195:	5e                   	pop    %esi
  104196:	5f                   	pop    %edi
  104197:	5d                   	pop    %ebp
  104198:	c3                   	ret    

00104199 <basic_check>:

static void
basic_check(void) {
  104199:	55                   	push   %ebp
  10419a:	89 e5                	mov    %esp,%ebp
  10419c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10419f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1041ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1041b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1041b9:	e8 9d 0e 00 00       	call   10505b <alloc_pages>
  1041be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1041c5:	75 24                	jne    1041eb <basic_check+0x52>
  1041c7:	c7 44 24 0c 11 7f 10 	movl   $0x107f11,0xc(%esp)
  1041ce:	00 
  1041cf:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1041d6:	00 
  1041d7:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  1041de:	00 
  1041df:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1041e6:	e8 e4 ca ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  1041eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1041f2:	e8 64 0e 00 00       	call   10505b <alloc_pages>
  1041f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1041fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1041fe:	75 24                	jne    104224 <basic_check+0x8b>
  104200:	c7 44 24 0c 2d 7f 10 	movl   $0x107f2d,0xc(%esp)
  104207:	00 
  104208:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10420f:	00 
  104210:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104217:	00 
  104218:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10421f:	e8 ab ca ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  104224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10422b:	e8 2b 0e 00 00       	call   10505b <alloc_pages>
  104230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104237:	75 24                	jne    10425d <basic_check+0xc4>
  104239:	c7 44 24 0c 49 7f 10 	movl   $0x107f49,0xc(%esp)
  104240:	00 
  104241:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104248:	00 
  104249:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104250:	00 
  104251:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104258:	e8 72 ca ff ff       	call   100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10425d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104260:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104263:	74 10                	je     104275 <basic_check+0xdc>
  104265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104268:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10426b:	74 08                	je     104275 <basic_check+0xdc>
  10426d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104270:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104273:	75 24                	jne    104299 <basic_check+0x100>
  104275:	c7 44 24 0c 68 7f 10 	movl   $0x107f68,0xc(%esp)
  10427c:	00 
  10427d:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104284:	00 
  104285:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  10428c:	00 
  10428d:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104294:	e8 36 ca ff ff       	call   100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10429c:	89 04 24             	mov    %eax,(%esp)
  10429f:	e8 9b f5 ff ff       	call   10383f <page_ref>
  1042a4:	85 c0                	test   %eax,%eax
  1042a6:	75 1e                	jne    1042c6 <basic_check+0x12d>
  1042a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042ab:	89 04 24             	mov    %eax,(%esp)
  1042ae:	e8 8c f5 ff ff       	call   10383f <page_ref>
  1042b3:	85 c0                	test   %eax,%eax
  1042b5:	75 0f                	jne    1042c6 <basic_check+0x12d>
  1042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ba:	89 04 24             	mov    %eax,(%esp)
  1042bd:	e8 7d f5 ff ff       	call   10383f <page_ref>
  1042c2:	85 c0                	test   %eax,%eax
  1042c4:	74 24                	je     1042ea <basic_check+0x151>
  1042c6:	c7 44 24 0c 8c 7f 10 	movl   $0x107f8c,0xc(%esp)
  1042cd:	00 
  1042ce:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1042d5:	00 
  1042d6:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  1042dd:	00 
  1042de:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1042e5:	e8 e5 c9 ff ff       	call   100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1042ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042ed:	89 04 24             	mov    %eax,(%esp)
  1042f0:	e8 34 f5 ff ff       	call   103829 <page2pa>
  1042f5:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  1042fb:	c1 e2 0c             	shl    $0xc,%edx
  1042fe:	39 d0                	cmp    %edx,%eax
  104300:	72 24                	jb     104326 <basic_check+0x18d>
  104302:	c7 44 24 0c c8 7f 10 	movl   $0x107fc8,0xc(%esp)
  104309:	00 
  10430a:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104311:	00 
  104312:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  104319:	00 
  10431a:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104321:	e8 a9 c9 ff ff       	call   100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104329:	89 04 24             	mov    %eax,(%esp)
  10432c:	e8 f8 f4 ff ff       	call   103829 <page2pa>
  104331:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  104337:	c1 e2 0c             	shl    $0xc,%edx
  10433a:	39 d0                	cmp    %edx,%eax
  10433c:	72 24                	jb     104362 <basic_check+0x1c9>
  10433e:	c7 44 24 0c e5 7f 10 	movl   $0x107fe5,0xc(%esp)
  104345:	00 
  104346:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10434d:	00 
  10434e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104355:	00 
  104356:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10435d:	e8 6d c9 ff ff       	call   100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104365:	89 04 24             	mov    %eax,(%esp)
  104368:	e8 bc f4 ff ff       	call   103829 <page2pa>
  10436d:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  104373:	c1 e2 0c             	shl    $0xc,%edx
  104376:	39 d0                	cmp    %edx,%eax
  104378:	72 24                	jb     10439e <basic_check+0x205>
  10437a:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  104381:	00 
  104382:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104389:	00 
  10438a:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  104391:	00 
  104392:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104399:	e8 31 c9 ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  10439e:	a1 ac b9 11 00       	mov    0x11b9ac,%eax
  1043a3:	8b 15 b0 b9 11 00    	mov    0x11b9b0,%edx
  1043a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1043ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1043af:	c7 45 e0 ac b9 11 00 	movl   $0x11b9ac,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1043b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043bc:	89 50 04             	mov    %edx,0x4(%eax)
  1043bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043c2:	8b 50 04             	mov    0x4(%eax),%edx
  1043c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043c8:	89 10                	mov    %edx,(%eax)
  1043ca:	c7 45 dc ac b9 11 00 	movl   $0x11b9ac,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1043d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043d4:	8b 40 04             	mov    0x4(%eax),%eax
  1043d7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1043da:	0f 94 c0             	sete   %al
  1043dd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1043e0:	85 c0                	test   %eax,%eax
  1043e2:	75 24                	jne    104408 <basic_check+0x26f>
  1043e4:	c7 44 24 0c 1f 80 10 	movl   $0x10801f,0xc(%esp)
  1043eb:	00 
  1043ec:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1043f3:	00 
  1043f4:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1043fb:	00 
  1043fc:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104403:	e8 c7 c8 ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  104408:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  10440d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104410:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  104417:	00 00 00 

    assert(alloc_page() == NULL);
  10441a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104421:	e8 35 0c 00 00       	call   10505b <alloc_pages>
  104426:	85 c0                	test   %eax,%eax
  104428:	74 24                	je     10444e <basic_check+0x2b5>
  10442a:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  104431:	00 
  104432:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104439:	00 
  10443a:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104441:	00 
  104442:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104449:	e8 81 c8 ff ff       	call   100ccf <__panic>

    free_page(p0);
  10444e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104455:	00 
  104456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104459:	89 04 24             	mov    %eax,(%esp)
  10445c:	e8 32 0c 00 00       	call   105093 <free_pages>
    free_page(p1);
  104461:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104468:	00 
  104469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10446c:	89 04 24             	mov    %eax,(%esp)
  10446f:	e8 1f 0c 00 00       	call   105093 <free_pages>
    free_page(p2);
  104474:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10447b:	00 
  10447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10447f:	89 04 24             	mov    %eax,(%esp)
  104482:	e8 0c 0c 00 00       	call   105093 <free_pages>
    assert(nr_free == 3);
  104487:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  10448c:	83 f8 03             	cmp    $0x3,%eax
  10448f:	74 24                	je     1044b5 <basic_check+0x31c>
  104491:	c7 44 24 0c 4b 80 10 	movl   $0x10804b,0xc(%esp)
  104498:	00 
  104499:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1044a0:	00 
  1044a1:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1044a8:	00 
  1044a9:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1044b0:	e8 1a c8 ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
  1044b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044bc:	e8 9a 0b 00 00       	call   10505b <alloc_pages>
  1044c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1044c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1044c8:	75 24                	jne    1044ee <basic_check+0x355>
  1044ca:	c7 44 24 0c 11 7f 10 	movl   $0x107f11,0xc(%esp)
  1044d1:	00 
  1044d2:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1044d9:	00 
  1044da:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1044e1:	00 
  1044e2:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1044e9:	e8 e1 c7 ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  1044ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044f5:	e8 61 0b 00 00       	call   10505b <alloc_pages>
  1044fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104501:	75 24                	jne    104527 <basic_check+0x38e>
  104503:	c7 44 24 0c 2d 7f 10 	movl   $0x107f2d,0xc(%esp)
  10450a:	00 
  10450b:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104512:	00 
  104513:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10451a:	00 
  10451b:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104522:	e8 a8 c7 ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  104527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10452e:	e8 28 0b 00 00       	call   10505b <alloc_pages>
  104533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10453a:	75 24                	jne    104560 <basic_check+0x3c7>
  10453c:	c7 44 24 0c 49 7f 10 	movl   $0x107f49,0xc(%esp)
  104543:	00 
  104544:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10454b:	00 
  10454c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  104553:	00 
  104554:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10455b:	e8 6f c7 ff ff       	call   100ccf <__panic>

    assert(alloc_page() == NULL);
  104560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104567:	e8 ef 0a 00 00       	call   10505b <alloc_pages>
  10456c:	85 c0                	test   %eax,%eax
  10456e:	74 24                	je     104594 <basic_check+0x3fb>
  104570:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  104577:	00 
  104578:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10457f:	00 
  104580:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104587:	00 
  104588:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10458f:	e8 3b c7 ff ff       	call   100ccf <__panic>

    free_page(p0);
  104594:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10459b:	00 
  10459c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10459f:	89 04 24             	mov    %eax,(%esp)
  1045a2:	e8 ec 0a 00 00       	call   105093 <free_pages>
  1045a7:	c7 45 d8 ac b9 11 00 	movl   $0x11b9ac,-0x28(%ebp)
  1045ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1045b1:	8b 40 04             	mov    0x4(%eax),%eax
  1045b4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1045b7:	0f 94 c0             	sete   %al
  1045ba:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1045bd:	85 c0                	test   %eax,%eax
  1045bf:	74 24                	je     1045e5 <basic_check+0x44c>
  1045c1:	c7 44 24 0c 58 80 10 	movl   $0x108058,0xc(%esp)
  1045c8:	00 
  1045c9:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1045d0:	00 
  1045d1:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1045d8:	00 
  1045d9:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1045e0:	e8 ea c6 ff ff       	call   100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1045e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045ec:	e8 6a 0a 00 00       	call   10505b <alloc_pages>
  1045f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1045fa:	74 24                	je     104620 <basic_check+0x487>
  1045fc:	c7 44 24 0c 70 80 10 	movl   $0x108070,0xc(%esp)
  104603:	00 
  104604:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10460b:	00 
  10460c:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  104613:	00 
  104614:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10461b:	e8 af c6 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  104620:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104627:	e8 2f 0a 00 00       	call   10505b <alloc_pages>
  10462c:	85 c0                	test   %eax,%eax
  10462e:	74 24                	je     104654 <basic_check+0x4bb>
  104630:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  104637:	00 
  104638:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10463f:	00 
  104640:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  104647:	00 
  104648:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10464f:	e8 7b c6 ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  104654:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  104659:	85 c0                	test   %eax,%eax
  10465b:	74 24                	je     104681 <basic_check+0x4e8>
  10465d:	c7 44 24 0c 89 80 10 	movl   $0x108089,0xc(%esp)
  104664:	00 
  104665:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10466c:	00 
  10466d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104674:	00 
  104675:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10467c:	e8 4e c6 ff ff       	call   100ccf <__panic>
    free_list = free_list_store;
  104681:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104684:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104687:	a3 ac b9 11 00       	mov    %eax,0x11b9ac
  10468c:	89 15 b0 b9 11 00    	mov    %edx,0x11b9b0
    nr_free = nr_free_store;
  104692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104695:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4

    free_page(p);
  10469a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046a1:	00 
  1046a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046a5:	89 04 24             	mov    %eax,(%esp)
  1046a8:	e8 e6 09 00 00       	call   105093 <free_pages>
    free_page(p1);
  1046ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046b4:	00 
  1046b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046b8:	89 04 24             	mov    %eax,(%esp)
  1046bb:	e8 d3 09 00 00       	call   105093 <free_pages>
    free_page(p2);
  1046c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046c7:	00 
  1046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046cb:	89 04 24             	mov    %eax,(%esp)
  1046ce:	e8 c0 09 00 00       	call   105093 <free_pages>
}
  1046d3:	c9                   	leave  
  1046d4:	c3                   	ret    

001046d5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1046d5:	55                   	push   %ebp
  1046d6:	89 e5                	mov    %esp,%ebp
  1046d8:	53                   	push   %ebx
  1046d9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1046df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1046e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1046ed:	c7 45 ec ac b9 11 00 	movl   $0x11b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1046f4:	eb 6b                	jmp    104761 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1046f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046f9:	83 e8 0c             	sub    $0xc,%eax
  1046fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1046ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104702:	83 c0 04             	add    $0x4,%eax
  104705:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10470c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10470f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104712:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104715:	0f a3 10             	bt     %edx,(%eax)
  104718:	19 c0                	sbb    %eax,%eax
  10471a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10471d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104721:	0f 95 c0             	setne  %al
  104724:	0f b6 c0             	movzbl %al,%eax
  104727:	85 c0                	test   %eax,%eax
  104729:	75 24                	jne    10474f <default_check+0x7a>
  10472b:	c7 44 24 0c 96 80 10 	movl   $0x108096,0xc(%esp)
  104732:	00 
  104733:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  10473a:	00 
  10473b:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  104742:	00 
  104743:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  10474a:	e8 80 c5 ff ff       	call   100ccf <__panic>
        count ++, total += p->property;
  10474f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104756:	8b 50 08             	mov    0x8(%eax),%edx
  104759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10475c:	01 d0                	add    %edx,%eax
  10475e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104764:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104767:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10476a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10476d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104770:	81 7d ec ac b9 11 00 	cmpl   $0x11b9ac,-0x14(%ebp)
  104777:	0f 85 79 ff ff ff    	jne    1046f6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10477d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104780:	e8 40 09 00 00       	call   1050c5 <nr_free_pages>
  104785:	39 c3                	cmp    %eax,%ebx
  104787:	74 24                	je     1047ad <default_check+0xd8>
  104789:	c7 44 24 0c a6 80 10 	movl   $0x1080a6,0xc(%esp)
  104790:	00 
  104791:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104798:	00 
  104799:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  1047a0:	00 
  1047a1:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1047a8:	e8 22 c5 ff ff       	call   100ccf <__panic>

    basic_check();
  1047ad:	e8 e7 f9 ff ff       	call   104199 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1047b2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1047b9:	e8 9d 08 00 00       	call   10505b <alloc_pages>
  1047be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1047c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1047c5:	75 24                	jne    1047eb <default_check+0x116>
  1047c7:	c7 44 24 0c bf 80 10 	movl   $0x1080bf,0xc(%esp)
  1047ce:	00 
  1047cf:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1047d6:	00 
  1047d7:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1047de:	00 
  1047df:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1047e6:	e8 e4 c4 ff ff       	call   100ccf <__panic>
    assert(!PageProperty(p0));
  1047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047ee:	83 c0 04             	add    $0x4,%eax
  1047f1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1047f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1047fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1047fe:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104801:	0f a3 10             	bt     %edx,(%eax)
  104804:	19 c0                	sbb    %eax,%eax
  104806:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104809:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10480d:	0f 95 c0             	setne  %al
  104810:	0f b6 c0             	movzbl %al,%eax
  104813:	85 c0                	test   %eax,%eax
  104815:	74 24                	je     10483b <default_check+0x166>
  104817:	c7 44 24 0c ca 80 10 	movl   $0x1080ca,0xc(%esp)
  10481e:	00 
  10481f:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104826:	00 
  104827:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  10482e:	00 
  10482f:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104836:	e8 94 c4 ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  10483b:	a1 ac b9 11 00       	mov    0x11b9ac,%eax
  104840:	8b 15 b0 b9 11 00    	mov    0x11b9b0,%edx
  104846:	89 45 80             	mov    %eax,-0x80(%ebp)
  104849:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10484c:	c7 45 b4 ac b9 11 00 	movl   $0x11b9ac,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104853:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104856:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104859:	89 50 04             	mov    %edx,0x4(%eax)
  10485c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10485f:	8b 50 04             	mov    0x4(%eax),%edx
  104862:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104865:	89 10                	mov    %edx,(%eax)
  104867:	c7 45 b0 ac b9 11 00 	movl   $0x11b9ac,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10486e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104871:	8b 40 04             	mov    0x4(%eax),%eax
  104874:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  104877:	0f 94 c0             	sete   %al
  10487a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10487d:	85 c0                	test   %eax,%eax
  10487f:	75 24                	jne    1048a5 <default_check+0x1d0>
  104881:	c7 44 24 0c 1f 80 10 	movl   $0x10801f,0xc(%esp)
  104888:	00 
  104889:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104890:	00 
  104891:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  104898:	00 
  104899:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1048a0:	e8 2a c4 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  1048a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048ac:	e8 aa 07 00 00       	call   10505b <alloc_pages>
  1048b1:	85 c0                	test   %eax,%eax
  1048b3:	74 24                	je     1048d9 <default_check+0x204>
  1048b5:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  1048bc:	00 
  1048bd:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1048c4:	00 
  1048c5:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1048cc:	00 
  1048cd:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1048d4:	e8 f6 c3 ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  1048d9:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  1048de:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1048e1:	c7 05 b4 b9 11 00 00 	movl   $0x0,0x11b9b4
  1048e8:	00 00 00 

    free_pages(p0 + 2, 3);
  1048eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048ee:	83 c0 28             	add    $0x28,%eax
  1048f1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1048f8:	00 
  1048f9:	89 04 24             	mov    %eax,(%esp)
  1048fc:	e8 92 07 00 00       	call   105093 <free_pages>
    assert(alloc_pages(4) == NULL);
  104901:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104908:	e8 4e 07 00 00       	call   10505b <alloc_pages>
  10490d:	85 c0                	test   %eax,%eax
  10490f:	74 24                	je     104935 <default_check+0x260>
  104911:	c7 44 24 0c dc 80 10 	movl   $0x1080dc,0xc(%esp)
  104918:	00 
  104919:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104920:	00 
  104921:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  104928:	00 
  104929:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104930:	e8 9a c3 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104938:	83 c0 28             	add    $0x28,%eax
  10493b:	83 c0 04             	add    $0x4,%eax
  10493e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104945:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104948:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10494b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10494e:	0f a3 10             	bt     %edx,(%eax)
  104951:	19 c0                	sbb    %eax,%eax
  104953:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104956:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10495a:	0f 95 c0             	setne  %al
  10495d:	0f b6 c0             	movzbl %al,%eax
  104960:	85 c0                	test   %eax,%eax
  104962:	74 0e                	je     104972 <default_check+0x29d>
  104964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104967:	83 c0 28             	add    $0x28,%eax
  10496a:	8b 40 08             	mov    0x8(%eax),%eax
  10496d:	83 f8 03             	cmp    $0x3,%eax
  104970:	74 24                	je     104996 <default_check+0x2c1>
  104972:	c7 44 24 0c f4 80 10 	movl   $0x1080f4,0xc(%esp)
  104979:	00 
  10497a:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104981:	00 
  104982:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  104989:	00 
  10498a:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104991:	e8 39 c3 ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104996:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10499d:	e8 b9 06 00 00       	call   10505b <alloc_pages>
  1049a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1049a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1049a9:	75 24                	jne    1049cf <default_check+0x2fa>
  1049ab:	c7 44 24 0c 20 81 10 	movl   $0x108120,0xc(%esp)
  1049b2:	00 
  1049b3:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1049ba:	00 
  1049bb:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1049c2:	00 
  1049c3:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1049ca:	e8 00 c3 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  1049cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049d6:	e8 80 06 00 00       	call   10505b <alloc_pages>
  1049db:	85 c0                	test   %eax,%eax
  1049dd:	74 24                	je     104a03 <default_check+0x32e>
  1049df:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  1049e6:	00 
  1049e7:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  1049ee:	00 
  1049ef:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1049f6:	00 
  1049f7:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  1049fe:	e8 cc c2 ff ff       	call   100ccf <__panic>
    assert(p0 + 2 == p1);
  104a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a06:	83 c0 28             	add    $0x28,%eax
  104a09:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104a0c:	74 24                	je     104a32 <default_check+0x35d>
  104a0e:	c7 44 24 0c 3e 81 10 	movl   $0x10813e,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104a2d:	e8 9d c2 ff ff       	call   100ccf <__panic>

    p2 = p0 + 1;
  104a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a35:	83 c0 14             	add    $0x14,%eax
  104a38:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  104a3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a42:	00 
  104a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a46:	89 04 24             	mov    %eax,(%esp)
  104a49:	e8 45 06 00 00       	call   105093 <free_pages>
    free_pages(p1, 3);
  104a4e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104a55:	00 
  104a56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a59:	89 04 24             	mov    %eax,(%esp)
  104a5c:	e8 32 06 00 00       	call   105093 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  104a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a64:	83 c0 04             	add    $0x4,%eax
  104a67:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  104a6e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a71:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104a74:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104a77:	0f a3 10             	bt     %edx,(%eax)
  104a7a:	19 c0                	sbb    %eax,%eax
  104a7c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104a7f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104a83:	0f 95 c0             	setne  %al
  104a86:	0f b6 c0             	movzbl %al,%eax
  104a89:	85 c0                	test   %eax,%eax
  104a8b:	74 0b                	je     104a98 <default_check+0x3c3>
  104a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a90:	8b 40 08             	mov    0x8(%eax),%eax
  104a93:	83 f8 01             	cmp    $0x1,%eax
  104a96:	74 24                	je     104abc <default_check+0x3e7>
  104a98:	c7 44 24 0c 4c 81 10 	movl   $0x10814c,0xc(%esp)
  104a9f:	00 
  104aa0:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104aa7:	00 
  104aa8:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  104aaf:	00 
  104ab0:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104ab7:	e8 13 c2 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104abf:	83 c0 04             	add    $0x4,%eax
  104ac2:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  104ac9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104acc:	8b 45 90             	mov    -0x70(%ebp),%eax
  104acf:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104ad2:	0f a3 10             	bt     %edx,(%eax)
  104ad5:	19 c0                	sbb    %eax,%eax
  104ad7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  104ada:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  104ade:	0f 95 c0             	setne  %al
  104ae1:	0f b6 c0             	movzbl %al,%eax
  104ae4:	85 c0                	test   %eax,%eax
  104ae6:	74 0b                	je     104af3 <default_check+0x41e>
  104ae8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104aeb:	8b 40 08             	mov    0x8(%eax),%eax
  104aee:	83 f8 03             	cmp    $0x3,%eax
  104af1:	74 24                	je     104b17 <default_check+0x442>
  104af3:	c7 44 24 0c 74 81 10 	movl   $0x108174,0xc(%esp)
  104afa:	00 
  104afb:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104b02:	00 
  104b03:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  104b0a:	00 
  104b0b:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104b12:	e8 b8 c1 ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104b17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b1e:	e8 38 05 00 00       	call   10505b <alloc_pages>
  104b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104b29:	83 e8 14             	sub    $0x14,%eax
  104b2c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104b2f:	74 24                	je     104b55 <default_check+0x480>
  104b31:	c7 44 24 0c 9a 81 10 	movl   $0x10819a,0xc(%esp)
  104b38:	00 
  104b39:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104b40:	00 
  104b41:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  104b48:	00 
  104b49:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104b50:	e8 7a c1 ff ff       	call   100ccf <__panic>
    free_page(p0);
  104b55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b5c:	00 
  104b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b60:	89 04 24             	mov    %eax,(%esp)
  104b63:	e8 2b 05 00 00       	call   105093 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104b68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104b6f:	e8 e7 04 00 00       	call   10505b <alloc_pages>
  104b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104b7a:	83 c0 14             	add    $0x14,%eax
  104b7d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104b80:	74 24                	je     104ba6 <default_check+0x4d1>
  104b82:	c7 44 24 0c b8 81 10 	movl   $0x1081b8,0xc(%esp)
  104b89:	00 
  104b8a:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104b91:	00 
  104b92:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  104b99:	00 
  104b9a:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104ba1:	e8 29 c1 ff ff       	call   100ccf <__panic>

    free_pages(p0, 2);
  104ba6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104bad:	00 
  104bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bb1:	89 04 24             	mov    %eax,(%esp)
  104bb4:	e8 da 04 00 00       	call   105093 <free_pages>
    free_page(p2);
  104bb9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104bc0:	00 
  104bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104bc4:	89 04 24             	mov    %eax,(%esp)
  104bc7:	e8 c7 04 00 00       	call   105093 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  104bcc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104bd3:	e8 83 04 00 00       	call   10505b <alloc_pages>
  104bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104bdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104bdf:	75 24                	jne    104c05 <default_check+0x530>
  104be1:	c7 44 24 0c d8 81 10 	movl   $0x1081d8,0xc(%esp)
  104be8:	00 
  104be9:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104bf0:	00 
  104bf1:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  104bf8:	00 
  104bf9:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104c00:	e8 ca c0 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  104c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c0c:	e8 4a 04 00 00       	call   10505b <alloc_pages>
  104c11:	85 c0                	test   %eax,%eax
  104c13:	74 24                	je     104c39 <default_check+0x564>
  104c15:	c7 44 24 0c 36 80 10 	movl   $0x108036,0xc(%esp)
  104c1c:	00 
  104c1d:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104c24:	00 
  104c25:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  104c2c:	00 
  104c2d:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104c34:	e8 96 c0 ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  104c39:	a1 b4 b9 11 00       	mov    0x11b9b4,%eax
  104c3e:	85 c0                	test   %eax,%eax
  104c40:	74 24                	je     104c66 <default_check+0x591>
  104c42:	c7 44 24 0c 89 80 10 	movl   $0x108089,0xc(%esp)
  104c49:	00 
  104c4a:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104c51:	00 
  104c52:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104c59:	00 
  104c5a:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104c61:	e8 69 c0 ff ff       	call   100ccf <__panic>
    nr_free = nr_free_store;
  104c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c69:	a3 b4 b9 11 00       	mov    %eax,0x11b9b4

    free_list = free_list_store;
  104c6e:	8b 45 80             	mov    -0x80(%ebp),%eax
  104c71:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104c74:	a3 ac b9 11 00       	mov    %eax,0x11b9ac
  104c79:	89 15 b0 b9 11 00    	mov    %edx,0x11b9b0
    free_pages(p0, 5);
  104c7f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104c86:	00 
  104c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c8a:	89 04 24             	mov    %eax,(%esp)
  104c8d:	e8 01 04 00 00       	call   105093 <free_pages>

    le = &free_list;
  104c92:	c7 45 ec ac b9 11 00 	movl   $0x11b9ac,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104c99:	eb 1d                	jmp    104cb8 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  104c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c9e:	83 e8 0c             	sub    $0xc,%eax
  104ca1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  104ca4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104cae:	8b 40 08             	mov    0x8(%eax),%eax
  104cb1:	29 c2                	sub    %eax,%edx
  104cb3:	89 d0                	mov    %edx,%eax
  104cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cbb:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104cbe:	8b 45 88             	mov    -0x78(%ebp),%eax
  104cc1:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104cc7:	81 7d ec ac b9 11 00 	cmpl   $0x11b9ac,-0x14(%ebp)
  104cce:	75 cb                	jne    104c9b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  104cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104cd4:	74 24                	je     104cfa <default_check+0x625>
  104cd6:	c7 44 24 0c f6 81 10 	movl   $0x1081f6,0xc(%esp)
  104cdd:	00 
  104cde:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104ce5:	00 
  104ce6:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  104ced:	00 
  104cee:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104cf5:	e8 d5 bf ff ff       	call   100ccf <__panic>
    assert(total == 0);
  104cfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cfe:	74 24                	je     104d24 <default_check+0x64f>
  104d00:	c7 44 24 0c 01 82 10 	movl   $0x108201,0xc(%esp)
  104d07:	00 
  104d08:	c7 44 24 08 4d 7e 10 	movl   $0x107e4d,0x8(%esp)
  104d0f:	00 
  104d10:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  104d17:	00 
  104d18:	c7 04 24 62 7e 10 00 	movl   $0x107e62,(%esp)
  104d1f:	e8 ab bf ff ff       	call   100ccf <__panic>
}
  104d24:	81 c4 94 00 00 00    	add    $0x94,%esp
  104d2a:	5b                   	pop    %ebx
  104d2b:	5d                   	pop    %ebp
  104d2c:	c3                   	ret    

00104d2d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104d2d:	55                   	push   %ebp
  104d2e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104d30:	8b 55 08             	mov    0x8(%ebp),%edx
  104d33:	a1 c0 b9 11 00       	mov    0x11b9c0,%eax
  104d38:	29 c2                	sub    %eax,%edx
  104d3a:	89 d0                	mov    %edx,%eax
  104d3c:	c1 f8 02             	sar    $0x2,%eax
  104d3f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104d45:	5d                   	pop    %ebp
  104d46:	c3                   	ret    

00104d47 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104d47:	55                   	push   %ebp
  104d48:	89 e5                	mov    %esp,%ebp
  104d4a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  104d50:	89 04 24             	mov    %eax,(%esp)
  104d53:	e8 d5 ff ff ff       	call   104d2d <page2ppn>
  104d58:	c1 e0 0c             	shl    $0xc,%eax
}
  104d5b:	c9                   	leave  
  104d5c:	c3                   	ret    

00104d5d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  104d5d:	55                   	push   %ebp
  104d5e:	89 e5                	mov    %esp,%ebp
  104d60:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  104d63:	8b 45 08             	mov    0x8(%ebp),%eax
  104d66:	c1 e8 0c             	shr    $0xc,%eax
  104d69:	89 c2                	mov    %eax,%edx
  104d6b:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  104d70:	39 c2                	cmp    %eax,%edx
  104d72:	72 1c                	jb     104d90 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  104d74:	c7 44 24 08 3c 82 10 	movl   $0x10823c,0x8(%esp)
  104d7b:	00 
  104d7c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  104d83:	00 
  104d84:	c7 04 24 5b 82 10 00 	movl   $0x10825b,(%esp)
  104d8b:	e8 3f bf ff ff       	call   100ccf <__panic>
    }
    return &pages[PPN(pa)];
  104d90:	8b 0d c0 b9 11 00    	mov    0x11b9c0,%ecx
  104d96:	8b 45 08             	mov    0x8(%ebp),%eax
  104d99:	c1 e8 0c             	shr    $0xc,%eax
  104d9c:	89 c2                	mov    %eax,%edx
  104d9e:	89 d0                	mov    %edx,%eax
  104da0:	c1 e0 02             	shl    $0x2,%eax
  104da3:	01 d0                	add    %edx,%eax
  104da5:	c1 e0 02             	shl    $0x2,%eax
  104da8:	01 c8                	add    %ecx,%eax
}
  104daa:	c9                   	leave  
  104dab:	c3                   	ret    

00104dac <page2kva>:

static inline void *
page2kva(struct Page *page) {
  104dac:	55                   	push   %ebp
  104dad:	89 e5                	mov    %esp,%ebp
  104daf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  104db2:	8b 45 08             	mov    0x8(%ebp),%eax
  104db5:	89 04 24             	mov    %eax,(%esp)
  104db8:	e8 8a ff ff ff       	call   104d47 <page2pa>
  104dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dc3:	c1 e8 0c             	shr    $0xc,%eax
  104dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dc9:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  104dce:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104dd1:	72 23                	jb     104df6 <page2kva+0x4a>
  104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104dda:	c7 44 24 08 6c 82 10 	movl   $0x10826c,0x8(%esp)
  104de1:	00 
  104de2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  104de9:	00 
  104dea:	c7 04 24 5b 82 10 00 	movl   $0x10825b,(%esp)
  104df1:	e8 d9 be ff ff       	call   100ccf <__panic>
  104df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104df9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  104dfe:	c9                   	leave  
  104dff:	c3                   	ret    

00104e00 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  104e00:	55                   	push   %ebp
  104e01:	89 e5                	mov    %esp,%ebp
  104e03:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  104e06:	8b 45 08             	mov    0x8(%ebp),%eax
  104e09:	83 e0 01             	and    $0x1,%eax
  104e0c:	85 c0                	test   %eax,%eax
  104e0e:	75 1c                	jne    104e2c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  104e10:	c7 44 24 08 90 82 10 	movl   $0x108290,0x8(%esp)
  104e17:	00 
  104e18:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  104e1f:	00 
  104e20:	c7 04 24 5b 82 10 00 	movl   $0x10825b,(%esp)
  104e27:	e8 a3 be ff ff       	call   100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  104e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  104e2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e34:	89 04 24             	mov    %eax,(%esp)
  104e37:	e8 21 ff ff ff       	call   104d5d <pa2page>
}
  104e3c:	c9                   	leave  
  104e3d:	c3                   	ret    

00104e3e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  104e3e:	55                   	push   %ebp
  104e3f:	89 e5                	mov    %esp,%ebp
  104e41:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  104e44:	8b 45 08             	mov    0x8(%ebp),%eax
  104e47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e4c:	89 04 24             	mov    %eax,(%esp)
  104e4f:	e8 09 ff ff ff       	call   104d5d <pa2page>
}
  104e54:	c9                   	leave  
  104e55:	c3                   	ret    

00104e56 <page_ref>:

static inline int
page_ref(struct Page *page) {
  104e56:	55                   	push   %ebp
  104e57:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104e59:	8b 45 08             	mov    0x8(%ebp),%eax
  104e5c:	8b 00                	mov    (%eax),%eax
}
  104e5e:	5d                   	pop    %ebp
  104e5f:	c3                   	ret    

00104e60 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  104e60:	55                   	push   %ebp
  104e61:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104e63:	8b 45 08             	mov    0x8(%ebp),%eax
  104e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  104e69:	89 10                	mov    %edx,(%eax)
}
  104e6b:	5d                   	pop    %ebp
  104e6c:	c3                   	ret    

00104e6d <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  104e6d:	55                   	push   %ebp
  104e6e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  104e70:	8b 45 08             	mov    0x8(%ebp),%eax
  104e73:	8b 00                	mov    (%eax),%eax
  104e75:	8d 50 01             	lea    0x1(%eax),%edx
  104e78:	8b 45 08             	mov    0x8(%ebp),%eax
  104e7b:	89 10                	mov    %edx,(%eax)
    return page->ref;
  104e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  104e80:	8b 00                	mov    (%eax),%eax
}
  104e82:	5d                   	pop    %ebp
  104e83:	c3                   	ret    

00104e84 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  104e84:	55                   	push   %ebp
  104e85:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  104e87:	8b 45 08             	mov    0x8(%ebp),%eax
  104e8a:	8b 00                	mov    (%eax),%eax
  104e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  104e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  104e92:	89 10                	mov    %edx,(%eax)
    return page->ref;
  104e94:	8b 45 08             	mov    0x8(%ebp),%eax
  104e97:	8b 00                	mov    (%eax),%eax
}
  104e99:	5d                   	pop    %ebp
  104e9a:	c3                   	ret    

00104e9b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  104e9b:	55                   	push   %ebp
  104e9c:	89 e5                	mov    %esp,%ebp
  104e9e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  104ea1:	9c                   	pushf  
  104ea2:	58                   	pop    %eax
  104ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  104ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  104ea9:	25 00 02 00 00       	and    $0x200,%eax
  104eae:	85 c0                	test   %eax,%eax
  104eb0:	74 0c                	je     104ebe <__intr_save+0x23>
        intr_disable();
  104eb2:	e8 fb c7 ff ff       	call   1016b2 <intr_disable>
        return 1;
  104eb7:	b8 01 00 00 00       	mov    $0x1,%eax
  104ebc:	eb 05                	jmp    104ec3 <__intr_save+0x28>
    }
    return 0;
  104ebe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104ec3:	c9                   	leave  
  104ec4:	c3                   	ret    

00104ec5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  104ec5:	55                   	push   %ebp
  104ec6:	89 e5                	mov    %esp,%ebp
  104ec8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  104ecb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104ecf:	74 05                	je     104ed6 <__intr_restore+0x11>
        intr_enable();
  104ed1:	e8 d6 c7 ff ff       	call   1016ac <intr_enable>
    }
}
  104ed6:	c9                   	leave  
  104ed7:	c3                   	ret    

00104ed8 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  104ed8:	55                   	push   %ebp
  104ed9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  104edb:	8b 45 08             	mov    0x8(%ebp),%eax
  104ede:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  104ee1:	b8 23 00 00 00       	mov    $0x23,%eax
  104ee6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  104ee8:	b8 23 00 00 00       	mov    $0x23,%eax
  104eed:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  104eef:	b8 10 00 00 00       	mov    $0x10,%eax
  104ef4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  104ef6:	b8 10 00 00 00       	mov    $0x10,%eax
  104efb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  104efd:	b8 10 00 00 00       	mov    $0x10,%eax
  104f02:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  104f04:	ea 0b 4f 10 00 08 00 	ljmp   $0x8,$0x104f0b
}
  104f0b:	5d                   	pop    %ebp
  104f0c:	c3                   	ret    

00104f0d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  104f0d:	55                   	push   %ebp
  104f0e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  104f10:	8b 45 08             	mov    0x8(%ebp),%eax
  104f13:	a3 e4 b8 11 00       	mov    %eax,0x11b8e4
}
  104f18:	5d                   	pop    %ebp
  104f19:	c3                   	ret    

00104f1a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  104f1a:	55                   	push   %ebp
  104f1b:	89 e5                	mov    %esp,%ebp
  104f1d:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  104f20:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  104f25:	89 04 24             	mov    %eax,(%esp)
  104f28:	e8 e0 ff ff ff       	call   104f0d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  104f2d:	66 c7 05 e8 b8 11 00 	movw   $0x10,0x11b8e8
  104f34:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  104f36:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  104f3d:	68 00 
  104f3f:	b8 e0 b8 11 00       	mov    $0x11b8e0,%eax
  104f44:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  104f4a:	b8 e0 b8 11 00       	mov    $0x11b8e0,%eax
  104f4f:	c1 e8 10             	shr    $0x10,%eax
  104f52:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  104f57:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  104f5e:	83 e0 f0             	and    $0xfffffff0,%eax
  104f61:	83 c8 09             	or     $0x9,%eax
  104f64:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  104f69:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  104f70:	83 e0 ef             	and    $0xffffffef,%eax
  104f73:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  104f78:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  104f7f:	83 e0 9f             	and    $0xffffff9f,%eax
  104f82:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  104f87:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  104f8e:	83 c8 80             	or     $0xffffff80,%eax
  104f91:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  104f96:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  104f9d:	83 e0 f0             	and    $0xfffffff0,%eax
  104fa0:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  104fa5:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  104fac:	83 e0 ef             	and    $0xffffffef,%eax
  104faf:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  104fb4:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  104fbb:	83 e0 df             	and    $0xffffffdf,%eax
  104fbe:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  104fc3:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  104fca:	83 c8 40             	or     $0x40,%eax
  104fcd:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  104fd2:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  104fd9:	83 e0 7f             	and    $0x7f,%eax
  104fdc:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  104fe1:	b8 e0 b8 11 00       	mov    $0x11b8e0,%eax
  104fe6:	c1 e8 18             	shr    $0x18,%eax
  104fe9:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104fee:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
  104ff5:	e8 de fe ff ff       	call   104ed8 <lgdt>
  104ffa:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  105000:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  105004:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  105007:	c9                   	leave  
  105008:	c3                   	ret    

00105009 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  105009:	55                   	push   %ebp
  10500a:	89 e5                	mov    %esp,%ebp
  10500c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  10500f:	c7 05 b8 b9 11 00 20 	movl   $0x108220,0x11b9b8
  105016:	82 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  105019:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  10501e:	8b 00                	mov    (%eax),%eax
  105020:	89 44 24 04          	mov    %eax,0x4(%esp)
  105024:	c7 04 24 bc 82 10 00 	movl   $0x1082bc,(%esp)
  10502b:	e8 13 b3 ff ff       	call   100343 <cprintf>
    pmm_manager->init();
  105030:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  105035:	8b 40 04             	mov    0x4(%eax),%eax
  105038:	ff d0                	call   *%eax
}
  10503a:	c9                   	leave  
  10503b:	c3                   	ret    

0010503c <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  10503c:	55                   	push   %ebp
  10503d:	89 e5                	mov    %esp,%ebp
  10503f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  105042:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  105047:	8b 40 08             	mov    0x8(%eax),%eax
  10504a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10504d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105051:	8b 55 08             	mov    0x8(%ebp),%edx
  105054:	89 14 24             	mov    %edx,(%esp)
  105057:	ff d0                	call   *%eax
}
  105059:	c9                   	leave  
  10505a:	c3                   	ret    

0010505b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  10505b:	55                   	push   %ebp
  10505c:	89 e5                	mov    %esp,%ebp
  10505e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  105061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  105068:	e8 2e fe ff ff       	call   104e9b <__intr_save>
  10506d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  105070:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  105075:	8b 40 0c             	mov    0xc(%eax),%eax
  105078:	8b 55 08             	mov    0x8(%ebp),%edx
  10507b:	89 14 24             	mov    %edx,(%esp)
  10507e:	ff d0                	call   *%eax
  105080:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  105083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105086:	89 04 24             	mov    %eax,(%esp)
  105089:	e8 37 fe ff ff       	call   104ec5 <__intr_restore>
    return page;
  10508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105091:	c9                   	leave  
  105092:	c3                   	ret    

00105093 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  105093:	55                   	push   %ebp
  105094:	89 e5                	mov    %esp,%ebp
  105096:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  105099:	e8 fd fd ff ff       	call   104e9b <__intr_save>
  10509e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  1050a1:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  1050a6:	8b 40 10             	mov    0x10(%eax),%eax
  1050a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1050ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1050b3:	89 14 24             	mov    %edx,(%esp)
  1050b6:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  1050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050bb:	89 04 24             	mov    %eax,(%esp)
  1050be:	e8 02 fe ff ff       	call   104ec5 <__intr_restore>
}
  1050c3:	c9                   	leave  
  1050c4:	c3                   	ret    

001050c5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  1050c5:	55                   	push   %ebp
  1050c6:	89 e5                	mov    %esp,%ebp
  1050c8:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  1050cb:	e8 cb fd ff ff       	call   104e9b <__intr_save>
  1050d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  1050d3:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  1050d8:	8b 40 14             	mov    0x14(%eax),%eax
  1050db:	ff d0                	call   *%eax
  1050dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  1050e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050e3:	89 04 24             	mov    %eax,(%esp)
  1050e6:	e8 da fd ff ff       	call   104ec5 <__intr_restore>
    return ret;
  1050eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1050ee:	c9                   	leave  
  1050ef:	c3                   	ret    

001050f0 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1050f0:	55                   	push   %ebp
  1050f1:	89 e5                	mov    %esp,%ebp
  1050f3:	57                   	push   %edi
  1050f4:	56                   	push   %esi
  1050f5:	53                   	push   %ebx
  1050f6:	81 ec ac 00 00 00    	sub    $0xac,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1050fc:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  105103:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10510a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  105111:	c7 04 24 d3 82 10 00 	movl   $0x1082d3,(%esp)
  105118:	e8 26 b2 ff ff       	call   100343 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  10511d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105124:	e9 42 01 00 00       	jmp    10526b <page_init+0x17b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  105129:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10512c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10512f:	89 d0                	mov    %edx,%eax
  105131:	c1 e0 02             	shl    $0x2,%eax
  105134:	01 d0                	add    %edx,%eax
  105136:	c1 e0 02             	shl    $0x2,%eax
  105139:	01 c8                	add    %ecx,%eax
  10513b:	8b 50 08             	mov    0x8(%eax),%edx
  10513e:	8b 40 04             	mov    0x4(%eax),%eax
  105141:	89 45 b8             	mov    %eax,-0x48(%ebp)
  105144:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105147:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10514a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10514d:	89 d0                	mov    %edx,%eax
  10514f:	c1 e0 02             	shl    $0x2,%eax
  105152:	01 d0                	add    %edx,%eax
  105154:	c1 e0 02             	shl    $0x2,%eax
  105157:	01 c8                	add    %ecx,%eax
  105159:	8b 48 0c             	mov    0xc(%eax),%ecx
  10515c:	8b 58 10             	mov    0x10(%eax),%ebx
  10515f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105162:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105165:	01 c8                	add    %ecx,%eax
  105167:	11 da                	adc    %ebx,%edx
  105169:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10516c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d(%s).\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type,
                memmap->map[i].type == E820_ARM ? "MEMORY" : "RESERVED");
  10516f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105172:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105175:	89 d0                	mov    %edx,%eax
  105177:	c1 e0 02             	shl    $0x2,%eax
  10517a:	01 d0                	add    %edx,%eax
  10517c:	c1 e0 02             	shl    $0x2,%eax
  10517f:	01 c8                	add    %ecx,%eax
  105181:	83 c0 14             	add    $0x14,%eax
  105184:	8b 00                	mov    (%eax),%eax

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d(%s).\n",
  105186:	83 f8 01             	cmp    $0x1,%eax
  105189:	75 09                	jne    105194 <page_init+0xa4>
  10518b:	c7 45 84 dd 82 10 00 	movl   $0x1082dd,-0x7c(%ebp)
  105192:	eb 07                	jmp    10519b <page_init+0xab>
  105194:	c7 45 84 e4 82 10 00 	movl   $0x1082e4,-0x7c(%ebp)
  10519b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10519e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1051a1:	89 d0                	mov    %edx,%eax
  1051a3:	c1 e0 02             	shl    $0x2,%eax
  1051a6:	01 d0                	add    %edx,%eax
  1051a8:	c1 e0 02             	shl    $0x2,%eax
  1051ab:	01 c8                	add    %ecx,%eax
  1051ad:	83 c0 14             	add    $0x14,%eax
  1051b0:	8b 00                	mov    (%eax),%eax
  1051b2:	89 45 80             	mov    %eax,-0x80(%ebp)
  1051b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1051b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1051bb:	83 c0 ff             	add    $0xffffffff,%eax
  1051be:	83 d2 ff             	adc    $0xffffffff,%edx
  1051c1:	89 c6                	mov    %eax,%esi
  1051c3:	89 d7                	mov    %edx,%edi
  1051c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1051c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1051cb:	89 d0                	mov    %edx,%eax
  1051cd:	c1 e0 02             	shl    $0x2,%eax
  1051d0:	01 d0                	add    %edx,%eax
  1051d2:	c1 e0 02             	shl    $0x2,%eax
  1051d5:	01 c8                	add    %ecx,%eax
  1051d7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1051da:	8b 58 10             	mov    0x10(%eax),%ebx
  1051dd:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1051e0:	89 54 24 20          	mov    %edx,0x20(%esp)
  1051e4:	8b 45 80             	mov    -0x80(%ebp),%eax
  1051e7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1051eb:	89 74 24 14          	mov    %esi,0x14(%esp)
  1051ef:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1051f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1051f6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1051f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1051fd:	89 54 24 10          	mov    %edx,0x10(%esp)
  105201:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  105205:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105209:	c7 04 24 f0 82 10 00 	movl   $0x1082f0,(%esp)
  105210:	e8 2e b1 ff ff       	call   100343 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type,
                memmap->map[i].type == E820_ARM ? "MEMORY" : "RESERVED");
        if (memmap->map[i].type == E820_ARM) {
  105215:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105218:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10521b:	89 d0                	mov    %edx,%eax
  10521d:	c1 e0 02             	shl    $0x2,%eax
  105220:	01 d0                	add    %edx,%eax
  105222:	c1 e0 02             	shl    $0x2,%eax
  105225:	01 c8                	add    %ecx,%eax
  105227:	83 c0 14             	add    $0x14,%eax
  10522a:	8b 00                	mov    (%eax),%eax
  10522c:	83 f8 01             	cmp    $0x1,%eax
  10522f:	75 36                	jne    105267 <page_init+0x177>
            if (maxpa < end && begin < KMEMSIZE) {
  105231:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105237:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10523a:	77 2b                	ja     105267 <page_init+0x177>
  10523c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10523f:	72 05                	jb     105246 <page_init+0x156>
  105241:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  105244:	73 21                	jae    105267 <page_init+0x177>
  105246:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  10524a:	77 1b                	ja     105267 <page_init+0x177>
  10524c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  105250:	72 09                	jb     10525b <page_init+0x16b>
  105252:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  105259:	77 0c                	ja     105267 <page_init+0x177>
                maxpa = end;
  10525b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10525e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  105261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105264:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  105267:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10526b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10526e:	8b 00                	mov    (%eax),%eax
  105270:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105273:	0f 8f b0 fe ff ff    	jg     105129 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  105279:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10527d:	72 1d                	jb     10529c <page_init+0x1ac>
  10527f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105283:	77 09                	ja     10528e <page_init+0x19e>
  105285:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  10528c:	76 0e                	jbe    10529c <page_init+0x1ac>
        maxpa = KMEMSIZE;
  10528e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  105295:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    // page number of Max PA, valid page must be less than this value.
    npage = maxpa / PGSIZE;
  10529c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10529f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1052a2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1052a6:	c1 ea 0c             	shr    $0xc,%edx
  1052a9:	a3 c0 b8 11 00       	mov    %eax,0x11b8c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1052ae:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  1052b5:	b8 c4 b9 11 00       	mov    $0x11b9c4,%eax
  1052ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  1052bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1052c0:	01 d0                	add    %edx,%eax
  1052c2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1052c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1052c8:	ba 00 00 00 00       	mov    $0x0,%edx
  1052cd:	f7 75 ac             	divl   -0x54(%ebp)
  1052d0:	89 d0                	mov    %edx,%eax
  1052d2:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1052d5:	29 c2                	sub    %eax,%edx
  1052d7:	89 d0                	mov    %edx,%eax
  1052d9:	a3 c0 b9 11 00       	mov    %eax,0x11b9c0

    for (i = 0; i < npage; i ++) {
  1052de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1052e5:	eb 2f                	jmp    105316 <page_init+0x226>
        SetPageReserved(pages + i);
  1052e7:	8b 0d c0 b9 11 00    	mov    0x11b9c0,%ecx
  1052ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052f0:	89 d0                	mov    %edx,%eax
  1052f2:	c1 e0 02             	shl    $0x2,%eax
  1052f5:	01 d0                	add    %edx,%eax
  1052f7:	c1 e0 02             	shl    $0x2,%eax
  1052fa:	01 c8                	add    %ecx,%eax
  1052fc:	83 c0 04             	add    $0x4,%eax
  1052ff:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  105306:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105309:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10530c:	8b 55 90             	mov    -0x70(%ebp),%edx
  10530f:	0f ab 10             	bts    %edx,(%eax)

    // page number of Max PA, valid page must be less than this value.
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  105312:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  105316:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105319:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  10531e:	39 c2                	cmp    %eax,%edx
  105320:	72 c5                	jb     1052e7 <page_init+0x1f7>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  105322:	8b 15 c0 b8 11 00    	mov    0x11b8c0,%edx
  105328:	89 d0                	mov    %edx,%eax
  10532a:	c1 e0 02             	shl    $0x2,%eax
  10532d:	01 d0                	add    %edx,%eax
  10532f:	c1 e0 02             	shl    $0x2,%eax
  105332:	89 c2                	mov    %eax,%edx
  105334:	a1 c0 b9 11 00       	mov    0x11b9c0,%eax
  105339:	01 d0                	add    %edx,%eax
  10533b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10533e:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  105345:	77 23                	ja     10536a <page_init+0x27a>
  105347:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10534a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10534e:	c7 44 24 08 24 83 10 	movl   $0x108324,0x8(%esp)
  105355:	00 
  105356:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10535d:	00 
  10535e:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105365:	e8 65 b9 ff ff       	call   100ccf <__panic>
  10536a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10536d:	05 00 00 00 40       	add    $0x40000000,%eax
  105372:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  105375:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10537c:	e9 80 01 00 00       	jmp    105501 <page_init+0x411>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  105381:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  105384:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105387:	89 d0                	mov    %edx,%eax
  105389:	c1 e0 02             	shl    $0x2,%eax
  10538c:	01 d0                	add    %edx,%eax
  10538e:	c1 e0 02             	shl    $0x2,%eax
  105391:	01 c8                	add    %ecx,%eax
  105393:	8b 50 08             	mov    0x8(%eax),%edx
  105396:	8b 40 04             	mov    0x4(%eax),%eax
  105399:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10539c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10539f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1053a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053a5:	89 d0                	mov    %edx,%eax
  1053a7:	c1 e0 02             	shl    $0x2,%eax
  1053aa:	01 d0                	add    %edx,%eax
  1053ac:	c1 e0 02             	shl    $0x2,%eax
  1053af:	01 c8                	add    %ecx,%eax
  1053b1:	8b 48 0c             	mov    0xc(%eax),%ecx
  1053b4:	8b 58 10             	mov    0x10(%eax),%ebx
  1053b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1053ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053bd:	01 c8                	add    %ecx,%eax
  1053bf:	11 da                	adc    %ebx,%edx
  1053c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1053c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1053c7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1053ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053cd:	89 d0                	mov    %edx,%eax
  1053cf:	c1 e0 02             	shl    $0x2,%eax
  1053d2:	01 d0                	add    %edx,%eax
  1053d4:	c1 e0 02             	shl    $0x2,%eax
  1053d7:	01 c8                	add    %ecx,%eax
  1053d9:	83 c0 14             	add    $0x14,%eax
  1053dc:	8b 00                	mov    (%eax),%eax
  1053de:	83 f8 01             	cmp    $0x1,%eax
  1053e1:	0f 85 16 01 00 00    	jne    1054fd <page_init+0x40d>
            if (begin < freemem) {
  1053e7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1053ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1053ef:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053f2:	72 17                	jb     10540b <page_init+0x31b>
  1053f4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053f7:	77 05                	ja     1053fe <page_init+0x30e>
  1053f9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1053fc:	76 0d                	jbe    10540b <page_init+0x31b>
                begin = freemem;
  1053fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105401:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105404:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10540b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10540f:	72 1d                	jb     10542e <page_init+0x33e>
  105411:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  105415:	77 09                	ja     105420 <page_init+0x330>
  105417:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10541e:	76 0e                	jbe    10542e <page_init+0x33e>
                end = KMEMSIZE;
  105420:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  105427:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10542e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105431:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105434:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  105437:	0f 87 c0 00 00 00    	ja     1054fd <page_init+0x40d>
  10543d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  105440:	72 09                	jb     10544b <page_init+0x35b>
  105442:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  105445:	0f 83 b2 00 00 00    	jae    1054fd <page_init+0x40d>
                begin = ROUNDUP(begin, PGSIZE);
  10544b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  105452:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105455:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105458:	01 d0                	add    %edx,%eax
  10545a:	83 e8 01             	sub    $0x1,%eax
  10545d:	89 45 98             	mov    %eax,-0x68(%ebp)
  105460:	8b 45 98             	mov    -0x68(%ebp),%eax
  105463:	ba 00 00 00 00       	mov    $0x0,%edx
  105468:	f7 75 9c             	divl   -0x64(%ebp)
  10546b:	89 d0                	mov    %edx,%eax
  10546d:	8b 55 98             	mov    -0x68(%ebp),%edx
  105470:	29 c2                	sub    %eax,%edx
  105472:	89 d0                	mov    %edx,%eax
  105474:	ba 00 00 00 00       	mov    $0x0,%edx
  105479:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10547c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10547f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105482:	89 45 94             	mov    %eax,-0x6c(%ebp)
  105485:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105488:	ba 00 00 00 00       	mov    $0x0,%edx
  10548d:	89 c7                	mov    %eax,%edi
  10548f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  105495:	89 bd 78 ff ff ff    	mov    %edi,-0x88(%ebp)
  10549b:	89 d0                	mov    %edx,%eax
  10549d:	83 e0 00             	and    $0x0,%eax
  1054a0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1054a6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1054ac:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1054b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1054b5:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1054b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054be:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1054c1:	77 3a                	ja     1054fd <page_init+0x40d>
  1054c3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1054c6:	72 05                	jb     1054cd <page_init+0x3dd>
  1054c8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1054cb:	73 30                	jae    1054fd <page_init+0x40d>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1054cd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1054d0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1054d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1054d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1054d9:	29 c8                	sub    %ecx,%eax
  1054db:	19 da                	sbb    %ebx,%edx
  1054dd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1054e1:	c1 ea 0c             	shr    $0xc,%edx
  1054e4:	89 c3                	mov    %eax,%ebx
  1054e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054e9:	89 04 24             	mov    %eax,(%esp)
  1054ec:	e8 6c f8 ff ff       	call   104d5d <pa2page>
  1054f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1054f5:	89 04 24             	mov    %eax,(%esp)
  1054f8:	e8 3f fb ff ff       	call   10503c <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1054fd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  105501:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105504:	8b 00                	mov    (%eax),%eax
  105506:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105509:	0f 8f 72 fe ff ff    	jg     105381 <page_init+0x291>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10550f:	81 c4 ac 00 00 00    	add    $0xac,%esp
  105515:	5b                   	pop    %ebx
  105516:	5e                   	pop    %esi
  105517:	5f                   	pop    %edi
  105518:	5d                   	pop    %ebp
  105519:	c3                   	ret    

0010551a <enable_paging>:

static void
enable_paging(void) {
  10551a:	55                   	push   %ebp
  10551b:	89 e5                	mov    %esp,%ebp
  10551d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  105520:	a1 bc b9 11 00       	mov    0x11b9bc,%eax
  105525:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  105528:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10552b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10552e:	0f 20 c0             	mov    %cr0,%eax
  105531:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  105534:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  105537:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10553a:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  105541:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  105545:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10554b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10554e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  105551:	c9                   	leave  
  105552:	c3                   	ret    

00105553 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  105553:	55                   	push   %ebp
  105554:	89 e5                	mov    %esp,%ebp
  105556:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  105559:	8b 45 14             	mov    0x14(%ebp),%eax
  10555c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10555f:	31 d0                	xor    %edx,%eax
  105561:	25 ff 0f 00 00       	and    $0xfff,%eax
  105566:	85 c0                	test   %eax,%eax
  105568:	74 24                	je     10558e <boot_map_segment+0x3b>
  10556a:	c7 44 24 0c 56 83 10 	movl   $0x108356,0xc(%esp)
  105571:	00 
  105572:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105579:	00 
  10557a:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  105581:	00 
  105582:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105589:	e8 41 b7 ff ff       	call   100ccf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10558e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  105595:	8b 45 0c             	mov    0xc(%ebp),%eax
  105598:	25 ff 0f 00 00       	and    $0xfff,%eax
  10559d:	89 c2                	mov    %eax,%edx
  10559f:	8b 45 10             	mov    0x10(%ebp),%eax
  1055a2:	01 c2                	add    %eax,%edx
  1055a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055a7:	01 d0                	add    %edx,%eax
  1055a9:	83 e8 01             	sub    $0x1,%eax
  1055ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1055af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1055b7:	f7 75 f0             	divl   -0x10(%ebp)
  1055ba:	89 d0                	mov    %edx,%eax
  1055bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055bf:	29 c2                	sub    %eax,%edx
  1055c1:	89 d0                	mov    %edx,%eax
  1055c3:	c1 e8 0c             	shr    $0xc,%eax
  1055c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1055c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1055d7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1055da:	8b 45 14             	mov    0x14(%ebp),%eax
  1055dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1055e8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1055eb:	eb 6b                	jmp    105658 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1055ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1055f4:	00 
  1055f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ff:	89 04 24             	mov    %eax,(%esp)
  105602:	e8 cc 01 00 00       	call   1057d3 <get_pte>
  105607:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10560a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10560e:	75 24                	jne    105634 <boot_map_segment+0xe1>
  105610:	c7 44 24 0c 82 83 10 	movl   $0x108382,0xc(%esp)
  105617:	00 
  105618:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  10561f:	00 
  105620:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  105627:	00 
  105628:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  10562f:	e8 9b b6 ff ff       	call   100ccf <__panic>
        *ptep = pa | PTE_P | perm;
  105634:	8b 45 18             	mov    0x18(%ebp),%eax
  105637:	8b 55 14             	mov    0x14(%ebp),%edx
  10563a:	09 d0                	or     %edx,%eax
  10563c:	83 c8 01             	or     $0x1,%eax
  10563f:	89 c2                	mov    %eax,%edx
  105641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105644:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  105646:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10564a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  105651:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  105658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10565c:	75 8f                	jne    1055ed <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10565e:	c9                   	leave  
  10565f:	c3                   	ret    

00105660 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  105660:	55                   	push   %ebp
  105661:	89 e5                	mov    %esp,%ebp
  105663:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  105666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10566d:	e8 e9 f9 ff ff       	call   10505b <alloc_pages>
  105672:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  105675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105679:	75 1c                	jne    105697 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10567b:	c7 44 24 08 8f 83 10 	movl   $0x10838f,0x8(%esp)
  105682:	00 
  105683:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  10568a:	00 
  10568b:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105692:	e8 38 b6 ff ff       	call   100ccf <__panic>
    }
    return page2kva(p);
  105697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10569a:	89 04 24             	mov    %eax,(%esp)
  10569d:	e8 0a f7 ff ff       	call   104dac <page2kva>
}
  1056a2:	c9                   	leave  
  1056a3:	c3                   	ret    

001056a4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1056a4:	55                   	push   %ebp
  1056a5:	89 e5                	mov    %esp,%ebp
  1056a7:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1056aa:	e8 5a f9 ff ff       	call   105009 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1056af:	e8 3c fa ff ff       	call   1050f0 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1056b4:	e8 75 04 00 00       	call   105b2e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1056b9:	e8 a2 ff ff ff       	call   105660 <boot_alloc_page>
  1056be:	a3 c4 b8 11 00       	mov    %eax,0x11b8c4
    memset(boot_pgdir, 0, PGSIZE);
  1056c3:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1056c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1056cf:	00 
  1056d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1056d7:	00 
  1056d8:	89 04 24             	mov    %eax,(%esp)
  1056db:	e8 b2 1a 00 00       	call   107192 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1056e0:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1056e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056e8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1056ef:	77 23                	ja     105714 <pmm_init+0x70>
  1056f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056f8:	c7 44 24 08 24 83 10 	movl   $0x108324,0x8(%esp)
  1056ff:	00 
  105700:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  105707:	00 
  105708:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  10570f:	e8 bb b5 ff ff       	call   100ccf <__panic>
  105714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105717:	05 00 00 00 40       	add    $0x40000000,%eax
  10571c:	a3 bc b9 11 00       	mov    %eax,0x11b9bc

    check_pgdir();
  105721:	e8 26 04 00 00       	call   105b4c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  105726:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10572b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  105731:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105739:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105740:	77 23                	ja     105765 <pmm_init+0xc1>
  105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105749:	c7 44 24 08 24 83 10 	movl   $0x108324,0x8(%esp)
  105750:	00 
  105751:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  105758:	00 
  105759:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105760:	e8 6a b5 ff ff       	call   100ccf <__panic>
  105765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105768:	05 00 00 00 40       	add    $0x40000000,%eax
  10576d:	83 c8 03             	or     $0x3,%eax
  105770:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  105772:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105777:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10577e:	00 
  10577f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105786:	00 
  105787:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10578e:	38 
  10578f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  105796:	c0 
  105797:	89 04 24             	mov    %eax,(%esp)
  10579a:	e8 b4 fd ff ff       	call   105553 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10579f:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1057a4:	8b 15 c4 b8 11 00    	mov    0x11b8c4,%edx
  1057aa:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1057b0:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1057b2:	e8 63 fd ff ff       	call   10551a <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1057b7:	e8 5e f7 ff ff       	call   104f1a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1057bc:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1057c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1057c7:	e8 1b 0a 00 00       	call   1061e7 <check_boot_pgdir>

    print_pgdir();
  1057cc:	e8 a3 0e 00 00       	call   106674 <print_pgdir>

}
  1057d1:	c9                   	leave  
  1057d2:	c3                   	ret    

001057d3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1057d3:	55                   	push   %ebp
  1057d4:	89 e5                	mov    %esp,%ebp
  1057d6:	83 ec 38             	sub    $0x38,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */ 

    
    pde_t *pdep = &pgdir[PDX(la)];                    // (1) find page directory entry
  1057d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057dc:	c1 e8 16             	shr    $0x16,%eax
  1057df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1057e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e9:	01 d0                	add    %edx,%eax
  1057eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {                           // (2) check if entry is not present
  1057ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057f1:	8b 00                	mov    (%eax),%eax
  1057f3:	83 e0 01             	and    $0x1,%eax
  1057f6:	85 c0                	test   %eax,%eax
  1057f8:	0f 85 b6 00 00 00    	jne    1058b4 <get_pte+0xe1>
        struct Page *p = NULL;
  1057fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        if (!create || (p = alloc_page()) == NULL) {  // (3) check if creating is needed, then alloc page for page table
  105805:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105809:	74 15                	je     105820 <get_pte+0x4d>
  10580b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105812:	e8 44 f8 ff ff       	call   10505b <alloc_pages>
  105817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10581a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10581e:	75 0a                	jne    10582a <get_pte+0x57>
            return NULL;
  105820:	b8 00 00 00 00       	mov    $0x0,%eax
  105825:	e9 e9 00 00 00       	jmp    105913 <get_pte+0x140>
        }
        set_page_ref(p, 1);                           // (4) set page reference
  10582a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105831:	00 
  105832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105835:	89 04 24             	mov    %eax,(%esp)
  105838:	e8 23 f6 ff ff       	call   104e60 <set_page_ref>
        uintptr_t pa = page2pa(p);                    // (5) get linear address of page
  10583d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105840:	89 04 24             	mov    %eax,(%esp)
  105843:	e8 ff f4 ff ff       	call   104d47 <page2pa>
  105848:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                 // (6) clear page content using memset
  10584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10584e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105854:	c1 e8 0c             	shr    $0xc,%eax
  105857:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10585a:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  10585f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105862:	72 23                	jb     105887 <get_pte+0xb4>
  105864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105867:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10586b:	c7 44 24 08 6c 82 10 	movl   $0x10826c,0x8(%esp)
  105872:	00 
  105873:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  10587a:	00 
  10587b:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105882:	e8 48 b4 ff ff       	call   100ccf <__panic>
  105887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10588a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10588f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105896:	00 
  105897:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10589e:	00 
  10589f:	89 04 24             	mov    %eax,(%esp)
  1058a2:	e8 eb 18 00 00       	call   107192 <memset>
        *pdep = pa | PTE_P | PTE_W | PTE_U;           // (7) set page directory entry's permission
  1058a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058aa:	83 c8 07             	or     $0x7,%eax
  1058ad:	89 c2                	mov    %eax,%edx
  1058af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058b2:	89 10                	mov    %edx,(%eax)
    }
    return KADDR(                                     // (8) return page table entry
  1058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b7:	c1 e8 0c             	shr    $0xc,%eax
  1058ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  1058bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1058c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058c9:	8b 00                	mov    (%eax),%eax
  1058cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1058d0:	01 d0                	add    %edx,%eax
  1058d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058d8:	c1 e8 0c             	shr    $0xc,%eax
  1058db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1058de:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  1058e3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1058e6:	72 23                	jb     10590b <get_pte+0x138>
  1058e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058ef:	c7 44 24 08 6c 82 10 	movl   $0x10826c,0x8(%esp)
  1058f6:	00 
  1058f7:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
  1058fe:	00 
  1058ff:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105906:	e8 c4 b3 ff ff       	call   100ccf <__panic>
  10590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10590e:	2d 00 00 00 40       	sub    $0x40000000,%eax
        &((pte_t *)PDE_ADDR(*pdep))[PTX(la)]
    );
}
  105913:	c9                   	leave  
  105914:	c3                   	ret    

00105915 <get_page>:

//get_page - get related Page structfor linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  105915:	55                   	push   %ebp
  105916:	89 e5                	mov    %esp,%ebp
  105918:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10591b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105922:	00 
  105923:	8b 45 0c             	mov    0xc(%ebp),%eax
  105926:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592a:	8b 45 08             	mov    0x8(%ebp),%eax
  10592d:	89 04 24             	mov    %eax,(%esp)
  105930:	e8 9e fe ff ff       	call   1057d3 <get_pte>
  105935:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  105938:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10593c:	74 08                	je     105946 <get_page+0x31>
        *ptep_store = ptep;
  10593e:	8b 45 10             	mov    0x10(%ebp),%eax
  105941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105944:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  105946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10594a:	74 1b                	je     105967 <get_page+0x52>
  10594c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10594f:	8b 00                	mov    (%eax),%eax
  105951:	83 e0 01             	and    $0x1,%eax
  105954:	85 c0                	test   %eax,%eax
  105956:	74 0f                	je     105967 <get_page+0x52>
        return pte2page(*ptep);
  105958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10595b:	8b 00                	mov    (%eax),%eax
  10595d:	89 04 24             	mov    %eax,(%esp)
  105960:	e8 9b f4 ff ff       	call   104e00 <pte2page>
  105965:	eb 05                	jmp    10596c <get_page+0x57>
    }
    return NULL;
  105967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10596c:	c9                   	leave  
  10596d:	c3                   	ret    

0010596e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10596e:	55                   	push   %ebp
  10596f:	89 e5                	mov    %esp,%ebp
  105971:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {                      // (1) check if this page table entry is present
  105974:	8b 45 10             	mov    0x10(%ebp),%eax
  105977:	8b 00                	mov    (%eax),%eax
  105979:	83 e0 01             	and    $0x1,%eax
  10597c:	85 c0                	test   %eax,%eax
  10597e:	74 52                	je     1059d2 <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);  // (2) find corresponding page to pte
  105980:	8b 45 10             	mov    0x10(%ebp),%eax
  105983:	8b 00                	mov    (%eax),%eax
  105985:	89 04 24             	mov    %eax,(%esp)
  105988:	e8 73 f4 ff ff       	call   104e00 <pte2page>
  10598d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                   // (3) decrease page reference
  105990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105993:	89 04 24             	mov    %eax,(%esp)
  105996:	e8 e9 f4 ff ff       	call   104e84 <page_ref_dec>
        if (page->ref == 0) {                 // (4) and free this page when page reference reachs 0
  10599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10599e:	8b 00                	mov    (%eax),%eax
  1059a0:	85 c0                	test   %eax,%eax
  1059a2:	75 13                	jne    1059b7 <page_remove_pte+0x49>
            free_page(page);
  1059a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1059ab:	00 
  1059ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059af:	89 04 24             	mov    %eax,(%esp)
  1059b2:	e8 dc f6 ff ff       	call   105093 <free_pages>
        }
        *ptep = 0;                            // (5) clear second page table entry
  1059b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1059ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);            // (6) flush tlb
  1059c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ca:	89 04 24             	mov    %eax,(%esp)
  1059cd:	e8 ff 00 00 00       	call   105ad1 <tlb_invalidate>
    }
}
  1059d2:	c9                   	leave  
  1059d3:	c3                   	ret    

001059d4 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1059d4:	55                   	push   %ebp
  1059d5:	89 e5                	mov    %esp,%ebp
  1059d7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1059da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1059e1:	00 
  1059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ec:	89 04 24             	mov    %eax,(%esp)
  1059ef:	e8 df fd ff ff       	call   1057d3 <get_pte>
  1059f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1059f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1059fb:	74 19                	je     105a16 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1059fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a00:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0e:	89 04 24             	mov    %eax,(%esp)
  105a11:	e8 58 ff ff ff       	call   10596e <page_remove_pte>
    }
}
  105a16:	c9                   	leave  
  105a17:	c3                   	ret    

00105a18 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  105a18:	55                   	push   %ebp
  105a19:	89 e5                	mov    %esp,%ebp
  105a1b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  105a1e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105a25:	00 
  105a26:	8b 45 10             	mov    0x10(%ebp),%eax
  105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a30:	89 04 24             	mov    %eax,(%esp)
  105a33:	e8 9b fd ff ff       	call   1057d3 <get_pte>
  105a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  105a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105a3f:	75 0a                	jne    105a4b <page_insert+0x33>
        return -E_NO_MEM;
  105a41:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  105a46:	e9 84 00 00 00       	jmp    105acf <page_insert+0xb7>
    }
    page_ref_inc(page);
  105a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4e:	89 04 24             	mov    %eax,(%esp)
  105a51:	e8 17 f4 ff ff       	call   104e6d <page_ref_inc>
    if (*ptep & PTE_P) {
  105a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a59:	8b 00                	mov    (%eax),%eax
  105a5b:	83 e0 01             	and    $0x1,%eax
  105a5e:	85 c0                	test   %eax,%eax
  105a60:	74 3e                	je     105aa0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  105a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a65:	8b 00                	mov    (%eax),%eax
  105a67:	89 04 24             	mov    %eax,(%esp)
  105a6a:	e8 91 f3 ff ff       	call   104e00 <pte2page>
  105a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a75:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105a78:	75 0d                	jne    105a87 <page_insert+0x6f>
            page_ref_dec(page);
  105a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7d:	89 04 24             	mov    %eax,(%esp)
  105a80:	e8 ff f3 ff ff       	call   104e84 <page_ref_dec>
  105a85:	eb 19                	jmp    105aa0 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  105a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a95:	8b 45 08             	mov    0x8(%ebp),%eax
  105a98:	89 04 24             	mov    %eax,(%esp)
  105a9b:	e8 ce fe ff ff       	call   10596e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  105aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa3:	89 04 24             	mov    %eax,(%esp)
  105aa6:	e8 9c f2 ff ff       	call   104d47 <page2pa>
  105aab:	0b 45 14             	or     0x14(%ebp),%eax
  105aae:	83 c8 01             	or     $0x1,%eax
  105ab1:	89 c2                	mov    %eax,%edx
  105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ab6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  105ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac2:	89 04 24             	mov    %eax,(%esp)
  105ac5:	e8 07 00 00 00       	call   105ad1 <tlb_invalidate>
    return 0;
  105aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105acf:	c9                   	leave  
  105ad0:	c3                   	ret    

00105ad1 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  105ad1:	55                   	push   %ebp
  105ad2:	89 e5                	mov    %esp,%ebp
  105ad4:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  105ad7:	0f 20 d8             	mov    %cr3,%eax
  105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  105add:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  105ae0:	89 c2                	mov    %eax,%edx
  105ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ae8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  105aef:	77 23                	ja     105b14 <tlb_invalidate+0x43>
  105af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105af4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105af8:	c7 44 24 08 24 83 10 	movl   $0x108324,0x8(%esp)
  105aff:	00 
  105b00:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
  105b07:	00 
  105b08:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105b0f:	e8 bb b1 ff ff       	call   100ccf <__panic>
  105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b17:	05 00 00 00 40       	add    $0x40000000,%eax
  105b1c:	39 c2                	cmp    %eax,%edx
  105b1e:	75 0c                	jne    105b2c <tlb_invalidate+0x5b>
        invlpg((void *)la);
  105b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  105b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b29:	0f 01 38             	invlpg (%eax)
    }
}
  105b2c:	c9                   	leave  
  105b2d:	c3                   	ret    

00105b2e <check_alloc_page>:

static void
check_alloc_page(void) {
  105b2e:	55                   	push   %ebp
  105b2f:	89 e5                	mov    %esp,%ebp
  105b31:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  105b34:	a1 b8 b9 11 00       	mov    0x11b9b8,%eax
  105b39:	8b 40 18             	mov    0x18(%eax),%eax
  105b3c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  105b3e:	c7 04 24 a8 83 10 00 	movl   $0x1083a8,(%esp)
  105b45:	e8 f9 a7 ff ff       	call   100343 <cprintf>
}
  105b4a:	c9                   	leave  
  105b4b:	c3                   	ret    

00105b4c <check_pgdir>:

static void
check_pgdir(void) {
  105b4c:	55                   	push   %ebp
  105b4d:	89 e5                	mov    %esp,%ebp
  105b4f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  105b52:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  105b57:	3d 00 80 03 00       	cmp    $0x38000,%eax
  105b5c:	76 24                	jbe    105b82 <check_pgdir+0x36>
  105b5e:	c7 44 24 0c c7 83 10 	movl   $0x1083c7,0xc(%esp)
  105b65:	00 
  105b66:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105b6d:	00 
  105b6e:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  105b75:	00 
  105b76:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105b7d:	e8 4d b1 ff ff       	call   100ccf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  105b82:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105b87:	85 c0                	test   %eax,%eax
  105b89:	74 0e                	je     105b99 <check_pgdir+0x4d>
  105b8b:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105b90:	25 ff 0f 00 00       	and    $0xfff,%eax
  105b95:	85 c0                	test   %eax,%eax
  105b97:	74 24                	je     105bbd <check_pgdir+0x71>
  105b99:	c7 44 24 0c e4 83 10 	movl   $0x1083e4,0xc(%esp)
  105ba0:	00 
  105ba1:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105ba8:	00 
  105ba9:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  105bb0:	00 
  105bb1:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105bb8:	e8 12 b1 ff ff       	call   100ccf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  105bbd:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105bc2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105bc9:	00 
  105bca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105bd1:	00 
  105bd2:	89 04 24             	mov    %eax,(%esp)
  105bd5:	e8 3b fd ff ff       	call   105915 <get_page>
  105bda:	85 c0                	test   %eax,%eax
  105bdc:	74 24                	je     105c02 <check_pgdir+0xb6>
  105bde:	c7 44 24 0c 1c 84 10 	movl   $0x10841c,0xc(%esp)
  105be5:	00 
  105be6:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105bed:	00 
  105bee:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  105bf5:	00 
  105bf6:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105bfd:	e8 cd b0 ff ff       	call   100ccf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  105c02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c09:	e8 4d f4 ff ff       	call   10505b <alloc_pages>
  105c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  105c11:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105c16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105c1d:	00 
  105c1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105c25:	00 
  105c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c29:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c2d:	89 04 24             	mov    %eax,(%esp)
  105c30:	e8 e3 fd ff ff       	call   105a18 <page_insert>
  105c35:	85 c0                	test   %eax,%eax
  105c37:	74 24                	je     105c5d <check_pgdir+0x111>
  105c39:	c7 44 24 0c 44 84 10 	movl   $0x108444,0xc(%esp)
  105c40:	00 
  105c41:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105c48:	00 
  105c49:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  105c50:	00 
  105c51:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105c58:	e8 72 b0 ff ff       	call   100ccf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  105c5d:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105c62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105c69:	00 
  105c6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105c71:	00 
  105c72:	89 04 24             	mov    %eax,(%esp)
  105c75:	e8 59 fb ff ff       	call   1057d3 <get_pte>
  105c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105c81:	75 24                	jne    105ca7 <check_pgdir+0x15b>
  105c83:	c7 44 24 0c 70 84 10 	movl   $0x108470,0xc(%esp)
  105c8a:	00 
  105c8b:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105c92:	00 
  105c93:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  105c9a:	00 
  105c9b:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105ca2:	e8 28 b0 ff ff       	call   100ccf <__panic>
    assert(pte2page(*ptep) == p1);
  105ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105caa:	8b 00                	mov    (%eax),%eax
  105cac:	89 04 24             	mov    %eax,(%esp)
  105caf:	e8 4c f1 ff ff       	call   104e00 <pte2page>
  105cb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105cb7:	74 24                	je     105cdd <check_pgdir+0x191>
  105cb9:	c7 44 24 0c 9d 84 10 	movl   $0x10849d,0xc(%esp)
  105cc0:	00 
  105cc1:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105cc8:	00 
  105cc9:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  105cd0:	00 
  105cd1:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105cd8:	e8 f2 af ff ff       	call   100ccf <__panic>
    assert(page_ref(p1) == 1);
  105cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ce0:	89 04 24             	mov    %eax,(%esp)
  105ce3:	e8 6e f1 ff ff       	call   104e56 <page_ref>
  105ce8:	83 f8 01             	cmp    $0x1,%eax
  105ceb:	74 24                	je     105d11 <check_pgdir+0x1c5>
  105ced:	c7 44 24 0c b3 84 10 	movl   $0x1084b3,0xc(%esp)
  105cf4:	00 
  105cf5:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105cfc:	00 
  105cfd:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  105d04:	00 
  105d05:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105d0c:	e8 be af ff ff       	call   100ccf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  105d11:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105d16:	8b 00                	mov    (%eax),%eax
  105d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d23:	c1 e8 0c             	shr    $0xc,%eax
  105d26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d29:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  105d2e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105d31:	72 23                	jb     105d56 <check_pgdir+0x20a>
  105d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d3a:	c7 44 24 08 6c 82 10 	movl   $0x10826c,0x8(%esp)
  105d41:	00 
  105d42:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  105d49:	00 
  105d4a:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105d51:	e8 79 af ff ff       	call   100ccf <__panic>
  105d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d59:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105d5e:	83 c0 04             	add    $0x4,%eax
  105d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  105d64:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105d69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105d70:	00 
  105d71:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105d78:	00 
  105d79:	89 04 24             	mov    %eax,(%esp)
  105d7c:	e8 52 fa ff ff       	call   1057d3 <get_pte>
  105d81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  105d84:	74 24                	je     105daa <check_pgdir+0x25e>
  105d86:	c7 44 24 0c c8 84 10 	movl   $0x1084c8,0xc(%esp)
  105d8d:	00 
  105d8e:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105d95:	00 
  105d96:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  105d9d:	00 
  105d9e:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105da5:	e8 25 af ff ff       	call   100ccf <__panic>

    p2 = alloc_page();
  105daa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105db1:	e8 a5 f2 ff ff       	call   10505b <alloc_pages>
  105db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  105db9:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105dbe:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  105dc5:	00 
  105dc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105dcd:	00 
  105dce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105dd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  105dd5:	89 04 24             	mov    %eax,(%esp)
  105dd8:	e8 3b fc ff ff       	call   105a18 <page_insert>
  105ddd:	85 c0                	test   %eax,%eax
  105ddf:	74 24                	je     105e05 <check_pgdir+0x2b9>
  105de1:	c7 44 24 0c f0 84 10 	movl   $0x1084f0,0xc(%esp)
  105de8:	00 
  105de9:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105df0:	00 
  105df1:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  105df8:	00 
  105df9:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105e00:	e8 ca ae ff ff       	call   100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105e05:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105e0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105e11:	00 
  105e12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105e19:	00 
  105e1a:	89 04 24             	mov    %eax,(%esp)
  105e1d:	e8 b1 f9 ff ff       	call   1057d3 <get_pte>
  105e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105e29:	75 24                	jne    105e4f <check_pgdir+0x303>
  105e2b:	c7 44 24 0c 28 85 10 	movl   $0x108528,0xc(%esp)
  105e32:	00 
  105e33:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105e3a:	00 
  105e3b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  105e42:	00 
  105e43:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105e4a:	e8 80 ae ff ff       	call   100ccf <__panic>
    assert(*ptep & PTE_U);
  105e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e52:	8b 00                	mov    (%eax),%eax
  105e54:	83 e0 04             	and    $0x4,%eax
  105e57:	85 c0                	test   %eax,%eax
  105e59:	75 24                	jne    105e7f <check_pgdir+0x333>
  105e5b:	c7 44 24 0c 58 85 10 	movl   $0x108558,0xc(%esp)
  105e62:	00 
  105e63:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105e6a:	00 
  105e6b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  105e72:	00 
  105e73:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105e7a:	e8 50 ae ff ff       	call   100ccf <__panic>
    assert(*ptep & PTE_W);
  105e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e82:	8b 00                	mov    (%eax),%eax
  105e84:	83 e0 02             	and    $0x2,%eax
  105e87:	85 c0                	test   %eax,%eax
  105e89:	75 24                	jne    105eaf <check_pgdir+0x363>
  105e8b:	c7 44 24 0c 66 85 10 	movl   $0x108566,0xc(%esp)
  105e92:	00 
  105e93:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105e9a:	00 
  105e9b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  105ea2:	00 
  105ea3:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105eaa:	e8 20 ae ff ff       	call   100ccf <__panic>
    assert(boot_pgdir[0] & PTE_U);
  105eaf:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105eb4:	8b 00                	mov    (%eax),%eax
  105eb6:	83 e0 04             	and    $0x4,%eax
  105eb9:	85 c0                	test   %eax,%eax
  105ebb:	75 24                	jne    105ee1 <check_pgdir+0x395>
  105ebd:	c7 44 24 0c 74 85 10 	movl   $0x108574,0xc(%esp)
  105ec4:	00 
  105ec5:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105ecc:	00 
  105ecd:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  105ed4:	00 
  105ed5:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105edc:	e8 ee ad ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 1);
  105ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ee4:	89 04 24             	mov    %eax,(%esp)
  105ee7:	e8 6a ef ff ff       	call   104e56 <page_ref>
  105eec:	83 f8 01             	cmp    $0x1,%eax
  105eef:	74 24                	je     105f15 <check_pgdir+0x3c9>
  105ef1:	c7 44 24 0c 8a 85 10 	movl   $0x10858a,0xc(%esp)
  105ef8:	00 
  105ef9:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105f00:	00 
  105f01:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  105f08:	00 
  105f09:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105f10:	e8 ba ad ff ff       	call   100ccf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  105f15:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105f1a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105f21:	00 
  105f22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105f29:	00 
  105f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105f31:	89 04 24             	mov    %eax,(%esp)
  105f34:	e8 df fa ff ff       	call   105a18 <page_insert>
  105f39:	85 c0                	test   %eax,%eax
  105f3b:	74 24                	je     105f61 <check_pgdir+0x415>
  105f3d:	c7 44 24 0c 9c 85 10 	movl   $0x10859c,0xc(%esp)
  105f44:	00 
  105f45:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105f4c:	00 
  105f4d:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  105f54:	00 
  105f55:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105f5c:	e8 6e ad ff ff       	call   100ccf <__panic>
    assert(page_ref(p1) == 2);
  105f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f64:	89 04 24             	mov    %eax,(%esp)
  105f67:	e8 ea ee ff ff       	call   104e56 <page_ref>
  105f6c:	83 f8 02             	cmp    $0x2,%eax
  105f6f:	74 24                	je     105f95 <check_pgdir+0x449>
  105f71:	c7 44 24 0c c8 85 10 	movl   $0x1085c8,0xc(%esp)
  105f78:	00 
  105f79:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105f80:	00 
  105f81:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  105f88:	00 
  105f89:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105f90:	e8 3a ad ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  105f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f98:	89 04 24             	mov    %eax,(%esp)
  105f9b:	e8 b6 ee ff ff       	call   104e56 <page_ref>
  105fa0:	85 c0                	test   %eax,%eax
  105fa2:	74 24                	je     105fc8 <check_pgdir+0x47c>
  105fa4:	c7 44 24 0c da 85 10 	movl   $0x1085da,0xc(%esp)
  105fab:	00 
  105fac:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105fb3:	00 
  105fb4:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  105fbb:	00 
  105fbc:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  105fc3:	e8 07 ad ff ff       	call   100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105fc8:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  105fcd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105fd4:	00 
  105fd5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105fdc:	00 
  105fdd:	89 04 24             	mov    %eax,(%esp)
  105fe0:	e8 ee f7 ff ff       	call   1057d3 <get_pte>
  105fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105fec:	75 24                	jne    106012 <check_pgdir+0x4c6>
  105fee:	c7 44 24 0c 28 85 10 	movl   $0x108528,0xc(%esp)
  105ff5:	00 
  105ff6:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  105ffd:	00 
  105ffe:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  106005:	00 
  106006:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  10600d:	e8 bd ac ff ff       	call   100ccf <__panic>
    assert(pte2page(*ptep) == p1);
  106012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106015:	8b 00                	mov    (%eax),%eax
  106017:	89 04 24             	mov    %eax,(%esp)
  10601a:	e8 e1 ed ff ff       	call   104e00 <pte2page>
  10601f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  106022:	74 24                	je     106048 <check_pgdir+0x4fc>
  106024:	c7 44 24 0c 9d 84 10 	movl   $0x10849d,0xc(%esp)
  10602b:	00 
  10602c:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106033:	00 
  106034:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  10603b:	00 
  10603c:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106043:	e8 87 ac ff ff       	call   100ccf <__panic>
    assert((*ptep & PTE_U) == 0);
  106048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10604b:	8b 00                	mov    (%eax),%eax
  10604d:	83 e0 04             	and    $0x4,%eax
  106050:	85 c0                	test   %eax,%eax
  106052:	74 24                	je     106078 <check_pgdir+0x52c>
  106054:	c7 44 24 0c ec 85 10 	movl   $0x1085ec,0xc(%esp)
  10605b:	00 
  10605c:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106063:	00 
  106064:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  10606b:	00 
  10606c:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106073:	e8 57 ac ff ff       	call   100ccf <__panic>

    page_remove(boot_pgdir, 0x0);
  106078:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10607d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106084:	00 
  106085:	89 04 24             	mov    %eax,(%esp)
  106088:	e8 47 f9 ff ff       	call   1059d4 <page_remove>
    assert(page_ref(p1) == 1);
  10608d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106090:	89 04 24             	mov    %eax,(%esp)
  106093:	e8 be ed ff ff       	call   104e56 <page_ref>
  106098:	83 f8 01             	cmp    $0x1,%eax
  10609b:	74 24                	je     1060c1 <check_pgdir+0x575>
  10609d:	c7 44 24 0c b3 84 10 	movl   $0x1084b3,0xc(%esp)
  1060a4:	00 
  1060a5:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1060ac:	00 
  1060ad:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1060b4:	00 
  1060b5:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1060bc:	e8 0e ac ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  1060c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060c4:	89 04 24             	mov    %eax,(%esp)
  1060c7:	e8 8a ed ff ff       	call   104e56 <page_ref>
  1060cc:	85 c0                	test   %eax,%eax
  1060ce:	74 24                	je     1060f4 <check_pgdir+0x5a8>
  1060d0:	c7 44 24 0c da 85 10 	movl   $0x1085da,0xc(%esp)
  1060d7:	00 
  1060d8:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1060df:	00 
  1060e0:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  1060e7:	00 
  1060e8:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1060ef:	e8 db ab ff ff       	call   100ccf <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1060f4:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1060f9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  106100:	00 
  106101:	89 04 24             	mov    %eax,(%esp)
  106104:	e8 cb f8 ff ff       	call   1059d4 <page_remove>
    assert(page_ref(p1) == 0);
  106109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10610c:	89 04 24             	mov    %eax,(%esp)
  10610f:	e8 42 ed ff ff       	call   104e56 <page_ref>
  106114:	85 c0                	test   %eax,%eax
  106116:	74 24                	je     10613c <check_pgdir+0x5f0>
  106118:	c7 44 24 0c 01 86 10 	movl   $0x108601,0xc(%esp)
  10611f:	00 
  106120:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106127:	00 
  106128:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  10612f:	00 
  106130:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106137:	e8 93 ab ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  10613c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10613f:	89 04 24             	mov    %eax,(%esp)
  106142:	e8 0f ed ff ff       	call   104e56 <page_ref>
  106147:	85 c0                	test   %eax,%eax
  106149:	74 24                	je     10616f <check_pgdir+0x623>
  10614b:	c7 44 24 0c da 85 10 	movl   $0x1085da,0xc(%esp)
  106152:	00 
  106153:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  10615a:	00 
  10615b:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  106162:	00 
  106163:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  10616a:	e8 60 ab ff ff       	call   100ccf <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  10616f:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  106174:	8b 00                	mov    (%eax),%eax
  106176:	89 04 24             	mov    %eax,(%esp)
  106179:	e8 c0 ec ff ff       	call   104e3e <pde2page>
  10617e:	89 04 24             	mov    %eax,(%esp)
  106181:	e8 d0 ec ff ff       	call   104e56 <page_ref>
  106186:	83 f8 01             	cmp    $0x1,%eax
  106189:	74 24                	je     1061af <check_pgdir+0x663>
  10618b:	c7 44 24 0c 14 86 10 	movl   $0x108614,0xc(%esp)
  106192:	00 
  106193:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  10619a:	00 
  10619b:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  1061a2:	00 
  1061a3:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1061aa:	e8 20 ab ff ff       	call   100ccf <__panic>
    free_page(pde2page(boot_pgdir[0]));
  1061af:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1061b4:	8b 00                	mov    (%eax),%eax
  1061b6:	89 04 24             	mov    %eax,(%esp)
  1061b9:	e8 80 ec ff ff       	call   104e3e <pde2page>
  1061be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1061c5:	00 
  1061c6:	89 04 24             	mov    %eax,(%esp)
  1061c9:	e8 c5 ee ff ff       	call   105093 <free_pages>
    boot_pgdir[0] = 0;
  1061ce:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1061d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1061d9:	c7 04 24 3b 86 10 00 	movl   $0x10863b,(%esp)
  1061e0:	e8 5e a1 ff ff       	call   100343 <cprintf>
}
  1061e5:	c9                   	leave  
  1061e6:	c3                   	ret    

001061e7 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1061e7:	55                   	push   %ebp
  1061e8:	89 e5                	mov    %esp,%ebp
  1061ea:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1061ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1061f4:	e9 ca 00 00 00       	jmp    1062c3 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1061f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1061fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106202:	c1 e8 0c             	shr    $0xc,%eax
  106205:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106208:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  10620d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  106210:	72 23                	jb     106235 <check_boot_pgdir+0x4e>
  106212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106215:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106219:	c7 44 24 08 6c 82 10 	movl   $0x10826c,0x8(%esp)
  106220:	00 
  106221:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  106228:	00 
  106229:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106230:	e8 9a aa ff ff       	call   100ccf <__panic>
  106235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106238:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10623d:	89 c2                	mov    %eax,%edx
  10623f:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  106244:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10624b:	00 
  10624c:	89 54 24 04          	mov    %edx,0x4(%esp)
  106250:	89 04 24             	mov    %eax,(%esp)
  106253:	e8 7b f5 ff ff       	call   1057d3 <get_pte>
  106258:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10625b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10625f:	75 24                	jne    106285 <check_boot_pgdir+0x9e>
  106261:	c7 44 24 0c 58 86 10 	movl   $0x108658,0xc(%esp)
  106268:	00 
  106269:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106270:	00 
  106271:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  106278:	00 
  106279:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106280:	e8 4a aa ff ff       	call   100ccf <__panic>
        assert(PTE_ADDR(*ptep) == i);
  106285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106288:	8b 00                	mov    (%eax),%eax
  10628a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10628f:	89 c2                	mov    %eax,%edx
  106291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106294:	39 c2                	cmp    %eax,%edx
  106296:	74 24                	je     1062bc <check_boot_pgdir+0xd5>
  106298:	c7 44 24 0c 95 86 10 	movl   $0x108695,0xc(%esp)
  10629f:	00 
  1062a0:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1062a7:	00 
  1062a8:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  1062af:	00 
  1062b0:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1062b7:	e8 13 aa ff ff       	call   100ccf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1062bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1062c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1062c6:	a1 c0 b8 11 00       	mov    0x11b8c0,%eax
  1062cb:	39 c2                	cmp    %eax,%edx
  1062cd:	0f 82 26 ff ff ff    	jb     1061f9 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1062d3:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1062d8:	05 ac 0f 00 00       	add    $0xfac,%eax
  1062dd:	8b 00                	mov    (%eax),%eax
  1062df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1062e4:	89 c2                	mov    %eax,%edx
  1062e6:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  1062eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1062ee:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1062f5:	77 23                	ja     10631a <check_boot_pgdir+0x133>
  1062f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1062fe:	c7 44 24 08 24 83 10 	movl   $0x108324,0x8(%esp)
  106305:	00 
  106306:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  10630d:	00 
  10630e:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106315:	e8 b5 a9 ff ff       	call   100ccf <__panic>
  10631a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10631d:	05 00 00 00 40       	add    $0x40000000,%eax
  106322:	39 c2                	cmp    %eax,%edx
  106324:	74 24                	je     10634a <check_boot_pgdir+0x163>
  106326:	c7 44 24 0c ac 86 10 	movl   $0x1086ac,0xc(%esp)
  10632d:	00 
  10632e:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106335:	00 
  106336:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  10633d:	00 
  10633e:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106345:	e8 85 a9 ff ff       	call   100ccf <__panic>

    assert(boot_pgdir[0] == 0);
  10634a:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10634f:	8b 00                	mov    (%eax),%eax
  106351:	85 c0                	test   %eax,%eax
  106353:	74 24                	je     106379 <check_boot_pgdir+0x192>
  106355:	c7 44 24 0c e0 86 10 	movl   $0x1086e0,0xc(%esp)
  10635c:	00 
  10635d:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106364:	00 
  106365:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  10636c:	00 
  10636d:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106374:	e8 56 a9 ff ff       	call   100ccf <__panic>

    struct Page *p;
    p = alloc_page();
  106379:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106380:	e8 d6 ec ff ff       	call   10505b <alloc_pages>
  106385:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  106388:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10638d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  106394:	00 
  106395:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10639c:	00 
  10639d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1063a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1063a4:	89 04 24             	mov    %eax,(%esp)
  1063a7:	e8 6c f6 ff ff       	call   105a18 <page_insert>
  1063ac:	85 c0                	test   %eax,%eax
  1063ae:	74 24                	je     1063d4 <check_boot_pgdir+0x1ed>
  1063b0:	c7 44 24 0c f4 86 10 	movl   $0x1086f4,0xc(%esp)
  1063b7:	00 
  1063b8:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1063bf:	00 
  1063c0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  1063c7:	00 
  1063c8:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1063cf:	e8 fb a8 ff ff       	call   100ccf <__panic>
    assert(page_ref(p) == 1);
  1063d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1063d7:	89 04 24             	mov    %eax,(%esp)
  1063da:	e8 77 ea ff ff       	call   104e56 <page_ref>
  1063df:	83 f8 01             	cmp    $0x1,%eax
  1063e2:	74 24                	je     106408 <check_boot_pgdir+0x221>
  1063e4:	c7 44 24 0c 22 87 10 	movl   $0x108722,0xc(%esp)
  1063eb:	00 
  1063ec:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1063f3:	00 
  1063f4:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  1063fb:	00 
  1063fc:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106403:	e8 c7 a8 ff ff       	call   100ccf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  106408:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10640d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  106414:	00 
  106415:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10641c:	00 
  10641d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106420:	89 54 24 04          	mov    %edx,0x4(%esp)
  106424:	89 04 24             	mov    %eax,(%esp)
  106427:	e8 ec f5 ff ff       	call   105a18 <page_insert>
  10642c:	85 c0                	test   %eax,%eax
  10642e:	74 24                	je     106454 <check_boot_pgdir+0x26d>
  106430:	c7 44 24 0c 34 87 10 	movl   $0x108734,0xc(%esp)
  106437:	00 
  106438:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  10643f:	00 
  106440:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  106447:	00 
  106448:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  10644f:	e8 7b a8 ff ff       	call   100ccf <__panic>
    assert(page_ref(p) == 2);
  106454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106457:	89 04 24             	mov    %eax,(%esp)
  10645a:	e8 f7 e9 ff ff       	call   104e56 <page_ref>
  10645f:	83 f8 02             	cmp    $0x2,%eax
  106462:	74 24                	je     106488 <check_boot_pgdir+0x2a1>
  106464:	c7 44 24 0c 6b 87 10 	movl   $0x10876b,0xc(%esp)
  10646b:	00 
  10646c:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106473:	00 
  106474:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  10647b:	00 
  10647c:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106483:	e8 47 a8 ff ff       	call   100ccf <__panic>

    const char *str = "ucore: Hello world!!";
  106488:	c7 45 dc 7c 87 10 00 	movl   $0x10877c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  10648f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106492:	89 44 24 04          	mov    %eax,0x4(%esp)
  106496:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10649d:	e8 19 0a 00 00       	call   106ebb <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1064a2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1064a9:	00 
  1064aa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1064b1:	e8 7e 0a 00 00       	call   106f34 <strcmp>
  1064b6:	85 c0                	test   %eax,%eax
  1064b8:	74 24                	je     1064de <check_boot_pgdir+0x2f7>
  1064ba:	c7 44 24 0c 94 87 10 	movl   $0x108794,0xc(%esp)
  1064c1:	00 
  1064c2:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  1064c9:	00 
  1064ca:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  1064d1:	00 
  1064d2:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  1064d9:	e8 f1 a7 ff ff       	call   100ccf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1064de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1064e1:	89 04 24             	mov    %eax,(%esp)
  1064e4:	e8 c3 e8 ff ff       	call   104dac <page2kva>
  1064e9:	05 00 01 00 00       	add    $0x100,%eax
  1064ee:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1064f1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1064f8:	e8 66 09 00 00       	call   106e63 <strlen>
  1064fd:	85 c0                	test   %eax,%eax
  1064ff:	74 24                	je     106525 <check_boot_pgdir+0x33e>
  106501:	c7 44 24 0c cc 87 10 	movl   $0x1087cc,0xc(%esp)
  106508:	00 
  106509:	c7 44 24 08 6d 83 10 	movl   $0x10836d,0x8(%esp)
  106510:	00 
  106511:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  106518:	00 
  106519:	c7 04 24 48 83 10 00 	movl   $0x108348,(%esp)
  106520:	e8 aa a7 ff ff       	call   100ccf <__panic>

    free_page(p);
  106525:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10652c:	00 
  10652d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106530:	89 04 24             	mov    %eax,(%esp)
  106533:	e8 5b eb ff ff       	call   105093 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  106538:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10653d:	8b 00                	mov    (%eax),%eax
  10653f:	89 04 24             	mov    %eax,(%esp)
  106542:	e8 f7 e8 ff ff       	call   104e3e <pde2page>
  106547:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10654e:	00 
  10654f:	89 04 24             	mov    %eax,(%esp)
  106552:	e8 3c eb ff ff       	call   105093 <free_pages>
    boot_pgdir[0] = 0;
  106557:	a1 c4 b8 11 00       	mov    0x11b8c4,%eax
  10655c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  106562:	c7 04 24 f0 87 10 00 	movl   $0x1087f0,(%esp)
  106569:	e8 d5 9d ff ff       	call   100343 <cprintf>
}
  10656e:	c9                   	leave  
  10656f:	c3                   	ret    

00106570 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  106570:	55                   	push   %ebp
  106571:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  106573:	8b 45 08             	mov    0x8(%ebp),%eax
  106576:	83 e0 04             	and    $0x4,%eax
  106579:	85 c0                	test   %eax,%eax
  10657b:	74 07                	je     106584 <perm2str+0x14>
  10657d:	b8 75 00 00 00       	mov    $0x75,%eax
  106582:	eb 05                	jmp    106589 <perm2str+0x19>
  106584:	b8 2d 00 00 00       	mov    $0x2d,%eax
  106589:	a2 48 b9 11 00       	mov    %al,0x11b948
    str[1] = 'r';
  10658e:	c6 05 49 b9 11 00 72 	movb   $0x72,0x11b949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  106595:	8b 45 08             	mov    0x8(%ebp),%eax
  106598:	83 e0 02             	and    $0x2,%eax
  10659b:	85 c0                	test   %eax,%eax
  10659d:	74 07                	je     1065a6 <perm2str+0x36>
  10659f:	b8 77 00 00 00       	mov    $0x77,%eax
  1065a4:	eb 05                	jmp    1065ab <perm2str+0x3b>
  1065a6:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1065ab:	a2 4a b9 11 00       	mov    %al,0x11b94a
    str[3] = '\0';
  1065b0:	c6 05 4b b9 11 00 00 	movb   $0x0,0x11b94b
    return str;
  1065b7:	b8 48 b9 11 00       	mov    $0x11b948,%eax
}
  1065bc:	5d                   	pop    %ebp
  1065bd:	c3                   	ret    

001065be <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1065be:	55                   	push   %ebp
  1065bf:	89 e5                	mov    %esp,%ebp
  1065c1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1065c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1065c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1065ca:	72 0a                	jb     1065d6 <get_pgtable_items+0x18>
        return 0;
  1065cc:	b8 00 00 00 00       	mov    $0x0,%eax
  1065d1:	e9 9c 00 00 00       	jmp    106672 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1065d6:	eb 04                	jmp    1065dc <get_pgtable_items+0x1e>
        start ++;
  1065d8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1065dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1065df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1065e2:	73 18                	jae    1065fc <get_pgtable_items+0x3e>
  1065e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1065e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1065ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1065f1:	01 d0                	add    %edx,%eax
  1065f3:	8b 00                	mov    (%eax),%eax
  1065f5:	83 e0 01             	and    $0x1,%eax
  1065f8:	85 c0                	test   %eax,%eax
  1065fa:	74 dc                	je     1065d8 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1065fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1065ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106602:	73 69                	jae    10666d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  106604:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  106608:	74 08                	je     106612 <get_pgtable_items+0x54>
            *left_store = start;
  10660a:	8b 45 18             	mov    0x18(%ebp),%eax
  10660d:	8b 55 10             	mov    0x10(%ebp),%edx
  106610:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  106612:	8b 45 10             	mov    0x10(%ebp),%eax
  106615:	8d 50 01             	lea    0x1(%eax),%edx
  106618:	89 55 10             	mov    %edx,0x10(%ebp)
  10661b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106622:	8b 45 14             	mov    0x14(%ebp),%eax
  106625:	01 d0                	add    %edx,%eax
  106627:	8b 00                	mov    (%eax),%eax
  106629:	83 e0 07             	and    $0x7,%eax
  10662c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10662f:	eb 04                	jmp    106635 <get_pgtable_items+0x77>
            start ++;
  106631:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  106635:	8b 45 10             	mov    0x10(%ebp),%eax
  106638:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10663b:	73 1d                	jae    10665a <get_pgtable_items+0x9c>
  10663d:	8b 45 10             	mov    0x10(%ebp),%eax
  106640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106647:	8b 45 14             	mov    0x14(%ebp),%eax
  10664a:	01 d0                	add    %edx,%eax
  10664c:	8b 00                	mov    (%eax),%eax
  10664e:	83 e0 07             	and    $0x7,%eax
  106651:	89 c2                	mov    %eax,%edx
  106653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106656:	39 c2                	cmp    %eax,%edx
  106658:	74 d7                	je     106631 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10665a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10665e:	74 08                	je     106668 <get_pgtable_items+0xaa>
            *right_store = start;
  106660:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106663:	8b 55 10             	mov    0x10(%ebp),%edx
  106666:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  106668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10666b:	eb 05                	jmp    106672 <get_pgtable_items+0xb4>
    }
    return 0;
  10666d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106672:	c9                   	leave  
  106673:	c3                   	ret    

00106674 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  106674:	55                   	push   %ebp
  106675:	89 e5                	mov    %esp,%ebp
  106677:	57                   	push   %edi
  106678:	56                   	push   %esi
  106679:	53                   	push   %ebx
  10667a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10667d:	c7 04 24 10 88 10 00 	movl   $0x108810,(%esp)
  106684:	e8 ba 9c ff ff       	call   100343 <cprintf>
    size_t left, right = 0, perm;
  106689:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  106690:	e9 fa 00 00 00       	jmp    10678f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106698:	89 04 24             	mov    %eax,(%esp)
  10669b:	e8 d0 fe ff ff       	call   106570 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1066a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1066a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1066a6:	29 d1                	sub    %edx,%ecx
  1066a8:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1066aa:	89 d6                	mov    %edx,%esi
  1066ac:	c1 e6 16             	shl    $0x16,%esi
  1066af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1066b2:	89 d3                	mov    %edx,%ebx
  1066b4:	c1 e3 16             	shl    $0x16,%ebx
  1066b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1066ba:	89 d1                	mov    %edx,%ecx
  1066bc:	c1 e1 16             	shl    $0x16,%ecx
  1066bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1066c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1066c5:	29 d7                	sub    %edx,%edi
  1066c7:	89 fa                	mov    %edi,%edx
  1066c9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1066cd:	89 74 24 10          	mov    %esi,0x10(%esp)
  1066d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1066d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1066d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1066dd:	c7 04 24 41 88 10 00 	movl   $0x108841,(%esp)
  1066e4:	e8 5a 9c ff ff       	call   100343 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1066e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066ec:	c1 e0 0a             	shl    $0xa,%eax
  1066ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1066f2:	eb 54                	jmp    106748 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1066f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1066f7:	89 04 24             	mov    %eax,(%esp)
  1066fa:	e8 71 fe ff ff       	call   106570 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1066ff:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  106702:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106705:	29 d1                	sub    %edx,%ecx
  106707:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106709:	89 d6                	mov    %edx,%esi
  10670b:	c1 e6 0c             	shl    $0xc,%esi
  10670e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106711:	89 d3                	mov    %edx,%ebx
  106713:	c1 e3 0c             	shl    $0xc,%ebx
  106716:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106719:	c1 e2 0c             	shl    $0xc,%edx
  10671c:	89 d1                	mov    %edx,%ecx
  10671e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  106721:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106724:	29 d7                	sub    %edx,%edi
  106726:	89 fa                	mov    %edi,%edx
  106728:	89 44 24 14          	mov    %eax,0x14(%esp)
  10672c:	89 74 24 10          	mov    %esi,0x10(%esp)
  106730:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106734:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106738:	89 54 24 04          	mov    %edx,0x4(%esp)
  10673c:	c7 04 24 60 88 10 00 	movl   $0x108860,(%esp)
  106743:	e8 fb 9b ff ff       	call   100343 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  106748:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10674d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106750:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106753:	89 ce                	mov    %ecx,%esi
  106755:	c1 e6 0a             	shl    $0xa,%esi
  106758:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10675b:	89 cb                	mov    %ecx,%ebx
  10675d:	c1 e3 0a             	shl    $0xa,%ebx
  106760:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  106763:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  106767:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10676a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10676e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106772:	89 44 24 08          	mov    %eax,0x8(%esp)
  106776:	89 74 24 04          	mov    %esi,0x4(%esp)
  10677a:	89 1c 24             	mov    %ebx,(%esp)
  10677d:	e8 3c fe ff ff       	call   1065be <get_pgtable_items>
  106782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106785:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106789:	0f 85 65 ff ff ff    	jne    1066f4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10678f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  106794:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106797:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10679a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10679e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1067a1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1067a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1067a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1067ad:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1067b4:	00 
  1067b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1067bc:	e8 fd fd ff ff       	call   1065be <get_pgtable_items>
  1067c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1067c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1067c8:	0f 85 c7 fe ff ff    	jne    106695 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1067ce:	c7 04 24 84 88 10 00 	movl   $0x108884,(%esp)
  1067d5:	e8 69 9b ff ff       	call   100343 <cprintf>
}
  1067da:	83 c4 4c             	add    $0x4c,%esp
  1067dd:	5b                   	pop    %ebx
  1067de:	5e                   	pop    %esi
  1067df:	5f                   	pop    %edi
  1067e0:	5d                   	pop    %ebp
  1067e1:	c3                   	ret    

001067e2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1067e2:	55                   	push   %ebp
  1067e3:	89 e5                	mov    %esp,%ebp
  1067e5:	83 ec 58             	sub    $0x58,%esp
  1067e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1067eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1067ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1067f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1067f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1067f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1067fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1067fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  106800:	8b 45 18             	mov    0x18(%ebp),%eax
  106803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106809:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10680c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10680f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  106812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10681c:	74 1c                	je     10683a <printnum+0x58>
  10681e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106821:	ba 00 00 00 00       	mov    $0x0,%edx
  106826:	f7 75 e4             	divl   -0x1c(%ebp)
  106829:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10682c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10682f:	ba 00 00 00 00       	mov    $0x0,%edx
  106834:	f7 75 e4             	divl   -0x1c(%ebp)
  106837:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10683a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10683d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106840:	f7 75 e4             	divl   -0x1c(%ebp)
  106843:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106846:	89 55 dc             	mov    %edx,-0x24(%ebp)
  106849:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10684c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10684f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106852:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106855:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106858:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10685b:	8b 45 18             	mov    0x18(%ebp),%eax
  10685e:	ba 00 00 00 00       	mov    $0x0,%edx
  106863:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  106866:	77 56                	ja     1068be <printnum+0xdc>
  106868:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10686b:	72 05                	jb     106872 <printnum+0x90>
  10686d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  106870:	77 4c                	ja     1068be <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  106872:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106875:	8d 50 ff             	lea    -0x1(%eax),%edx
  106878:	8b 45 20             	mov    0x20(%ebp),%eax
  10687b:	89 44 24 18          	mov    %eax,0x18(%esp)
  10687f:	89 54 24 14          	mov    %edx,0x14(%esp)
  106883:	8b 45 18             	mov    0x18(%ebp),%eax
  106886:	89 44 24 10          	mov    %eax,0x10(%esp)
  10688a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10688d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106890:	89 44 24 08          	mov    %eax,0x8(%esp)
  106894:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106898:	8b 45 0c             	mov    0xc(%ebp),%eax
  10689b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10689f:	8b 45 08             	mov    0x8(%ebp),%eax
  1068a2:	89 04 24             	mov    %eax,(%esp)
  1068a5:	e8 38 ff ff ff       	call   1067e2 <printnum>
  1068aa:	eb 1c                	jmp    1068c8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1068ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1068af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068b3:	8b 45 20             	mov    0x20(%ebp),%eax
  1068b6:	89 04 24             	mov    %eax,(%esp)
  1068b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1068bc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1068be:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1068c2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1068c6:	7f e4                	jg     1068ac <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1068c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1068cb:	05 38 89 10 00       	add    $0x108938,%eax
  1068d0:	0f b6 00             	movzbl (%eax),%eax
  1068d3:	0f be c0             	movsbl %al,%eax
  1068d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1068d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1068dd:	89 04 24             	mov    %eax,(%esp)
  1068e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1068e3:	ff d0                	call   *%eax
}
  1068e5:	c9                   	leave  
  1068e6:	c3                   	ret    

001068e7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1068e7:	55                   	push   %ebp
  1068e8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1068ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1068ee:	7e 14                	jle    106904 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1068f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1068f3:	8b 00                	mov    (%eax),%eax
  1068f5:	8d 48 08             	lea    0x8(%eax),%ecx
  1068f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1068fb:	89 0a                	mov    %ecx,(%edx)
  1068fd:	8b 50 04             	mov    0x4(%eax),%edx
  106900:	8b 00                	mov    (%eax),%eax
  106902:	eb 30                	jmp    106934 <getuint+0x4d>
    }
    else if (lflag) {
  106904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106908:	74 16                	je     106920 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10690a:	8b 45 08             	mov    0x8(%ebp),%eax
  10690d:	8b 00                	mov    (%eax),%eax
  10690f:	8d 48 04             	lea    0x4(%eax),%ecx
  106912:	8b 55 08             	mov    0x8(%ebp),%edx
  106915:	89 0a                	mov    %ecx,(%edx)
  106917:	8b 00                	mov    (%eax),%eax
  106919:	ba 00 00 00 00       	mov    $0x0,%edx
  10691e:	eb 14                	jmp    106934 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  106920:	8b 45 08             	mov    0x8(%ebp),%eax
  106923:	8b 00                	mov    (%eax),%eax
  106925:	8d 48 04             	lea    0x4(%eax),%ecx
  106928:	8b 55 08             	mov    0x8(%ebp),%edx
  10692b:	89 0a                	mov    %ecx,(%edx)
  10692d:	8b 00                	mov    (%eax),%eax
  10692f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106934:	5d                   	pop    %ebp
  106935:	c3                   	ret    

00106936 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  106936:	55                   	push   %ebp
  106937:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106939:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10693d:	7e 14                	jle    106953 <getint+0x1d>
        return va_arg(*ap, long long);
  10693f:	8b 45 08             	mov    0x8(%ebp),%eax
  106942:	8b 00                	mov    (%eax),%eax
  106944:	8d 48 08             	lea    0x8(%eax),%ecx
  106947:	8b 55 08             	mov    0x8(%ebp),%edx
  10694a:	89 0a                	mov    %ecx,(%edx)
  10694c:	8b 50 04             	mov    0x4(%eax),%edx
  10694f:	8b 00                	mov    (%eax),%eax
  106951:	eb 28                	jmp    10697b <getint+0x45>
    }
    else if (lflag) {
  106953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106957:	74 12                	je     10696b <getint+0x35>
        return va_arg(*ap, long);
  106959:	8b 45 08             	mov    0x8(%ebp),%eax
  10695c:	8b 00                	mov    (%eax),%eax
  10695e:	8d 48 04             	lea    0x4(%eax),%ecx
  106961:	8b 55 08             	mov    0x8(%ebp),%edx
  106964:	89 0a                	mov    %ecx,(%edx)
  106966:	8b 00                	mov    (%eax),%eax
  106968:	99                   	cltd   
  106969:	eb 10                	jmp    10697b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10696b:	8b 45 08             	mov    0x8(%ebp),%eax
  10696e:	8b 00                	mov    (%eax),%eax
  106970:	8d 48 04             	lea    0x4(%eax),%ecx
  106973:	8b 55 08             	mov    0x8(%ebp),%edx
  106976:	89 0a                	mov    %ecx,(%edx)
  106978:	8b 00                	mov    (%eax),%eax
  10697a:	99                   	cltd   
    }
}
  10697b:	5d                   	pop    %ebp
  10697c:	c3                   	ret    

0010697d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10697d:	55                   	push   %ebp
  10697e:	89 e5                	mov    %esp,%ebp
  106980:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  106983:	8d 45 14             	lea    0x14(%ebp),%eax
  106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10698c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106990:	8b 45 10             	mov    0x10(%ebp),%eax
  106993:	89 44 24 08          	mov    %eax,0x8(%esp)
  106997:	8b 45 0c             	mov    0xc(%ebp),%eax
  10699a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10699e:	8b 45 08             	mov    0x8(%ebp),%eax
  1069a1:	89 04 24             	mov    %eax,(%esp)
  1069a4:	e8 02 00 00 00       	call   1069ab <vprintfmt>
    va_end(ap);
}
  1069a9:	c9                   	leave  
  1069aa:	c3                   	ret    

001069ab <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1069ab:	55                   	push   %ebp
  1069ac:	89 e5                	mov    %esp,%ebp
  1069ae:	56                   	push   %esi
  1069af:	53                   	push   %ebx
  1069b0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1069b3:	eb 18                	jmp    1069cd <vprintfmt+0x22>
            if (ch == '\0') {
  1069b5:	85 db                	test   %ebx,%ebx
  1069b7:	75 05                	jne    1069be <vprintfmt+0x13>
                return;
  1069b9:	e9 d1 03 00 00       	jmp    106d8f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1069be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1069c5:	89 1c 24             	mov    %ebx,(%esp)
  1069c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1069cb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1069cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1069d0:	8d 50 01             	lea    0x1(%eax),%edx
  1069d3:	89 55 10             	mov    %edx,0x10(%ebp)
  1069d6:	0f b6 00             	movzbl (%eax),%eax
  1069d9:	0f b6 d8             	movzbl %al,%ebx
  1069dc:	83 fb 25             	cmp    $0x25,%ebx
  1069df:	75 d4                	jne    1069b5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1069e1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1069e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1069ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1069ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1069f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1069f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1069fc:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1069ff:	8b 45 10             	mov    0x10(%ebp),%eax
  106a02:	8d 50 01             	lea    0x1(%eax),%edx
  106a05:	89 55 10             	mov    %edx,0x10(%ebp)
  106a08:	0f b6 00             	movzbl (%eax),%eax
  106a0b:	0f b6 d8             	movzbl %al,%ebx
  106a0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106a11:	83 f8 55             	cmp    $0x55,%eax
  106a14:	0f 87 44 03 00 00    	ja     106d5e <vprintfmt+0x3b3>
  106a1a:	8b 04 85 5c 89 10 00 	mov    0x10895c(,%eax,4),%eax
  106a21:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106a23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106a27:	eb d6                	jmp    1069ff <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  106a29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106a2d:	eb d0                	jmp    1069ff <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a39:	89 d0                	mov    %edx,%eax
  106a3b:	c1 e0 02             	shl    $0x2,%eax
  106a3e:	01 d0                	add    %edx,%eax
  106a40:	01 c0                	add    %eax,%eax
  106a42:	01 d8                	add    %ebx,%eax
  106a44:	83 e8 30             	sub    $0x30,%eax
  106a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  106a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  106a4d:	0f b6 00             	movzbl (%eax),%eax
  106a50:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  106a53:	83 fb 2f             	cmp    $0x2f,%ebx
  106a56:	7e 0b                	jle    106a63 <vprintfmt+0xb8>
  106a58:	83 fb 39             	cmp    $0x39,%ebx
  106a5b:	7f 06                	jg     106a63 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106a5d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  106a61:	eb d3                	jmp    106a36 <vprintfmt+0x8b>
            goto process_precision;
  106a63:	eb 33                	jmp    106a98 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  106a65:	8b 45 14             	mov    0x14(%ebp),%eax
  106a68:	8d 50 04             	lea    0x4(%eax),%edx
  106a6b:	89 55 14             	mov    %edx,0x14(%ebp)
  106a6e:	8b 00                	mov    (%eax),%eax
  106a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106a73:	eb 23                	jmp    106a98 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  106a75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106a79:	79 0c                	jns    106a87 <vprintfmt+0xdc>
                width = 0;
  106a7b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106a82:	e9 78 ff ff ff       	jmp    1069ff <vprintfmt+0x54>
  106a87:	e9 73 ff ff ff       	jmp    1069ff <vprintfmt+0x54>

        case '#':
            altflag = 1;
  106a8c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106a93:	e9 67 ff ff ff       	jmp    1069ff <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  106a98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106a9c:	79 12                	jns    106ab0 <vprintfmt+0x105>
                width = precision, precision = -1;
  106a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106aa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106aa4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106aab:	e9 4f ff ff ff       	jmp    1069ff <vprintfmt+0x54>
  106ab0:	e9 4a ff ff ff       	jmp    1069ff <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106ab5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  106ab9:	e9 41 ff ff ff       	jmp    1069ff <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106abe:	8b 45 14             	mov    0x14(%ebp),%eax
  106ac1:	8d 50 04             	lea    0x4(%eax),%edx
  106ac4:	89 55 14             	mov    %edx,0x14(%ebp)
  106ac7:	8b 00                	mov    (%eax),%eax
  106ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  106acc:	89 54 24 04          	mov    %edx,0x4(%esp)
  106ad0:	89 04 24             	mov    %eax,(%esp)
  106ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  106ad6:	ff d0                	call   *%eax
            break;
  106ad8:	e9 ac 02 00 00       	jmp    106d89 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106add:	8b 45 14             	mov    0x14(%ebp),%eax
  106ae0:	8d 50 04             	lea    0x4(%eax),%edx
  106ae3:	89 55 14             	mov    %edx,0x14(%ebp)
  106ae6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106ae8:	85 db                	test   %ebx,%ebx
  106aea:	79 02                	jns    106aee <vprintfmt+0x143>
                err = -err;
  106aec:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106aee:	83 fb 06             	cmp    $0x6,%ebx
  106af1:	7f 0b                	jg     106afe <vprintfmt+0x153>
  106af3:	8b 34 9d 1c 89 10 00 	mov    0x10891c(,%ebx,4),%esi
  106afa:	85 f6                	test   %esi,%esi
  106afc:	75 23                	jne    106b21 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  106afe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106b02:	c7 44 24 08 49 89 10 	movl   $0x108949,0x8(%esp)
  106b09:	00 
  106b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  106b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106b11:	8b 45 08             	mov    0x8(%ebp),%eax
  106b14:	89 04 24             	mov    %eax,(%esp)
  106b17:	e8 61 fe ff ff       	call   10697d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  106b1c:	e9 68 02 00 00       	jmp    106d89 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  106b21:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106b25:	c7 44 24 08 52 89 10 	movl   $0x108952,0x8(%esp)
  106b2c:	00 
  106b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  106b34:	8b 45 08             	mov    0x8(%ebp),%eax
  106b37:	89 04 24             	mov    %eax,(%esp)
  106b3a:	e8 3e fe ff ff       	call   10697d <printfmt>
            }
            break;
  106b3f:	e9 45 02 00 00       	jmp    106d89 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  106b44:	8b 45 14             	mov    0x14(%ebp),%eax
  106b47:	8d 50 04             	lea    0x4(%eax),%edx
  106b4a:	89 55 14             	mov    %edx,0x14(%ebp)
  106b4d:	8b 30                	mov    (%eax),%esi
  106b4f:	85 f6                	test   %esi,%esi
  106b51:	75 05                	jne    106b58 <vprintfmt+0x1ad>
                p = "(null)";
  106b53:	be 55 89 10 00       	mov    $0x108955,%esi
            }
            if (width > 0 && padc != '-') {
  106b58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b5c:	7e 3e                	jle    106b9c <vprintfmt+0x1f1>
  106b5e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106b62:	74 38                	je     106b9c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  106b64:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  106b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  106b6e:	89 34 24             	mov    %esi,(%esp)
  106b71:	e8 15 03 00 00       	call   106e8b <strnlen>
  106b76:	29 c3                	sub    %eax,%ebx
  106b78:	89 d8                	mov    %ebx,%eax
  106b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106b7d:	eb 17                	jmp    106b96 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  106b7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  106b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  106b86:	89 54 24 04          	mov    %edx,0x4(%esp)
  106b8a:	89 04 24             	mov    %eax,(%esp)
  106b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  106b90:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  106b92:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106b96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b9a:	7f e3                	jg     106b7f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106b9c:	eb 38                	jmp    106bd6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  106b9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106ba2:	74 1f                	je     106bc3 <vprintfmt+0x218>
  106ba4:	83 fb 1f             	cmp    $0x1f,%ebx
  106ba7:	7e 05                	jle    106bae <vprintfmt+0x203>
  106ba9:	83 fb 7e             	cmp    $0x7e,%ebx
  106bac:	7e 15                	jle    106bc3 <vprintfmt+0x218>
                    putch('?', putdat);
  106bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bb5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  106bbf:	ff d0                	call   *%eax
  106bc1:	eb 0f                	jmp    106bd2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  106bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bca:	89 1c 24             	mov    %ebx,(%esp)
  106bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  106bd0:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106bd2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106bd6:	89 f0                	mov    %esi,%eax
  106bd8:	8d 70 01             	lea    0x1(%eax),%esi
  106bdb:	0f b6 00             	movzbl (%eax),%eax
  106bde:	0f be d8             	movsbl %al,%ebx
  106be1:	85 db                	test   %ebx,%ebx
  106be3:	74 10                	je     106bf5 <vprintfmt+0x24a>
  106be5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106be9:	78 b3                	js     106b9e <vprintfmt+0x1f3>
  106beb:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  106bef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106bf3:	79 a9                	jns    106b9e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106bf5:	eb 17                	jmp    106c0e <vprintfmt+0x263>
                putch(' ', putdat);
  106bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bfe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  106c05:	8b 45 08             	mov    0x8(%ebp),%eax
  106c08:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106c0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106c12:	7f e3                	jg     106bf7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  106c14:	e9 70 01 00 00       	jmp    106d89 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c20:	8d 45 14             	lea    0x14(%ebp),%eax
  106c23:	89 04 24             	mov    %eax,(%esp)
  106c26:	e8 0b fd ff ff       	call   106936 <getint>
  106c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106c37:	85 d2                	test   %edx,%edx
  106c39:	79 26                	jns    106c61 <vprintfmt+0x2b6>
                putch('-', putdat);
  106c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c42:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  106c49:	8b 45 08             	mov    0x8(%ebp),%eax
  106c4c:	ff d0                	call   *%eax
                num = -(long long)num;
  106c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106c54:	f7 d8                	neg    %eax
  106c56:	83 d2 00             	adc    $0x0,%edx
  106c59:	f7 da                	neg    %edx
  106c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106c61:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106c68:	e9 a8 00 00 00       	jmp    106d15 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  106c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c74:	8d 45 14             	lea    0x14(%ebp),%eax
  106c77:	89 04 24             	mov    %eax,(%esp)
  106c7a:	e8 68 fc ff ff       	call   1068e7 <getuint>
  106c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106c85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106c8c:	e9 84 00 00 00       	jmp    106d15 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c98:	8d 45 14             	lea    0x14(%ebp),%eax
  106c9b:	89 04 24             	mov    %eax,(%esp)
  106c9e:	e8 44 fc ff ff       	call   1068e7 <getuint>
  106ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ca6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106ca9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106cb0:	eb 63                	jmp    106d15 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  106cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  106cb9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  106cc3:	ff d0                	call   *%eax
            putch('x', putdat);
  106cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  106ccc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  106cd6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  106cdb:	8d 50 04             	lea    0x4(%eax),%edx
  106cde:	89 55 14             	mov    %edx,0x14(%ebp)
  106ce1:	8b 00                	mov    (%eax),%eax
  106ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ce6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106ced:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106cf4:	eb 1f                	jmp    106d15 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  106cfd:	8d 45 14             	lea    0x14(%ebp),%eax
  106d00:	89 04 24             	mov    %eax,(%esp)
  106d03:	e8 df fb ff ff       	call   1068e7 <getuint>
  106d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106d0e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106d15:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106d1c:	89 54 24 18          	mov    %edx,0x18(%esp)
  106d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106d23:	89 54 24 14          	mov    %edx,0x14(%esp)
  106d27:	89 44 24 10          	mov    %eax,0x10(%esp)
  106d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106d31:	89 44 24 08          	mov    %eax,0x8(%esp)
  106d35:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d40:	8b 45 08             	mov    0x8(%ebp),%eax
  106d43:	89 04 24             	mov    %eax,(%esp)
  106d46:	e8 97 fa ff ff       	call   1067e2 <printnum>
            break;
  106d4b:	eb 3c                	jmp    106d89 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d54:	89 1c 24             	mov    %ebx,(%esp)
  106d57:	8b 45 08             	mov    0x8(%ebp),%eax
  106d5a:	ff d0                	call   *%eax
            break;
  106d5c:	eb 2b                	jmp    106d89 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d61:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d65:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  106d6f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106d71:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106d75:	eb 04                	jmp    106d7b <vprintfmt+0x3d0>
  106d77:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  106d7e:	83 e8 01             	sub    $0x1,%eax
  106d81:	0f b6 00             	movzbl (%eax),%eax
  106d84:	3c 25                	cmp    $0x25,%al
  106d86:	75 ef                	jne    106d77 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  106d88:	90                   	nop
        }
    }
  106d89:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106d8a:	e9 3e fc ff ff       	jmp    1069cd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  106d8f:	83 c4 40             	add    $0x40,%esp
  106d92:	5b                   	pop    %ebx
  106d93:	5e                   	pop    %esi
  106d94:	5d                   	pop    %ebp
  106d95:	c3                   	ret    

00106d96 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106d96:	55                   	push   %ebp
  106d97:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d9c:	8b 40 08             	mov    0x8(%eax),%eax
  106d9f:	8d 50 01             	lea    0x1(%eax),%edx
  106da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  106da5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dab:	8b 10                	mov    (%eax),%edx
  106dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  106db0:	8b 40 04             	mov    0x4(%eax),%eax
  106db3:	39 c2                	cmp    %eax,%edx
  106db5:	73 12                	jae    106dc9 <sprintputch+0x33>
        *b->buf ++ = ch;
  106db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dba:	8b 00                	mov    (%eax),%eax
  106dbc:	8d 48 01             	lea    0x1(%eax),%ecx
  106dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  106dc2:	89 0a                	mov    %ecx,(%edx)
  106dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  106dc7:	88 10                	mov    %dl,(%eax)
    }
}
  106dc9:	5d                   	pop    %ebp
  106dca:	c3                   	ret    

00106dcb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106dcb:	55                   	push   %ebp
  106dcc:	89 e5                	mov    %esp,%ebp
  106dce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106dd1:	8d 45 14             	lea    0x14(%ebp),%eax
  106dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106dda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106dde:	8b 45 10             	mov    0x10(%ebp),%eax
  106de1:	89 44 24 08          	mov    %eax,0x8(%esp)
  106de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  106de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  106dec:	8b 45 08             	mov    0x8(%ebp),%eax
  106def:	89 04 24             	mov    %eax,(%esp)
  106df2:	e8 08 00 00 00       	call   106dff <vsnprintf>
  106df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106dfd:	c9                   	leave  
  106dfe:	c3                   	ret    

00106dff <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106dff:	55                   	push   %ebp
  106e00:	89 e5                	mov    %esp,%ebp
  106e02:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106e05:	8b 45 08             	mov    0x8(%ebp),%eax
  106e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  106e11:	8b 45 08             	mov    0x8(%ebp),%eax
  106e14:	01 d0                	add    %edx,%eax
  106e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106e24:	74 0a                	je     106e30 <vsnprintf+0x31>
  106e26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106e2c:	39 c2                	cmp    %eax,%edx
  106e2e:	76 07                	jbe    106e37 <vsnprintf+0x38>
        return -E_INVAL;
  106e30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106e35:	eb 2a                	jmp    106e61 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106e37:	8b 45 14             	mov    0x14(%ebp),%eax
  106e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  106e41:	89 44 24 08          	mov    %eax,0x8(%esp)
  106e45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e4c:	c7 04 24 96 6d 10 00 	movl   $0x106d96,(%esp)
  106e53:	e8 53 fb ff ff       	call   1069ab <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106e5b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106e61:	c9                   	leave  
  106e62:	c3                   	ret    

00106e63 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  106e63:	55                   	push   %ebp
  106e64:	89 e5                	mov    %esp,%ebp
  106e66:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106e69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  106e70:	eb 04                	jmp    106e76 <strlen+0x13>
        cnt ++;
  106e72:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  106e76:	8b 45 08             	mov    0x8(%ebp),%eax
  106e79:	8d 50 01             	lea    0x1(%eax),%edx
  106e7c:	89 55 08             	mov    %edx,0x8(%ebp)
  106e7f:	0f b6 00             	movzbl (%eax),%eax
  106e82:	84 c0                	test   %al,%al
  106e84:	75 ec                	jne    106e72 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  106e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106e89:	c9                   	leave  
  106e8a:	c3                   	ret    

00106e8b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  106e8b:	55                   	push   %ebp
  106e8c:	89 e5                	mov    %esp,%ebp
  106e8e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  106e98:	eb 04                	jmp    106e9e <strnlen+0x13>
        cnt ++;
  106e9a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  106e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106ea1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106ea4:	73 10                	jae    106eb6 <strnlen+0x2b>
  106ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  106ea9:	8d 50 01             	lea    0x1(%eax),%edx
  106eac:	89 55 08             	mov    %edx,0x8(%ebp)
  106eaf:	0f b6 00             	movzbl (%eax),%eax
  106eb2:	84 c0                	test   %al,%al
  106eb4:	75 e4                	jne    106e9a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  106eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106eb9:	c9                   	leave  
  106eba:	c3                   	ret    

00106ebb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  106ebb:	55                   	push   %ebp
  106ebc:	89 e5                	mov    %esp,%ebp
  106ebe:	57                   	push   %edi
  106ebf:	56                   	push   %esi
  106ec0:	83 ec 20             	sub    $0x20,%esp
  106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  106ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  106ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106ed5:	89 d1                	mov    %edx,%ecx
  106ed7:	89 c2                	mov    %eax,%edx
  106ed9:	89 ce                	mov    %ecx,%esi
  106edb:	89 d7                	mov    %edx,%edi
  106edd:	ac                   	lods   %ds:(%esi),%al
  106ede:	aa                   	stos   %al,%es:(%edi)
  106edf:	84 c0                	test   %al,%al
  106ee1:	75 fa                	jne    106edd <strcpy+0x22>
  106ee3:	89 fa                	mov    %edi,%edx
  106ee5:	89 f1                	mov    %esi,%ecx
  106ee7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106eea:	89 55 e8             	mov    %edx,-0x18(%ebp)
  106eed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  106ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  106ef3:	83 c4 20             	add    $0x20,%esp
  106ef6:	5e                   	pop    %esi
  106ef7:	5f                   	pop    %edi
  106ef8:	5d                   	pop    %ebp
  106ef9:	c3                   	ret    

00106efa <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  106efa:	55                   	push   %ebp
  106efb:	89 e5                	mov    %esp,%ebp
  106efd:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  106f00:	8b 45 08             	mov    0x8(%ebp),%eax
  106f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  106f06:	eb 21                	jmp    106f29 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  106f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f0b:	0f b6 10             	movzbl (%eax),%edx
  106f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106f11:	88 10                	mov    %dl,(%eax)
  106f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106f16:	0f b6 00             	movzbl (%eax),%eax
  106f19:	84 c0                	test   %al,%al
  106f1b:	74 04                	je     106f21 <strncpy+0x27>
            src ++;
  106f1d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  106f21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106f25:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  106f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106f2d:	75 d9                	jne    106f08 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  106f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106f32:	c9                   	leave  
  106f33:	c3                   	ret    

00106f34 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  106f34:	55                   	push   %ebp
  106f35:	89 e5                	mov    %esp,%ebp
  106f37:	57                   	push   %edi
  106f38:	56                   	push   %esi
  106f39:	83 ec 20             	sub    $0x20,%esp
  106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  106f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  106f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106f4e:	89 d1                	mov    %edx,%ecx
  106f50:	89 c2                	mov    %eax,%edx
  106f52:	89 ce                	mov    %ecx,%esi
  106f54:	89 d7                	mov    %edx,%edi
  106f56:	ac                   	lods   %ds:(%esi),%al
  106f57:	ae                   	scas   %es:(%edi),%al
  106f58:	75 08                	jne    106f62 <strcmp+0x2e>
  106f5a:	84 c0                	test   %al,%al
  106f5c:	75 f8                	jne    106f56 <strcmp+0x22>
  106f5e:	31 c0                	xor    %eax,%eax
  106f60:	eb 04                	jmp    106f66 <strcmp+0x32>
  106f62:	19 c0                	sbb    %eax,%eax
  106f64:	0c 01                	or     $0x1,%al
  106f66:	89 fa                	mov    %edi,%edx
  106f68:	89 f1                	mov    %esi,%ecx
  106f6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106f6d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106f70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  106f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  106f76:	83 c4 20             	add    $0x20,%esp
  106f79:	5e                   	pop    %esi
  106f7a:	5f                   	pop    %edi
  106f7b:	5d                   	pop    %ebp
  106f7c:	c3                   	ret    

00106f7d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  106f7d:	55                   	push   %ebp
  106f7e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  106f80:	eb 0c                	jmp    106f8e <strncmp+0x11>
        n --, s1 ++, s2 ++;
  106f82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106f86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106f8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  106f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106f92:	74 1a                	je     106fae <strncmp+0x31>
  106f94:	8b 45 08             	mov    0x8(%ebp),%eax
  106f97:	0f b6 00             	movzbl (%eax),%eax
  106f9a:	84 c0                	test   %al,%al
  106f9c:	74 10                	je     106fae <strncmp+0x31>
  106f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  106fa1:	0f b6 10             	movzbl (%eax),%edx
  106fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fa7:	0f b6 00             	movzbl (%eax),%eax
  106faa:	38 c2                	cmp    %al,%dl
  106fac:	74 d4                	je     106f82 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  106fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106fb2:	74 18                	je     106fcc <strncmp+0x4f>
  106fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  106fb7:	0f b6 00             	movzbl (%eax),%eax
  106fba:	0f b6 d0             	movzbl %al,%edx
  106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fc0:	0f b6 00             	movzbl (%eax),%eax
  106fc3:	0f b6 c0             	movzbl %al,%eax
  106fc6:	29 c2                	sub    %eax,%edx
  106fc8:	89 d0                	mov    %edx,%eax
  106fca:	eb 05                	jmp    106fd1 <strncmp+0x54>
  106fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106fd1:	5d                   	pop    %ebp
  106fd2:	c3                   	ret    

00106fd3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  106fd3:	55                   	push   %ebp
  106fd4:	89 e5                	mov    %esp,%ebp
  106fd6:	83 ec 04             	sub    $0x4,%esp
  106fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fdc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106fdf:	eb 14                	jmp    106ff5 <strchr+0x22>
        if (*s == c) {
  106fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  106fe4:	0f b6 00             	movzbl (%eax),%eax
  106fe7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  106fea:	75 05                	jne    106ff1 <strchr+0x1e>
            return (char *)s;
  106fec:	8b 45 08             	mov    0x8(%ebp),%eax
  106fef:	eb 13                	jmp    107004 <strchr+0x31>
        }
        s ++;
  106ff1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  106ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  106ff8:	0f b6 00             	movzbl (%eax),%eax
  106ffb:	84 c0                	test   %al,%al
  106ffd:	75 e2                	jne    106fe1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  106fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107004:	c9                   	leave  
  107005:	c3                   	ret    

00107006 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  107006:	55                   	push   %ebp
  107007:	89 e5                	mov    %esp,%ebp
  107009:	83 ec 04             	sub    $0x4,%esp
  10700c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10700f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  107012:	eb 11                	jmp    107025 <strfind+0x1f>
        if (*s == c) {
  107014:	8b 45 08             	mov    0x8(%ebp),%eax
  107017:	0f b6 00             	movzbl (%eax),%eax
  10701a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10701d:	75 02                	jne    107021 <strfind+0x1b>
            break;
  10701f:	eb 0e                	jmp    10702f <strfind+0x29>
        }
        s ++;
  107021:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  107025:	8b 45 08             	mov    0x8(%ebp),%eax
  107028:	0f b6 00             	movzbl (%eax),%eax
  10702b:	84 c0                	test   %al,%al
  10702d:	75 e5                	jne    107014 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  10702f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  107032:	c9                   	leave  
  107033:	c3                   	ret    

00107034 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  107034:	55                   	push   %ebp
  107035:	89 e5                	mov    %esp,%ebp
  107037:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10703a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  107041:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  107048:	eb 04                	jmp    10704e <strtol+0x1a>
        s ++;
  10704a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10704e:	8b 45 08             	mov    0x8(%ebp),%eax
  107051:	0f b6 00             	movzbl (%eax),%eax
  107054:	3c 20                	cmp    $0x20,%al
  107056:	74 f2                	je     10704a <strtol+0x16>
  107058:	8b 45 08             	mov    0x8(%ebp),%eax
  10705b:	0f b6 00             	movzbl (%eax),%eax
  10705e:	3c 09                	cmp    $0x9,%al
  107060:	74 e8                	je     10704a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  107062:	8b 45 08             	mov    0x8(%ebp),%eax
  107065:	0f b6 00             	movzbl (%eax),%eax
  107068:	3c 2b                	cmp    $0x2b,%al
  10706a:	75 06                	jne    107072 <strtol+0x3e>
        s ++;
  10706c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  107070:	eb 15                	jmp    107087 <strtol+0x53>
    }
    else if (*s == '-') {
  107072:	8b 45 08             	mov    0x8(%ebp),%eax
  107075:	0f b6 00             	movzbl (%eax),%eax
  107078:	3c 2d                	cmp    $0x2d,%al
  10707a:	75 0b                	jne    107087 <strtol+0x53>
        s ++, neg = 1;
  10707c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  107080:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  107087:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10708b:	74 06                	je     107093 <strtol+0x5f>
  10708d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  107091:	75 24                	jne    1070b7 <strtol+0x83>
  107093:	8b 45 08             	mov    0x8(%ebp),%eax
  107096:	0f b6 00             	movzbl (%eax),%eax
  107099:	3c 30                	cmp    $0x30,%al
  10709b:	75 1a                	jne    1070b7 <strtol+0x83>
  10709d:	8b 45 08             	mov    0x8(%ebp),%eax
  1070a0:	83 c0 01             	add    $0x1,%eax
  1070a3:	0f b6 00             	movzbl (%eax),%eax
  1070a6:	3c 78                	cmp    $0x78,%al
  1070a8:	75 0d                	jne    1070b7 <strtol+0x83>
        s += 2, base = 16;
  1070aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1070ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1070b5:	eb 2a                	jmp    1070e1 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1070b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1070bb:	75 17                	jne    1070d4 <strtol+0xa0>
  1070bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1070c0:	0f b6 00             	movzbl (%eax),%eax
  1070c3:	3c 30                	cmp    $0x30,%al
  1070c5:	75 0d                	jne    1070d4 <strtol+0xa0>
        s ++, base = 8;
  1070c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1070cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1070d2:	eb 0d                	jmp    1070e1 <strtol+0xad>
    }
    else if (base == 0) {
  1070d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1070d8:	75 07                	jne    1070e1 <strtol+0xad>
        base = 10;
  1070da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1070e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1070e4:	0f b6 00             	movzbl (%eax),%eax
  1070e7:	3c 2f                	cmp    $0x2f,%al
  1070e9:	7e 1b                	jle    107106 <strtol+0xd2>
  1070eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1070ee:	0f b6 00             	movzbl (%eax),%eax
  1070f1:	3c 39                	cmp    $0x39,%al
  1070f3:	7f 11                	jg     107106 <strtol+0xd2>
            dig = *s - '0';
  1070f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1070f8:	0f b6 00             	movzbl (%eax),%eax
  1070fb:	0f be c0             	movsbl %al,%eax
  1070fe:	83 e8 30             	sub    $0x30,%eax
  107101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107104:	eb 48                	jmp    10714e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  107106:	8b 45 08             	mov    0x8(%ebp),%eax
  107109:	0f b6 00             	movzbl (%eax),%eax
  10710c:	3c 60                	cmp    $0x60,%al
  10710e:	7e 1b                	jle    10712b <strtol+0xf7>
  107110:	8b 45 08             	mov    0x8(%ebp),%eax
  107113:	0f b6 00             	movzbl (%eax),%eax
  107116:	3c 7a                	cmp    $0x7a,%al
  107118:	7f 11                	jg     10712b <strtol+0xf7>
            dig = *s - 'a' + 10;
  10711a:	8b 45 08             	mov    0x8(%ebp),%eax
  10711d:	0f b6 00             	movzbl (%eax),%eax
  107120:	0f be c0             	movsbl %al,%eax
  107123:	83 e8 57             	sub    $0x57,%eax
  107126:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107129:	eb 23                	jmp    10714e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10712b:	8b 45 08             	mov    0x8(%ebp),%eax
  10712e:	0f b6 00             	movzbl (%eax),%eax
  107131:	3c 40                	cmp    $0x40,%al
  107133:	7e 3d                	jle    107172 <strtol+0x13e>
  107135:	8b 45 08             	mov    0x8(%ebp),%eax
  107138:	0f b6 00             	movzbl (%eax),%eax
  10713b:	3c 5a                	cmp    $0x5a,%al
  10713d:	7f 33                	jg     107172 <strtol+0x13e>
            dig = *s - 'A' + 10;
  10713f:	8b 45 08             	mov    0x8(%ebp),%eax
  107142:	0f b6 00             	movzbl (%eax),%eax
  107145:	0f be c0             	movsbl %al,%eax
  107148:	83 e8 37             	sub    $0x37,%eax
  10714b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10714e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107151:	3b 45 10             	cmp    0x10(%ebp),%eax
  107154:	7c 02                	jl     107158 <strtol+0x124>
            break;
  107156:	eb 1a                	jmp    107172 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  107158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10715c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10715f:	0f af 45 10          	imul   0x10(%ebp),%eax
  107163:	89 c2                	mov    %eax,%edx
  107165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107168:	01 d0                	add    %edx,%eax
  10716a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10716d:	e9 6f ff ff ff       	jmp    1070e1 <strtol+0xad>

    if (endptr) {
  107172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  107176:	74 08                	je     107180 <strtol+0x14c>
        *endptr = (char *) s;
  107178:	8b 45 0c             	mov    0xc(%ebp),%eax
  10717b:	8b 55 08             	mov    0x8(%ebp),%edx
  10717e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  107180:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  107184:	74 07                	je     10718d <strtol+0x159>
  107186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107189:	f7 d8                	neg    %eax
  10718b:	eb 03                	jmp    107190 <strtol+0x15c>
  10718d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  107190:	c9                   	leave  
  107191:	c3                   	ret    

00107192 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  107192:	55                   	push   %ebp
  107193:	89 e5                	mov    %esp,%ebp
  107195:	57                   	push   %edi
  107196:	83 ec 24             	sub    $0x24,%esp
  107199:	8b 45 0c             	mov    0xc(%ebp),%eax
  10719c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10719f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1071a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1071a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1071a9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1071ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1071af:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1071b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1071b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1071b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1071bc:	89 d7                	mov    %edx,%edi
  1071be:	f3 aa                	rep stos %al,%es:(%edi)
  1071c0:	89 fa                	mov    %edi,%edx
  1071c2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1071c5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1071c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1071cb:	83 c4 24             	add    $0x24,%esp
  1071ce:	5f                   	pop    %edi
  1071cf:	5d                   	pop    %ebp
  1071d0:	c3                   	ret    

001071d1 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1071d1:	55                   	push   %ebp
  1071d2:	89 e5                	mov    %esp,%ebp
  1071d4:	57                   	push   %edi
  1071d5:	56                   	push   %esi
  1071d6:	53                   	push   %ebx
  1071d7:	83 ec 30             	sub    $0x30,%esp
  1071da:	8b 45 08             	mov    0x8(%ebp),%eax
  1071dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1071e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1071e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1071e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1071e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1071ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1071f2:	73 42                	jae    107236 <memmove+0x65>
  1071f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1071fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1071fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107203:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  107206:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107209:	c1 e8 02             	shr    $0x2,%eax
  10720c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10720e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107214:	89 d7                	mov    %edx,%edi
  107216:	89 c6                	mov    %eax,%esi
  107218:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10721a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10721d:	83 e1 03             	and    $0x3,%ecx
  107220:	74 02                	je     107224 <memmove+0x53>
  107222:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  107224:	89 f0                	mov    %esi,%eax
  107226:	89 fa                	mov    %edi,%edx
  107228:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10722b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10722e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  107231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107234:	eb 36                	jmp    10726c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  107236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107239:	8d 50 ff             	lea    -0x1(%eax),%edx
  10723c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10723f:	01 c2                	add    %eax,%edx
  107241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107244:	8d 48 ff             	lea    -0x1(%eax),%ecx
  107247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10724a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10724d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107250:	89 c1                	mov    %eax,%ecx
  107252:	89 d8                	mov    %ebx,%eax
  107254:	89 d6                	mov    %edx,%esi
  107256:	89 c7                	mov    %eax,%edi
  107258:	fd                   	std    
  107259:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10725b:	fc                   	cld    
  10725c:	89 f8                	mov    %edi,%eax
  10725e:	89 f2                	mov    %esi,%edx
  107260:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  107263:	89 55 c8             	mov    %edx,-0x38(%ebp)
  107266:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  107269:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10726c:	83 c4 30             	add    $0x30,%esp
  10726f:	5b                   	pop    %ebx
  107270:	5e                   	pop    %esi
  107271:	5f                   	pop    %edi
  107272:	5d                   	pop    %ebp
  107273:	c3                   	ret    

00107274 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  107274:	55                   	push   %ebp
  107275:	89 e5                	mov    %esp,%ebp
  107277:	57                   	push   %edi
  107278:	56                   	push   %esi
  107279:	83 ec 20             	sub    $0x20,%esp
  10727c:	8b 45 08             	mov    0x8(%ebp),%eax
  10727f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107282:	8b 45 0c             	mov    0xc(%ebp),%eax
  107285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107288:	8b 45 10             	mov    0x10(%ebp),%eax
  10728b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10728e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107291:	c1 e8 02             	shr    $0x2,%eax
  107294:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  107296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  107299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10729c:	89 d7                	mov    %edx,%edi
  10729e:	89 c6                	mov    %eax,%esi
  1072a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1072a2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1072a5:	83 e1 03             	and    $0x3,%ecx
  1072a8:	74 02                	je     1072ac <memcpy+0x38>
  1072aa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1072ac:	89 f0                	mov    %esi,%eax
  1072ae:	89 fa                	mov    %edi,%edx
  1072b0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1072b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1072b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1072bc:	83 c4 20             	add    $0x20,%esp
  1072bf:	5e                   	pop    %esi
  1072c0:	5f                   	pop    %edi
  1072c1:	5d                   	pop    %ebp
  1072c2:	c3                   	ret    

001072c3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1072c3:	55                   	push   %ebp
  1072c4:	89 e5                	mov    %esp,%ebp
  1072c6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1072c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1072cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1072cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1072d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1072d5:	eb 30                	jmp    107307 <memcmp+0x44>
        if (*s1 != *s2) {
  1072d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1072da:	0f b6 10             	movzbl (%eax),%edx
  1072dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1072e0:	0f b6 00             	movzbl (%eax),%eax
  1072e3:	38 c2                	cmp    %al,%dl
  1072e5:	74 18                	je     1072ff <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1072e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1072ea:	0f b6 00             	movzbl (%eax),%eax
  1072ed:	0f b6 d0             	movzbl %al,%edx
  1072f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1072f3:	0f b6 00             	movzbl (%eax),%eax
  1072f6:	0f b6 c0             	movzbl %al,%eax
  1072f9:	29 c2                	sub    %eax,%edx
  1072fb:	89 d0                	mov    %edx,%eax
  1072fd:	eb 1a                	jmp    107319 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1072ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  107303:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  107307:	8b 45 10             	mov    0x10(%ebp),%eax
  10730a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10730d:	89 55 10             	mov    %edx,0x10(%ebp)
  107310:	85 c0                	test   %eax,%eax
  107312:	75 c3                	jne    1072d7 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  107314:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107319:	c9                   	leave  
  10731a:	c3                   	ret    
