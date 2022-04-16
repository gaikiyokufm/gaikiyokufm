local_url = "localhost"

TODAY := $(shell date +%Y-%m-%d)
EP_NUM := $(shell ls -1 _posts/ | wc -l | sed 's/\ //g')
EP_NUM_PAD := $(shell printf "%04d" $(EP_NUM))
NEW_FILENAME := _posts/$(TODAY)-$(EP_NUM).md
AUDIO_FILENAME := audio/gaikiyokufm-$(EP_NUM_PAD).mp3
DURATION := $(shell sox --i -d $(AUDIO_FILENAME) | sed -e "s/\.[0-9]*//")
FILESIZE := $(shell ls -l $(AUDIO_FILENAME) | awk '{print $$5}')

help:
	@echo make preprocess ARG=hoge.wav: preprocess for hoge.wav
	@echo make mp3 ARG=hoge.wav       : convert wav to mp3
	@echo make post                   : create post for new mp3

post:
	@cp _posts/template.md $(NEW_FILENAME)
	@sed -i '' -e 's/EP_NUM_PAD/$(EP_NUM_PAD)/g' $(NEW_FILENAME)
	@sed -i '' -e 's/EP_NUM/$(EP_NUM)/g' $(NEW_FILENAME)
	@sed -i '' -e 's/DATE/$(TODAY)/g' $(NEW_FILENAME)
	@sed -i '' -e 's/DURATION/$(DURATION)/g' $(NEW_FILENAME)
	@sed -i '' -e 's/FILESIZE/$(FILESIZE)/g' $(NEW_FILENAME)
	nvim $(NEW_FILENAME)

preprocess:
	@sox ${ARG} -c 1 ${ARG:.wav=}-left.wav remix 1
	@sox ${ARG} -c 1 ${ARG:.wav=}-right.wav remix 2

mp3:
	lame --noreplaygain -q 2 --cbr -b 64 -m m --resample 44.1 --add-id3v2 ${ARG} audio/gaikiyokufm-$(EP_NUM_PAD).mp3
