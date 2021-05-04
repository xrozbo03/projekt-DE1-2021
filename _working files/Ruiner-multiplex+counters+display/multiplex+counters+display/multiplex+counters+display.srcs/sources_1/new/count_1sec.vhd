------------------------------------------------------------------------
-- Copyright (c) 2032-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_1sec is
    Port ( 
        clk           : in STD_LOGIC;       -- Main clock
        cnt_o         : out STD_LOGIC       -- 1 second output
    );
end count_1sec;

architecture Behavioral of count_1sec is

    signal cnt_1sec : unsigned(27 - 1 downto 0) := (others => '0');                 -- Local counter
    constant second : unsigned(27 - 1 downto 0) := "101111101011110000100000000";   -- 100000000 clock pulses to 1 sec

begin
    
    p_clk_ena : process(clk)
    begin
        if(rising_edge(clk)) then
            if (cnt_1sec >= (second-1)) then    -- If local counter value is equal to 100000000
                cnt_o    <= '1';                -- Set output to high
                cnt_1sec <= (others => '0');    -- Reset local counter value
            else
                cnt_o    <= '0';                -- Set output to low
                cnt_1sec <= cnt_1sec+1;         -- Increase local counter by 1
            end if;
        end if;
    end process p_clk_ena;

end Behavioral;
