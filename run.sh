#!/bin/bash
if [ -f game.love ]; then
	rm game.love
fi
zip -r -i "*.lua" "assets/*" @ game.love . && termux-open game.love
