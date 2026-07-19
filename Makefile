all: check test

check:
	v fmt -w .
	v vet .

test:
	v test .

clean:
	rm -rf *_test *.dSYM
