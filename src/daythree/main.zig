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

    var iter = std.mem.splitSequence(u8, readBuf, "\n");

    var lineNum: u8 = 0;
    var grid: [][]u8 = undefined;
    while (iter.next()) |line| {
        lineNum += 1;
        for (line, 0..) |c, i| {
            const index: u8 = @as(u8, @intCast(i));
            grid[lineNum][index] = c;
        }
    }

    for (grid, 0..) |line, row| {
        for (line, 0..) |char, column| {
            std.debug.print("row {d} column {d} value {c} \n", .{ row, column, char });
        }
    }
}
