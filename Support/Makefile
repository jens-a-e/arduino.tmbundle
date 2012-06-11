# Arduino 0021 Makefile
# Arduino adaptation by mellis, eighthave, oli.keller, pyrou
#
# This makefile allows you to build sketches from the command line
# without the Arduino environment (or Java).
#
# Detailed instructions for using the makefile:
#
#  1. Copy this file into the folder with your sketch. There should be a
#     file with the same name as the folder and with the extension .pde
#     (e.g. foo.pde in the foo/ folder).
#
#  2. Modify the line containg "INSTALL_DIR" to point to the directory that
#     contains the Arduino installation (for example, under Mac OS X, this
#     might be /Applications/Arduino.app).
#
#  3. Modify the line containing "PORT" to refer to the filename
#     representing the USB or serial connection to your Arduino board
#     (e.g. PORT = /dev/tty.USB0).  If the exact name of this file
#     changes, you can use * as a wildcard (e.g. PORT = /dev/tty.usb*).
#
#  4. Set the line containing "MCU" to match your board's processor.
#     Older one's are atmega8 based, newer ones like Arduino Mini, Bluetooth
#     or Diecimila have the atmega168.  If you're using a LilyPad Arduino,
#     change F_CPU to 8000000.
#
#  5. At the command line, change to the directory containing your
#     program's file and the makefile.
#
#  6. Type "make" and press enter to compile/verify your program.
#
#  7. Type "make upload", reset your Arduino board, and press enter to
#     upload your program to the Arduino board.
#
# $Id$


# Default Environment vars
# can be overridden

ARDUINO_PORT               ?= /dev/tty.usbmodem*
ARDUINO_UPLOAD_RATE        ?= 115200
ARDUINO_AVRDUDE_PROGRAMMER ?= arduino
ARDUINO_MCU                ?= atmega328p
#ARDUINO_MCU ?= atmega168
ARDUINO_F_CPU              ?= 16000000
# can be standard, micro, mega, leonardo, eightanaloginputs
ARDUINO_VARIANT            ?= standard


TARGET      = $(notdir $(CURDIR))
BUILD_DIR   = "$(CURDIR)/build"
INSTALL_DIR = /Applications/Arduino.app/Contents/Resources/Java
UPLOAD_RATE = 		$(ARDUINO_UPLOAD_RATE)
PORT = 			$(ARDUINO_PORT)
AVRDUDE_PROGRAMMER = 	$(ARDUINO_AVRDUDE_PROGRAMMER)
MCU = 			$(ARDUINO_MCU)
F_CPU = 		$(ARDUINO_F_CPU)

############################################################################
# Below here nothing should be changed...

VERSION=100

# =============
# = Bin Paths =
# =============
ARDUINO = $(INSTALL_DIR)/hardware/arduino/cores/arduino
AVR_TOOLS_PATH = $(INSTALL_DIR)/hardware/tools/avr/bin
# AVR_TOOLS_PATH = /usr/bin
AVRDUDE_PATH = $(INSTALL_DIR)/hardware/tools/avr/bin

# ==================================
# = Comport Settings & Flash Paths =
# ==================================
# Programming support using avrdude. Settings and variables.
AVRDUDE_PORT = $(PORT)
AVRDUDE_WRITE_FLASH = -U flash:w:build/$(TARGET).hex


# ================
# = Source Files =
# ================
C_MODULES =  \
$(ARDUINO)/wiring_pulse.c \
$(ARDUINO)/wiring_analog.c \
$(ARDUINO)/wiring.c \
$(ARDUINO)/wiring_digital.c \
$(ARDUINO)/WInterrupts.c \
$(ARDUINO)/wiring_shift.c \

CXX_MODULES = \
$(ARDUINO)/Tone.cpp \
$(ARDUINO)/main.cpp \
$(ARDUINO)/new.cpp \
$(ARDUINO)/WMath.cpp \
$(ARDUINO)/Print.cpp \
$(ARDUINO)/Stream.cpp \
$(ARDUINO)/WString.cpp \
$(ARDUINO)/IPAddress.cpp \
$(ARDUINO)/USBCore.cpp \
$(ARDUINO)/HardwareSerial.cpp

