
CC=gcc
ERLC=erlc

CFLAGS+= -Wall -std=c99 -include stdbool.h
CFLAGS+= -I/usr/local/Cellar/erlang/17.3/lib/erlang/usr/include

LDFLAGS+= -lpcap
LDFLAGS+= /usr/local/Cellar/erlang/17.3/lib/erlang/usr/lib/libei.a 
LDFLAGS+= /usr/local/Cellar/erlang/17.3/lib/erlang/usr/lib/liberl_interface.a

SRC= send.c recv.c util.c pretty.c fflog.c 
OBJ= ${SRC:%.c=%.o}

BIN= capture console
NIF= pretty_nif.so

BEAM= ${NIF:%_nif.so=%.beam}

all: ${BIN} ${NIF} ${BEAM} install

install: ${NIF} ${BEAM}
	@cp  -v -f $^ ..


%_nif.so: ${OBJ} %_nif.c
	${CC} ${CFLAGS} ${LDFLAGS} -undefined dynamic_lookup -dynamiclib $^ -o $@


capture: ${OBJ} capture.o
	${CC} ${LDFLAGS} $^ -o $@

console: ${OBJ} console.o
	${CC} ${LDFLAGS} $^ -o $@

client: ${OBJ} client.o
	${CC} ${LDFLAGS} $^ -o $@



%.beam: %.erl
	${ERLC} $^
		
%.o: %.c
	${CC} ${CFLAGS} $^ -c -o $@

suid:
	sudo chown root:staff capture
	sudo chmod 4755 capture
	
clean:
	rm -f ${BIN} ${NIF} ./*.o ./*.beam core ../${NIF} ../${BEAM}

help:
	@echo "to build:"
	@echo "  make capture && make suid"

.PHONY: all clean suid help
	