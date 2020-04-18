const isr = @import("isr.zig");
const interrupt = @import("interrupt.zig");

var ticks: u32 = 0;

fn handle(context: *isr.Context) void {
    ticks += 1;
}

pub fn sleep(ticks: u32) void {
    var eticks = timer_ticks + ticks;
    while (timer_ticks < eticks) {}
}

pub fn init() void {
    interrupt.register(0, handle);
}
