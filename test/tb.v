# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


def pack_inputs(a, b):
    """Pack two 4-bit numbers into ui_in"""
    return (a << 4) | b


@cocotb.test()
async def test_alu(dut):
    dut._log.info("Start ALU Test")

    # Clock: 10 us period
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # -----------------------------
    # TEST CASES
    # -----------------------------

    # ADD: 5 + 3 = 8
    dut.ui_in.value = pack_inputs(5, 3)
    dut.uio_in.value = 0b000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 8, "ADD failed"

    # SUB: 9 - 4 = 5
    dut.ui_in.value = pack_inputs(9, 4)
    dut.uio_in.value = 0b001
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, "SUB failed"

    # AND: 6 & 3 = 2
    dut.ui_in.value = pack_inputs(6, 3)
    dut.uio_in.value = 0b010
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 2, "AND failed"

    # OR: 6 | 3 = 7
    dut.ui_in.value = pack_inputs(6, 3)
    dut.uio_in.value = 0b011
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 7, "OR failed"

    # XOR: 6 ^ 3 = 5
    dut.ui_in.value = pack_inputs(6, 3)
    dut.uio_in.value = 0b100
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, "XOR failed"

    # SHIFT LEFT: 4 << 1 = 8
    dut.ui_in.value = pack_inputs(4, 0)
    dut.uio_in.value = 0b101
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 8, "SHIFT LEFT failed"

    # SHIFT RIGHT: 8 >> 1 = 4
    dut.ui_in.value = pack_inputs(8, 0)
    dut.uio_in.value = 0b110
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 4, "SHIFT RIGHT failed"

    # EQUAL: 5 == 5 → 1
    dut.ui_in.value = pack_inputs(5, 5)
    dut.uio_in.value = 0b111
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 1, "EQUAL failed"

    # EQUAL: 5 != 3 → 0
    dut.ui_in.value = pack_inputs(5, 3)
    dut.uio_in.value = 0b111
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "EQUAL false case failed"

    dut._log.info("All ALU tests passed ✅")
