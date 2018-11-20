# muxig

A simple script for creating tmux layouts. There is a layout for watching git repository state by default.

## Install

```bash
sudo make install # uninstall for reverting
```

## Custom muxig commands

Just create ~/.muxig.rb - it will be loaded with each muxig run.
Conf file has plain ruby syntax with possibility to add custom commands:

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
