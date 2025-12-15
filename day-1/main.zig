const std = @import("std");
const DoublyLinkedList = std.DoublyLinkedList;

pub fn main() !void {
    // GeneralPurposeAllocator is being renamed
    // to DebugAllocator. Let's get used to that name
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    // var list: SinglyLinkedList = .{};
    var list: DoublyLinkedList = .{};
    var counter: i32 = 1;
    const limit: i32 = 5;
    const first = try allocator.create(Pos);
    first.* = .{
        .id = 0,
        .node = .{},
    };
    list.prepend(&first.node);
    while (counter < limit) {
        const node = try allocator.create(Pos);
        defer allocator.destroy(node);
        node.* = .{
            .id = counter,
            .node = .{},
        };

        list.prepend(&node.node);
        counter += 1;
    }
    // const user1 = try allocator.create(User);
    // defer allocator.destroy(user1);
    // user1.* = .{
    //     .id = 1,
    //     .node = .{},
    // };
    // list.prepend(&user1.node);
    //
    // const user2 = try allocator.create(User);
    // defer allocator.destroy(user2);
    // user2.* = .{
    //     .id = 2,
    //     .node = .{},
    // };
    // list.prepend(&user2.node);
    //
    var node = list.first;
    while (node) |n| {
        const p: *Pos = @fieldParentPtr("node", n);
        std.debug.print("{any}\n", .{p});
        node = n.next;
    }
}

const Pos = struct {
    id: i32,
    node: DoublyLinkedList.Node,
};

