# Directories
PREFIX = /usr/local
EXEC_PREFIX = $(PREFIX)
BINDIR = $(EXEC_PREFIX)/bin
ETCDIR = /etc/new/module.d

all: new
	@echo "Nothing to do"

install: all
	install -d $(BINDIR)
	install -d $(ETCDIR)
	install -m 755 new $(BINDIR)
	install -m 644 *.new.rb $(ETCDIR)
	install -m 644 *.new.rb.yaml $(ETCDIR)

clean:
	@echo "Nothing to do"

.PHONY: all clean install
