const std = @import("std");
const dvui = @import("dvui");

pub const dvui_app: dvui.App = .{
    .config = .{ .options = .{ .size = .{ .w = 400.0, .h = 300.0 }, .title = "Wiki" } },
    .initFn = appInit,
    .frameFn = appFrame,
    .deinitFn = appDeinit,
};
pub const main = dvui.App.main;
pub const panic = dvui.App.panic;
pub const std_options: std.Options = .{
    .logFn = dvui.App.logFn,
};

fn appInit(win: *dvui.Window) !void {
    _ = win;
}

fn appFrame() !dvui.App.Result {
    var vbox = dvui.box(@src(), .{ .dir = .vertical }, .{ .expand = .both });
    defer vbox.deinit();

    dvui.label(@src(), "Hello World", .{}, .{});

    if (dvui.button(@src(), "List Files", .{}, .{})) {
        // std.log.info("clicked");
    }

    return .ok;
}

fn appDeinit(win: *dvui.Window) void {
    _ = win;
}
