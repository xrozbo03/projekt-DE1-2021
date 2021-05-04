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

    p_hall_sens : process(hall_sens_i)
    begin
        if(hall_sens_i = '0') then  -- If magnet gets near the sensor, logic low value is generated
            cycle_o <= '1';         -- Generetes high output
        else
            cycle_o <= '0';         -- Hall sensor generates logic high value if the magnet is not near the sensor
        end if;
    end process p_hall_sens;

end Behavioral;