const std = @import("std");

pub fn main() !void {
    std.debug.print("Day 3 - Gear ratios \n", .{});

    const filename: []const u8 = "partone-example.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    const fileStat = try file.stat();
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const readBuf = try file.readToEndAlloc(allocator, fileStat.size);
    defer allocator.free(readBuf);

    const iter = std.mem.splitSequence(u8, readBuf, "\n");
    _ = iter;
}
