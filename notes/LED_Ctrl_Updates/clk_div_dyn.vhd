-- Simple parameterized clock divider that uses a counter
--
-- Modified to output a single period pulse to be used as a clock enable. This
-- way, FPGA has a single clock domain of clk_in but the circuit can still
-- operate slower using the clock enable.
--
-- This version of the clock divider dynamically changes the output rate based
-- on the passed in divider value.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clk_div_dyn IS
  PORT (
    clk_in : IN  STD_LOGIC;
    rst    : IN  STD_LOGIC;
    div    : IN  UNSIGNED(7 DOWNTO 0);  -- div+1 is the clock divider
    clk_en : OUT STD_LOGIC
    );
END clk_div_dyn;

ARCHITECTURE bhv OF clk_div_dyn IS

  signal count : UNSIGNED(div'range);

BEGIN

  PROCESS(clk_in, rst)
  BEGIN
    IF(rst = '1') THEN
      count  <= (OTHERS => '0'); --@@@ UNSIGNED(to_unsigned(0,count'length));
      clk_en <= '0';
    ELSIF(rising_edge(clk_in)) THEN
      IF(count = div) THEN
        count  <= (OTHERS => '0'); --@@@ UNSIGNED(to_unsigned(0,count'length));
        clk_en <= '1';
      ELSE
        count  <= count + 1;
        clk_en <= '0';
      END IF;
    END IF;
  END PROCESS;

END bhv;
