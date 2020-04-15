const MultiBoot = @import("kernel/multiboot.zig");

export const multiboot_header align(4) linksection(".multiboot") = MultiBoot.Header{};

export fn kmain() noreturn {
    var vram = @intToPtr([*]u16, 0xb8000);

    vram[0] = 'h' | 0x0700;
    vram[1] = 'e' | 0x0700;
    vram[2] = 'l' | 0x0700;
    vram[3] = 'l' | 0x0700;
    vram[4] = 'o' | 0x0700;
    vram[5] = '!' | 0x0700;

    while (true) {}
}
