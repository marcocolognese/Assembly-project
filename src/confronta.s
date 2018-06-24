.section .data

nuovo_ins:
	.ascii "Codice errato. Inserire nuovamente il codice (senza spazi)\n"
nuovo_ins_len:
	.long . - nuovo_ins

dinamic_ins:
	.ascii "Modalità controllo dinamico inserita\n"
dinamic_ins_len:
	.long . - dinamic_ins

safe_ins:
	.ascii "Modalità controllo emergenza inserita\n"
safe_ins_len:
	.long . - safe_ins

failure_ins:
	.ascii "Failure controllo codice. Modalità safe inserita\n"
failure_ins_len:
	.long . - failure_ins



.section .text
.global confronta

.type confronta, @function

confronta:

	movl $1, %edx	# EDX tiene il conto dei tentativi. 
	pushl %edx	# Parte da 1 perchè all'avvio del programma 
			# è già stato fatto un tentativo
	cmp $1, %ecx	# Uso ECX per capire se è già stato fatto un
	je codice_errato# errore per in numero di parametri inseriti

confronta_inserimento:

	cmp $332, %eax		# Verifico se i parametri inseriti
	je controllo_dinamico	# possono corrispondere ad una
	cmp $992, %eax		# modalita' di controllo
	je controllo_emergenza
	jmp codice_errato

controllo_emergenza:

	movl  $4, %eax  # Stampa il messaggio dell'inserimento
	movl  $1, %ebx	# della modalità "controllo di emergenza"
	leal  safe_ins, %ecx
	movl  safe_ins_len, %edx
	int   $0x80		# In caso di "controllo di emergenza"
	jmp fine_programma	# si chiude il programma

controllo_dinamico:

	movl  $4, %eax  # Stampa il messaggio dell'inserimento
	movl  $1, %ebx	# della modalità "controllo dinamico"
	leal  dinamic_ins, %ecx
	movl  dinamic_ins_len, %edx
	int   $0x80
	jmp fine	# Vado alla fine della funzione in modo da
			# permettere al programma di proseguire
			# la verifica dei passeggeri per la modalità
			# "controllo dinamico"

codice_errato:

	popl %edx
	cmp $3, %edx		# Se ho raggiunto i tre tentativi
	je failure		# viene dato tale messaggio
	inc %edx		# altrimenti incremento EDX
	pushl %edx
	movl $4, %eax		# Codice errato. Viene chiesto un
	movl $1, %ebx		# nuovo inserimento
	leal  nuovo_ins, %ecx
	movl  nuovo_ins_len, %edx
	int   $0x80

nuovo_inserimento:

	call tastiera	# Ricevo da tastiera un nuovo inserimento
	movl %eax, %ecx
	cmp $51, %ecx	# Confronto il primo valore se corrisponde
	je forse_dinamico	# a quello dinamico o emergenza
	cmp $57, %ecx
	je forse_emergenza
	jmp svuota_buffer	# Se non ho corrispondenze svuoto
				# il buffer della tastiera

forse_dinamico:

	call tastiera	# Se il primo valore corrisponde a quello
	movl %eax, %ebx	# dinamico, verifico che sia così anche
	cmp $51, %ebx	# per il secondo
	je ultimo_valore_dinamico
	jmp svuota_buffer	# Se non corrisponde svuoto il buffer

forse_emergenza:

	call tastiera	# Se il primo valore corrisponde a quello
	movl %eax, %ebx	# dinamico, verifico che sia così anche
	cmp $57, %ebx	# per il secondo
	je ultimo_valore_emergenza
	jmp svuota_buffer	# Se non corrisponde svuoto il buffer

ultimo_valore_dinamico:

	call tastiera	# Verifico che corrisponda anche l'ultimo
	cmp $50, %eax	# valore con quello dinamico
	je pressione_invio_dinamico
	jmp svuota_buffer	# Altrimenti svuoto il buffer

ultimo_valore_emergenza:

	call tastiera	# Verifico che corrisponda anche l'ultimo
	cmp $50, %eax	# valore con quello dinamico
	je pressione_invio_emergenza
	jmp svuota_buffer	# Altrimenti svuoto il buffer

pressione_invio_dinamico:

	call tastiera	# Verifico che non ci siano altri valori
	cmp $10, %eax	# altrimenti il codice non è corretto
	je controllo_dinamico
	jmp svuota_buffer	# Se ne trovo altri svuoto il buffer

pressione_invio_emergenza:

	call tastiera	# Verifico che non ci siano altri valori
	cmp $10, %eax	# altrimenti il codice non è corretto
	je controllo_emergenza
	jmp svuota_buffer	# Se ne trovo altri svuoto il buffer

svuota_buffer:

	call tastiera	# Leggo da tastiera fino all'invio in
	cmp $10, %eax	# modo da svuotare il buffer
	je codice_errato
	jmp svuota_buffer

failure:

	movl  $4, %eax  # Stampa il messaggio che indica il
	movl  $1, %ebx	# superamento dei 3 tentativi e il 
			# conseguente inserimento della modalità 
			# "controllo di emergenza" e uscita dal
			# programma.
	leal  failure_ins, %ecx
	movl  failure_ins_len, %edx
	int   $0x80
	jmp fine_programma

fine_programma:

	xorl %eax, %eax	# Blocco di codice per uscire dal programma.
	incl %eax	# 1 è il codice della exit.
	xorl %ebx, %ebx	# Azzero ebx (alla exit viene passato 0).
	int $0x80	# Invoca la funzione exit.

fine:
			# Ripristino dei registri salvati sullo 
			# stack. L'ordine delle pop è l'inverso 
			# delle push.
	popl %edx

	ret             # Fine della funzione confronta.
                  	# L'esecuzione riprende dall'istruzione 
			# sucessiva alla call che l'ha invocata.
