-- Adafruit RGB LED Matrix Display Driver
-- Special memory for the framebuffer with separate read/write clocks

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

USE work.rgbmatrix.ALL;

ENTITY ram_half IS
  PORT (
    rst      : IN  STD_LOGIC;
    clk      : IN  STD_LOGIC;
    wr_en    : IN  STD_LOGIC;
    wr_addr  : IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    wr_data  : IN  STD_LOGIC_VECTOR((DATA_WIDTH/2)-1 DOWNTO 0);
    rd_addr  : IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    rd_data  : OUT STD_LOGIC_VECTOR((DATA_WIDTH/2)-1 DOWNTO 0)
    );
END ram_half;

ARCHITECTURE bhv OF ram_half IS
  -- Internal signals

  -- Inferred RAM storage signal
  TYPE half_ram IS ARRAY(0 TO 2**ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(wr_data'range);
  SIGNAL ram : half_ram;

BEGIN


  ----------------------------------------------------------------------------------------------------------------------
  -- The following processes are specifically written in maximize the chance that they get inferred into
  -- dual-port Block Rams so as to best use the available resources.
  ----------------------------------------------------------------------------------------------------------------------
  -- Write process for the memory
  PROCESS(clk)
  BEGIN
    IF(rising_edge(clk)) THEN
      IF (wr_en = '1') THEN
        -- store input in pixel ram at the current write address
        ram(conv_integer(wr_addr)) <= wr_data;
      END IF;
    END IF;
  END PROCESS;

  -- Read process for the memory
  --@@@
  --PROCESS(clk)
  --BEGIN
  --  IF(rising_edge(clk)) THEN
  --    rd_data <= ram(conv_integer(rd_addr));  -- retrieve contents at the given read address
  --  END IF;
  --END PROCESS;

  -- System runs at 40 MHz but is running out of resources, so save some f/f's by making rd_data combinatorial
  rd_data <= ram(conv_integer(rd_addr));  -- retrieve contents at the given read address


END bhv;
