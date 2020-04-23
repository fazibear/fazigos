const vga = @import("vga.zig");
const logger = @import("logger.zig");

pub inline fn inb(port: u16) u8 {
    return asm volatile ("inb %[port], %[result]"
        : [result] "={al}" (-> u8)
        : [port] "N{dx}" (port)
    );
}

pub inline fn inw(port: u16) u16 {
    return asm volatile ("inw %[port], %[result]"
        : [result] "={ax}" (-> u16)
        : [port] "N{dx}" (port)
    );
}

pub inline fn inl(port: u16) u32 {
    return asm volatile ("inl %[port], %[result]"
        : [result] "={eax}" (-> u32)
        : [port] "N{dx}" (port)
    );
}

pub inline fn insl(port: u16, addr: var, cnt: usize) void {
    asm volatile ("cld; repne; insl;"
        : [addr] "={edi}" (addr),
          [cnt] "={ecx}" (cnt)
        : [port] "{dx}" (port),
          [addr] "0" (addr),
          [cnt] "1" (cnt)
        : "memory", "cc"
    );
}

pub inline fn outb(port: u16, value: u8) void {
    asm volatile ("outb %[value], %[port]"
        :
        : [value] "{al}" (value),
          [port] "N{dx}" (port)
    );
}

pub inline fn outw(port: u16, value: u16) void {
    asm volatile ("outw %[value], %[port]"
        :
        : [value] "{ax}" (value),
          [port] "N{dx}" (port)
    );
}

pub inline fn outl(port: u16, value: u32) void {
    asm volatile ("outl %[value], %[port]"
        :
        : [value] "{eax}" (value),
          [port] "N{dx}" (port)
    );
}
pub inline fn ltr(desc: u16) void {
    asm volatile ("ltr %[desc]"
        :
        : [desc] "r" (desc)
    );
}

pub inline fn halt() noreturn {
    cli();
    while (true) asm volatile ("hlt");
}

pub inline fn cli() void {
    asm volatile ("cli");
}

pub inline fn sti() void {
    asm volatile ("sti");
}
pub inline fn hlt() void {
    asm volatile ("hlt");
}

pub inline fn int3() void {
    asm volatile ("int3");
}

pub inline fn lidt(idtr: usize) void {
    asm volatile ("lidt (%[idtr])"
        :
        : [idtr] "r" (idtr)
    );
}

pub fn cr2() usize {
    return asm volatile ("movl %%cr2, %[result]"
        : [result] "=r" (-> usize)
    );
}

pub fn dr7() usize {
    return asm volatile ("movl %%dr7, %[result]"
        : [result] "=r" (-> usize)
    );
}

pub fn panic(comptime format: []const u8, args: var) noreturn {
    vga.set_color(vga.Color.White);
    vga.set_background(vga.Color.Red);
    logger.err(format, args);
    vga.printf(format, args);
    halt();
}
