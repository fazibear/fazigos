pub inline fn lidt(idtr: usize) void {
    asm volatile ("lidt (%[idtr])"
        :
        : [idtr] "r" (idtr)
    );
}
