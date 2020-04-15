const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const kernel = buildKernel(b);
}

fn buildKernel(b: *Builder) []const u8 {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .i386,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const kernel = b.addExecutable("kernel", "src/kernel.zig");

    kernel.addAssemblyFile("src/kernel/boot.s");

    kernel.setLinkerScriptPath("src/kernel/link.ld");
    kernel.setOutputDir("build");
    kernel.setTarget(target);
    kernel.setBuildMode(mode);
    b.default_step.dependOn(&kernel.step);
    return kernel.getOutputPath();
}
