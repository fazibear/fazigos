const std = @import("std");
const fmt = std.fmt;

var vga = VGA{
    .chars = @intToPtr([*]Entry, 0xb8000),
    .position = 0,
    .current_foreground = Color.White,
    .current_background = Color.Black,
};

pub fn clear() void {
    vga.clear();
}

pub fn set_color(color: Color) void {
    vga.set_foreground_color(color);
}

pub fn set_background(color: Color) void {
    vga.set_background_color(color);
}

pub fn print(string: []const u8) void {
    for (string) |char| vga.print_char(char);
}

pub fn printf(comptime format: []const u8, args: var) void {
    var printf_buff: [256]u8 = undefined;
    var formatted = fmt.bufPrint(printf_buff[0..], format, args) catch |err| switch (err) {
        error.NoSpaceLeft => "xxx",
    };
    print(formatted);
}

pub fn println(comptime string: []const u8) void {
    print(string ++ "\n");
}

pub fn init() void {
    clear();
    set_background(Color.Blue);
    set_color(Color.LightBlue);
    print(
        \\********************************************************************************
        \\*                 _____              .__                                       *
        \\*               _/ ____\____  _______|__| ____   ____  ______                  *
        \\*               \   __\\__  \ \___   /  |/ ___\ /  _ \/  ___/                  *
        \\*                |  |   / __ \_/    /|  / /_/  >  <_> )___ \                   *
        \\*                |__|  (____  /_____ \__\___  / \____/____  >                  *
        \\*                           \/      \/ /_____/            \/                   *
        \\********************************************************************************
    );
    set_background(Color.Black);
    set_color(Color.White);
}

// ------------------------------------------------------

const SCREEN_WIDTH = 80;
const SCREEN_HEIGHT = 25;
const SCREEN_SIZE = SCREEN_WIDTH * SCREEN_HEIGHT;

const VGA = struct {
    chars: [*]Entry,
    position: usize,
    current_foreground: Color,
    current_background: Color,

    pub fn set_foreground_color(self: *VGA, color: Color) void {
        self.current_foreground = color;
    }

    pub fn set_background_color(self: *VGA, color: Color) void {
        self.current_background = color;
    }

    pub fn entry(self: *VGA, char: u8) Entry {
        return Entry{
            .char = char,
            .foreground = self.current_foreground,
            .background = self.current_background,
        };
    }

    pub fn clear(self: *VGA) void {
        std.mem.set(Entry, self.chars[0..SCREEN_SIZE], self.entry(' '));
        self.position = 0;
    }

    pub fn print_char(self: *VGA, char: u8) void {
        switch (char) {
            // Newline.
            '\n' => {
                const rest = self.position % SCREEN_WIDTH;
                if (rest > 0) {
                    self.position += SCREEN_WIDTH - rest;
                }
            },
            // Return
            '\r' => {
                self.position %= SCREEN_WIDTH;
            },
            // Tab.
            '\t' => {
                self.print_char(' ');
            },
            // Backspace.
            '\x08' => {
                self.position -= 1;
                self.print_char(' ');
            },
            else => {
                self.chars[self.position] = self.entry(char);
                self.position += 1;
            },
        }
    }
};

// Color codes.
pub const Color = enum(u4) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGrey = 7,
    DarkGrey = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

const Entry = packed struct {
    char: u8,
    foreground: Color,
    background: Color,
};
