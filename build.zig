const std = @import("std");

pub fn build(b: *std.Build) void {
    const kernel = b.addExecutable(.{
        .name = "zos",
        .root_source_file = b.path("src/kernel.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .riscv32,
            .os_tag = .freestanding,
            .abi = .none,
        }),
        .optimize = .Debug,
        .strip = false,
    });

    kernel.setLinkerScript(b.path("src/kernel.ld"));

    b.installArtifact(kernel);

    const run_cmd = b.addSystemCommand(&.{"qemu-system-riscv32"});
    run_cmd.addArgs(&.{
        "-machine", "virt", // start a virt machine
        "-bios",      "default", // use the default firmware: OpenSBI in our case
        "-nographic", "--no-reboot",
        "-serial",    "mon:stdio",
        "-kernel",
    });
    run_cmd.addArtifactArg(kernel);

    const run_step = b.step("run", "Run Qemu");
    run_step.dependOn(&run_cmd.step);
}