ARDUINO_LIB = \
$(wildcard $(INSTALL_DIR)/libraries/*/*.cpp) \
$(wildcard $(INSTALL_DIR)/libraries/*/*/*.cpp) \
$(wildcard $(INSTALL_DIR)/libraries/*/*/*/*.cpp)

ARDUINO_C_LIB = \
$(wildcard $(INSTALL_DIR)/libraries/*/*.c) \
$(wildcard $(INSTALL_DIR)/libraries/*/*/*.c) \
$(wildcard $(INSTALL_DIR)/libraries/*/*/*/*.c)


CXX_APP      = build/$(TARGET).cpp
LOCAL_CSRC   = $(wildcard *.c)
LOCAL_CXXSRC = $(wildcard *.cpp)

# ===================
# = Grouped Sources =
# ===================
MODULES = $(C_MODULES) $(CXX_MODULES)
SRC     = $(C_MODULES) $(ARDUINO_C_LIB) $(LOCAL_CSRC) 
CXXSRC  = $(CXX_MODULES) $(ARDUINO_LIB) $(LOCAL_CXXSRC) $(CXX_APP)

# ================
# = Object Files =
# ================
# Define all object files.
OBJ         = $(SRC:.c=.o) $(CXXSRC:.cpp=.o) $(ASRC:.S=.o)
LOCAL_OBJ   = $(LOCAL_CSRC:.c=.o) $(LOCAL_CXXSRC:.cpp=.o)
OBJ_MODULES = $(C_MODULES:.c=.o) $(CXX_MODULES:.cpp=.o) $(ARDUINO_LIB:.cpp=.o) $(ARDUINO_C_LIB:.c=.o)

# =================
# = Listing Files =
# =================
# Define all listing files.
LST = $(ASRC:.S=.lst) $(CXXSRC:.cpp=.lst) $(SRC:.c=.lst)


# ==========
# = Format =
# ==========
FORMAT = ihex

# ============
# = Makefile =
# ============
# Name of this Makefile (used for "make depend").
MAKEFILE = Makefile


# ====================
# = Compiler Options =
# ====================
# Debugging format.
# Native formats for AVR-GCC's -g are stabs [default], or dwarf-2.
# AVR (extended) COFF requires stabs, plus an avr-objcopy run.
#DEBUG = stabs
DEBUG =
OPT = s

# Place -D or -U options here
CDEFS = -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)
CXXDEFS = -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)


# ============
# = Includes =
# ============
AVR_HEADERS = $(INSTALL_DIR)/hardware/tools/avr/avr/include/avr
AVR_VARIANT_HEADERS = $(INSTALL_DIR)/hardware/arduino/variants/$(ARDUINO_VARIANT)

ARDUINO_LIB_INCLUDES = $(addprefix -I, $(dir $(ARDUINO_LIB))) $(addprefix -I, $(dir $(ARDUINO_C_LIB)))

CINCS   = -I$(CURDIR) -I$(ARDUINO) $(ARDUINO_LIB_INCLUDES) -I$(AVR_HEADERS) -I$(AVR_VARIANT_HEADERS)
CXXINCS = -I$(CURDIR) -I$(ARDUINO) $(ARDUINO_LIB_INCLUDES) -I$(AVR_HEADERS)

# ==================
# = Compiler Flags =
# ==================
# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
#CSTANDARD = -std=gnu99
CDEBUG = -g$(DEBUG)
#CWARN = -Wall -Wstrict-prototypes
CWARN = -Wall   # show all warnings
# CWARN = -w      # suppress all warnings
####CTUNING = -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CTUNING = -ffunction-sections -fdata-sections
CXXTUNING = -fno-exceptions -ffunction-sections -fdata-sections
#CEXTRA = -Wa,-adhlns=$(<:.c=.lst)

CFLAGS = $(CDEBUG) -O$(OPT) $(CWARN) $(CTUNING) $(CDEFS) $(CINCS) $(CSTANDARD) $(CEXTRA)
CXXFLAGS = $(CDEBUG) -O$(OPT) $(CWARN) $(CXXTUNING) $(CDEFS) $(CINCS)
#ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs
LDFLAGS = -O$(OPT) -lm -Wl,--gc-sections

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = $(CFLAGS) -mmcu=$(MCU)
ALL_CXXFLAGS = $(CXXFLAGS) -mmcu=$(MCU)
ALL_ASFLAGS = -x assembler-with-cpp $(ASFLAGS) -mmcu=$(MCU)
ALL_LDFLAGS = $(LDFLAGS) -mmcu=$(MCU)

# ==================
# = AVR Dude Flags =
# ==================
# AVRDUDE_FLAGS = -V -F -C $(INSTALL_DIR)/hardware/tools/avr/etc/avrdude.conf \

AVRDUDE_FLAGS = -V -F -C $(INSTALL_DIR)/hardware/tools/avr/etc/avrdude.conf \
-p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER) \
-b $(UPLOAD_RATE)


# ============
# = Programs =
# ============
# Program settings
CC      = $(AVR_TOOLS_PATH)/avr-gcc
CXX     = $(AVR_TOOLS_PATH)/avr-g++
LD      = $(AVR_TOOLS_PATH)/avr-gcc
OBJCOPY = $(AVR_TOOLS_PATH)/avr-objcopy
OBJDUMP = $(AVR_TOOLS_PATH)/avr-objdump
AR      = $(AVR_TOOLS_PATH)/avr-ar
SIZE    = $(AVR_TOOLS_PATH)/avr-size
NM      = $(AVR_TOOLS_PATH)/avr-nm
AVRDUDE = $(AVRDUDE_PATH)/avrdude
REMOVE  = rm -f
MV      = mv -f


# ============================================================================
# = TARGETS ---------------------------------------------------------------- =
# ============================================================================
# Default target.
# all: applet_files build sizeafter
all: build sizeafter

# Target: clean project.
clean:
	$(REMOVE) \
	build/$(TARGET).hex \
	build/$(TARGET).eep \
	build/$(TARGET).cof \
	build/$(TARGET).elf \
	build/$(TARGET).map \
	build/$(TARGET).sym \
	build/$(TARGET).lss \
	build/*.o \
	build/*.c \
	build/*.cpp \
	build/core.a \
	$(OBJ) $(LST) $(SRC:.c=.s) $(SRC:.c=.d) $(CXXSRC:.cpp=.s) $(CXXSRC:.cpp=.d)

debug:
	@echo "Local C Source:"
	@for i in $(LOCAL_CSRC);   do echo "   "$$i; done
	@echo "Local CXX Source:"
	@for i in $(LOCAL_CXXSRC); do echo "   "$$i; done
	@echo "Local Objects:"
	@for i in $(LOCAL_OBJ);    do echo "   "$$i; done
	@echo "All Objects:"
	@for i in $(OBJ);          do echo "   "$$i; done

#elf hex
build: prepare elf hex
	@echo "Building $(TARGET) finished!"

rebuild: clean build

#applet_files: $(TARGET).pde
# applet_files: $(TARGET).ino
#  $(TARGET).ino
# build/$(TARGET).cpp: $(TARGET).ino
prepare:
	# Here is the "preprocessing".
	# It creates a .cpp file based with the same name as the .ino file.
	# On top of the new .cpp file comes the WProgram.h header.
	# and prototypes for setup() and Loop()
	# Then the .cpp file will be compiled. Errors during compile will
	# refer to this new, automatically generated, file.
	# Not the original .ino file you actually edit...
	test -d build || mkdir build
	echo '#include "Arduino.h"' > build/$(TARGET).cpp
	echo 'void setup();' >> build/$(TARGET).cpp
	echo 'void loop();'  >> build/$(TARGET).cpp
	cat $(TARGET).ino    >> build/$(TARGET).cpp

elf: build/$(TARGET).elf
hex: build/$(TARGET).hex
eep: build/$(TARGET).eep
lss: build/$(TARGET).lss
sym: build/$(TARGET).sym

# Program the device.  
upload: build/$(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

# Display size of file.
HEXSIZE = $(SIZE) --target=$(FORMAT) build/$(TARGET).hex
ELFSIZE = $(SIZE)  build/$(TARGET).elf

sizebefore:
	@if [ -f build/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_BEFORE); $(HEXSIZE); echo; fi

sizeafter:
	@if [ -f build/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_AFTER); $(HEXSIZE); echo; fi


# Link: create ELF output file from library.
# build/$(TARGET).elf: $(TARGET).ino build/core.a
# build/$(TARGET).elf:
build/$(TARGET).elf: build/$(TARGET).o
	$(LD) $(ALL_LDFLAGS) -o $@ build/$(TARGET).o build/core.a $(LOCAL_OBJ)

# Build the local files before heading over
build/$(TARGET).o: build/core.a $(LOCAL_OBJ)

# clean_local:
# $(REMOVE) $(LOCAL_OBJ) build/$(TARGET).o

build/core.a: $(OBJ_MODULES)
	@for i in $(OBJ_MODULES); do echo $(AR) rcs build/core.a $$i; $(AR) rcs build/core.a $$i; done


# Compile: create object files from C++ source files.
.cpp.o:
	$(CXX) -c $(ALL_CXXFLAGS) $< -o $@

# Compile: create object files from C source files.
.c.o:
	$(CC) -c $(ALL_CFLAGS) $< -o $@

# Compile: create assembler files from C source files.
.c.s:
	$(CC) -S $(ALL_CFLAGS) $< -o $@

# Assemble: create object files from assembler source files.
.S.o:
	$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Automatic dependencies
%.d: %.c
	$(CC) -M $(ALL_CFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > $@

%.d: %.cpp
	$(CXX) -M $(ALL_CXXFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > $@


.PHONY:	all build elf hex eep lss sym program coff extcoff clean applet_files sizebefore sizeafter


# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.
COFFCONVERT=$(OBJCOPY) --debugging \
--change-section-address .data-0x800000 \
--change-section-address .bss-0x800000 \
--change-section-address .noinit-0x800000 \
--change-section-address .eeprom-0x810000

coff: build/$(TARGET).elf
	$(COFFCONVERT) -O coff-avr build/$(TARGET).elf $(TARGET).cof

extcoff: $(TARGET).elf
	$(COFFCONVERT) -O coff-ext-avr build/$(TARGET).elf $(TARGET).cof


.SUFFIXES: .elf .hex .eep .lss .sym

.elf.hex:
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

.elf.eep:
	$(OBJCOPY) -O $(FORMAT) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--no-change-warnings \
	--change-section-lma .eeprom=0 $< $@

# Create extended listing file from ELF output file.
.elf.lss:
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
.elf.sym:
	$(NM) -n $< > $@

