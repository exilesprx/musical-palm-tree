const std = @import("std");
const testing = std.testing;

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
const allocator = arena.allocator();

pub fn main() !void {
    defer arena.deinit();

    std.debug.print("Day 1 2023 - Trebuchet?!\n", .{});

    const total: u32 = try calculateCalibrations("input.txt");
    std.debug.print("Total is: {d}\n", .{total});
}

fn calculateCalibrations(filename: []const u8) !u32 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
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
    return total;
}

fn replaceString(string: []const u8, target: []const u8, replacement: []const u8) ![]const u8 {
    const size = std.mem.replacementSize(u8, string, target, replacement);
    const output = try allocator.alloc(u8, size);
    _ = std.mem.replace(u8, string, target, replacement, output);
    return output;
}

test "replaces text in the middle" {
    const string = try replaceString("Hello zig world", "zig", "new");
    try testing.expect(std.mem.eql(u8, string, "Hello new world"));
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
