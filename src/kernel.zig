// [*]u8 is a pointer to a slice of u8 value with unknown length
// ie it is just a pointer to a memory location of the first element
// of the buffer
const bss = @extern([*]u8, .{ .name = "__bss" });
const bss_end = @extern([*]u8, .{ .name = "__bss_end" });
const stack_top = @extern([*]u8, .{ .name = "__stack_top" });

export fn kernel_main() noreturn {
    // BSS contains read/write data with an initial value of zero
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss);
    const bss_slice = bss[0..bss_len];
    @memset(bss_slice, 0);
    while (true)
        asm volatile ("");
}

export fn boot() linksection(".text.boot") callconv(.Naked) void {
    asm volatile (
        \\mv sp, %[stack_top]
        \\j kernel_main
        :
        : [stack_top] "r" (stack_top),
    );
}
