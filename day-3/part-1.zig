const std = @import("std");
pub fn readInput(allocator: std.mem.Allocator) ![]const u8 {
    // defer {
    // const leak_detected = gpa.deinit();
    // if (leak_detected) {
    //     std.log.err("Mem leak", .{});
    // }
    // }

    const file_path = "./data.txt";
    const buffer = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    return buffer;
}
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var sum: u64 = 0;
    const batteryPacks: []const u8 = try readInput(allocator);
    defer allocator.free(batteryPacks);
    // const batteryPacks: []const u8 = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
    // const batteryPack1: []const u8 = "987654321111111";
    var packsIterator = std.mem.splitScalar(u8, batteryPacks, '\n');
    while (packsIterator.next()) |packsKey| {
        if (packsKey.len == 0) continue;
        var buffer1: u8 = '0';
        // var buffer2: u8 = "0";
        // var buffer1Int: u64 = std.fmt.parseInt(u64, buffer1, 10);
        // var buffer2Int: u64 = std.fmt.parseInt(u64, buffer2, 10);
        var buffer1Int: u64 = 0;
        // var largestIntPos: usize = 0;
        var buffer2Int: u64 = 0;

        for (packsKey, 0..) |key, index| {
            const keyInt: u64 = key - '0';
            // const keyInt: u64 = @intCast(key);
            // const keyInt: u64 = std.fmt.ParseInt(u64, key, 10);
            // std.debug.print("Checking if {d} > {d}\n", .{ keyInt, buffer1Int });
            if (keyInt > buffer1Int and index < packsKey.len - 1) {
                // std.debug.print("True\n", .{});
                buffer1Int = keyInt;
                buffer1 = key;
            }

            // to deal with duplicates we can just find the position of the largest charecter and pop it out of the array

        }
        const index = std.mem.indexOfScalar(u8, packsKey, buffer1).?;
        std.debug.print("index is {d}\n", .{index});

        for (packsKey[index + 1 ..]) |key| {
            const keyInt: u64 = key - '0';
            if (keyInt > buffer2Int) {
                buffer2Int = keyInt;
            }
        }
        std.debug.print("Largest numbers are {d} and {d} or {d}{d}\n", .{ buffer1Int, buffer2Int, buffer1Int, buffer2Int });

        buffer1Int = buffer1Int * 10;
        std.debug.print("buffer1Int is now {d}\n", .{buffer1Int});

        std.debug.print("buffer2Int is now {d}\n", .{buffer2Int});
        const tempSum = buffer1Int + buffer2Int;
        sum += tempSum;
        std.debug.print("Sum is now {d}\n", .{sum});

        //sum += currentSum
    }
    std.debug.print("Sum is \n {d}\n", .{sum});
    //we need to convert it back to a string
    // largestIntPos = std.mem.indexofS
    // remember to start at the index of the largest pos+1 for the second iteration

}
