const vga = @import("vga.zig");
const idt = @import("idt.zig");
const exception = @import("exception.zig");
const interrupt = @import("interrupt.zig");

// Context saved by Interrupt Service Routines.
pub const Context = packed struct {
// General purpose registers.
    gs: u32, fs: u32, es: u32, ds: u32, edi: u32, esi: u32, ebp: u32, esp: u32, ebx: u32, edx: u32, ecx: u32, eax: u32,

    // Number of the interrupt.
    interrupt_num: u32,

    // Associated error code (or 0).
    error_code: u32,

    // CPU status:
    eip: u32, cs: u32, eflags: u32, useresp: u32, ss: u32
};

export fn isr_handler(context: *Context) void {
    if (context.interrupt_num > 31) {
        interrupt.handler(context);
    } else {
        exception.handler(context);
    }
}

pub fn init() void {
    // exceptions
    idt.set_gate(1, idt.INTERRUPT_GATE, isr1);
    idt.set_gate(2, idt.INTERRUPT_GATE, isr2);
    idt.set_gate(3, idt.INTERRUPT_GATE, isr3);
    idt.set_gate(4, idt.INTERRUPT_GATE, isr4);
    idt.set_gate(5, idt.INTERRUPT_GATE, isr5);
    idt.set_gate(6, idt.INTERRUPT_GATE, isr6);
    idt.set_gate(7, idt.INTERRUPT_GATE, isr7);
    idt.set_gate(8, idt.INTERRUPT_GATE, isr8);
    idt.set_gate(9, idt.INTERRUPT_GATE, isr9);
    idt.set_gate(10, idt.INTERRUPT_GATE, isr10);
    idt.set_gate(11, idt.INTERRUPT_GATE, isr11);
    idt.set_gate(12, idt.INTERRUPT_GATE, isr12);
    idt.set_gate(13, idt.INTERRUPT_GATE, isr13);
    idt.set_gate(14, idt.INTERRUPT_GATE, isr14);
    idt.set_gate(15, idt.INTERRUPT_GATE, isr15);
    idt.set_gate(16, idt.INTERRUPT_GATE, isr16);
    idt.set_gate(17, idt.INTERRUPT_GATE, isr17);
    idt.set_gate(18, idt.INTERRUPT_GATE, isr18);
    idt.set_gate(19, idt.INTERRUPT_GATE, isr19);
    idt.set_gate(20, idt.INTERRUPT_GATE, isr20);
    idt.set_gate(21, idt.INTERRUPT_GATE, isr21);
    idt.set_gate(22, idt.INTERRUPT_GATE, isr22);
    idt.set_gate(23, idt.INTERRUPT_GATE, isr23);
    idt.set_gate(24, idt.INTERRUPT_GATE, isr24);
    idt.set_gate(25, idt.INTERRUPT_GATE, isr25);
    idt.set_gate(26, idt.INTERRUPT_GATE, isr26);
    idt.set_gate(27, idt.INTERRUPT_GATE, isr27);
    idt.set_gate(28, idt.INTERRUPT_GATE, isr28);
    idt.set_gate(29, idt.INTERRUPT_GATE, isr29);
    idt.set_gate(30, idt.INTERRUPT_GATE, isr30);
    idt.set_gate(31, idt.INTERRUPT_GATE, isr31);

    // interupts
    // idt.set_gate(32, idt.INTERRUPT_GATE, isr32);
    // idt.set_gate(33, idt.INTERRUPT_GATE, isr33);
    // idt.set_gate(34, idt.INTERRUPT_GATE, isr34);
    // idt.set_gate(35, idt.INTERRUPT_GATE, isr35);
    // idt.set_gate(36, idt.INTERRUPT_GATE, isr36);
    // idt.set_gate(37, idt.INTERRUPT_GATE, isr37);
    // idt.set_gate(38, idt.INTERRUPT_GATE, isr38);
    // idt.set_gate(39, idt.INTERRUPT_GATE, isr39);
    // idt.set_gate(40, idt.INTERRUPT_GATE, isr40);
    // idt.set_gate(41, idt.INTERRUPT_GATE, isr41);
    // idt.set_gate(42, idt.INTERRUPT_GATE, isr42);
    // idt.set_gate(43, idt.INTERRUPT_GATE, isr43);
    // idt.set_gate(44, idt.INTERRUPT_GATE, isr44);
    // idt.set_gate(45, idt.INTERRUPT_GATE, isr45);
    // idt.set_gate(46, idt.INTERRUPT_GATE, isr46);
    // idt.set_gate(47, idt.INTERRUPT_GATE, isr47);
    //
    // // syscalls
    // idt.set_gate(128, idt.SYSCALL_GATE, isr128);
}
// Interrupt Service Routines defined externally in assembly.
extern fn isr0() void;
extern fn isr1() void;
extern fn isr2() void;
extern fn isr3() void;
extern fn isr4() void;
extern fn isr5() void;
extern fn isr6() void;
extern fn isr7() void;
extern fn isr8() void;
extern fn isr9() void;
extern fn isr10() void;
extern fn isr11() void;
extern fn isr12() void;
extern fn isr13() void;
extern fn isr14() void;
extern fn isr15() void;
extern fn isr16() void;
extern fn isr17() void;
extern fn isr18() void;
extern fn isr19() void;
extern fn isr20() void;
extern fn isr21() void;
extern fn isr22() void;
extern fn isr23() void;
extern fn isr24() void;
extern fn isr25() void;
extern fn isr26() void;
extern fn isr27() void;
extern fn isr28() void;
extern fn isr29() void;
extern fn isr30() void;
extern fn isr31() void;
extern fn isr32() void;
extern fn isr33() void;
extern fn isr34() void;
extern fn isr35() void;
extern fn isr36() void;
extern fn isr37() void;
extern fn isr38() void;
extern fn isr39() void;
extern fn isr40() void;
extern fn isr41() void;
extern fn isr42() void;
extern fn isr43() void;
extern fn isr44() void;
extern fn isr45() void;
extern fn isr46() void;
extern fn isr47() void;
extern fn isr128() void;
