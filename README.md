In this project, we designed an application specific processor (ASP) and programmed it in Verilog code. Our ASP includes two layers of protection:
soft error detection and integrity attack detection. The ASP resides between a processor system and a network to make sure that the data sent out
to the network is soft-error free, and that the data received from the network to be used by the destination processor is not tampered.
We designed an instruction set architecture (ISA) that is efficient, easy to implement, and allows for both the soft error detection
and data authentication to be completed as fast as possible. We also built a pipelined processor for our instruction set, and wrote test cases
to verify our design for various tag sizes.
