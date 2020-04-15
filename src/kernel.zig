const MultiBoot = @import("kernel/multiboot.zig");
const Vga = @import("kernel/vga.zig");

export const multiboot_header align(4) linksection(".multiboot") = MultiBoot.Header{};

export fn kmain() noreturn {
    Vga.init();
    while (true) {}
}
