------------------------------------------------------------------------
-- Copyright (c) 2032-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_up_mode is
    generic(
        g_CNT_WIDTH : natural := 2                                  -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;                                   -- Main clock
        reset    : in  std_logic;                                   -- Synchronous reset
        en_i     : in  std_logic;                                   -- Push button input
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)   -- Output to driver_7seg_4digits_mode
    );
end cnt_up_mode;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture Behavioral of cnt_up_mode is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); -- default value of "00"
    signal s_cnt_btn   : std_logic := '0';                                      -- signal to proces button

begin
   --------------------------------------------------------------------
    -- p_cnt_up:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up counter.
    --------------------------------------------------------------------
    p_cnt_up : process(clk)
    begin

        if rising_edge(clk) then
            if (reset = '1') then                       -- Synchronous reset
                s_cnt_local <= (others => '0');         -- Clear all bits
                s_cnt_btn   <= '0';
            elsif (en_i = '1' and s_cnt_btn = '0') then -- if button is pushed after release
                s_cnt_local <= s_cnt_local + 1;
                s_cnt_btn   <= '1';
            elsif (en_i = '0' and s_cnt_btn = '1') then -- if button was released
                s_cnt_btn   <= '0';   
            end if;
        end if;
    end process p_cnt_up;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_o <= std_logic_vector(s_cnt_local);


end Behavioral;
