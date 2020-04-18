const multiboot = @import("kernel/multiboot.zig");
const vga = @import("kernel/vga.zig");
const gdt = @import("kernel/gdt.zig");
const idt = @import("kernel/idt.zig");
const isr = @import("kernel/isr.zig");
const sys = @import("kernel/sys.zig");

const timer = @import("kernel/timer.zig");
const keyboard = @import("kernel/keyboard.zig");

export const multiboot_header align(4) linksection(".multiboot") = multiboot.Header{};

export fn kmain(magic: u32, info: *const multiboot.Info) void {
    gdt.init();
    idt.init();
    isr.init();
    vga.init();

    vga.printf(
        \\
        \\! Info:
        \\!  magic: {}
        \\!  mem_lower: {}
        \\!  mem_upper: {}
        \\
    , .{
        magic,
        info.mem_lower,
        info.mem_upper,
    });

    timer.init();
    keyboard.init();
}
