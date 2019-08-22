usingnamespace @import("index.zig");

var command: [10]u8 = undefined;
var command_len: usize = 0;

fn execute(com: []u8) void {
    if (@import("std").mem.eql(u8, com, "lspci")) pci.lspci();
    if (@import("std").mem.eql(u8, com, "paging")) x86.paging.addrspace();
}

pub fn keypress(char: u8) void {
    // this is a custom "readline" capped at 10 characters
    switch (char) {
        '\n' => {
            print("\n");
            execute(command[0..command_len]);
            print("> ");
            command_len = 0;
        },
        '\x08' => return, //backspace
        '\x00' => return,
        else => {
            // general case
            if (command_len == 10) return;
            vga.writeChar(char);
            command[command_len] = char;
            command_len += 1;
        },
    }
}

pub fn initialize() void {
    x86.interrupt.registerIRQ(1, ps2.keyboard_handler);
    print("> ");
}
