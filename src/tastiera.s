.section .data

car:
	.byte 0		# Variabile car di tipo byte

.section .text
.global tastiera

.type tastiera, @function

tastiera:

	pushl %ebx	# Salvo i registri
	pushl %ecx
	pushl %edx
	xorl %eax, %eax

inizio:

	movl $3, %eax	# Leggo un solo carattere da tastiera
	xorl %ebx, %ebx
	leal car, %ecx
	movl $1, %edx
	int $0x80

	movb car, %eax	# Sposto il carattere in EAX

fine:

	popl %edx	# Recupero i registri dallo stack
	popl %ecx
	popl %ebx

	ret
