----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 21:01:33
-- Design Name: 
-- Module Name: speed_avg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity speed_avg is
    Port (
          clk               : in std_logic;
          cnt_1sec_i        : in std_logic;                            -- 1 second count
          time_count_i      : in std_logic_vector(19 - 1 downto 0);    -- time for trip in seconds
          distance_i        : in std_logic_vector (19 - 1 downto 0);   -- distance for trip in meters
          
          test_o : out std_logic_vector(19 - 1 downto 0);
          
          speed_avg_dig1_o  : out std_logic_vector(4 - 1 downto 0);
          speed_avg_dig2_o  : out std_logic_vector(4 - 1 downto 0);
          speed_avg_dig3_o  : out std_logic_vector(4 - 1 downto 0);
          speed_avg_dig4_o  : out std_logic_vector(4 - 1 downto 0)
    );
end speed_avg;

------------------------------------------------------------------------
-- Architecture declaration for speed average
------------------------------------------------------------------------
architecture Behavioral of speed_avg is

    -- local sinals
    signal s_time       : unsigned (19 - 1 downto 0);
    signal s_distance   : unsigned (19 - 1 downto 0);
    signal s_cnt_result : unsigned (19 - 1 downto 0);

begin

p_speed_avg : process (clk)
    begin
       if rising_edge(clk) then
           if (cnt_1sec_i = '1')then 
                s_cnt_result <= (others => '0');
                s_distance   <= unsigned(distance_i);
                s_time       <= unsigned(time_count_i);
                    
            elsif (s_time <= s_distance) then
                s_distance <= s_distance - s_time;
                s_cnt_result <= s_cnt_result + 1;
            else
                test_o <= std_logic_vector(s_cnt_result);
            end if;
       end if; 
       
    end process p_speed_avg;

end Behavioral;
