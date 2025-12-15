const std = @import("std");
const DoublyLinkedList = std.DoublyLinkedList;
const directionType = struct { u8, []const u8 };
var gpa: std.heap.DebugAllocator(.{}) = .init;

pub fn parseInstructions(inst: []const u8) void {
    var it = std.mem.splitScalar(u8, inst, '\n');

    while (it.next()) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
pub fn main() !void {
    const pinst = "R10\nL5\nL1\nR3";
    parseInstructions(pinst);
    // GeneralPurposeAllocator is being renamed
    // to DebugAllocator. Let's get used to that name
    const allocator = gpa.allocator();

    // var list: SinglyLinkedList = .{};
    var list: DoublyLinkedList = .{};
    var counter: i32 = 1;
    const limit: i32 = 100;
    const first = try allocator.create(Pos);
    first.* = .{
        .id = 0,
        .node = .{},
    };
    list.prepend(&first.node);
    while (counter < limit) {
        const node = try allocator.create(Pos);
        // defer allocator.destroy(node);
        node.* = .{
            .id = counter,
            .node = .{},
        };

        list.append(&node.node);
        counter += 1;
    }
    if (list.last) |tail| {
        if (list.first) |head| {
            tail.next = head;
            // Optionally link head.prev = tail for full circularity
            head.prev = tail;
        }
    }

    var Node = list.first;
    const initCounter = 50;
    var c: i32 = 0;
    while (c < initCounter) {
        if (Node) |node| {
            Node = node.next.?;
            c += 1;
        }
        if (Node) |y| {
            const p: *Pos = @fieldParentPtr("node", y);
            std.debug.print("{any}\n", .{p.id});
        }
    }
    const dir: []const u8 = "L32\nR2\nL64";

    var it = std.mem.splitScalar(u8, dir, '\n');

    while (it.next()) |line| {
        const direction: u8 = line[0];
        const amountString: []const u8 = line[1..];
        const amount: i32 = try std.fmt.parseInt(i32, amountString, 10);
        std.debug.print("{c} {d} times\n", .{ direction, amount });
        // const integer_value: i32 = try std.fmt.parseInt(i32, input_str, radix);

    }

    //maybe an event que of the rotations,
    // then we read the rotation number and direction, and call that funct
    //
    // nah nah, a (for each \n) just call a left(count) or right(count) function with the first
    // parameter to those functions being a count pulled from the second and third elment
    // of the string array after we make those an int, by joining into a string then calling some strconv
    // then print the value of each node
    //
    // or we create an array and a counter and for each entery we make array[pos-int] = counter
    // then we can see in number in which they were pressed, and which numbers were landed on the array is an array of numbers 1-99
    //
    // split the R38 into a slice of the 1st and second position in the array (1,2) then call some strtoint on then
    // use an enum for direction, case switch for either direction
    //
    //
    // var node = list.first;
    // while (node) |n| {
    //     const p: *Pos = @fieldParentPtr("node", n);
    //     std.debug.print("{any}\n", .{p});
    //     node = n.next;
    // }
}

const Pos = struct {
    id: i32,
    node: DoublyLinkedList.Node,
};

