################################################################################
#                                   LICENSE                                    #
################################################################################
#   This file is part of libtmpidl.                                            #
#                                                                              #
#   libtmpidl is free software: you can redistribute it and/or modify          #
#   it under the terms of the GNU General Public License as published by       #
#   the Free Software Foundation, either version 3 of the License, or          #
#   (at your option) any later version.                                        #
#                                                                              #
#   libtmpidl is distributed in the hope that it will be useful,               #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#   GNU General Public License for more details.                               #
#                                                                              #
#   You should have received a copy of the GNU General Public License          #
#   along with libtmpidl.  If not, see <https://www.gnu.org/licenses/>.        #
################################################################################
#   Author:     Ryan Maguire                                                   #
#   Date:       March 9, 2022                                                  #
################################################################################
TARGET_LIB := libtmpidl.so
LIBTMPL := ./libtmpl/libtmpl.a

BUILD_DIR := ./build
SRC_DIRS := ./csrc

CWARN := -Wall -Wextra -Wpedantic
CFLAGS := $(EXTRA_FLAGS) -I../ -I./ -O3 -fPIC -flto -DNDEBUG -c
LFLAGS := $(EXTRA_LFLAGS) -L./libtmpl/ -O3 -flto -shared
LFLAGS += -lm -l:libtmpl.a

ifdef OMP
CFLAGS += -fopenmp
LFLAGS += -fopenmp
endif

SRCS := $(shell find $(SRC_DIRS) -name "*.c")
OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)

.PHONY: clean install uninstall all libtmpl

all: $(TARGET_LIB) $(LIBTMPL)

$(TARGET_LIB): $(OBJS) $(LIBTMPL)
	@$(CC) $(OBJS) $(LFLAGS) -o $@ -lm
	@echo "Building $(TARGET_LIB) ..."

$(BUILD_DIR)/%.o: %.c $(LIBTMPL)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBTMPL):
	$(MAKE) -C libtmpl/ BUILD_STATIC=1

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET_LIB)
	$(MAKE) -C libtmpl/ clean BUILD_STATIC=1

install:
	mkdir -p /usr/local/lib/
	cp $(TARGET_LIB) /usr/local/lib/$(TARGET_LIB)

uninstall:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET_LIB)
	rm -f /usr/local/lib/$(TARGET_LIB)
	$(MAKE) -C libtmpl/ uninstall
