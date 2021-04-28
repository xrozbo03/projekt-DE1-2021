----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.04.2021 20:37:07
-- Design Name: 
-- Module Name: tb_count_1sec - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_cycle is
    -- Entity of testbench is always empty
end entity tb_cycle; 

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cycle is

    -- Number of bits for testbench counter
   -- constant c_CNT_WIDTH         : natural := 2;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_rst        : std_logic;
    signal s_en         : std_logic;
    signal s_cycle      : std_logic_vector(2 - 1 downto 0);
    signal s_hall_sens_i : std_logic
    

begin
  
    uut_cycle : entity work.cycle
       
        port map(
            clk      => s_clk_100MHz,
            rst    => s_rst,
            en_i     => s_en,
            cycle_o  => s_cycle,
            hall_sens_i => s_hall_sens_i
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock
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
    p_reset_gen : process
    begin
           s_rst <= '0';
        wait for 20 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cycle = "00"  --error report
        report "Stimulus process failed" severity error;  

        
        s_rst <= '0';
        wait for 200 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cycle = "00"
        report "Stimulus process failed" severity error;

        
        s_rst <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
     report "Stimulus process started" severity note;
        
        s_cycle <= '0';
        s_rst <= '0';
        
        
        while now < 1000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
       
       s_rst <= '1';
       wait for 1 ps;
       s_rst <= '0';
       
        while now < 10000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
        
        wait for 2000 ns;
        
        while now < 52000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
       
       s_rst <= '1';
       wait for 1 ns;
       s_rst <= '0';

        
        while now < 10000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
                  
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;