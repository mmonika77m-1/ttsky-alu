## How it works

This project implements a simple 4-bit Arithmetic Logic Unit (ALU).  
It performs basic arithmetic and logical operations on two input operands.

### Inputs
- **A[3:0] (ui[3:0])** → 4-bit operand A  
- **B[1:0] (ui[5:4])** → 2-bit operand B  
- **OP[1:0] (ui[7:6])** → Operation select  

### Operations

| OP1 OP0 | Operation        | Description            |
|--------|-----------------|------------------------|
| 00     | ADD             | A + B                  |
| 01     | SUB             | A - B                  |
| 10     | AND             | A & B                  |
| 11     | OR              | A \| B                 |

The result is produced on the **8-bit output bus (uo[7:0])**.  
Lower bits contain the computed result, while upper bits may remain zero depending on the operation.

---

## How to test

1. Provide input values:
   - Set operand **A** using `ui[0]` to `ui[3]`
   - Set operand **B** using `ui[4]` and `ui[5]`
   - Select operation using `ui[6]` and `ui[7]`

2. Observe output:
   - The result appears on `uo[0]` to `uo[7]`

### Example

- A = 5 → `0101`  
- B = 2 → `10`  
- OP = `00` (Addition)  

**Expected Output:**
- Result = 7 → `00000111`

---

## External hardware

No external hardware is required.

This design can be tested using:
- Simulation tools like **cocotb**
- Tiny Tapeout test infrastructure

Optional:
- LEDs can be connected to `uo[7:0]` to visualize the result
