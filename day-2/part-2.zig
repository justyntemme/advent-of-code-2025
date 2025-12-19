const std = @import("std");
pub fn main() !void {
    // 1. Initialize allocator
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit(); // Clean up the allocator itself
    const allocator = gpa.allocator();

    // 2. Use ArrayListUnmanaged (matches your syntax style)
    var badCodes: std.ArrayListUnmanaged([]u8) = .{};
    var sBuffer: std.ArrayListUnmanaged([]const u8) = .{};

    // Clean up the LISTS structure
    defer sBuffer.deinit(allocator);

    // 3. Clean up the CONTENT of badCodes before the list itself
    defer {
        for (badCodes.items) |code| {
            allocator.free(code);
        }
        badCodes.deinit(allocator);
    }
    const s: []const u8 = "19391-47353,9354357-9434558,4646427538-4646497433,273-830,612658-674925,6639011-6699773,4426384-4463095,527495356-527575097,22323258-22422396,412175-431622,492524-611114,77-122,992964846-993029776,165081-338962,925961-994113,7967153617-7967231799,71518058-71542434,64164836-64292066,4495586-4655083,2-17,432139-454960,4645-14066,6073872-6232058,9999984021-10000017929,704216-909374,48425929-48543963,52767-94156,26-76,1252-3919,123-228";
    // const s: []const u8 = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    var it = std.mem.splitScalar(u8, s, ',');

    while (it.next()) |line| {
        var innerIterator = std.mem.splitScalar(u8, line, '-');
        var counter: usize = 0;
        var minVal: u64 = 0;
        var maxVal: u64 = 0;

        while (innerIterator.next()) |innerIt| {
            if (counter == 0) {
                const cleanString = std.mem.trim(u8, innerIt, " \n\r\t");
                minVal = try std.fmt.parseInt(u64, cleanString, 10);
            } else if (counter == 1) {
                const cleanString = std.mem.trim(u8, innerIt, " \n\r\t");
                maxVal = try std.fmt.parseInt(u64, cleanString, 10);
            }
            counter += 1;
        }
        var index = minVal;
        std.debug.print("Starting iterating through group {d}-{d}\n", .{ minVal, maxVal });

        while (index <= maxVal) {
            // Allocate the string for checking
            const currentString = try std.fmt.allocPrint(allocator, "{d}", .{index});
            // Ensure we free 'currentString' at end of this scope
            defer allocator.free(currentString);

            // Check all pattern lengths from 1 to len/2
            var isInvalid = false;
            var patternLen: usize = 1;
            while (patternLen <= currentString.len / 2) : (patternLen += 1) {
                if (@rem(currentString.len, patternLen) == 0) {
                    const repetitions = currentString.len / patternLen;
                    if (repetitions >= 2) {
                        const pattern = currentString[0..patternLen];
                        var matches = true;
                        for (1..repetitions) |i| {
                            const start = i * patternLen;
                            if (!std.mem.eql(u8, pattern, currentString[start .. start + patternLen])) {
                                matches = false;
                                break;
                            }
                        }
                        if (matches) {
                            isInvalid = true;
                            break; // Found a match, no need to check other pattern lengths
                        }
                    }
                }
            }

            if (isInvalid) {
                try badCodes.append(allocator, try allocator.dupe(u8, currentString));
                std.debug.print("{s} is a bad code\n", .{currentString});
            }

            index += 1;
        }
    }
    var total: u64 = 0;
    for (badCodes.items) |code| {
        const integer = try std.fmt.parseInt(u64, code, 10);
        total += integer;
    }
    std.debug.print("{d}\n", .{total});
}
