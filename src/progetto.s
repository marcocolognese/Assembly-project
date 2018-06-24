.section .text

.global _start

.align 4

_start:

	pop %eax		# Verifico quanti argomenti sono stati
	cmp $4, %eax		# inseriti da riga di comando.
	jne confronto_codice

fetch_parametro:
				# Eseguo 1 pop a vuoto per arrivare
				# a poter estrarre direttamente i 
	pop %eax		# parametri che mi interessano

	pop %eax		# Leggo il primo parametro
    	call atoi
	movl %eax, %ecx		# Sposto il primo parametro in ecx

	pop %eax		# Leggo il secondo parametro
	call atoi
	xchgl %eax, %ecx	# Ho il primo parametro in eax e il 
				# secondo in ecx

	movl  $10, %ebx
	pushl %edx
	mull  %ebx		# eax = eax * 10
	popl %edx
	xorl  %ebx, %ebx
	addl %ecx, %eax		# eax = eax + ecx
	movl %eax, %ecx		# sposto il valore in ecx	

	pop %eax		# Leggo il terzo parametro
	call atoi
	xchgl %eax, %ecx

	movl  $10, %ebx
	pushl %edx
	mull  %ebx		# eax = eax * 10
	popl %edx
	xorl  %ebx, %ebx
	addl %ecx, %eax		# eax = eax + ecx
				# In EAX ho il codice inserito 
				# dall'utente. Non è diviso in 3 
				# registri
	xorl %ecx, %ecx		# Azzero ECX che indica se c'era stato
				# un errore nell'inserimento dei
				# parametri.
	call confronta		# Confronto i parametri

	call dinamico		# A questo punto del programma ci si
				# può arrivare solamente se ci si
				# trova nella modalità di controllo
				# dinamico. Negli altri casi l'uscita
				# dal programma sarebbe avvenuta
				# nella funzione "confronta"

	jmp fine		# Salto alla fine del programma perchè
				# il codice successivo si utilizza
				# solamento in caso di errore
				# nell'inserimento dei parametri

confronto_codice:

	movl $1, %ecx		# Metto a 1 ECX che indica l'errore
	call confronta		# commesso nell'inserimento dei
				# parametri


	call dinamico		# A questo punto del programma ci si
				# può arrivare solamente se ci si
				# trova nella modalità di controllo
				# dinamico. Negli altri casi l'uscita
				# dal programma sarebbe avvenuta
				# nella funzione "confronta"

fine:

	xorl %eax, %eax
	incl %eax		# 1 è il codice della exit
	xorl %ebx, %ebx		# azzero ebx (alla exit si passa 0)
	int $0x80		# invoca la funzione exit
