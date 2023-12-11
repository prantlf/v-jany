all: check test

check:
	v fmt -w .
	v vet .

test:
	v -use-os-system-to-run test .

clean:
	rm -rf src/*_test src/*.dSYM
