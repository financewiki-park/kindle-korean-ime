BUILD ?= build
CC ?= cc
CFLAGS ?= -O2 -std=c99 -Wall -Wextra -Werror

.PHONY: test host arm clean
test: $(BUILD)/test_hangul
	$(BUILD)/test_hangul
$(BUILD)/test_hangul: src/hangul_core.c src/hangul_core.h tests/test_hangul.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -Isrc src/hangul_core.c tests/test_hangul.c -o $@
host: $(BUILD)/korean-ime-x11
$(BUILD)/korean-ime-x11: src/hangul_core.c src/hangul_core.h src/x11_bridge.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -Isrc src/hangul_core.c src/x11_bridge.c -lX11 -o $@
arm:
	@test -n "$(CROSS_COMPILE)" || (echo "Set CROSS_COMPILE"; exit 2)
	mkdir -p $(BUILD)
	$(CROSS_COMPILE)gcc $(CFLAGS) -Isrc src/hangul_core.c src/x11_bridge.c -lX11 -o $(BUILD)/korean-ime-x11
clean:
	rm -rf $(BUILD)
