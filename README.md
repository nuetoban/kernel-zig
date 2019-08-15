## hobby kernel in zig

slowly porting from rust.

### features

 - vga frame buffer
 - ps2 keyboard driver
 - interrupts
 - terminal console
 - lspci

### dependencies

`zig` compiler

### compile

`zig build` compiles and links the multiboot kernel, without a bootloader.

### test

`./qemu.sh start`  
`./qemu.sh monitor`  
`./qemu.sh gdb`  

# Notes

## interrupts

`interrupt` -> `idt[n]` -> `isrN` -> `isrDispatch` -> `handlers[n]` (default `unhandled()`)

## layout

`0->4Mib` kernel reserved
`1Mib` interrupt stack
