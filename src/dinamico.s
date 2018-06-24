.section .data

car:
	.byte 0		# Variabile utilizzata per andare a capo
tot:
	.long 0		# Variabile che indica il totale dei 				# passeggeri
tot_somma:		# La variabile indica la somma dei passeggeri
	.long 0		# delle varie file
x:			# Variabile per i bias
	.long 0
y:			# Variabile per i bias
	.long 0
z:			# Variabile per i bias
	.long 0
bias1:			# Variabile che contiene il valore del bias1
	.long 0
bias2:			# Variabile che contiene il valore del bias2
	.long 0
bias3:			# Variabile che contiene il valore del bias3
	.long 0
bias4:			# Variabile che contiene il valore del bias4
	.long 0
print_bias1:
	.ascii "Bias_flap1: "
print_bias1_len:
	.long . - print_bias1
print_bias2:
	.ascii "Bias_flap2: "
print_bias2_len:
	.long . - print_bias2
print_bias3:
	.ascii "Bias_flap3: "
print_bias3_len:
	.long . - print_bias3
print_bias4:
	.ascii "Bias_flap4: "
print_bias4_len:
	.long . - print_bias4
meno:			# Variabile utilizzata per l'operatore "-"
	.ascii "-"
meno_len:
	.long . - meno
resto_divisione:	# Variabile utilizzata per il resto della
	.ascii ".5"	# divisione per 2
resto_divisione_len:
	.long . - resto_divisione

tot_ins:
	.ascii "Inserire il numero totale dei passeggeri a bordo\n"
tot_ins_len:
	.long . - tot_ins

fila_a_ins:
	.ascii "Inserire il numero totale passeggeri della fila A\n"
fila_a_ins_len:
	.long . - fila_a_ins

fila_b_ins:
	.ascii "Inserire il numero totale passeggeri della fila B\n"
fila_b_ins_len:
	.long . - fila_b_ins

fila_c_ins:
	.ascii "Inserire il numero totale passeggeri della fila C\n"
fila_c_ins_len:
	.long . - fila_c_ins

fila_d_ins:
	.ascii "Inserire il numero totale passeggeri della fila D\n"
fila_d_ins_len:
	.long . - fila_d_ins

fila_e_ins:
	.ascii "Inserire il numero totale passeggeri della fila E\n"
fila_e_ins_len:
	.long . - fila_e_ins

fila_f_ins:
	.ascii "Inserire il numero totale passeggeri della fila F\n"
fila_f_ins_len:
	.long . - fila_f_ins

errore_tot:
	.ascii "Somma totali file diverso da totale passeggeri\n"
errore_tot_len:
	.long . - errore_tot

failure_ins:
	.ascii "Failure controllo passeggeri. Modalità safe inserita\n"
failure_ins_len:
	.long . - failure_ins

troppi_pass:
	.ascii "Troppi passeggeri (max 180)\n"
troppi_pass_len:
	.long . - troppi_pass

troppi_fila:
	.ascii "Troppi passeggeri nella fila (max 30)\n"
troppi_fila_len:
	.long . - troppi_fila



.section .text
.global dinamico

.type dinamico, @function

dinamico:

	movl $1, %edx	# EDX conta i tentativi, siamo al primo
	pushl %edx	# Salvo il valore

ins_tot:

    	movl  $4, %eax		# Messaggio per l'inserimento
	movl  $1, %ebx		# del numero totale di passeggeri
	leal  tot_ins, %ecx
	movl  tot_ins_len, %edx
	int   $0x80

inizio:

	xorl %eax, %eax		# Azzero EAX

lettura_totale:

	movl %eax, %edx		# Leggo il valore fino all'invio
	call tastiera
	cmp $10, %eax
	je fila_a

	subl $48, %eax		# Il carattere è in codice ASCII
	xchgl %eax, %edx	# e va modificato
	pushl %edx
	movl $10, %ebx
	mull %ebx
	popl %edx
	addl %edx, %eax
	jmp lettura_totale

fila_a:

	cmp $180, %edx
	jg troppi_passeggeri

	movl %edx, tot	# salvo il totale dei passeggeri su una
			# variabile
	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# del dei passeggeri della fila A
	leal  fila_a_ins, %ecx
	movl  fila_a_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_a:

	movl %eax, %edx		# Leggo il valore fino all'invio
	call tastiera
	cmp $10, %eax
	je fila_b

	subl $48, %eax		# Il carattere è in codice ASCII
	xchgl %eax, %edx	# e va modificato
	pushl %edx
	movl $10, %ebx
	mull %ebx
	popl %edx
	addl %edx, %eax
	jmp lettura_fila_a

