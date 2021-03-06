const isr = @import("isr.zig");
const sys = @import("sys.zig");

const exceptions = &[_][]const u8{
    "Division By Zero",
    "Debug",
    "Non Maskable Interrupt",
    "Breakpoint",
    "Into Detected Overflow",
    "Out of Bounds",
    "Invalid Opcode",
    "No Coprocessor",

    "Double Fault",
    "Coprocessor Segment Overrun",
    "Bad TSS",
    "Segment Not Present",
    "Stack Fault",
    "General Protection Fault",
    "Page Fault",
    "Unknown Interrupt",

    "Coprocessor Fault",
    "Alignment Check",
    "Machine Check",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",

    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
};

pub fn handler(context: *isr.Context) void {
    sys.panic(
        \\! System Halted: {}
        \\!   int_no: {}
        \\!   err_code: {}
    , .{
        exceptions[context.interrupt_num],
        context.interrupt_num,
        context.error_code,
    });
}
