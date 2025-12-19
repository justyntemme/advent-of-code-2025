const std = @import("std");
pub fn readInput(allocator: std.mem.Allocator) ![]const u8 {
    const file_path = "./data.txt";
    const buffer = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    return buffer;
}
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    // var buffer: std.ArrayListUnmanaged(u8) = .{};
    // defer buffer.deinit(allocator);
    //
    // scratchpad
    //
    //maybe we need to search for the smallest numbers and drop those
    //
    //maybe we find the largest number to the left
    //
    //sliding window but with 4 digits, no not that
    //
    // i do think we need to do something where we drop digits rather than looping through for the biggest
    //
    //
    var buffer: u64 = 0;

    const batteryPacksFile: []const u8 = try readInput(allocator);
    const batteryPacks: []const u8 = "987654321111111\n811111111111119\n234234234234278\n818181911112111";
    defer allocator.free(batteryPacksFile);
    var packsIterator = std.mem.splitScalar(u8, batteryPacks, '\n');
    while (packsIterator.next()) |packsKey| {
        var tempBuffer: u64 = 0;

        if (packsKey.len == 0) continue;
        for (packsKey, 0..) |_, index| {
            if (packsKey.len >= (index + 12)) {
                std.debug.print("Index: {d}\n", .{index});
                // std.debug.print("packsKey length: {d}\n index: {d}\npackskey: {s}\n", .{ packsKey.len, index, packsKey });
                const tempBufferString = packsKey[index .. index + 12];
                // std.debug.print("Temp buffer string {s}\n", .{tempBufferString});
                const tempBufferInt = try std.fmt.parseInt(u64, tempBufferString, 10);
                std.debug.print("TempbufferInt: {d}\nTempbuffer: {d}\n", .{ tempBufferInt, tempBuffer });
                if (tempBuffer < tempBufferInt) tempBuffer = tempBufferInt;
                std.debug.print("TempBuffer: {d}\n", .{tempBuffer});
            }
        }
        buffer = buffer + tempBuffer;
        std.debug.print("Buffer is now: {d}\n", .{buffer});
        //scratchpad:
        // iterate through all numbers, moe the sum addition logic insdie the while loop
        // start the next iteration after the index of the pargest number
        //
        // 12 digit sliding window
        std.debug.print("{d}\n", .{buffer});
    }
    // std.debug.print("Sum is\n{d}\n", .{});
}
