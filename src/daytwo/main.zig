const std = @import("std");

pub fn main() !void {
    std.debug.print("Day 2 - Cude Conundrum\n", .{});

    const filename: []const u8 = "partone-example.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const readBuf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(readBuf);

    var iter = std.mem.splitSequence(u8, readBuf, "\n");

    while (iter.next()) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
