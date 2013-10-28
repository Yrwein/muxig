
.DEFAULT_GOAL = help

build:
	@which ronn \
		&& { \
			ronn MANUAL.md; \
		} \
		|| { \
			echo 'Ronn is not installed'; \
			echo '  http://rtomayko.github.io/ronn/'; \
			echo '  apt-get install ruby-ronn'; \
			return 1; \
		}

install: build uninstall
	mkdir -p /var/lib/muxig
	cp -r src/* /var/lib/muxig
	ln -s /var/lib/muxig/run.rb /usr/bin/muxig
	cp MANUAL.1 /usr/share/man/man1/muxig.1
	echo 'complete -W "git-cui clear-panes close-window kill" muxig' | tee /etc/bash_completion.d/muxig
	@echo
	@echo '<muxig> was successfully installed.'

uninstall:
	rm -f /usr/bin/muxig
	rm -Rf /var/lib/muxig
	rm -f /usr/share/man/man1/muxig.1
	rm -f /etc/bash_completion.d/muxig

help:
	@echo 'Usage:'
	@echo '  install - installs binary and manual, requires root permissions (build and uninstall is run before this target)'
	@echo '  uninstall - uninstalls all installed files, requires root permissions (even from previous muxig versions)'
	@echo '  help - shows this help'
	@echo '  build - builds man page (and in future maybe more stuff?)'
