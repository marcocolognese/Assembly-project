### MAKEFILE ###

EXE = run
AS = as
LD = ld
FLAGS = -gstabs

OBJ = progetto.o atoi.o itoa.o tastiera.o confronta.o dinamico.o

all: $(EXE)

clean:
	rm -f *.o *% core $(EXE)

install: $(EXE)
	cp $(EXE) /usr/bin/

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ) -melf_i386

progetto.o : progetto.s
	$(AS) $(FLAGS) -o progetto.o progetto.s --32

atoi.o : atoi.s
	$(AS) $(FLAGS) -o atoi.o atoi.s --32

itoa.o : itoa.s
	$(AS) $(FLAGS) -o itoa.o itoa.s --32

tastiera.o : tastiera.s
	$(AS) $(FLAGS) -o tastiera.o tastiera.s --32

confronta.o : confronta.s
	$(AS) $(FLAGS) -o confronta.o confronta.s --32

dinamico.o : dinamico.s
	$(AS) $(FLAGS) -o dinamico.o dinamico.s --32
