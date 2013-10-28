muxig(1) -- set tmux layout for easier work with git
====================================================

## SYNOPSIS

`muxig` [<command>]

## DESCRIPTION

Muxig sets layout of tmux for real time tracking _git status_ and _git
branch_. Using <git-cui> command it splits terminal into three
panes. The first is left untached. The second is infinitely refreshing
_git status_ and the third infinitely refreshing _git branch_.

So if you in any way create / modify / delete file you will
immediately see that in the second pane and the same stands for
manipulating with branches and the third pane.

## OPTIONS

Without command muxig just starts tmux.

Command list for use inside tmux:

 * **git-cui**:
     split current window to git console user interface
 * **kill**:
     kills tmux
 * **clear-panes**:
     kills all panes in window except active
 * **close-window**:
     close current window with all panes

## AUTHORS

The first version of muxig was based on "output" of tmuxinator tool by
Allen Bargi. Further improvements is made by Josef Cech.

## REPORTING BUGS

https://github.com/Yrwein/muxig

## SEE ALSO

tmux(1), git(1), watch(1)
