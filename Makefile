run:
	love .

dist: love windows32

love:
	zip *.lua assets > shuut.zip
	mv shuut.zip shuut.love

windows32: love
	rm -fr shuut-windows32
	mkdir shuut-windows32
	cat love-0.9.2-win32/love.exe shuut.love > shuut-windows32/shuut.exe
	cp love-0.9.2-win32/*.dll love-0.9.2-win32/license.txt shuut-windows32
	(cd shuut-windows32 && zip * > shuut-windows32.zip)
clean:
	rm -f shuut.love
	rm -rf shuut-windows32
