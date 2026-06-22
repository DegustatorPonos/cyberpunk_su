all:
	zig build test && zig build run

build:
	zig build && cp zig-out/bin/backend app

test:
	zig build test

# It is important that this comand only runs on unix machines
deps:
	git clone https://github.com/redis/hiredis
	cd hiredis; sudo make install
	cd hiredis; sudo make; cp libhiredis.so ../libhiredis.so.1.3.0

build-container:
	sudo docker build -t cp2020_back .
