const isr = @import("isr.zig");
const vga = @import("vga.zig");

pub fn handler(context: *isr.Context) void {
    vga.println("Interupt");
    while (true) {}
}
