# booth_multiplier

Verilog implementation of the Booth's multiplier for 6-bit inputs, following the optimized version presented in the last half of this [video](https://www.youtube.com/watch?v=FkCT6nX6c-c). More info in the [wiki](https://en.wikipedia.org/wiki/Booth%27s_multiplication_algorithm).

## Synthesis results
Logical synthesis ran using Quartus Prime.  
Device: 5CGXFC7C6U19C7

**1. Original version (non-optimized, first half of the video):**
- Logic ALMs: 17  
- Registers: 31  
- Pins: 29  
- Frequency Slow 85º: 350 MHz  
- Frequency Slow 0º: 333 MHz  
> *This version requires the number of bits of the operands as clock cycles (e.g., 6 bits require 6 cycles to get the result).*

**2. Optimized version (last half of the video):**
- Logic ALMs: 21
- Registers: 31
- Pins: 29
- Frequency Slow 85: 285 MHz
- Frequency Slow 0: 282 MHz  
> *This version requires only half of the operations necessary for version 1, but its not complete (problems with signed numbers larger than 16)*

**3. Version with reduction in operand size and 2 main states in the fsm:**
- Logic ALMs: 25  
- Registers: 43  
- Pins: 30  
- Frequency Slow 85: 357 MHz  
- Frequency Slow 0: 334 MHz  
> *This version was an attempt of increasing the frequency by breaking the combinational logic in two stages, it succeeded but the gain is not enough to compensate the throughput loss.*  
> *The code for version 3 is in the folder **2 state version**.*

**4. Last version - reducing operand size for version 2.**
- Logic ALMs: 22  
- Registers: 30  
- Pins: 29  
- Frequency Slow 85: 276 MHz  
- Frequency Slow 0: 270 MHz  
> *This version was chosen as the final one, it had the previous problems fixed, being able to multiply numbers between 31 and -31.  
It uses 3 cycles to produce an output. By some crazy synthesis reason, reducing the operand size for the sum and input mux worsened the frequency (before the size was 14 and now it is 7 bits).*  
