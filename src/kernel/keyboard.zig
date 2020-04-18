const isr = @import("isr.zig");
const vga = @import("vga.zig");
const sys = @import("sys.zig");
const interrupt = @import("interrupt.zig");

var keyboard_shift = false;
var keyboard_alt = false;

const keyboard_chars = [_]u8{
    0,   0,   '1', '2', '3', '4', '5', '6', '7',  '8', '9', '0',  '-',  '=', '\x08', '\t',
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o',  'p', '[', ']',  '\n', 0,   'a',    's',
    'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0,   '\\', 'z',  'x', 'c',    'v',
    'b', 'n', 'm', ',', '.', '/', 0,   '*', 0,    ' ', 0,   0,    0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,   0,    0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,   0,    0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,   0,    0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,   0,    0,    0,   0,      0,
};

const keyboard_chars_shift = [_]u8{
    0,   0,   '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_',  '+', '\x08', '\t',
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', 0,   'A',    'S',
    'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', 0,   '|', 'Z',  'X', 'C',    'V',
    'B', 'N', 'M', '<', '>', '?', 0,   '0', 0,   ' ', 0,   0,   0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,      0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0,      0,
};

fn set_control_keys(scancode: u8) bool {
    switch (scancode) {
        0x2a, 0x36 => {
            keyboard_shift = true;
            return true;
        },
        0x38 => {
            keyboard_alt = true;
            return true;
        },
        0xAA, 0xB6 => {
            keyboard_shift = false;
            return true;
        },
        0xB8 => {
            keyboard_alt = false;
            return true;
        },
        else => return false,
    }
}

fn scancode_to_char(scancode: u8) u8 {
    if (keyboard_shift) {
        return keyboard_chars_shift[scancode];
    } else {
        return keyboard_chars[scancode];
    }
}

fn handle(context: *isr.Context) void {
    var scancode = sys.inb(0x60);

    var control_key = set_control_keys(scancode);
    if (scancode & 0x80 == 0) {
        if (!control_key) {
            vga.printch(scancode_to_char(scancode));
        }
    }
}

pub fn init() void {
    interrupt.register(1, handle);
}
