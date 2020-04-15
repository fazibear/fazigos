.global __start
.type __start, @function

__start:
  # assign current stack pointer location to stack_top
  mov $0x80000, %esp

  # call the kernel main source
  call kmain

  cli

# put system in infinite loop
sti_loop:
  sti
  jmp sti_loop
