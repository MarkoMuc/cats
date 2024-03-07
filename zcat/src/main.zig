const std = @import("std");
const process = std.process;
const print = std.debug.print;
const mem = std.mem;
const fs = std.fs;

fn concat(args: [][:0]const u8) !void {
    const stdout = std.io.getStdOut();
    var buf_out = std.io.bufferedWriter(stdout.writer());
    const writer = buf_out.writer();
    defer stdout.close();

    var msg_buf: [4096]u8 = undefined;

    if (args.len == 1) {
        const stdin = std.io.getStdIn();
        defer stdin.close();

        var buf_in = std.io.bufferedReader(stdin.reader());
        const std_reader = buf_in.reader();

        while (try std_reader.readUntilDelimiterOrEof(&msg_buf, '\n')) |msg| {
            try writer.print("{s}\n", .{msg});
            try buf_out.flush();
        }
        return;
    }

    var stripped_args = args[1..];

    for (stripped_args) |arg| {
        var file: std.fs.File = undefined;

        if (!mem.eql(u8, "-", arg)) {
            file = fs.cwd().openFile(arg, .{}) catch {
                try writer.print("zcat: {s}: no such file.\n", .{arg});
                try buf_out.flush();
                continue;
            };
        } else {
            file = std.io.getStdIn();
        }

        defer file.close();

        const curr_reader = std.io.bufferedReader(file.reader()).reader();

        while (try curr_reader.readUntilDelimiterOrEof(&msg_buf, '\n')) |msg| {
            try writer.print("{s}\n", .{msg});
            try buf_out.flush();
        }
    }
}

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    try concat(args);
}
