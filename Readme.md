#  [Z]ig [O]perating [S]ystem in 1,000 Lines 

## Links
- [Operating System in 1,000 Lines](https://operating-system-in-1000-lines.vercel.app/en/)
- [RISCV manual](https://riscv-software-src.github.io/riscv-unified-db/manual/html/isa/20240411/chapters/intro.html)
- [RISCV ratified specifications](https://riscv.org/specifications/ratified/)
- [OpenSBI specs](https://www.scs.stanford.edu/~zyedidia/docs/riscv/riscv-sbi.pdf)
- [Zig inline Assembly explained](https://github.com/ziglang/zig/blob/master/doc/langref/Assembly%20Syntax%20Explained.zig)
- [Zig SHOWTIME - Zig Livecoding OS in 1k lines of Zig!](https://www.youtube.com/live/eAM9ol7W2w8?si=ppRmLGOx6j1YUsol)

## Notes

- With some distributions you can see an error: `qemu-system-riscv32: Unable to load the RISC-V firmware "opensbi-riscv32-generic-fw_dynamic.bin"`
- To solve it copy the binary into the current directory: `curl -LO https://github.com/qemu/qemu/raw/v8.0.4/pc-bios/opensbi-riscv32-generic-fw_dynamic.bin`

### RISC-V
- RISC-V has three CPU modes:
  - M-mode: Machine Mode, highest privileged, OpenSBI operates in this mode
  - S-mode: Supervisor mode, kernel operates in this mode
  - U-mode: User mode. The least privileged one. For example manipulating CSR can not be done in this mode.

### ZIG
- Assembly:
   ```zig
   asm volatile(
      \\syscall
      : <output> // as [ret] "={x10}" (-> usize)
                 // - ret is the named to be used
                 // - the constraint string means "the result value of syscall is whatever is in $x10"
                 // - next is either a value binding or '->' and a type.
      : <inputs>
      : <clobbers> // declares registers that are not preserved during the execution of this assembly code
   ```

## Logs
- *27 Jan 2024*: starting the project
  - jump into *kernel_main*
  - check that PC looks good
  - implement *ecall* to interact with **SBI**
    - print a message on console using the EID 0x01 that is putchar 
  - add a writer to be able to use print from std.io.Writer
