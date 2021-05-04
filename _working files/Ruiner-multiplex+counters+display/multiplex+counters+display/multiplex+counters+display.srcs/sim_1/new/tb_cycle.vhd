------------------------------------------------------------------------
-- Copyright (c) 2020-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_cycle is
end entity tb_cycle; 

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cycle is

    signal s_hall_sens  : std_logic;
    signal s_cycle      : std_logic;

begin
    -- Connecting testbench signals with cycle entity
    -- (Unit Under Test)
    uut_cnt : entity work.cycle
        port map(
            hall_sens_i => s_hall_sens,
            cycle_o     => s_cycle
        );

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        
        -- Default value for Hall sensor
        s_hall_sens <= '1';
        wait for 50 ns;
        
        -- 1 cycle
        s_hall_sens <= '0';
        wait for 10 ns;
        assert(s_cycle = '1')
        report "Test failed for low value of Hall sensor" severity error;

        -- Return to default state
        s_hall_sens <= '1';
        wait for 100 ns;
        assert(s_cycle = '0')
        report "Test failed for high value of Hall sensor" severity error;
        
        -- 1 cycle
        s_hall_sens <= '0';
        wait for 10 ns;

        -- Return to default state
        s_hall_sens <= '1';
        wait for 10 ns;
        
        -- 1 cycle
        s_hall_sens <= '0';
        wait for 10 ns;
        
        -- Return to default state
        s_hall_sens <= '1';
        wait for 10 ns;
        
        -- 1 cycle
        s_hall_sens <= '0';
        wait for 10 ns;
        
        -- Return to default state
        s_hall_sens <= '1';
        wait for 10 ns;
        
        -- 1 cycle
        s_hall_sens <= '0';
        wait for 10 ns;
        
        s_hall_sens <= '1';
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;
