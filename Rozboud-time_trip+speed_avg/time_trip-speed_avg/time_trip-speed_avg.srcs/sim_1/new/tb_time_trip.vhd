----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 21:02:09
-- Design Name: 
-- Module Name: tb_time_trip - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_time_trip is
--  Port ( );
end tb_time_trip;

architecture testbench of tb_time_trip is
    
    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 1 ns; -- 1 ns for faster simulation
    
    -- local signals
    signal s_clk             : std_logic;
    signal s_cycle           : std_logic;
    signal s_cnt_1sec        : std_logic;
    signal s_reset           : std_logic;
    signal s_time_count      : std_logic_vector (19 - 1 downto 0);
    signal s_time_trip_dig1  : std_logic_vector (4 - 1 downto 0);
    signal s_time_trip_dig2  : std_logic_vector (4 - 1 downto 0);
    signal s_time_trip_dig3  : std_logic_vector (4 - 1 downto 0);
    signal s_time_trip_dig4  : std_logic_vector (4 - 1 downto 0);
    
begin
    -- Unit under test
    uut_time_trip : entity work.time_trip
        port map (
            clk              =>  s_clk,
            cycle_i          =>  s_cycle,
            cnt_1sec_i       =>  s_cnt_1sec,      
            reset            =>  s_reset,         
            time_count_o     =>  s_time_count,    
            time_trip_dig1_o =>  s_time_trip_dig1,
            time_trip_dig2_o =>  s_time_trip_dig2,
            time_trip_dig3_o =>  s_time_trip_dig3,
            time_trip_dig4_o =>  s_time_trip_dig4
        );

 --------------------------------------------------------------------
 -- Clock generation process
 --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 365000 ns loop         -- 36500 periods of 100MHz clock
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
 --------------------------------------------------------------------
 -- Reset generation process
 --------------------------------------------------------------------
    p_reset_gen : process
    begin
        -- Reset deactivated
        s_reset <= '0'; wait for 100 ns;
        -- Reset activated
        s_reset <= '1'; wait for 30 ns;

        s_reset <= '0'; wait for 150 ns;

        s_reset <= '1'; wait for 2 ns;

        s_reset <= '0';
        wait;
    end process p_reset_gen;

  --------------------------------------------------------------------
  -- Generation process for 1 sec counter simulation
  --------------------------------------------------------------------
    p_clk_1sec_gen : process
    begin
    
        s_cnt_1sec <= '0';
        wait for 500 ns;
        
        while now < 365000 ns loop         -- 73000 periods of 1 sec enambe signal
            s_cnt_1sec <= '0';
            wait for 5ns;
            s_cnt_1sec <= '1';
            wait for 5ns;
        end loop;
        wait;
    end process p_clk_1sec_gen;
    
  --------------------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        
         while now < 6000 ns loop         -- 1000 periods of cycle
            s_cycle <= '0';
            wait for 5ns;
            s_cycle <= '1';
            wait for 1ns;
        end loop;
        
        s_cycle <= '0';
        wait for 1000 ns;
        
        while now < 360000 ns loop         -- 60000  periods of cycle
            s_cycle <= '0';
            wait for 5ns;
            s_cycle <= '1';
            wait for 1ns;
        end loop;
        
        s_cycle <= '0';

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;


end testbench;
