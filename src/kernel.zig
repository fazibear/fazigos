const multiboot = @import("kernel/multiboot.zig");
const vga = @import("kernel/vga.zig");
const gdt = @import("kernel/gdt.zig");
const idt = @import("kernel/idt.zig");
const isr = @import("kernel/isr.zig");
const sys = @import("kernel/sys.zig");

const timer = @import("kernel/timer.zig");
const keyboard = @import("kernel/keyboard.zig");
const serial = @import("kernel/serial.zig");
const logger = @import("kernel/logger.zig");

export const multiboot_header align(4) linksection(".multiboot") = multiboot.Header{};

export fn kmain(magic: u32, info: *const multiboot.Info) void {
    gdt.init();
    idt.init();
    isr.init();
    vga.init();

    logger.init();
    timer.init();
    keyboard.init();

    logger.info("Kernel info parameter:{x}", .{info});
}
