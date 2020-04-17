const as = @import("as.zig");

// Types of gates.
pub const INTERRUPT_GATE = 0x8E;
pub const SYSCALL_GATE = 0xEE;

// Interrupt Descriptor Table.
var idt_table: [256]IDTEntry = undefined;

// IDT descriptor register pointing at the IDT.
const idtr = IDTRegister{
    .limit = @as(u16, @sizeOf(@TypeOf(idt_table))),
    .base = &idt_table,
};

// Structure representing an entry in the IDT.
const IDTEntry = packed struct {
    offset_low: u16,
    selector: u16,
    zero: u8,
    flags: u8,
    offset_high: u16,
};

// IDT descriptor register.
const IDTRegister = packed struct {
    limit: u16,
    base: *[256]IDTEntry,
};

pub fn set_gate(n: u8, flags: u8, offset: extern fn () void) void {
    const intOffset = @ptrToInt(offset);

    idt_table[n].offset_low = @truncate(u16, intOffset);
    idt_table[n].offset_high = @truncate(u16, intOffset >> 16);
    idt_table[n].flags = flags;
    idt_table[n].zero = 0;
    idt_table[n].selector = 0x08;// gdt.KERNEL_CODE
}

pub fn init() void {
    as.lidt(@ptrToInt(&idtr));
}
