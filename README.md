1. Objectives

The purpose of this lab is to implement two variations of a binary multiplier, one combinational and the other sequential. The combinational design requires both traditional logic gates (AND gates) and adders to implement, while the sequential design calls for an FSM-based design. Additionally, we opted to alter and reuse modules from our previous lab, outputting a counter on the Basys 3’s 7 segment display (7SD), to display the product of our multiplication.

2. Introduction

A multiplier is a digital logic circuit that takes 2 n-bit inputs to produce a single 2*n-bit output (product). Implemented either using purely combinational or a mix of both combinational and sequential logic, the multiplier performs rudimentary bit-shift operations and binary additions to produce its output. In our designs, we take 2 4-bit inputs (A, B) to generate the 8-bit output (product). The board’s switches are used to generate the input signals, and the product is output in decimal using our previous lab’s 7SD logic.

The combinational multiplier is made using only AND gates, adders, and intermediary bit-shifting operations. The internal logic mimics that of performing binary multiplication by hand. First, each bit of the multiplier (B) is sign extended and ANDed with the multiplicand (A). Next, the AND result is shifted (by m bits, based on the place of the multiplier bit, with m = 0 being the LSB of the original multiplier) to generate partial products. Lastly, all partial products are summed to generate the final product.

The sequential multiplier requires additional complex logic and clock-based control. We implemented this version of the multiplier using a 4-state Moore style FSM (using combinational logic to transition between states), with S0_idle, S1_multiplication, S2_update_result, and S3_done. In S0, the partial_product and shift_count variables are initialized to 0, B is cloned to operand_bb, and A is 0 extended to 8 bits. The machine spends the majority of its time cycling between S1 and S2. S1 contains the majority of mathematical logic, generating a partial product to be added to the running partial product if the current multiplier bit is 1 (holding the partial product if it reads 0), left shifting the multiplicand to ensure the place is correct in the next iteration, and right shifting the operand_bb variable to prepare the desired bit of B to serve as the current bit for the subsequent iteration. S2 simply verifies whether or not 4 shifts have been performed, updating the final product variable if so and returning to S1 if not. The system additionally implements a reset to return to S0 mid calculation.

3. Instructions for simulation and FPGA implementation

Simulation: 

a. Create a project in vivavdo containing all of these files.

b. Select the desired testbench file and corresponding design file as the top modules.

c. Run simulation and view waveform.

FPGA implementation:

a. Create a project in vivavdo containing all of these files.

b. Select the desired top module (Combinational or Sequential) as the top module.

c. Generate the bitstream and connect to FPGA board.

d. Switches 0-3 correspond with multiplicand A, 4-7 correspond with multiplier B, and 8 corresponds with reset (active low).

5. Additional Soures

https://hilite.me/ - Used to format Appendix code in Lab Report
