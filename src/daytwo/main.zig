const std = @import("std");
const testing = std.testing;

pub fn main() !void {
    std.debug.print("Day 2 - Cude Conundrum\n", .{});

    const Bag = enum(u8) {
        red = 12,
        green = 13,
        blue = 14,
    };

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

    var sum: u16 = 0;
    var gameNum: u8 = 1;
    while (iter.next()) |line| {
        // std.debug.print("{s}\n", .{line});
        var games = std.mem.splitAny(u8, line, ":;,");
        var isValidGame = true;
        while (games.next()) |game| {
            // std.debug.print("{s}\n", .{game});
            var num = std.ArrayList(u8).init(allocator);
            var string = std.ArrayList(u8).init(allocator);
            defer num.deinit();
            defer string.deinit();
            for (game) |token| {
                if (std.ascii.isDigit(token)) {
                    try num.append(token);
                } else if (std.ascii.isAlphabetic(token)) {
                    try string.append(token);
                }
            }

            const convertedNum = try std.fmt.parseInt(u8, std.mem.sliceTo(num.items, 0), 10);
            const convertedString = std.mem.sliceTo(string.items, 0);

            if (std.mem.eql(u8, convertedString, "red") and convertedNum > @intFromEnum(Bag.red)) {
                isValidGame = false;
            }
            if (std.mem.eql(u8, convertedString, "green") and convertedNum > @intFromEnum(Bag.green)) {
                isValidGame = false;
            }
            if (std.mem.eql(u8, convertedString, "blue") and convertedNum > @intFromEnum(Bag.blue)) {
                isValidGame = false;
            }
        }

        if (isValidGame) {
            sum += gameNum;
        }

        gameNum += 1;
    }

    std.debug.print("Sum: {d}\n", .{sum});
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
