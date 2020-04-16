const MultiBoot = @import("kernel/multiboot.zig");
const vga = @import("kernel/vga.zig");
const gdt = @import("kernel/gdt.zig");
export const multiboot_header align(4) linksection(".multiboot") = MultiBoot.Header{};

export fn kmain() noreturn {
    gdt.init();
    vga.init();

    while (true) {}
}
