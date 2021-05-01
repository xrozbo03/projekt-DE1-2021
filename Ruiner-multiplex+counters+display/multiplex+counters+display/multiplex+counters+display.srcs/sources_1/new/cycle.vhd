------------------------------------------------------------------------
-- Copyright (c) 2032-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cycle is
    Port ( 
        hall_sens_i           : in STD_LOGIC;   -- Hall sensor input
        cycle_o               : out STD_LOGIC   -- Reverse logic output
    );
end cycle;

architecture Behavioral of cycle is

begin

    p_clk_ena : process(hall_sens_i)
    begin
        if(hall_sens_i = '0') then
            cycle_o <= '1';
        else
            cycle_o <= '0';
        end if;
    end process p_clk_ena;

end Behavioral;
