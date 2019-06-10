sources=$(shell find src -type f)
demo-sources=$(shell find demo -type f)

all: build/zwl.pk3 build/demo.pk3

build/zwl.pk3: $(sources)
	7z a -tzip $@ ./src/*

build/demo.pk3: $(demo-sources)
	7z a -tzip $@ ./demo/*

clean:
	rm -r build/*

.PHONY: all clean
