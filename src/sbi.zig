const io = @import("std").io;

// An ECALL is used as the control transfer instruction between the supervisor and the SEE.
// - a7 encodes the SBI extension ID (EID),
// - a6 encodes the SBI function ID (FID) for a given extension ID encoded in a7 for any SBI extension defined in or after SBI v0.2.
// - All registers except a0 & a1 must be preserved across an SBI call by the callee.
//  SBI functions must return a pair of values in a0 and a1, with a0 returning an error code. This is
// analogous to returning the C structure
// struct sbiRet {
//   long error;
//   long value;
// }
const SbiRet = struct {
    err: usize,
    val: usize,
};

const ExtensionId = enum(u8) {
    putchar = 1,
};

fn putchar(ch: u8) void {
    // TODO: check the return value
    _ = call(ch, 0, 0, 0, 0, 0, 0, @intFromEnum(ExtensionId.putchar));
}

fn write_fn(context: *const anyopaque, bytes: []const u8) !usize {
    _ = context;
    for (bytes) |byte| {
        putchar(byte);
    }
    return bytes.len;
}

// https://ziglang.org/documentation/master/std/#std.io.Reader
pub const console = io.AnyWriter{
    .context = undefined,
    .writeFn = write_fn,
};

fn call(arg0: usize, arg1: usize, arg2: usize, arg3: usize, arg4: usize, arg5: usize, arg6: usize, arg7: usize) SbiRet {
    var err: usize = undefined;
    var val: usize = undefined;

    asm volatile (
        \\ecall
        : [err] "={a0}" (err),
          [val] "={a1}" (val),
        : [arg0] "{a0}" (arg0),
          [arg1] "{a1}" (arg1),
          [arg2] "{a2}" (arg2),
          [arg3] "{a3}" (arg3),
          [arg4] "{a4}" (arg4),
          [arg5] "{a5}" (arg5),
          [arg6] "{a6}" (arg6),
          [arg7] "{a7}" (arg7),
        : "memory"
    );

    return SbiRet{
        .err = err,
        .val = val,
    };
}