fila_b:

	cmp $30, %edx		# Verifico di non avere più di 30
	jg troppi_nella_fila	# passeggeri nella fila

	movl %edx, tot_somma	# Mettiamo la fila A nella variabile
				# per la somma dei passeggeri delle
				# varie file
	movl %edx, x		# Salvo in X il valore
	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# del dei passeggeri della fila B
	leal  fila_b_ins, %ecx
	movl  fila_b_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_b:

	movl %eax, %ecx		# Leggo il valore fino all'invio
	call tastiera
	cmp $10, %eax
	je fila_c

	subl $48, %eax		# Il carattere è in codice ASCII
	xchgl %eax, %ecx	# e va modificato
	pushl %ecx
	movl $10, %ebx
	mull %ebx
	popl %ecx
	addl %ecx, %eax
	jmp lettura_fila_b

fila_c:

	cmp $30, %ecx		# Verifico di non avere più di 30
	jg troppi_nella_fila	# passeggeri nella fila

	addl %ecx, tot_somma
	movl %ecx, y		# Salvo in Y il valore

	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# del dei passeggeri della fila E
	leal  fila_c_ins, %ecx
	movl  fila_c_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_c:

	movl %eax, %ecx
	call tastiera
	cmp $10, %eax
	je fila_d

	subl $48, %eax
	xchgl %eax, %ecx
	pushl %ecx
	movl $10, %ebx
	mull %ebx
	popl %ecx
	addl %ecx, %eax
	jmp lettura_fila_c

fila_d:

	cmp $30, %ecx
	jg troppi_nella_fila

	addl %ecx, tot_somma
	movl %ecx, z		# Salvo in Z il valore

	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# del dei passeggeri della fila E
	leal  fila_d_ins, %ecx
	movl  fila_d_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_d:

	movl %eax, %ebx
	call tastiera
	cmp $10, %eax
	je fila_e

	subl $48, %eax
	xchgl %eax, %ebx
	pushl %ebx
	movl $10, %ebx
	mull %ebx
	popl %ebx
	addl %ebx, %eax
	jmp lettura_fila_d

fila_e:

	cmp $30, %ebx
	jg troppi_nella_fila

	addl %ebx, tot_somma
	subl %ebx, z	# ho calcolato Z per i bias su una variabile

	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# del dei passeggeri della fila E
	leal  fila_e_ins, %ecx
	movl  fila_e_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_e:

	movl %eax, %ebx		# Leggo il valore fino all'invio
	call tastiera
	cmp $10, %eax
	je fila_f

	subl $48, %eax		# Il carattere è in codice ASCII
	xchgl %eax, %ebx	# e va modificato
	pushl %ebx
	movl $10, %ebx
	mull %ebx
	popl %ebx
	addl %ebx, %eax
	jmp lettura_fila_e

fila_f:

	cmp $30, %ebx
	jg troppi_nella_fila

	addl %ebx, tot_somma
	subl %ebx, y	# ho calcolato Y per i bias su una variabile

	movl  $4, %eax  # Stampa il messaggio per l'inserimento
	movl  $1, %ebx	# dei passeggeri della fila F
	leal  fila_f_ins, %ecx
	movl  fila_f_ins_len, %edx
	int   $0x80

	xorl %eax, %eax

lettura_fila_f:

	movl %eax, %ebx		# Leggo il valore fino all'invio
	call tastiera
	cmp $10, %eax
	je verifica_totale

	subl $48, %eax		# Il carattere è in codice ASCII
	xchgl %eax, %ebx	# e va modificato
	pushl %ebx
	movl $10, %ebx
	mull %ebx
	popl %ebx
	addl %ebx, %eax
	jmp lettura_fila_f

verifica_totale:

	cmp $30, %ebx		# Verifico di non avere più di 30
	jg troppi_nella_fila	# passeggeri nella fila

	subl %ebx, x	# ho calcolato X per i bias su una variabile
	addl %ebx, tot_somma	# aggiungo alla variabile della somma

	movl tot, %eax
	cmp %eax, tot_somma	# Verifico che il totale dei
	jne errore		# passeggeri inserito corrisponda al
				# totale dei passeggeri delle file
	jmp calcolo_primo_bias

