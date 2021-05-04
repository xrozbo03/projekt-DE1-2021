------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tire_diameter is
    port(
        sw_i             : in  std_logic_vector(3 - 1 downto 0);  -- Switches to select tire diameter                        
        tire_diameter_o  : out std_logic_vector(5 - 1 downto 0)   -- Output to send selected value
    );
end tire_diameter;

architecture testbench of tire_diameter is

begin

    p_diameter : process(sw_i)
    begin
        case sw_i is
            when "000"   =>      
                tire_diameter_o <= "11101";         -- Combination "00" corresponds to the diameter of 29''   (737 mm)
            when "001"   =>      
                tire_diameter_o <= "11100";         -- Combination "01" corresponds to the diameter of 28''   (711 mm)
            when "010"   =>      
                tire_diameter_o <= "11011";         -- Combination "10" corresponds to the diameter of 27,5'' (699 mm)
            when "011"   =>      
                tire_diameter_o <= "11010";         -- Combination "10" corresponds to the diameter of 26''   (660 mm)
            when "100"   =>      
                tire_diameter_o <= "11000";         -- Combination "10" corresponds to the diameter of 24''   (610 mm)
            when "101"   =>      
                tire_diameter_o <= "10100";         -- Combination "10" corresponds to the diameter of 20''   (508 mm)
            when "110"   =>      
                tire_diameter_o <= "10000";         -- Combination "10" corresponds to the diameter of 16''   (406 mm)        
            when others =>      
                tire_diameter_o <= "01100";         -- Combination "11" corresponds to the diameter of 12''   (305 mm)
        end case;
    end process p_diameter;

end architecture testbench;
