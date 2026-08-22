const std = @import("std");
const dvui = @import("dvui");
const SDLBackend = @import("sdl-backend");
const myfs = @import("fs.zig");

const vsync = true;
var g_backend: ?SDLBackend = null;
var g_win: ?*dvui.Window = null;

var text_label_buf = std.mem.zeroes([50]u8);

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    SDLBackend.enableSDLLogging();
    std.log.info("SDL Version: {f}", .{SDLBackend.getSDLVersion()});

    var backend = try SDLBackend.initWindow(.{
        .io = init.io,
        .environ_map = init.environ_map,
        .size = .{ .w = 800.0, .h = 400.0 },
        .min_size = .{ .w = 400.0, .h = 400.0 },
        .vsync = vsync,
        .title = "Wiki",
    });
    g_backend = backend;
    defer backend.deinit();

    var window_open = true;
    var win = try dvui.Window.init(@src(), init.gpa, backend.backend(), .{
        .open_flag = &window_open,
    });
    g_win = &win;
    defer win.deinit();

    var interrupted: bool = false;
    while (window_open) {
        const nstime = win.beginWait(interrupted);
        try win.begin(nstime);

        try backend.addAllEvents(&win);

        {
            var vbox = dvui.box(
                @src(),
                .{ .dir = .vertical },
                .{ .expand = .both },
            );
            defer vbox.deinit();

            dvui.label(@src(), "Hello World", .{}, .{});

            var textbox = dvui.textEntry(
                @src(),
                .{ .text = .{ .buffer = &text_label_buf } },
                .{},
            );
            textbox.deinit();

            if (dvui.button(
                @src(),
                "List Files",
                .{},
                .{},
            )) {
                // std.log.info("clicked");
                try std.Io.File.stdout().writeStreamingAll(io, "clicked : ");
                // try std.Io.File.stdout().writeStreamingAll(io, &text_label_buf);
                const path = std.mem.sliceTo(&text_label_buf, 0);
                try myfs.listdir(path, io, init.gpa);
            }
        }

        const end_micros = try win.end(.{});
        const wait_event_micros = win.waitTime(end_micros);
        interrupted = try backend.waitEventTimeout(wait_event_micros);
    }
}
