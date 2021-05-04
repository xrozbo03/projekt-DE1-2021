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
          clk               : in std_logic;                            -- 100HMz clock        
          reset             : in std_logic;                            -- reset trip button
          cnt_1sec_i        : in std_logic;                            -- 1 second count
          time_count_i      : in std_logic_vector(19 - 1 downto 0);    -- time for trip in seconds
          distance_i        : in std_logic_vector (19 - 1 downto 0);   -- distance for trip in meters
          speed_avg_dig1_o  : out std_logic_vector(4 - 1 downto 0);    -- average speed tens of km/h
          speed_avg_dig2_o  : out std_logic_vector(4 - 1 downto 0);    -- average speed km/h
          speed_avg_dig3_o  : out std_logic_vector(4 - 1 downto 0);    -- average speed first decimal place
          speed_avg_dig4_o  : out std_logic_vector(4 - 1 downto 0)     -- average speed second decimal place
    );
end speed_avg;

------------------------------------------------------------------------
-- Architecture declaration for speed average
------------------------------------------------------------------------
architecture Behavioral of speed_avg is

    -- local sinals  
    signal s_enable_conversion : std_logic; -- release conversion from m/s to km/h
    signal s_enable_new_value  : std_logic; -- release new value for distance and time
    
    signal s_time              : natural;  -- signal with time value
    signal s_distance          : natural;  -- signal with distance value
    signal s_cnt_result        : natural;  -- result in m/s
    signal s_final_result      : natural;   -- unit conversion to km/h
    signal s_result_in_natural : natural;   -- result in KM/H
    
    signal s_cnt4   : unsigned(4 - 1 downto 0) := (others => '0');  -- average speed tens of km/h
    signal s_cnt3   : unsigned(4 - 1 downto 0) := (others => '0');  -- average speed km/h
    signal s_cnt2   : unsigned(4 - 1 downto 0) := (others => '0');  -- average speed first decimal place
    signal s_cnt1   : unsigned(4 - 1 downto 0) := (others => '0');  -- average speed second decimal place
    
    -- local constants to compare specific values of counters
    constant c_NINE      : unsigned(4 - 1 downto 0) := b"1001";

begin

p_speed_avg : process (clk)
    begin
    
        if rising_edge(clk) then
             
             if (reset = '1') or ((s_enable_new_value = '1') and (cnt_1sec_i = '1')) then        -- reset counters value and set new distance and time.
                 s_cnt_result        <= 0;
                 s_distance          <= (TO_INTEGER(unsigned(distance_i))) * 100;                --  *100 to second decimal result
                 s_time              <= (TO_INTEGER(unsigned(time_count_i)));
                 s_final_result      <= 0;
                 s_cnt1              <= (others => '0');
                 s_cnt2              <= (others => '0');
                 s_cnt3              <= (others => '0');
                 s_cnt4              <= (others => '0');
                 s_enable_conversion <= '0';
                 s_enable_new_value  <= '0';
                 
             elsif (cnt_1sec_i = '0') and (s_enable_new_value = '0') then 
                 s_enable_new_value  <= '1';
                 
             elsif (s_distance >= s_time) then
                 s_distance   <= s_distance - s_time;
                 s_cnt_result <= s_cnt_result + 1;
                  
             elsif (s_enable_conversion = '0') then
                 s_result_in_natural <= s_cnt_result;
                 s_final_result <= s_result_in_natural * 18;                   -- 3,6x m/s -> km/h *100 to second decimal
                 s_enable_conversion <= '1';
             
             elsif (s_final_result >= 5) then
                 s_final_result <= s_final_result - 5;
                 s_cnt1   <= s_cnt1 + 1;            -- counting second decimal place
                 if (s_cnt1 = c_NINE) then         -- move to tens of minute
                     s_cnt1 <= (others => '0');    -- back to 0 in minutes
                     s_cnt2 <= s_cnt2 + 1;
                       
                     if (s_cnt2 = c_NINE) then          -- move from minutes to hours
                         s_cnt2 <= (others => '0');    -- back to 0 in tens of minutes
                         s_cnt3 <= s_cnt3 + 1;
                           
                         if (s_cnt3 = c_NINE) then         -- move to tens of hours
                             s_cnt3 <= (others => '0');    -- back to 0 in hours
                             s_cnt4 <= s_cnt4 + 1;
                               
                             if(s_cnt4 = c_NINE) then
                                 s_cnt4 <= (others => '0'); -- back to 0 in tens of hours
                                  
                             end if;
                         end if;
                     end if;
                 end if;
             end if;
         end if; 
         
    -- Outputs retype to std_logic_vector
    speed_avg_dig1_o <= std_logic_vector(s_cnt4);
    speed_avg_dig2_o <= std_logic_vector(s_cnt3);
    speed_avg_dig3_o <= std_logic_vector(s_cnt2);
    speed_avg_dig4_o <= std_logic_vector(s_cnt1); 

    end process p_speed_avg;

end Behavioral;
