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
        // defer allocator.destroy(node);
        node.* = .{
            .id = counter,
            .node = .{},
        };

        list.prepend(&node.node);
        counter += 1;
    }
    if (list.last) |tail| {
        if (list.first) |head| {
            tail.next = head;
            // Optionally link head.prev = tail for full circularity
            head.prev = tail;
        }
    }
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
