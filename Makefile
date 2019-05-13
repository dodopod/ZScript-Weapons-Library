sources=$(shell find src -type f)
target=zwl.pk3

build/$(target): $(sources)
	7z a -tzip $@ ./src/*

clean:
	rm -r build/*

.PHONY: clean
