const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.resolveTargetQuery(try std.Build.parseTargetQuery(.{
        .arch_os_abi = "x86-windows.xp...xp-msvc",
        .cpu_features = "i386",
    }));
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "Minimus",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .linkage = .dynamic,
    });
    b.installArtifact(exe);

    const iso = b.addSystemCommand(&.{"xorriso"});
    iso.addArg("-dev");
    const isoPath = iso.addOutputFileArg("Minimus.iso");
    iso.addArg("-joliet");
    iso.addArg("on");
    iso.addArg("-map-single");
    iso.addArtifactArg(exe);
    iso.addArg("/Minimus.exe");
    iso.has_side_effects = true;
    b.getInstallStep().dependOn(&b.addInstallFileWithDir(isoPath, .prefix, "Minimus.iso").step);
}
