PACKAGE = link-grammar-el

default: prepare byte-compile
	cp -r lisp Makefile README.org ${PACKAGE}

prepare:
	mkdir -p ${PACKAGE}

byte-compile:
	emacs -Q -L ./lisp -batch -f batch-byte-compile ./lisp/*.el

clean:
	rm -f ./lisp/*.elc
	rm -rf ${PACKAGE}

# We don't have an install script yet
install:
	emacs -Q -L . -batch -l etc/install ${DIR}

tar.bz2: default
	tar cjf ${PACKAGE}.tar.bz2 ${PACKAGE}

zip: default
	zip -r ${PACKAGE}.zip ${PACKAGE}

package: tar.bz2 zip
