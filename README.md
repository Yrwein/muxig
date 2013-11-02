# muxig

Simple script creating tmux layout for watching git repository state.

It is planned to be configurable tmux manager in future versions.

## Install

```bash
sudo make install # uninstall for reverting
```

## Own muxig commands

Just create ~/.muxig.rb - it will be loaded with each muxig run.
Conf file has plain ruby syntax with possibility to add own commands:

    windows['git-cui'] = split :horizontal do
      pane
      split :vertical, 30 do
        pane "watch --no-title --color -n '0,3' git status --short -b"
        pane "watch --no-title --color -n '1' git branch"
      end
    end

## Manual

```bash
man muxig # source in MANUAL.md
```
