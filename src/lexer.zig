const std = @import("std");

pub fn markupCode(char: u8) Kind {
    if (char == '#') {
        return Kind.h1;
    } else if (char == '>') {
        return Kind.blockquote;
    } else {
        return Kind.p;
    }
}

pub const Kind = enum { h1, h2, h3, h4, h5, p, li, blockquote, l_wikilink, r_wikilink };

pub fn main() void {
    const wikiText: []const u8 =
        \\# Headding
        \\Paragraph goes here
        \\This is a [[wikilink]] embedded in a sentence
        \\This transcludes a section ![[another-page#heading-title]]
        \\Lets do list now
        \\- one
        \\- two
        \\- three
        \\now a blockquote
        \\> Who goes there - Albert Einstein
        \\now an admonition
        \\> [!NOTE]
        \\> A noteworthy text can go here.
    ;

    std.debug.print("hi \n", .{});
    std.debug.print("------------------------- \n", .{});
    // std.debug.print(wikiText, .{});
    // std.debug.print("\n------------------------- \n", .{});

    var block_count: u8 = 0;
    // var tokens: [2000]Kind = Kind.p;
    var tokens = [_]Kind{Kind.p} ** 2000;
    var t_ix: u32 = 0;

    for (wikiText) |char| {
        // std.debug.print("{c}", .{char});

        if (char == '\n') {
            block_count += 1;
        }

        tokens[t_ix] = markupCode(char);

        t_ix += 1;
    }

    std.debug.print("Block Count : {d} \n", .{block_count});

    for (tokens) |token| {
        // std.debug.print("token ; {t} \n", .{token});
        if (token == Kind.l_wikilink) {
            std.debug.print("found wikilink", .{});
        }
    }
}
