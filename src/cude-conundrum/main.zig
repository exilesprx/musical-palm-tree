const std = @import("std");
const testing = std.testing;

pub fn main() !void {
    std.debug.print("Day 2 - Cude Conundrum\n", .{});

    const Bag = enum(u8) {
        red = 12,
        green = 13,
        blue = 14,
    };
    _ = Bag;

    const filename: []const u8 = "input.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    const fileStat = try file.stat();
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const readBuf = try file.readToEndAlloc(allocator, fileStat.size);
    defer allocator.free(readBuf);

    var iter = std.mem.splitSequence(u8, readBuf, "\n");

    var total: u32 = 0;
    while (iter.next()) |line| {
        // std.debug.print("{s}\n", .{line});
        var sets = std.mem.splitAny(u8, line, ":;,");
        var redCubes: u8 = 0;
        var greenCubes: u8 = 0;
        var blueCubes: u8 = 0;
        while (sets.next()) |details| {
            // std.debug.print("{s}\n", .{game});
            var num = std.ArrayList(u8).init(allocator);
            var string = std.ArrayList(u8).init(allocator);
            defer num.deinit();
            defer string.deinit();
            for (details) |token| {
                if (std.ascii.isDigit(token)) {
                    try num.append(token);
                } else if (std.ascii.isAlphabetic(token)) {
                    try string.append(token);
                }
            }

            const cubes = try std.fmt.parseInt(u8, std.mem.sliceTo(num.items, 0), 10);
            const color = std.mem.sliceTo(string.items, 0);

            if (std.mem.eql(u8, color, "red") and cubes > redCubes) {
                redCubes = cubes;
            }
            if (std.mem.eql(u8, color, "green") and cubes > greenCubes) {
                greenCubes = cubes;
            }
            if (std.mem.eql(u8, color, "blue") and cubes > blueCubes) {
                blueCubes = cubes;
            }
        }
        std.debug.print("red: {d}, green: {d}, blue: {d}\n", .{ redCubes, greenCubes, blueCubes });
        total += @as(u16, @intCast(redCubes)) * @as(u16, @intCast(greenCubes)) * @as(u16, @intCast(blueCubes));
    }

    std.debug.print("total: {d}\n", .{total});
}

test "concat char to string" {
    const allocator = testing.allocator;
    var string = std.ArrayList(u8).init(allocator);
    defer string.deinit();

    try string.append('a');
    try string.append('b');
    try string.append('c');
    try string.append('d');
    try string.append('e');
    try string.append('f');
    try string.append('g');
    try string.append('h');
    try string.append('i');
    try string.append('j');
    try string.append('k');
    try string.append('l');
    try string.append('m');
    try string.append('n');
    try string.append('o');
    try string.append('p');
    try string.append('q');
    try string.append('r');
    try string.append('s');
    try string.append('t');
    try string.append('u');
    try string.append('v');
    try string.append('w');
    try string.append('x');
    try string.append('y');
    try string.append('z');

    const expected = "abcdefghijklmnopqrstuvwxyz";
    const actual = std.mem.sliceTo(string.items, 0);
    try testing.expectEqualStrings(expected, actual);
}
