// Access byte values.
const KERNEL = 0x90;
const USER = 0xF0;
const CODE = 0x0A;
const DATA = 0x02;

// Segment flags.
const PROTECTED = (1 << 2);
const BLOCKS_4K = (1 << 3);

// Structure representing an entry in the GDT.
const GDTEntry = packed struct {
    limit_low: u16,
    base_low: u16,
    base_mid: u8,
    access: u8,
    limit_high: u4,
    flags: u4,
    base_high: u8,
};

// GDT descriptor register.
const GDTRegister = packed struct {
    limit: u16,
    base: *const GDTEntry,
};

fn gdt_entry(base: usize, limit: usize, access: u8, flags: u4) GDTEntry {
    return GDTEntry{
        .limit_low = @truncate(u16, limit),
        .base_low = @truncate(u16, base),
        .base_mid = @truncate(u8, base >> 16),
        .access = @truncate(u8, access),
        .limit_high = @truncate(u4, limit >> 16),
        .flags = @truncate(u4, flags),
        .base_high = @truncate(u8, base >> 24),
    };
}

// Fill in the GDT.
var gdt align(4) = [_]GDTEntry{
    gdt_entry(0, 0, 0, 0),
    gdt_entry(0, 0xFFFFFFFF, KERNEL | CODE, PROTECTED | BLOCKS_4K),
    gdt_entry(0, 0xFFFFFFFF, KERNEL | DATA, PROTECTED | BLOCKS_4K),
};

// GDT descriptor register pointing at the GDT.
var gdtr = GDTRegister{
    .limit = @as(u16, @sizeOf(@TypeOf(gdt))),
    .base = &gdt[0],
};

// function from asm
extern fn load_gdt(gdtr: *const GDTRegister) void;

pub fn init() void {
    load_gdt(&gdtr);
}
