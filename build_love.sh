#!/bin/bash
#if [ -f game.love ]; then
#	rm game.love
#fi
zip -FS -r -i "*.lua" "assets/*" @ game.love . && \
	cp -v game.love ~/storage/shared/Documents/konduktör/game.love 
