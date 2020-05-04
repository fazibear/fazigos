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
    logger.info("* start kmain info parameter:{x}", .{info});

    vga.init();
    logger.info("VGA Initialized", .{});

    gdt.init();
    logger.info("GDT Initialized", .{});

    idt.init();
    logger.info("IDT Initialized", .{});

    isr.init();
    logger.info("ISR Initialized", .{});

    timer.init();
    logger.info("timer Initialized", .{});

    keyboard.init();
    logger.info("keyboard Initialized", .{});

    logger.info("end kmain", .{});
}
