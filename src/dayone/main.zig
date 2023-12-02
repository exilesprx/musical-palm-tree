const std = @import("std");

pub fn main() !void {
    std.debug.print("Day 1 2023 - Trebuchet?!\n", .{});

    const exampleTotal: u16 = try calculateCalibrations("example.txt");
    std.debug.print("Total for example is: {d}\n", .{exampleTotal});

    const inputTotal: u16 = try calculateCalibrations("input.txt");
    std.debug.print("Total for input is: {d}\n", .{inputTotal});
}

pub fn calculateCalibrations(filename: []const u8) !u16 {
    // const filename = "example.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(read_buf);

    var iter = std.mem.splitSequence(u8, read_buf, "\n");

    var total: u16 = 0;
    while (iter.next()) |line| {
        var num: u8 = 0;
        for (line) |c| {
            const isDigit = std.ascii.isDigit(c);
            if (isDigit and num == 0) {
                // only multiple by 10 if its the first number found (num hasn't been updated yet)
                num = try std.fmt.charToDigit(c, 10);
                total += num * 10;
            } else if (isDigit) {
                num = try std.fmt.charToDigit(c, 10);
            }
        }

        // add the last num found
        total += num;
    }
    return total;
}