const std = @import("std");
const testing = std.testing;

pub fn main() !void {
    std.debug.print("Day 1 2023 - Trebuchet?!\n", .{});

    const filename: []const u8 = "input.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    const fileStat = try file.stat();
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const read_buf = try file.readToEndAlloc(allocator, fileStat.size);
    defer allocator.free(read_buf);

    var iter = std.mem.splitSequence(u8, read_buf, "\n");

    var total: u32 = 0;
    const targets = [9][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    while (iter.next()) |line| {
        var first: u8 = 0;
        var last: u8 = 0;
        outerFor: for (line, 0..) |c, i| {
            const isDigit = std.ascii.isDigit(c);

            if (isDigit and first == 0) {
                first = try std.fmt.charToDigit(c, 10);
                break;
            } else {
                for (targets, 0..) |target, digit| {
                    const end: u8 = @as(u8, @intCast(i)) + @as(u8, @intCast(target.len));
                    if (end > line.len) {
                        continue;
                    }
                    if (std.mem.eql(u8, line[i .. i + target.len], target)) {
                        first = @as(u8, @intCast(digit)) + 1;
                        break :outerFor;
                    }
                }
            }
        }

        var i: usize = line.len;
        outerWhile: while (i > 0) {
            i -= 1;
            const isDigit = std.ascii.isDigit(line[i]);
            if (isDigit) {
                last = try std.fmt.charToDigit(line[i], 10);
                break;
            } else {
                for (targets, 0..) |target, digit| {
                    const start: i64 = @as(i64, @intCast(i)) - @as(i64, @intCast(target.len));
                    if (start < 0) {
                        continue;
                    }
                    if (std.mem.eql(u8, line[i + 1 - target.len .. i + 1], target)) {
                        last = @as(u8, @intCast(digit)) + 1;
                        break :outerWhile;
                    }
                }
            }
        }

        total += first * 10 + last;
    }
    std.debug.print("Total is: {d}\n", .{total});
}

test "it gives me substring" {
    const string = "some random string";
    const substring = string[2..6];

    try testing.expect(std.mem.eql(u8, "me r", substring));
}

test "include ending char" {
    const string = "random";
    const substring = string[0..string.len];

    try testing.expect(std.mem.eql(u8, "random", substring));
}
