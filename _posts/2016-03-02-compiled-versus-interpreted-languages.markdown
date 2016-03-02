---
layout:   post
title:    "Compiled Versus Interpreted Languages"
date:     2016-03-02 01:02:25
comments: true
---
When we think about programming languages we can divide them into the categories of interpreted or compiled. The obvious example of a compiled language is C. The source code is taken by the compiler and translated into machine code, which is executed directly by the CPU. An interpreted language is not translated directly to machine code; it is run line-by-line inside a virtual machine. This concept is slightly confused by Just-in-Time compilers (JITs) which take an intermediate representation such as Java Bytecode and then produce machine code on-the-fly.

This view of the world doesn't actually hold up to intense scrutiny, as these categories aren't as clear-cut as we first thought. With a language like Java, we first compile it to bytecode and then run it on a virtual machine, which is a Java Bytecode interpreter. But aren't we basically doing the same thing with C? We compile in to machine code, and run it on a machine code interpreter (a CPU). Granted the interpreter is implemented in hardware, not software.

What about hardware description languages like Verilog? Our target is no longer a CPU, but an FPGA (Field Programmable Gate Array), which is essentially a chip with configurable digital logic gates. Rather than compile to machine code, we compile to a hardware layout (via some intruction set that the FPGA understands in order to configure itself).

So in Java-land we are compiling (to bytecode), then interpreting the bytecode with our VM, which actually compiles into several intermediate formats before generating machine code. Which we then interpret with our physical CPU.

At least we can say that our code is either statically compiled or dynamically compiled, right? For C, we run our compiler and get some output, and that is what gets run. For Java we do our bytecode compilation, and then some combination of compilation and interpreting stages will end up generating machine code or running statically compiled code that interprets Java code.

This is basically true until we get to the CPU level, where instructions are swapped around (out-of-order execution) to account for data load times from memory, or executed where they weren't meant to be, because it could be quicker to get the results of both sides of an if-statement while we wait for the condition to be determined. Basically my point is that you have no control over what happens to your code, so give up. We all die alone.