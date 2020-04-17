const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const kernel_bin = buildKernel(b);
    addQemuStep(b, kernel_bin);
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
            .cpu_model = .{ .explicit = &std.Target.x86.cpu._i686 }
        },
    });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const kernel = b.addExecutable("kernel", "src/kernel.zig");

    kernel.addAssemblyFile("src/kernel/boot.s");
    kernel.addAssemblyFile("src/kernel/gdt.s");
    kernel.addAssemblyFile("src/kernel/isr.s");

    kernel.setLinkerScriptPath("src/kernel/link.ld");
    kernel.setOutputDir("build");
    kernel.setTarget(target);
    kernel.setBuildMode(mode);
    b.default_step.dependOn(&kernel.step);
    return kernel.getOutputPath();
}

fn addQemuStep(b: *Builder, kernel_bin: []const u8) void {
    const qemu = b.step("qemu", "Run kernel in qemu");
    const qemu_args = &[_][]const u8{
        "qemu-system-x86_64",
        "-d", "unimp",
        "-kernel", kernel_bin,
    };
    const run_qemu = b.addSystemCommand(qemu_args);
    qemu.dependOn(&run_qemu.step);
    run_qemu.step.dependOn(b.default_step);
}
