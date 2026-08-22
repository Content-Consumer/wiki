const std = @import("std");
const stdout = std.Io.File.stdout();
const stdin = std.Io.File.stdin();

fn listdir(path: []u8, io: std.Io, allocator: std.mem.Allocator) !void {
    // Read a directory
    const dir = try std.Io.Dir.openDir(std.Io.Dir.cwd(), io, path, .{ .iterate = true });
    defer dir.close(io);

    // Walk it recursively
    var walker = try dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next(io)) |file| {
        try stdout.writeStreamingAll(io, file.path);
        try stdout.writeStreamingAll(io, "\n");
    }
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;

    try stdout.writeStreamingAll(io, "Hello World\n");

    // const DIR_PATH = "/home/denntenna/Notes";

    var buf: [1024]u8 = undefined;
    var reader = stdin.reader(io, &buf);

    while (try reader.interface.takeDelimiter('\n')) |line| {
        try stdout.writeStreamingAll(io, "rcvd {s} \n");
        // try listdir(line, io, gpa);

        if (listdir(line, io, gpa)) {} else |err| {
            switch (err) {
                error.FileNotFound => {
                    try stdout.writeStreamingAll(io, "error : file not found");
                    return;
                },
                else => return err,
            }
        }
    }
}
