----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2021 11:30:12
-- Design Name: 
-- Module Name: tb_speed_avg - Behavioral
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

entity tb_speed_avg is
--  Port ( );
end tb_speed_avg;

architecture Behavioral of tb_speed_avg is
    
    -- Local constants
    constant c_CLK_100MHZ_PERIOD   : time    := 1 ns; -- 1ns for faster simulation

    -- local signals
    signal s_clk           : std_logic;
    signal s_cnt_1sec      : std_logic;
    signal s_time_count    : std_logic_vector(19 - 1 downto 0);
    signal s_distance      : std_logic_vector (19 - 1 downto 0);
    
    signal s_test : std_logic_vector(19 - 1 downto 0);          

begin
    -- Unit under test
    uut_speed_avg : entity work.speed_avg
        port map (
            clk          => s_clk,
            cnt_1sec_i   => s_cnt_1sec,
            time_count_i => s_time_count,
            distance_i   => s_distance,
            test_o       => s_test
        );
        
  --------------------------------------------------------------------
  -- Generation process for 1 sec counter simulation
  --------------------------------------------------------------------
    p_clk_1sec_gen : process
    begin
        -- 1000 ns sequence
        s_cnt_1sec <= '0';
        wait for 100ns;
        s_cnt_1sec <= '1';
        wait for 100ns;
        s_cnt_1sec <= '0';
        wait for 100ns;
        s_cnt_1sec <= '1';
        wait for 100ns;
        s_cnt_1sec <= '0';
        wait for 100ns;
        s_cnt_1sec <= '1';
        wait for 100ns;
        s_cnt_1sec <= '0';
        wait for 100ns;
        s_cnt_1sec <= '1';
        wait for 100ns;
        s_cnt_1sec <= '0';
        wait for 100ns;
        s_cnt_1sec <= '1';
        wait for 100ns;
        -- end sequence

        
    end process p_clk_1sec_gen;
    
  --------------------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 1000 ns loop                -- 1000 periods of 100MHz clock
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
  --------------------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;


        wait for 100ns;

        s_distance <= "0000000000001100100";   -- 100
        s_time_count <= "0000000000000001000"; -- 8
        wait for 200ns;
        
        s_distance <= "0000000000000110010";   -- 50
        s_time_count <= "0000000000000000010"; -- 2
        wait for 200ns;

        s_distance <= "0000000110001001110";   -- 3150
        s_time_count <= "0000000000000110010"; -- 50
        wait for 200ns;
        
        s_distance <= "0000000000000110010";   -- 50
        s_time_count <= "0000000000000000010"; -- 2
        wait for 400ns;
        
        s_distance <= "0000000110001001110";   -- 3150
        s_time_count <= "0000000000000001000"; -- 8
        wait for 200ns;
        
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;
