const isr = @import("isr.zig");
const vga = @import("vga.zig");

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
    var x: u32 = 1123;
    vga.set_color(vga.Color.Red);
    vga.printf(
        \\! System Halted: {}
        \\!   int_no: {}
        \\!   err_code: {}
    , .{
        exceptions[context.interrupt_num],
        @truncate(u16, context.interrupt_num),
        @truncate(u16, context.error_code),
    });
    while (true) {}
}
