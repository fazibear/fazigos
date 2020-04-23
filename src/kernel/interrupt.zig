const isr = @import("isr.zig");
const sys = @import("sys.zig");

var handlers = [_]fn (*isr.Context) void{unhandled} ** 16;

fn unhandled(context: *isr.Context) noreturn {
    sys.panic(
        \\! Unhadled IRQ{}:
        \\!   int_no: {}
        \\!   err_code: {}
    , .{
        context.interrupt_num - 32,
        context.interrupt_num,
        context.error_code,
    });
}

pub fn register(n: u8, irq_handler: fn (*isr.Context) void) void {
    handlers[n] = irq_handler;
}

pub fn unregister(n: u8) void {
    handlers[n] = unhandled;
}

pub fn handler(context: *isr.Context) void {
    handlers[context.interrupt_num - 32](context);
    if (context.interrupt_num > 40) {
        sys.outb(0xA0, 0x20);
    }
    sys.outb(0x20, 0x20);
}
