# seamstress

*seamstress* is a Lua scripting environment
for communicating with music, visuals and data.

## usage

seamstress is run from the command line. 
invoke it with `seamstress` or `seamstress <filename>`
(`seamstress -h` lists optional command-line arguments).
on startup, seamstress will search for a user-provided script file 
named `<filename>.lua` (defaulting to `script.lua`) to run.
this file may either be found in the current directory of your command-line prompt
or in `~/seamstress` (that is, a folder named `seamstress` under your `$HOME` directory,
which is typically `/Users/<username>` on macOS and `/home/<username>` on Linux).

on startup, seamstress creates two OS windows
and commandeers the command-line prompt as a Lua
REPL (short for **r**ead **e**valuate **p**rint **l**oop).
one of these windows is reserved for seamstress's `params` system,
while the other (the main window)
is available for scripts to draw to using seamstress's `screen` module.
to exit seamstress, close the main window or enter `quit` in to the REPL.

## scripting 

seamstress scripts are written in Lua,
an embeddable, extensible scripting language.
as of 1.0.0, seamstress supports Lua version 5.4.x.
[Lua.org](https://www.lua.org) has resources for programming in Lua.
additionally, [monome](https://monome.org) has studies for scripting in Lua for
[norns](https://monome.org/docs/norns/studies/) and [seamstress](https://monome.org/docs/grid/studies/seamstress/) to get you off the ground.

## installation

to install with homebrew, do
```bash
brew tap ryleelyman/seamstress
brew install seamstress
```

if you'd like to use [monome](https://monome.org) devices with seamstress,
you'll need to install [serialosc](https://github.com/monome/serialosc).

to instead build from source, you'll need the following libraries.
the following incantation is for homebrew,
but the list of dependencies is identical on linux.
```bash
brew install pkg-config zig asio liblo lua readline rtmidi sdl2 sdl2_image sdl2_ttf
```

with those installed, you can execute
```bash
zig build
```
to build a copy of seamstress in `zig-out`.

NB: this command builds `seamstress` in Debug mode.
you can change this 
by passing `-Doptimize=ReleaseFast` or `-Doptimize=ReleaseSafe` to the build command.

NB: the created seamstress expects the directory structure
within `zig-out`. if you move `zig-out/bin/seamstress` somewhere else,
say to `/usr/local/bin/seamstress`
don't forget to move `zig-out/share/seamstress` to `/usr/local/share/seamstress` as well.

## docs

the lua API is documented [here](https://ryleealanza.org/docs/index.html).
to regenerate docs, you'll need [LDoc](https://github.com/lunarmodules/ldoc),
which requires Penlight.
with both installed, running `ldoc .` in the base directory of seamstress will
regenerate documentation.

## style

lua formatting is done with [stylua](https://github.com/JohnnyMorganz/StyLua),
while zig formatting is done with `zig fmt`.
a `stylua.toml` is provided, so if you feel like matching seamstress's "house lua style",
simply run `stylua .` in the root of the repo.
similarly, you can run `zig fmt filename.zig` to format `filename.zig`.
(this is not a requirement for contributing.)

## acknowledgments

seamstress is inspired by [monome norns's](https://github.com/monome/norns) matron,
which was written by [@catfact](https://github.com/catfact).
norns was initiated by [@tehn](https://github.com/tehn).
