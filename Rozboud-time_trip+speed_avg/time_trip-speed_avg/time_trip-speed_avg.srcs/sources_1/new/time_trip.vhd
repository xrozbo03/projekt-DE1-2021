----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 15:03:32
-- Design Name: 
-- Module Name: time_trip - Behavioral
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

entity time_trip is

    Port ( 
          clk               : in std_logic;                            -- 100HMz clock
          cycle_i           : in std_logic;                            -- input for driving verification
          cnt_1sec_i        : in std_logic;                            -- 1 second counter
          reset             : in std_logic;                            -- reset trip button
          time_count_o      : out std_logic_vector (19 - 1 downto 0);  -- sumary number of minutes on trip
          time_trip_dig1_o  : out std_logic_vector (4 - 1 downto 0);   -- data output for tens of hour digit
          time_trip_dig2_o  : out std_logic_vector (4 - 1 downto 0);   -- data output for hour digit
          time_trip_dig3_o  : out std_logic_vector (4 - 1 downto 0);   -- data output for tens of minute digit
          time_trip_dig4_o  : out std_logic_vector (4 - 1 downto 0)    -- data output for minute digit
          );
end time_trip;

------------------------------------------------------------------------
-- Architecture declaration for time trip
------------------------------------------------------------------------
architecture Behavioral of time_trip is

    -- local counter
    signal s_cnt4   : unsigned(4 - 1 downto 0)  := (others => '0');  -- tens of hours counter
    signal s_cnt3   : unsigned(4 - 1 downto 0)  := (others => '0');  -- hours counter
    signal s_cnt2   : unsigned(4 - 1 downto 0)  := (others => '0');  -- tens of minutes counter
    signal s_cnt1   : unsigned(4 - 1 downto 0)  := (others => '0');  -- minutes counter
    signal s_cnt0   : unsigned(6 - 1 downto 0)  := (others => '0');  -- seconds to determine the minute
    signal s_cntall : unsigned(19 - 1 downto 0) := (others => '0'); -- sum of all seconds
    
    signal s_enable      : std_logic;               -- enable counting process
    signal s_cnt_enable  : unsigned (4-1 downto 0); -- counter 10s to control s_enable

    -- local constants to compare specific values of counters
    constant c_NINE      : unsigned(4 - 1 downto 0) := b"1001";
    constant c_FIVE      : unsigned(4 - 1 downto 0) := b"0101";
    constant c_FIVTYNINE : unsigned(6 - 1 downto 0) := b"11_1011";

begin

p_time_trip : process(clk, cycle_i, cnt_1sec_i)
    begin
        -- wheel rotation verification
        if (cnt_1sec_i = '1') then
            s_cnt_enable <= s_cnt_enable + 1;
            
            if (cycle_i = '1') then
                s_cnt_enable <= (others => '0');
                s_enable <= '1';
            elsif (s_cnt_enable = 10) then
                s_enable <= '0';
            end if;
        
        end if;
        
        if rising_edge(clk) then

            -- counting process
            if(reset = '1') then
                -- reset counter
                s_cnt0   <= (others => '0');
                s_cnt1   <= (others => '0');
                s_cnt2   <= (others => '0');
                s_cnt3   <= (others => '0');
                s_cnt4   <= (others => '0');
                s_cntall <= (others => '0');
                
            elsif (s_enable = '1') then             -- turn on the counter while moving
                if (cnt_1sec_i = '1') then
                    s_cntall <= s_cntall + 1;          -- counting all seconds
                    s_cnt0   <= s_cnt0 + 1;            -- counting seconds to minutes
                    
                    if (s_cnt0 = c_FIVTYNINE) then         -- move to minutes
                        s_cnt1 <= s_cnt1 + 1;
                        s_cnt0 <= (others => '0');     -- clean seconds
                        
                        if (s_cnt1 = c_NINE) then         -- move to tens of minute
                            s_cnt1 <= (others => '0');    -- back to 0 in minutes
                            s_cnt2 <= s_cnt2 + 1;
                            
                            if (s_cnt2 = c_FIVE) then          -- move from minutes to hours
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
            end if;
        end if;
        
        
    end process p_time_trip;
  
    -- Outputs retype to std_logic_vector
    time_trip_dig4_o <= std_logic_vector(s_cnt1);
    time_trip_dig3_o <= std_logic_vector(s_cnt2);
    time_trip_dig2_o <= std_logic_vector(s_cnt3);
    time_trip_dig1_o <= std_logic_vector(s_cnt4);
    time_count_o     <= std_logic_vector(s_cntall);
    
end Behavioral;
