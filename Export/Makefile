name = ShoutAtTheCat

zips = $(name)_Linux.zip $(name)_Windows.zip

%.zip: %
	zip -r $@ $(basename $@)

all: $(zips)
