-- Adafruit RGB LED Matrix Display Driver
-- Finite state machine to control the LED matrix hardware
--
-- Modified to use updated clk_div which was changed to output a clock enable
-- so that all of VHDL runs on the same clock domain. Also changed RGB outputs
-- so that they transition on falling edge of clk_out. This maximizes the
-- setup and hold times. clk_out, lat and oe_n are now output directly from
-- f/fs to minimize clock to output delay. Lengthed oe_n deassert time by one
-- 10 MHz period.
--
-- Modified the state machine extensively in order to minimize the LED
-- ghosting. Going with suggestions found on Adafruit forums.
--
-- 1. Write all 0's to the row shift register first before start PWM refreshes.
-- 2. Perform all PWM sub-periods on a single row before advancing to the next row.
--    1. This minimizes the number of row transitions which is where the ghost appears
--    2. May want to try writing all 0's to a row at the end of PWM and before advancing to the next row.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.rgbmatrix.ALL;

ENTITY ledctrl IS
  PORT (
    rst      : IN  STD_LOGIC;
    clk_in   : IN  STD_LOGIC;
    div      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- LED Debug IO
    frame    : OUT STD_LOGIC;           -- if '1', then at the start of a frame (ie. bpp_count = 0)
    -- LED Panel IO
    clk_out  : OUT STD_LOGIC;
    rgb1     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    rgb2     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    row_addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    lat      : OUT STD_LOGIC;
    oe_n     : OUT STD_LOGIC;
    -- Memory IO
    addr     : OUT STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    data     : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
END ledctrl;

ARCHITECTURE bhv OF ledctrl IS
  -- Internal signals
  SIGNAL clk_en, clk30_en, clk20_en, clk10_en, clk05_en : STD_LOGIC;

  -- Essential state machine signals
  TYPE STATE_TYPE IS (INIT, READ_PIXEL_DATA, INCR_COL_ADDR, LATCH, INCR_ROW_ADDR);
  SIGNAL state, next_state : STATE_TYPE;

  -- State machine signals
  SIGNAL col_count, next_col_count : UNSIGNED(IMG_WIDTH_LOG2 DOWNTO 0);
  SIGNAL bpp_count, next_bpp_count : UNSIGNED(PIXEL_DEPTH-1 DOWNTO 0);
  SIGNAL s_row_addr, next_row_addr : STD_LOGIC_VECTOR(row_addr'range);
  SIGNAL next_rgb1, next_rgb2      : STD_LOGIC_VECTOR(rgb1'range);
  SIGNAL s_oe_n, s_lat, s_clk_out  : STD_LOGIC;

  SIGNAL update_rgb : STD_LOGIC;        -- If '1', then update the RGB outputs
  SIGNAL next_frame : STD_LOGIC;        -- If '1', then clocking in pixels at start of a frame

BEGIN

  ------------------------------------------------------------------------------------------------------------------------
  ---- Allow one of 4 clock speeds.
  ----
  ---- For a 16 x 32 RGB matrix with 8 bit pixel depth, 5 MHz clock =~ 30 frames per second
  ------------------------------------------------------------------------------------------------------------------------

  ---- A simple clock divider is used here to slow down this part of the circuit
  --U_CLKDIV30 : ENTITY work.clk_div
  --  GENERIC MAP (
  --    clk_in_freq  => 40000000,         -- 40MHz input clock
  --    clk_out_freq => 30000000          -- 30MHz output clock
  --    )
  --  PORT MAP (
  --    rst    => rst,
  --    clk_in => clk_in,
  --    clk_en => clk30_en
  --    );


  ---- A simple clock divider is used here to slow down this part of the circuit
  --U_CLKDIV20 : ENTITY work.clk_div
  --  GENERIC MAP (
  --    clk_in_freq  => 40000000,         -- 40MHz input clock
  --    clk_out_freq => 20000000          -- 20MHz output clock
  --    )
  --  PORT MAP (
  --    rst    => rst,
  --    clk_in => clk_in,
  --    clk_en => clk20_en
  --    );

  ---- A simple clock divider is used here to slow down this part of the circuit
  --U_CLKDIV10 : ENTITY work.clk_div
  --  GENERIC MAP (
  --    clk_in_freq  => 40000000,         -- 40MHz input clock
  --    clk_out_freq => 10000000          -- 10MHz output clock
  --    )
  --  PORT MAP (
  --    rst    => rst,
  --    clk_in => clk_in,
  --    clk_en => clk10_en
  --    );

  ---- A simple clock divider is used here to slow down this part of the circuit
  --U_CLKDIV05 : ENTITY work.clk_div
  --  GENERIC MAP (
  --    clk_in_freq  => 40000000,         -- 40MHz input clock
  --    clk_out_freq => 05000000          --  5MHz output clock
  --    )
  --  PORT MAP (
  --    rst    => rst,
  --    clk_in => clk_in,
  --    clk_en => clk05_en
  --    );

  ---- Select when speed to run the clock enable which ultimately
  ---- effects the frame rate. Note that there are 2 states per clk_out
  ---- period so a 5 MHz clk_en means that clk_out essentially runs a
  ---- 5 MHz / 2 = 2.5 MHz.
  --clk_en <= clk30_en WHEN rate = "11" ELSE
  --          clk20_en WHEN rate = "10" ELSE
  --          clk10_en WHEN rate = "01" ELSE
  --          clk05_en;

  ----------------------------------------------------------------------------------------------------------------------
  -- For a 16 x 32 RGB matrix with 24-bit pixel depth (8-bit per R,G & B), 5 MHz clock =~ 30 frames per second
  -- but this rate has a noticable flicker.  So 10 MHz clock =~ 76 fps is better.  div = 3 for 10 MHz
  -- ie. 40 MHz / (div+1) = 10 MHz
  ----------------------------------------------------------------------------------------------------------------------
  U_CLKDIV : ENTITY work.clk_div_dyn
    PORT MAP (
      rst    => rst,
      clk_in => clk_in,
      div    => UNSIGNED(div),
      clk_en => clk_en);

  ----------------------------------------------------------------------------------------------------------------------
  -- Breakout internal signals to the output port
  row_addr <= s_row_addr;

  -- col_count is one extra bit long in order to compare against the expected
  -- width.  So discard that upper bit for ram addr
  addr <= s_row_addr & STD_LOGIC_VECTOR(col_count(col_count'high-1 DOWNTO 0));

  ----------------------------------------------------------------------------------------------------------------------
  -- State register
  PROCESS(rst, clk_in)
  BEGIN
    IF(rst = '1') THEN
      state      <= INIT;
      col_count  <= (OTHERS => '0');
      bpp_count  <= (OTHERS => '1');    -- first state transition incrs bpp_count so start at -1 so first bpp_count = 0
      s_row_addr <= (OTHERS => '1');    -- this inits to 111 because the row_addr is incr when bpp_count = 255
      frame      <= '0';
      rgb1       <= (OTHERS => '0');
      rgb2       <= (OTHERS => '0');
      oe_n       <= '1';                -- active low, so do not enable LED Matrix output
      lat        <= '0';
      clk_out    <= '0';
    ELSIF(rising_edge(clk_in)) THEN
      IF (clk_en = '1') THEN
        -- Run all f/f clocks at the slower clk_en rate
        state      <= next_state;
        col_count  <= next_col_count;
        bpp_count  <= next_bpp_count;
        s_row_addr <= next_row_addr;
        frame      <= next_frame;

        IF (update_rgb = '1') THEN
          rgb1 <= next_rgb1;
          rgb2 <= next_rgb2;
        END IF;

        -- Use f/fs to eliminate variable delays due to combinatorial logic output.
        -- Also, this allows the RGB data to transition on the falling edge of
        -- clk_out in order to maximum the setup and hold times.
        oe_n    <= s_oe_n;
        lat     <= s_lat;
        clk_out <= s_clk_out;

      END IF;
    END IF;
  END PROCESS;

  -- Next-state logic
  PROCESS(state, col_count, bpp_count, s_row_addr, data) IS
    -- Internal breakouts
    VARIABLE upper, lower              : UNSIGNED(DATA_WIDTH/2-1 DOWNTO 0);
    VARIABLE upper_r, upper_g, upper_b : UNSIGNED(PIXEL_DEPTH-1 DOWNTO 0);
    VARIABLE lower_r, lower_g, lower_b : UNSIGNED(PIXEL_DEPTH-1 DOWNTO 0);
    VARIABLE r1, g1, b1, r2, g2, b2    : STD_LOGIC;
  BEGIN

    -- Pixel data is given as 2 combined words, with the upper half containing
    -- the upper pixel and the lower half containing the lower pixel. Inside
    -- each half the pixel data is encoded in RGB order with multiple repeated
    -- bits for each subpixel depending on the chosen color depth. For example,
    -- a PIXEL_DEPTH of 3 results in a 18-bit word arranged RRRGGGBBBrrrgggbbb.
    -- The following assignments break up this encoding into the human-readable
    -- signals used above, or reconstruct it into LED data signals.
    upper   := UNSIGNED(data(DATA_WIDTH-1 DOWNTO DATA_WIDTH/2));
    lower   := UNSIGNED(data(DATA_WIDTH/2-1 DOWNTO 0));
    upper_r := upper(3*PIXEL_DEPTH-1 DOWNTO 2*PIXEL_DEPTH);
    upper_g := upper(2*PIXEL_DEPTH-1 DOWNTO PIXEL_DEPTH);
    upper_b := upper(PIXEL_DEPTH-1 DOWNTO 0);
    lower_r := lower(3*PIXEL_DEPTH-1 DOWNTO 2*PIXEL_DEPTH);
    lower_g := lower(2*PIXEL_DEPTH-1 DOWNTO PIXEL_DEPTH);
    lower_b := lower(PIXEL_DEPTH-1 DOWNTO 0);

    r1 := '0'; g1 := '0'; b1 := '0';    -- Defaults
    r2 := '0'; g2 := '0'; b2 := '0';    -- Defaults

    -- Default register next-state assignments
    next_col_count <= col_count;
    next_bpp_count <= bpp_count;
    next_row_addr  <= s_row_addr;

    -- Default signal assignments
    s_clk_out  <= '0';
    s_lat      <= '0';
    s_oe_n     <= '1';                  -- this signal is "active low"
    update_rgb <= '0';
    next_frame <= '0';

    -- States
    CASE state IS
      WHEN INIT =>
        -- If PIXEL_DEPTH = 8, there are 255 passes per frame refresh. So to
        -- count to 255 starting from 0, when reach 254, must roll over to 0
        -- on the next count.  The reason using 255 passes instead of 256 is
        -- because 0 = 0% duty cycle and therefore 255 = 100% duty cycle.
        -- For 255 to be 100%, then it must be 255/255 and not 255/256.
        --
        -- However, having said all that, to minimize ghosting, before
        -- starting PWM, make the first pass through the row write all 0's.
        -- So actually count 0 to 255 but 0 means to right all 0's.
        IF(bpp_count >= UNSIGNED(to_signed(-1, PIXEL_DEPTH))) THEN
          next_bpp_count <= (OTHERS => '0');
          next_state     <= INCR_ROW_ADDR;
        ELSE
          next_bpp_count <= bpp_count + 1;
          next_state     <= READ_PIXEL_DATA;
        END IF;

      WHEN INCR_ROW_ADDR =>
        -- display is disabled during row_addr (select lines) update
        IF (s_row_addr = "111") THEN
          next_frame <= '1';                -- indicate at start of a frame (incrementing row to 0)
        END IF;
        next_row_addr  <= STD_LOGIC_VECTOR(UNSIGNED(s_row_addr) + 1);
        next_state <= READ_PIXEL_DATA;

      WHEN READ_PIXEL_DATA =>
        IF (bpp_count /= 0) THEN
          -- If bpp_count = 0, then shift in all 0's, otherwise,
          -- Do parallel comparisons against BPP counter to gain multibit color
          IF(upper_r >= bpp_count) THEN
            r1 := '1';
          END IF;
          IF(upper_g >= bpp_count) THEN
            g1 := '1';
          END IF;
          IF(upper_b >= bpp_count) THEN
            b1 := '1';
          END IF;
          IF(lower_r >= bpp_count) THEN
            r2 := '1';
          END IF;
          IF(lower_g >= bpp_count) THEN
            g2 := '1';
          END IF;
          IF(lower_b >= bpp_count) THEN
            b2 := '1';
          END IF;
        END IF;
        update_rgb     <= '1';              -- clock out these new RGB values
        IF(col_count < IMG_WIDTH) THEN      -- check if at the rightmost side of the image
          s_oe_n     <= '0';                -- enable display while simply updating the shift register
          next_state <= INCR_COL_ADDR;
        ELSE
          s_oe_n     <= '1';                -- disable display before latch in new LED anodes
          next_state <= LATCH;
        END IF;

      WHEN INCR_COL_ADDR =>
        s_clk_out     <= '1';               -- pulse the output clock
        s_oe_n        <= '0';               -- enable display
        next_col_count <= col_count + 1;    -- update/increment column counter
        next_state    <= READ_PIXEL_DATA;

      WHEN LATCH =>
        -- display is disabled during latching
        s_lat      <= '1';                  -- latch the data
        next_col_count <= (OTHERS => '0');  -- reset the column counter
        next_state <= INIT;                 -- restart state machine

      WHEN OTHERS => NULL;
    END CASE;

    next_rgb1 <= r1 & g1 & b1;
    next_rgb2 <= r2 & g2 & b2;

  END PROCESS;

END bhv;
