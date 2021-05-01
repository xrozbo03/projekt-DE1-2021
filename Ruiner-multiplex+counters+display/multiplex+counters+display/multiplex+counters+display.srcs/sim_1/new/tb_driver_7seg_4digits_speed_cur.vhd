------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_driver_7seg_4digits_speed_cur is
    -- Entity of testbench is always empty
end entity tb_driver_7seg_4digits_speed_cur;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_driver_7seg_4digits_speed_cur is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz      : std_logic;
    --- WRITE YOUR CODE HERE
    signal s_reset           : std_logic;

    signal s_speed_cur_dig1  : std_logic_vector(4 - 1 downto 0);
    signal s_speed_cur_dig2  : std_logic_vector(4 - 1 downto 0);
    signal s_speed_cur_dig3  : std_logic_vector(4 - 1 downto 0); 
    signal s_speed_cur_dig4  : std_logic_vector(4 - 1 downto 0);    
    signal s_dp              : std_logic_vector(4 - 1 downto 0);  
    signal s_seg             : std_logic_vector(7 - 1 downto 0);   
    signal s_dig             : std_logic_vector(4 - 1 downto 0);
    signal s_colon           : std_logic;
    signal s_colon_cathode   : std_logic;

begin
    -- Connecting testbench signals with driver_7seg_4digits_speed_cur entity
    -- (Unit Under Test)
    --- WRITE YOUR CODE HERE
    uut_driver_7seg : entity work.driver_7seg_4digits_speed_cur
    port map(
        clk                => s_clk_100MHz,
        reset              => s_reset,
        speed_cur_dig1_i   => s_speed_cur_dig1,
        speed_cur_dig2_i   => s_speed_cur_dig2,
        speed_cur_dig3_i   => s_speed_cur_dig3,
        speed_cur_dig4_i   => s_speed_cur_dig4,
        dp_o               => s_dp,
        seg_o              => s_seg,
        colon_o            => s_colon,
        colon_cathode_o    => s_colon_cathode, 
        dig_o              => s_dig
    );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 32 ms loop
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    --- WRITE YOUR CODE HERE
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 23 ms;

        -- Reset activated
        s_reset <= '1';
        wait for 4 ms;
        assert(s_seg = "0000100" and s_dig = "1000")
        report "Test failed for reset value 1" severity error;

        s_reset <= '0';
        wait;
    end process p_reset_gen;
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        
        s_speed_cur_dig1 <= "0011";
        s_speed_cur_dig2 <= "0001";
        s_speed_cur_dig3 <= "0100";
        s_speed_cur_dig4 <= "0010";
        
        wait for 4 ms;
        assert(s_seg = "0000110" and s_dig = "1000")
        report "Test failed for digit 1" severity error;
        
        wait for 4 ms;
        assert(s_seg = "1001111" and s_dig = "0100")
        report "Test failed for digit 2" severity error;
        
        wait for 4 ms;
        assert(s_seg = "1001100" and s_dig = "0010")
        report "Test failed for digit 3" severity error;
        
        wait for 4 ms;
        assert(s_seg = "0010010" and s_dig = "0001")
        report "Test failed for digit 4" severity error;
        
        wait for 2ms;
        assert(s_seg = "0000110" and s_dig = "1000")
        report "Test failed for digit 1 before change" severity error;
        
        s_speed_cur_dig1 <= "1001";
        wait for 2ms;
        assert(s_seg = "0000100" and s_dig = "1000")
        report "Test failed for digit 1 after change" severity error;
        
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end architecture testbench;
