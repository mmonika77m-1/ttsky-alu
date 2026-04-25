# SPDX-FileCopyrightText: © 2026
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


# ALU operation codes (adjust to match your design)
ADD = 0
SUB = 1
AND = 2
OR  = 3
XOR = 4
MUL = 5


@cocotb.test()
async def test_alu(dut):
    dut._log.info("Starting ALU Test")

    # Create clock (10 us period → 100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Resetting DUT")
    dut.rst_n.value = 0
    dut.a.value = 0
    dut.b.value = 0
    dut.op.value = 0

    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Small helper function
    async def check(op, a, b, expected):
        dut.a.value = a
        dut.b.value = b
        dut.op.value = op

        await ClockCycles(dut.clk, 1)

        result = int(dut.result.value)
        dut._log.info(f"OP={op}, A={a}, B={b} => RESULT={result}")

        assert result == expected, f"Expected {expected}, got {result}"

    # Test cases
    dut._log.info("Running test cases")

    await check(ADD, 10, 5, 15)
    await check(SUB, 10, 5, 5)
    await check(AND, 10, 5, 10 & 5)
    await check(OR,  10, 5, 10 | 5)
    await check(XOR, 10, 5, 10 ^ 5)
    await check(MUL, 10, 5, 50)

    # Edge cases
    await check(ADD, 0, 0, 0)
    await check(SUB, 0, 5, -5 & 0xFFFFFFFF)  # if 32-bit wraparound
    await check(MUL, 255, 2, 510)

    dut._log.info("All ALU tests passed!")