errore:

	popl %edx	# Verifico di avere tentativi a disposizione
	cmp $3, %edx
	je failure

	inc %edx	# Si incrementano i tentativi
	pushl %edx

	movl  $4, %eax  # Stampa il messaggio di errore per il totale
	movl  $1, %ebx
	leal  errore_tot, %ecx
	movl  errore_tot_len, %edx
	int   $0x80

	jmp ins_tot	# Ricomincia l'inserimento

troppi_passeggeri:

	movl  $4, %eax  # Stampa il messaggio per l'eccesso di
	movl  $1, %ebx	# passeggeri (max 180)
	leal  troppi_pass, %ecx
	movl  troppi_pass_len, %edx
	int   $0x80

	popl %edx
	cmp $3, %edx
	je failure

	inc %edx
	pushl %edx

	jmp ins_tot

troppi_nella_fila:

	movl  $4, %eax  # Stampa il messaggio per l'eccesso di
	movl  $1, %ebx	# passeggeri in una fila (max 30)
	leal  troppi_fila, %ecx
	movl  troppi_fila_len, %edx
	int   $0x80

	popl %edx	# Verifico di avere tentativi a disposizione
	cmp $3, %edx
	je failure

	inc %edx	# Incremento i tentativi
	pushl %edx

	jmp ins_tot

failure:

	movl  $4, %eax  # Stampa il messaggio di superamento
	movl  $1, %ebx	# del limite di tentativi
	leal  failure_ins, %ecx
	movl  failure_ins_len, %edx
	int   $0x80
	jmp fine	# Esce dalla funzione

calcolo_primo_bias:

	movl  $4, %eax	# Messaggio per la stampa di "bias_flap1"
	movl  $1, %ebx
	leal  print_bias1, %ecx
	movl  print_bias1_len, %edx
	int   $0x80

	movl $3, %ecx	# Costante k1
	movl x, %eax
	imull %ecx	# moltiplico k1 per X (imull perchè X può
	movl $2, %ebx	# essere un valore negativo)
	idivl %ebx	# Divido il risultato per 2
	pushl %edx	# Salvo il resto 2 volte sullo stack per
	pushl %edx	# controllarlo al bias1 e al bias4

	movl %eax, bias1 # Carico il risultato nella variabile
			# del primo bias
	movl $6, %ecx	# Costante k2
	movl y, %eax
	imull %ecx	# moltiplico k1 per Y
	movl $2, %ebx	# moltiplico k1 per X (imull perchè Y può
			# essere un valore negativo)
	idivl %ebx	# Divido il risultato per 2

	addl %eax, bias1 # Ho calcolato il primo bias
	movl bias1, %eax
	cmp $0, %eax
	jl primo_bias_negativo	# Verifico se il primo bias è 
				# negativo
	call itoa	# Se non lo è, stampo il bias

	popl %edx
	cmp $0, %edx	# Se la divisione ha resto lo stampo a video
	je calcolo_secondo_bias

	movl  $4, %eax  # Stampa il resto della divisione
	movl  $1, %ebx
	leal  resto_divisione, %ecx
	movl  resto_divisione_len, %edx
	int   $0x80

	jmp calcolo_secondo_bias

primo_bias_negativo:

	movl  $4, %eax  # Stampa il "-" perchè è un valore negativo
	movl  $1, %ebx
	leal  meno, %ecx
	movl  meno_len, %edx
	int   $0x80

	movl bias1, %eax
	movl $-1, %ebx	# Moltiplico il bias per -1 perchè non posso
	imul %ebx	# stampare un negativo con itoa
	call itoa	# Stampo primo bias negato dal "-" precedente

	popl %edx	# Se la divisione ha resto lo stampo a video
	cmp $0, %edx
	je calcolo_secondo_bias

	movl  $4, %eax  # Stampa il resto della divisione
	movl  $1, %ebx
	leal  resto_divisione, %ecx
	movl  resto_divisione_len, %edx
	int   $0x80

