const sys = @import("sys.zig");
const vga = @import("vga.zig");

pub const Port = enum(u16) {
    COM1 = 0x3F8,
    COM2 = 0x2F8,
    COM3 = 0x3E8,
    COM4 = 0x2E8,
};

const LCR: u16 = 3;
const BAUD_MAX: u32 = 115200;
const CHAR_LEN: u8 = 8;
const SINGLE_STOP_BIT: bool = true;
const PARITY_BIT: bool = false;
pub const DEFAULT_BAUDRATE = 38400;

fn lcr(char_len: u8, stop_bit: bool, parity_bit: bool, msb: u1) u8 {
    if (char_len != 0 and (char_len < 5 or char_len > 8)) {
        sys.panic("Failed to initialize serial: Invalid char length", .{});
    }
    const val = char_len & 0x3 |
        @intCast(u8, @boolToInt(stop_bit)) << 2 |
        @intCast(u8, @boolToInt(parity_bit)) << 3 |
        @intCast(u8, msb) << 7;
    return val;
}

fn baud_divisor(baud: u32) u16 {
    if (baud > BAUD_MAX or baud == 0) {
        sys.panic("Failed to initialize serial: Invalid baud rate", .{});
    }
    return @truncate(u16, BAUD_MAX / baud);
}

fn transmit_empty(port: Port) bool {
    return sys.inb(@enumToInt(port) + 5) & 0x20 > 0;
}

pub fn write_char(char: u8, port: Port) void {
    while (!transmit_empty(port)) {
        sys.hlt();
    }
    sys.outb(@enumToInt(port), char);
}

pub fn write(str: []const u8, port: Port) void {
    for (str) |char| {
        write_char(char, port);
    }
}

pub fn init(baud: u32, port: Port) void {
    const divisor: u16 = baud_divisor(baud);
    const port_int = @enumToInt(port);

    sys.outb(port_int + LCR, lcr(0, false, false, 1));
    sys.outb(port_int, @truncate(u8, divisor));
    sys.outb(port_int + 1, @truncate(u8, divisor >> 8));
    sys.outb(port_int + LCR, lcr(CHAR_LEN, SINGLE_STOP_BIT, PARITY_BIT, 0));
    sys.outb(port_int + 1, 0);
}
