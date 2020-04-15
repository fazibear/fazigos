const MAGIC = @as(u32, 0x1BADB002); // multiboot magic
const ALIGN = @as(u32, 1 << 0); // Align loaded modules at 4k
const MEMINFO = @as(u32, 1 << 1); // Receive a memory map from the bootloader.
const ADDR = @as(u32, 1 << 16); // Load specific addr
const FLAGS = ALIGN | MEMINFO; // Combine the flags.
const CHECKSUM = ~(MAGIC +% FLAGS) +% 1;

pub const Header = packed struct {
    magic: u32 = MAGIC, // Must be equal to header magic number.
    flags: u32 = FLAGS, // Feature flags.
    checksum: u32 = CHECKSUM, // Above fields plus this one must equal 0 mod 2^32.
    // following fields are used if flag bit 16 is specified
    header_addr: u32 = 0,
    load_addr: u32 = 0,
    load_end_addr: u32 = 0,
    bss_end_addr: u32 = 0,
    entry_addr: u32 = 0,
};
