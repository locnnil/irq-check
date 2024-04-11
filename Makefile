prefix = /usr

all:
        install

install:
        install check_irqs.sh $(DESTDIR)$(prefix)/bin
