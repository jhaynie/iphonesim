CC=gcc

SIM_PRIVATE_FRAMEWORK_DIR=/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/PrivateFrameworks
CFLAGS=-Wall -Werror -I. -ISource
LDFLAGS=-framework AppKit -F${SIM_PRIVATE_FRAMEWORK_DIR} -framework iPhoneSimulatorRemoteClient -Wl,-rpath -Wl,${SIM_PRIVATE_FRAMEWORK_DIR}
OBJS= \
	Source/main.o \
	Source/nsprintf.o \
	Source/iPhoneSimulator.o

.SUFFIXES: .m
.m.o:
	${CC} ${CFLAGS} -c $< -o $@

all: iphonesim

iphonesim: ${OBJS}
	${CC} -o $@ ${OBJS} ${LDFLAGS}

clean:
	rm -f ${OBJS} iphonesim
