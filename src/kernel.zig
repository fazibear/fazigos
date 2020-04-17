const MultiBoot = @import("kernel/multiboot.zig");
const vga = @import("kernel/vga.zig");
const gdt = @import("kernel/gdt.zig");
const idt = @import("kernel/idt.zig");
const isr = @import("kernel/isr.zig");
export const multiboot_header align(4) linksection(".multiboot") = MultiBoot.Header{};

export fn kmain() noreturn {
    gdt.init();
    idt.init();
    isr.init();
    vga.init();

    while (true) {}
}
