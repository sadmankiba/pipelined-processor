# Proj Notes

Assembly files are in dir - /u/s/i/sinclair/courses/cs552/spring2022/handouts/testprograms/public/*/*.asm. Copied to testprograms/ dir. 

## Running program

- Copy all assembly programs to a test directory.
- You can run either all programs or a particular program in your processor
  - A particular prog. It generates `loadfile_all.img` that is fed into the `memory2c.v` module.
```
wsrun.pl -prog <testdir>/<file>.asm <tb-module-name> *.v
```
  - All progs in a dir. This also creates a `summary.log`.
```
wsrun.pl -list <testdir>/all.list <tb-module-name> *.v 
```

- Run all tests and generate appropriate logs for demo 1.

```
cd project/demo1/verilog
/u/s/w/swamit/public/html/courses/cs552/fall2022/handouts/bins/run-phase1-all.sh
```

Ref: Ian's tutorial video

## Additional Running

For debugging, we won't use Modelsim as it will be complex. We can view the waveform from the dump file:
```
vsim -view dataset=dump.wlf
```

We can use `wisccalculator` to describe expected behavior of a binary file. It can be found in /u/s/i/sinclair/courses/cs552/spring2022/handouts/simulator/programs/wisccalculator.

```
wisccalculator <obj-file>
``` 

You can run assembler on a custom assmbly program to create binary object files. It creates a few files. Two imp: object file `loadfile_all.img` and listing `loadfile.lst` for personal reference.

```
assemble.sh <file>.asm
```



## UWisc Articles
[Command-line ModelSim Tutorial](https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2022/vsimCommandLine.html)
[Using assembler](https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2022/usingAssembler.html) 

[Test programs](https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2022/testProgs.html)
