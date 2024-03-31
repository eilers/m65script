# m65script
* **State:** Experimental

This interpreter is planned as extension of the existing Basic-Language of the [Mega65](https://mega65.org). The goal is to add some control structures known from current programming languages without losing the interactive experience you know and love on these machines.
It is therefore not a cross-compiler or any pre-compilation involved.

## Credits
This project bases on the genius work by [lotabout](https://github.com/lotabout) who wrote a great tutorial about how to write an interpreter which results in a C-Interpreter which was able to execute the interpreter itself (see: [write-a-C-interpreter](https://github.com/lotabout/write-a-C-interpreter).
After examining several various existing interpreters, it was the only one that was small enough (and without unresolvable dependencies) to be cross compileable on the Mega65. I therefore chose it for my project.

## How to compile
First clone this project with all submodules:
```bash
git clone --recurse-submodules https://github.com/eilers/m65script.git
```
You need the following tools in your PATH

1. mos-mega65-clang: You can install it from [here](https://github.com/llvm-mos/llvm-mos-sdk?tab=readme-ov-file#download)
2. petcat: It installs with [VICE](https://vice-emu.sourceforge.io/index.html#download)
3. cc1541: This is _not_ c1541 that comes with VICE. The prject can be found [here](https://www.mankier.com/1/cc1541). We need this in order to create d81 disk images.
4. xemu: A current version of the XEMU in order to run this program. You will find it [here](https://github.com/lgblgblgb/xemu).
5. The latest version of the Mega65 ROM.

If all of the tools are installed, you can compile and run the interpreter by simply enter
```bash
make run
```
This will comple the project, create an autostarting d81 image and start XEMU wit this disk mounted.
