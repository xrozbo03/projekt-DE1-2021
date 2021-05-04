------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_hex_7seg is
end tb_hex_7seg;

architecture testbench of tb_hex_7seg is

    -- Local signals
    signal s_hex       : std_logic_vector(4 - 1 downto 0);
    signal s_seg       : std_logic_vector(7 - 1 downto 0);

begin

    -- Connecting testbench signals with hex_7seg entity (Unit Under Test)
    uut_hex_7seg : entity work.hex_7seg
        port map(
            hex_i           => s_hex,
            seg_o           => s_seg
        );
        
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;


        -- First test values
        s_hex <= "0000";   -- 0 
        wait for 100 ns;
        assert(s_seg = "0000001")
        report "Test failed for input data '0000'" severity error;
        
        s_hex <= "0001";   -- 1 
        wait for 50 ns;
        assert(s_seg = "1001111")
        report "Test failed for input data '0001'" severity error;
        
        s_hex <= "0010";   -- 2 
        wait for 50 ns;
        assert(s_seg = "0010010")
        report "Test failed for input data '0010'" severity error; 
        
        s_hex <= "0011";   -- 3 
        wait for 50 ns;
        assert(s_seg = "0000110")
        report "Test failed for input data '0011'" severity error; 
        
        s_hex <= "0100";   -- 4 
        wait for 50 ns;
        assert(s_seg = "1001100")
        report "Test failed for input data '0100'" severity error; 
        
        s_hex <= "0101";   -- 5 
        wait for 50 ns;
        assert(s_seg = "0100100")
        report "Test failed for input data '0101'" severity error; 
        
        s_hex <= "0110";   -- 6 
        wait for 50 ns; 
        assert(s_seg = "0100000")
        report "Test failed for input data '0110'" severity error;
        
        s_hex <= "0111";   -- 7 
        wait for 50 ns;
        assert(s_seg = "0001111")
        report "Test failed for input data '0111'" severity error; 
        
        s_hex <= "1000";   -- 8 
        wait for 50 ns;
        assert(s_seg = "0000000")
        report "Test failed for input data '1000'" severity error; 
        
        s_hex <= "1001";   -- 9 
        wait for 50 ns; 
        assert(s_seg = "0000100")
        report "Test failed for input data '1001'" severity error;       
        
        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;    

end architecture testbench;
