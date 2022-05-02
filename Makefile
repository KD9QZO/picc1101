#
# Makefile
#
# This is the Makefile for the 'picc1101' project.
#

PROJ := picc1101


CROSS :=

CC      := $(CROSS)gcc
CXX     := $(CROSS)g++
#CPP    := $(CROSS)cpp
#LD     := $(CROSS)ld
#AS     := $(CROSS)as
AR      := $(CROSS)ar
NM      := $(CROSS)nm
READELF := $(CROSS)readelf
OBJCOPY := $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump
SIZE    := $(CROSS)size

#
# Make sure pkg-config is installed.
#
ifeq ($(shell pkg-config --version),)
	$(error FATAL ERROR: pkg-config is not installed)
endif

# Set the maximum verbosity level to build the project with [1..4]
MAX_VERBOSE_LEVEL := 4


DEFINES := -DMAX_VERBOSE_LEVEL=$(MAX_VERBOSE_LEVEL)


STDLVL := gnu11
OPTLVL := 2
DBGLVL := 2


MAPFILE  := $(PROJ).map


OBJS := main.o
OBJS += serial.o
OBJS += pi_cc_spi.o
OBJS += radio.o
OBJS += kiss.o
OBJS += util.o
OBJS += test.o


INCDIRS  := -I.


CFLAGS += -pipe
CFLAGS += -std=$(STDLVL)
CFLAGS += -O$(OPTLVL)
CFLAGS += -g$(DBGLVL)
CFLAGS += $(DEFINES)
CFLAGS += -Wall
CFLAGS += $(INCDIRS)

CPPFLAGS :=

CXXFLAGS :=

LDFLAGS += -Wl,-Map=$(MAPFILE)
LDFLAGS += -Wl,--cref
LDFLAGS  += -Wl,--relax

LIBS := -lm
LIBS += -lwiringPi






all:	$(PROJ)


%.o:	%.c *.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@


$(PROJ):	$(OBJS)
	$(CC) -g -o $@ $^ $(LDFLAGS) $(LIBS)
#	$(CCPREFIX)gcc $(LDFLAGS) -s -lm -lwiringPi -o picc1101 main.o serial.o pi_cc_spi.o radio.o kiss.o util.o test.o


#main.o: main.h main.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o main.o main.c

#serial.o: main.h serial.h serial.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o serial.o serial.c

#pi_cc_spi.o: main.h pi_cc_spi.h pi_cc_spi.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o pi_cc_spi.o pi_cc_spi.c

#radio.o: main.h radio.h radio.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o radio.o radio.c

#kiss.o: main.h kiss.h kiss.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o kiss.o kiss.c

#test.o: test.h test.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o test.o test.c

#util.o: util.h util.c
#	$(CCPREFIX)gcc $(CFLAGS) $(EXTRA_CFLAGS) -c -o util.o util.c


install:	$(PROJ)
	install -c -m 0755 -s $(PROJ) /usr/local/bin/$(PROJ)
	install -c -m 0755 -d /usr/local/share/$(PROJ)
	install -c -m 0644 README.md /usr/local/share/$(PROJ)/README.md

clean:
	rm -f *.o *.map $(PROJ)
