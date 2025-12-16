const std = @import("std");

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();
    var badCodes: std.ArrayList([]const u8) = .{};
    // var entries: std.ArrayList([]u8) = .{};
    var sBuffer: std.ArrayList([]const u8) = .{};
    // var buffer: u8 = '';

    defer sBuffer.deinit(allocator);
    defer badCodes.deinit(allocator);
    // var badCodesasIntegers: std.ArrayList(i32) = .{};
    var badCode: bool = false;

    //we need to loop through an string and explode out all of the strings sperated by a ,
    //then we ( need ) to create a iterate through checking for any repeated chars by using
    // if (string[curretCharPos] == string[curretCharPos + 1]) {
    // print("invalid")
    const s: []const u8 = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    var it = std.mem.splitScalar(u8, s, ',');
    while (it.next()) |line| {
        var innerIterator = std.mem.splitScalar(u8, line, '-');
        var counter: usize = 0;
        var minVal: usize = 0;
        var maxVal: usize = 0;
        while (innerIterator.next()) |innerIt| {
            badCode = false;
            try sBuffer.append(allocator, innerIt);

            if (counter == 0) {
                // std.debug.print("counter detect at 0 for {s}", .{line});
                const cleanString = std.mem.trim(u8, innerIt, " \n\r\t");
                minVal = try std.fmt.parseInt(usize, cleanString, 10);
            } else if (counter == 1) {
                const cleanString = std.mem.trim(u8, innerIt, " \n\r\t");
                maxVal = try std.fmt.parseInt(usize, cleanString, 10);
            }
            counter += 1;

            // for (innerIt, 0..) |_, index| { // this is iterating over every string within each grouping -- we can delete this eventually
            //     // convert to int
            //     //if current index == next index then add to array of ints
            //     //then combine all ints for solution
            //     // check if last item
            //     // std.debug.print("element is {c}", element);
            //
            //     // this is where we need to convert the groupings into ranges and pass the ranges asa the min/max to the iterators below
            //     if (index < innerIt.len - 1) {
            //         // for (innerIt[index..]) |currentElement| { //every letter in grouping
            //         //     // std.debug.print("Testing: current element is {c}, as index {d}\n", .{ currentElement, currentIndex });
            //         //     // try sBuffer.append(allocator, currentElement);
            //         // }
            //         // try entries.append(allocator, sBuffer.items);
            //
            //         // if (element == innerIt[index + 1]) {
            //         //
            //         //     // for each element in string, build a array of strings of index of element -> end
            //         //     // check if any of the strings contain any of the other strings
            //         //     //
            //         //     // if thsi doesn't work then after building the array we need to build an array of all possible
            //         //     // strings or each char in the array
            //         //     //
            //         //     // example
            //         //     //
            //         //     // abcdef would have
            //         //     // [a],[ab],[abc], [abdcd], [abcde], [abcdef]
            //         //     // [b], [bc], [bcd], [bcde], [bcdef]
            //         //     // [c], [cd], [cde], [cdef]
            //         //     // [d], [de], [def]
            //         //     // [e], [ef]
            //         //     //
            //         //     // Then we loop through all entries in the array and compare the strings to the element,
            //         //     // if a match is Found then thats a bad code
            //         //     //
            //         //     // example with bad code
            //         //     //
            //         //     // 123123
            //         //     // [1], [12], [123], [1231], [12312], [123123]
            //         //     // [2], [23], [231], [2312], [23123]
            //         //     // [3], [231], [2312], [23123]
            //         //     // [1], [12], [123]
            //         //     //
            //         //     // I think the issue here is if we have say 104198 we would detect two numbers
            //         //     // So maybe ensure len of num > 2 on bad codes
            //         //     // or we drop the first index so its just
            //         //     //  [12], [123], [1231], [12312], [123123]
            //         //     //  [23], [231], [2312], [23123]
            //         //     //  [231], [2312], [23123]
            //         //     //  [12], [123]
            //         //     //
            //         //     //  This is for each number in rnage
            //         //     //  set min and increment while less than or equal to max
            //         //     // test example 38593859
            //         //     //
            //         //     //
            //         //     //
            //         //     // maybe we should first explode by , then in the second function explode by - and set lower limit and upper limit there, then call a function to iterate trhough that number
            //         //     // range after converting both to ints, and convert every index to a string and do the string comparison there.
            //         //
            //         //     //we misunderstood the problem, we need to create a buffer of where we are at -1 and compare the whole string
            //         //     //this is a good starting point, we can do the rest tomorrow. but we need to strcomp of variable size,
            //         //     //not just this char and the next. we will need to create a buffer that checks until the end, we will somehow reset bad code if
            //         //     //there is further strings
            //         //     //
            //         //     //wait wait wait, we are given number ranges and need to find the numbers within that range that does this.
            //         //     //so now that we have exploded things we should turn them into ints and start cycling through each number
            //         //     //turning it into an int and doing our buffer string comparison.
            //         //     std.debug.print("BAD CODE@ {c} of index {d}\n", .{ element, index });
            //         //     badCode = true;
            //         // }
            //     }
            //     // std.debug.print("Current sbuffer {s}\n", .{sBuffer.items});
            //     // for (entries.items) |element| {
            //     //     std.debug.print("{s},\n", .{element});
            //     // }
            // }
            // if (badCode == true) {
            //     try badCodes.append(allocator, innerIt);
            // }
        }

        for (minVal..maxVal) |index| {
            std.debug.print("{d}-", .{index});
        }
        std.debug.print("\n", .{});

        // std.debug.print("{}-\n", .{sBuffer});
    }
    // for (badCodes.items) |item| {
    //     std.debug.print("Found bad code {s}\n", .{item});
    // }
}
