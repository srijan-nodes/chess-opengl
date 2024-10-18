# Compiler
CC = gcc
CFLAGS = -Wall -g -DGLEW_STATIC -DGLFW_INCLUDE_NONE

# Detect OS
ifeq ($(OS),Windows_NT)
    OS = windows
else
    UNAME := $(shell uname -s)
    ifeq ($(UNAME),Linux)
        OS = linux
    else
        $(error OS not supported by this Makefile)
    endif
endif

# Library and include paths
ifeq ($(OS), windows)
    LIB=-L./lib -lglew32 -lglfw3 -lcglm -lfreetype -lgdi32 -lopengl32
    INC=-I./include -I./include/freetype
    TARGET_EXEC = $(BUILD_DIR)/chess.exe
else ifeq ($(OS), linux)
    LIB=-lGLEW -lglfw -lcglm -lfreetype -lm
    INC=-I./include -I./include/freetype
    TARGET_EXEC = $(BUILD_DIR)/chess
endif

# Directories
SRC_DIR = src
BUILD_DIR = build
RES_DIR = res

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(SRC_DIR)/**/**/*.c)
HEADERS = $(wildcard $(SRC_DIR)/*.h) $(wildcard $(SRC_DIR)/**/*.h) $(wildcard $(SRC_DIR)/**/**/*.h)
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

# Directory creation guard
dir_guard=@mkdir -p $(@D)

# Targets
.PHONY: all clean

all: $(TARGET_EXEC)

$(TARGET_EXEC): $(OBJECTS)
	$(dir_guard)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@ $(LIB)

# Improve recompilation strategy when headers change
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c $(HEADERS)
	$(dir_guard)
	$(CC) $(CFLAGS) $(INC) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
