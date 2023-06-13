const std = @import("std");
const builtin = @import("builtin");
const args = @import("args.zig");
const spindle = @import("spindle.zig");
const events = @import("events.zig");
const metros = @import("metros.zig");
const dev_monitor = switch (builtin.target.os.tag) {
    .linux => @import("dev_monitor_linux.zig"),
    else => @import("dev_monitor_macos.zig"),
};
const osc = @import("osc.zig");
const input = @import("input.zig");
const screen = @import("screen.zig");
const midi = @import("midi.zig");
const c = @import("c_includes.zig").imported;

const VERSION = std.builtin.Version{ .major = 0, .minor = 5, .patch = 0 };

pub fn main() !void {
    defer std.debug.print("seamstress shutdown complete\n", .{});
    try args.parse();
    try print_version();

    var general_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = general_allocator.allocator();
    defer _ = general_allocator.deinit();
    defer events.free_pending();

    var allocated = true;
    const config = std.process.getEnvVarOwned(allocator, "SEAMSTRESS_CONFIG") catch |err| blk: {
        if (err == std.process.GetEnvVarOwnedError.EnvironmentVariableNotFound) {
            allocated = false;
            break :blk "'/usr/local/share/seamstress/lua/config.lua'";
        } else {
            return err;
        }
    };
    defer if (allocated) allocator.free(config);

    std.debug.print("init events\n", .{});
    try events.init(allocator);

    std.debug.print("init metros\n", .{});
    try metros.init(allocator);
    defer metros.deinit();

    std.debug.print("init spindle\n", .{});
    try spindle.init(config, allocator);
    defer spindle.deinit();

    std.debug.print("init device monitor\n", .{});
    try dev_monitor.init(allocator);
    defer dev_monitor.deinit();

    std.debug.print("init MIDI\n", .{});
    try midi.init(allocator);
    defer midi.deinit() catch {};

    std.debug.print("init osc\n", .{});
    try osc.init(args.local_port, allocator);
    defer osc.deinit();

    std.debug.print("init input\n", .{});
    try input.init(allocator);
    defer input.deinit();

    std.debug.print("init screen\n", .{});
    const width = try std.fmt.parseUnsigned(u16, args.width, 10);
    const height = try std.fmt.parseUnsigned(u16, args.height, 10);
    try screen.init(width, height);
    defer screen.deinit();

    std.debug.print("handle events\n", .{});
    try events.handle_pending();

    std.debug.print("spinning spindle\n", .{});
    try spindle.startup(args.script_file);

    std.debug.print("entering main loop\n", .{});
    try events.loop();
}

fn print_version() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("SEAMSTRESS\n", .{});
    try stdout.print("seamstress version: {d}.{d}.{d}\n", VERSION);
    try bw.flush();
}