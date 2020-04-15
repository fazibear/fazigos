/* ENTRY(x86_main) */
ENTRY(__start)

/* OUTPUT_FORMAT(elf32-i386) */

SECTIONS {
    /* lower half kernel <1MiB */
	. = 0x10000;

	/* ensure that the multiboot header is at the beginning */
	.multiboot :
	{
		/* KEEP otherwise it gets garbage collected by linker */
		KEEP(*(.multiboot))
		. = ALIGN(4K);
	}

	.text :
	{
		*(.text)
		. = ALIGN(4K);
	}

	.rodata :
	{
		*(.rodata)
		. = ALIGN(4K);
	}

	.data :
	{
		*(.data)
		. = ALIGN(4K);
	}

	.bss :
	{
		*(.bss)
		. = ALIGN(4K);
	}
}
