TARGET = WavProcessor

SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build

CC = clang

COMPILE_FLAGS = compile_flags.txt

SOURCES := $(wildcard $(SRC_DIR)/*.c)

OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(SOURCES)))
HEADERS := $(wildcard $(INC_DIR)/*.h)
INCLUDES = -I./$(INC_DIR)

CFLAGS = -O2 $(INCLUDES)

.PHONY: all install clean

all: $(BUILD_DIR)/$(TARGET) $(BUILD_DIR)/$(COMPILE_FLAGS)

$(BUILD_DIR)/$(TARGET): $(OBJECTS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/$(COMPILE_FLAGS): | $(BUILD_DIR)
	@echo "creating $(BUILD_DIR)/$(COMPILE_FLAGS)"
	@echo "$(CFLAGS)" | sed -E 's/(-I\.\/|-I)([^\/]+)/-I..\/\2/g' | tr ' ' '\n' > "$(BUILD_DIR)/$(COMPILE_FLAGS)"

$(BUILD_DIR):
	mkdir -p $@

install: all
	@echo "copying $(TARGET) to /usr/local/bin/"
	@cp $(BUILD_DIR)/$(TARGET) /usr/local/bin/$(TARGET)

clean:
	-rm -rf $(BUILD_DIR)
