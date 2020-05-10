const multiboot = @import("multiboot.zig");
const sys = @import("sys.zig");
const logger = @import("logger.zig");

const PAGE_SIZE = 4096;

const FreeMemoryStack = struct {
    stack: [*]usize,
    index: usize,

    pub fn init(start: usize) FreeMemoryStack {
        return FreeMemoryStack{
            .stack = @intToPtr([*]usize, start),
            .index = 0,
        };
    }
};

pub var free_memory = FreeMemoryStack.init(0x2000000);

pub fn init(start: usize, memory_map: ?[]multiboot.MemoryMapEntry) void {
    if (memory_map) |map| {
        free_memory = FreeMemoryStack.init(start);

        for (map) |entry| {
            if (entry.type != multiboot.MemoryType.Free) continue;
            logger.info("{x}", .{entry});
        }
    } else {
        sys.panic("Memory Map does not exists!", .{});
    }
}
