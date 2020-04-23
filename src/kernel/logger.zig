const std = @import("std");
const fmt = std.fmt;
const serial = @import("serial.zig");

const Error = error{};
const OutStream = std.io.OutStream(void, Error, format_callback);
const out_stream = OutStream{ .context = {} };

const BLACK = "\x1b[30;1m";
const RED = "\x1b[31;1m";
const GREEN = "\x1b[32;1m";
const YELLOW = "\x1b[33;1m";
const BLUE = "\x1b[34;1m";
const MAGENTA = "\x1b[35;1m";
const CYAN = "\x1b[36;1m";
const WHITE = "\x1b[37;1m";
const DIM = "\x1b[2m";
const RESET = "\x1b[0m";

const ERROR = RED ++ "[   ERROR ] " ++ RESET;
const INFO = YELLOW ++ "[    INFO ] " ++ RESET;

fn format_callback(context: void, str: []const u8) Error!usize {
    serial.write(str, serial.Port.COM1);
    return str.len;
}

pub fn init() void {
    serial.init(serial.DEFAULT_BAUDRATE, serial.Port.COM1);
}

pub fn err(comptime format: []const u8, args: var) void {
    fmt.format(out_stream, ERROR ++ format ++ "\n", args) catch unreachable;
}

pub fn info(comptime format: []const u8, args: var) void {
    fmt.format(out_stream, INFO ++ format ++ "\n", args) catch unreachable;
}
