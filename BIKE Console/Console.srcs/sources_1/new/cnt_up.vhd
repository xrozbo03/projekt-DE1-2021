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
entity cnt_up is
    generic(
        g_CNT_WIDTH : natural := 2      -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;                                   -- Main clock
        reset    : in  std_logic;                                   -- Synchronous reset
        en_i     : in  std_logic;                                   -- Enable input
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)   -- Output signal for selected digit
    );
end entity cnt_up;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_up is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); -- default value of "00"

begin
    --------------------------------------------------------------------
    -- p_cnt_up:
    -- Clocked process with synchronous reset which implements 2-bit
    -- up counter.
    --------------------------------------------------------------------
    p_cnt_up : process(clk)
    begin

        if rising_edge(clk) then
            if (reset = '1') then                  -- Synchronous reset
                s_cnt_local <= (others => '0');    -- Clear all bits
            elsif (en_i = '1') then                -- Test if counter is enabled
                s_cnt_local <= s_cnt_local + 1;    -- Increase local counter by 1
            end if;
        end if;
    end process p_cnt_up;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;