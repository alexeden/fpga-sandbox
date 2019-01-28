-- Adafruit RGB LED Matrix Display Driver
-- User-editable configuration and constants package

library ieee;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package rgbmatrix is

    -- User configurable constants
    constant NUM_PANELS   : integer := 1; -- total number of LED matrix panels
    constant PIXEL_DEPTH  : integer := 8; -- number of bits per pixel

    -- Special constants (change these at your own risk, stuff might break!)
    constant PANEL_WIDTH  : integer := 32; -- width of the panel in pixels
    constant PANEL_HEIGHT : integer := 16; -- height of the panel in pixels
    constant DATA_WIDTH   : positive := PIXEL_DEPTH*6;
                                         -- one bit for each subpixel (3), times
                                         -- the number of simultaneous lines (2)

    -- Derived constants
    constant ADDR_WIDTH     : positive := positive(log2(real(NUM_PANELS*PANEL_WIDTH*PANEL_HEIGHT/2)));
    constant IMG_WIDTH      : positive := PANEL_WIDTH*NUM_PANELS;
    constant IMG_WIDTH_LOG2 : positive := positive(log2(real(IMG_WIDTH)));

end rgbmatrix;
