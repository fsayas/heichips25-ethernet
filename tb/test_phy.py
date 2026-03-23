import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

async def reset_dut(dut):
    dut.rst_n.value = 0
    await Timer(100, units="ns")
    dut.rst_n.value = 1
    await Timer(100, units="ns")

class MDIOMaster:
    def __init__(self, dut):
        self.dut = dut
        self.dut.mdio_i.value = 1
        self.dut.mdc_i.value = 0
    
    async def send_bit(self, b):
        self.dut.mdio_i.value = b
        await Timer(200, units="ns")
        self.dut.mdc_i.value = 1
        await Timer(200, units="ns")
        self.dut.mdc_i.value = 0
        
    async def recv_bit(self):
        self.dut.mdio_i.value = 1 # Z
        await Timer(200, units="ns")
        self.dut.mdc_i.value = 1
        await Timer(1, units="ns")
        b = int(self.dut.mdio_o.value) if int(self.dut.mdio_oe.value) else 1
        await Timer(199, units="ns")
        self.dut.mdc_i.value = 0
        return b

    async def send_preamble(self, ones=32):
        for _ in range(ones):
            await self.send_bit(1)

    async def write_reg(self, phy_addr, reg_addr, data):
        await self.send_bit(0)
        await self.send_bit(1)
        await self.send_bit(0)
        await self.send_bit(1)
        for i in range(4, -1, -1):
            await self.send_bit((phy_addr >> i) & 1)
        for i in range(4, -1, -1):
            await self.send_bit((reg_addr >> i) & 1)
        await self.send_bit(1)
        await self.send_bit(0)
        for i in range(15, -1, -1):
            await self.send_bit((data >> i) & 1)

    async def read_reg(self, phy_addr, reg_addr, skip_ta=False):
        await self.send_bit(0)
        await self.send_bit(1)
        await self.send_bit(1)
        await self.send_bit(0)
        for i in range(4, -1, -1):
            await self.send_bit((phy_addr >> i) & 1)
        for i in range(4, -1, -1):
            await self.send_bit((reg_addr >> i) & 1)
        
        ta1 = await self.recv_bit() # PHY drives Z
        ta0 = await self.recv_bit() # PHY drives 0
        if not skip_ta:
            cocotb.log.info(f"header_buf: {self.dut.mdio_inst.header_buf.value.binstr}, state={self.dut.mdio_inst.state.value}")
            assert ta0 == 0, f"Turnaround 0 bit missing! header_buf is {self.dut.mdio_inst.header_buf.value.binstr}"
        
        val = 0
        for i in range(16):
            b = await self.recv_bit()
            val = (val << 1) | b
        return val

@cocotb.test()
async def test_mdio_preamble_sync(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    master = MDIOMaster(dut)

    # 1.1: 31 ones, a 0, 1 -> should not sync
    await master.send_preamble(31)
    await master.send_bit(0)
    await master.send_bit(1)
    # Check that MDIO FSM is not in RUN (IDLE == 0)
    assert dut.mdio_inst.state.value == 0

    # 1.2: 1 one, 0, 32 ones -> should sync on the 32 ones
    await master.send_preamble(1)
    await master.send_bit(0)
    await master.send_preamble(32)
    # Check that MDIO FSM isn't broken
    await master.send_bit(0)
    await master.send_bit(1)
    # Check that state went to RUN (value 1)
    assert dut.mdio_inst.state.value == 1

@cocotb.test()
async def test_wrong_address(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    master = MDIOMaster(dut)
    await master.send_preamble(32)
    # PHY=2, REG=1 (BMSR is 0x1804 if it successfully reads)
    val = await master.read_reg(2, 1, skip_ta=True)
    assert val == 0xFFFF, f"Expected Z (ffff) for wrong PHY address, got {val:x}"

@cocotb.test()
async def test_mdio_reads(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    master = MDIOMaster(dut)
    
    await master.send_preamble(32)
    val = await master.read_reg(1, 0)
    assert val == 0x0100, f"Expected 0x0100 for BMCR, got {val:04X}"
    
    await master.send_preamble(32)
    val = await master.read_reg(1, 1)
    assert val == 0x1804, f"Expected 0x1804 for BMSR, got {val:04X}"
    
    await master.send_preamble(32)
    val = await master.read_reg(1, 2)
    assert val == 0x4843, f"Expected 0x4843 for PHYID1, got {val:04X}"

@cocotb.test()
async def test_mdio_write_and_loopback(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    master = MDIOMaster(dut)
    
    # Init test pins
    dut.tx_en.value = 0
    dut.txd.value = 0
    dut.ref_clk.value = 0
    
    await master.send_preamble(32)
    await master.write_reg(1, 0, 0x4100) # Loopback (bit 14)
    await Timer(100, units="ns")
    
    dut.tx_en.value = 1
    dut.txd.value = 3
    await Timer(50, units="ns")
    assert dut.rx_dv.value == 1, "Loopback RX_DV failed"
    assert dut.rxd.value == 3, "Loopback RXD failed"

    # Test resetting the stats
    await master.send_preamble(32)
    await master.write_reg(1, 0, 0x8100) # Reset (bit 15)
    await Timer(100, units="ns")
    
    await master.send_preamble(32)
    val = await master.read_reg(1, 16)
    assert val == 0, "Packet counter didn't reset"
