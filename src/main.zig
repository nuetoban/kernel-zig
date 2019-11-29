usingnamespace @import("kernel");

// Place the header at the very beginning of the binary.
export const multiboot_header align(4) linksection(".multiboot") = multiboot: {
    const MAGIC = u32(0x1BADB002); // multiboot magic
    const ALIGN = u32(1 << 0); // Align loaded modules at 4k
    const MEMINFO = u32(1 << 1); // Receive a memory map from the bootloader.
    const ADDR = u32(1 << 16); // Load specific addr
    const FLAGS = ALIGN | MEMINFO; // Combine the flags.

    break :multiboot multiboot.MultibootHeader{
        .magic = MAGIC,
        .flags = FLAGS,
        .checksum = ~(MAGIC +% FLAGS) +% 1,
    };
};

extern fn switch_tasks(stack: u32) void;

// arch independant initialization
export fn kmain(magic: u32, info: *const multiboot.MultibootInfo) noreturn {
    assert(magic == multiboot.MULTIBOOT_BOOTLOADER_MAGIC);
    clear();
    println("--- x86 initialization ---");
    x86.x86_main(info);
    println("--- core initialization ---");
    pci.scan();
    vmem.initialize();

    // var a = vmem.allocate(u32) catch unreachable;
    // println("a={}", &a);
    // const b = vmem.allocate(VGAEntry) catch unreachable;
    // println("b={x}", &b);

    const t = task.Task.new(@ptrToInt(topbar)) catch unreachable;
    println("task={x}", &t);

    console.initialize();

    while (true) asm volatile ("hlt");
}