calcolo_secondo_bias:

	movb  $10, car  # Copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga.
	movl  $1, %ebx	# Solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80

	movl  $4, %eax	# Messaggio per la stampa di "bias_flap2"
	movl  $1, %ebx
	leal  print_bias2, %ecx
	movl  print_bias2_len, %edx
	int   $0x80

	movl $6, %ecx	# Costante k2
	movl y, %eax
	imull %ecx	# moltiplico k2 per Y
	movl $2, %ebx
	idivl %ebx	# Divido il risultato per 2

	movl %eax, bias2

	movl $12, %ecx	# Costante k3
	movl z, %eax
	imull %ecx	# moltiplico k3 per Z
	movl $2, %ebx
	idivl %ebx	# Divido il risultato per 2

	addl %eax, bias2 # Ho calcolato il secondo bias
	movl bias2, %eax

	cmp $0, %eax
	jl secondo_bias_negativo
	call itoa	# Stampo il bias se è positivo

	movb  $10, car  # copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga
	movl  $1, %ebx	# solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80

	jmp calcolo_terzo_bias

secondo_bias_negativo:

	movl  $4, %eax  # Stampa il "-" perchè è un valore negativo
	movl  $1, %ebx
	leal  meno, %ecx
	movl  meno_len, %edx
	int   $0x80

	movl bias2, %eax
	movl $-1, %ebx	# lo rendo positivo per la stampa
	imul %ebx
	call itoa	# Stampo il primo bias negato

	movb  $10, car  # copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga
	movl  $1, %ebx	# solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80

calcolo_terzo_bias:

	movl  $4, %eax	# Messaggio per la stampa di "bias_flap3"
	movl  $1, %ebx
	leal  print_bias3, %ecx
	movl  print_bias3_len, %edx
	int   $0x80

	cmp $0, bias2	# Il terzo bias è l'opposto del secondo
	jg terzo_bias_negativo

	movl bias2, %eax
	movl $-1, %ebx
	imul %ebx
	call itoa	# Stampo il primo bias negato

	movb  $10, car  # copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga
	movl  $1, %ebx	# solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80

	jmp calcolo_quarto_bias

terzo_bias_negativo:

	movl  $4, %eax  # Stampa il "-" perchè è un valore negativo
	movl  $1, %ebx
	leal  meno, %ecx
	movl  meno_len, %edx
	int   $0x80

	movl bias2, %eax
	call itoa	# Stampo il primo bias negato

	movb  $10, car  # copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga
	movl  $1, %ebx	# solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80

calcolo_quarto_bias:

	movl  $4, %eax	# Messaggio per la stampa di "bias_flap4"
	movl  $1, %ebx
	leal  print_bias4, %ecx
	movl  print_bias4_len, %edx
	int   $0x80

	cmp $0, bias1
	jg quarto_bias_negativo

	movl bias1, %eax
	movl $-1, %ebx	# Il quarto bias è l'opposto del primo
	imul %ebx
	call itoa	# Stampo il primo bias negato

	popl %edx
	cmp $0, %edx	# Se la divisione ha resto lo stampo a video
	je fine

	movl  $4, %eax  # Stampa il resto della divisione
	movl  $1, %ebx
	leal  resto_divisione, %ecx
	movl  resto_divisione_len, %edx
	int   $0x80

	jmp fine

quarto_bias_negativo:

	movl  $4, %eax  # Stampa il "-" perchè è un valore negativo
	movl  $1, %ebx
	leal  meno, %ecx
	movl  meno_len, %edx
	int   $0x80

	movl bias1, %eax
	call itoa	# Stampo il primo bias negato

	popl %edx	# Se la divisione ha resto lo stampo a video
	cmp $0, %edx
	je fine

	movl  $4, %eax  # Stampa il resto della divisione
	movl  $1, %ebx
	leal  resto_divisione, %ecx
	movl  resto_divisione_len, %edx
	int   $0x80

fine:

	movb  $10, car  # Copia nella variabile car il codice ascii 
	movl  $4, %eax  # del carattere per andare a capo riga.
	movl  $1, %ebx	# Solito blocco di istruzioni per la stampa
	leal  car, %ecx
	mov   $1, %edx
	int   $0x80
			# Ripristino dei registri salvati sullo 
			# stack. L'ordine delle pop è l'inverso 
	popl %edx	# delle push.

	ret             # Fine della funzione confronta.
                  	# L'esecuzione riprende dall'istruzione 
			# sucessiva alla call che l'ha invocata.
