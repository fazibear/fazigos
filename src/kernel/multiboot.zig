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

pub const Info = packed struct {
    // Multiboot info version number.
    flags: u32,

    // Available memory from BIOS.
    // present if flags[0]
    mem_lower: u32,
    mem_upper: u32,

    // present if flags[1]
    boot_device: u32,

    // present if flags[2]
    cmdline: u32,

    // Boot-Module list.
    mods_count: u32,
    mods_addr: u32,

    syms: extern union {
        // present if flags[4]
        nlist: extern struct {
            tabsize: u32,
            strsize: u32,
            addr: u32,
            _reserved: u32,
        },
        // present if flags[5]
        shdr: extern struct {
            num: u32,
            size: u32,
            addr: u32,
            shndx: u32,
        },
    },

    // Memory Mapping buffer.
    // present if flags[6]
    mmap_length: u32,
    mmap_addr: u32,

    // Drive Info buffer.
    drives_length: u32,
    drives_addr: u32,

    // ROM configuration table.
    config_table: u32,

    // Boot Loader Name.
    boot_loader_name: u32,

    // APM table.
    apm_table: u32,

    // Video.
    vbe_control_info: u32,
    vbe_mode_info: u32,
    vbe_mode: u16,
    vbe_interface_seg: u16,
    vbe_interface_off: u16,
    vbe_interface_len: u16,
};
