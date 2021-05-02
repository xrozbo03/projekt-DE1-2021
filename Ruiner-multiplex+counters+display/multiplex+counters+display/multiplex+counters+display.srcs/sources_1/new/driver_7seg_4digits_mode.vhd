------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations
use ieee.numeric_std.all;   -- Package for arithmetic operations

entity driver_7seg_4digits_mode is
    Port ( 
           clk                : in  std_logic;                             -- Main clock
           reset              : in  std_logic;                             -- Synchronous reset
           en_i               : in  std_logic;                             -- Button to select mode
           speed_avg_dig1_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Speed average value for 1. digit (tens of kilometers)
           speed_avg_dig2_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Speed average value for 2. digit (kilometers)
           speed_avg_dig3_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Speed average value for 3. digit (hundreds of meters)
           speed_avg_dig4_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Speed average value for 4. digit (tens of meters)
           trip_dig1_i        : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 1. digit (hundreds of kilometers)
           trip_dig2_i        : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 2. digit (tens of kilometers)
           trip_dig3_i        : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 3. digit (kilometers)
           trip_dig4_i        : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 4. digit (hundreds of meters)
           all_dig1_i         : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 1. digit (thousands of kilometers)
           all_dig2_i         : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 2. digit (hundreds of kilometers)
           all_dig3_i         : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 3. digit (tens of kilometers)
           all_dig4_i         : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 4. digit (kilometers)
           time_trip_dig1_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Current time of 1 trip value for 1. digit (tens of hours)
           time_trip_dig2_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Current time of 1 trip value for 2. digit (hours)
           time_trip_dig3_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Current time of 1 trip value for 3. digit (tens of minutes)
           time_trip_dig4_i   : in STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Current time of 1 trip value for 4. digit (minutes)
           seg_o              : out std_logic_vector (7 - 1 downto 0);     -- Cathode values for individual segments
           LED_o              : out STD_LOGIC_VECTOR (4 - 1 downto 0);     -- LEDs on board to display which mode is selected
           dig_o              : out STD_LOGIC_VECTOR (4 - 1 downto 0);     -- Choose which digit will be active (enable anode)
           dp_o               : out STD_LOGIC_VECTOR (4 - 1 downto 0)      -- Choose decimal point of the digit
    ); 
end driver_7seg_4digits_mode;

architecture Behavioral of driver_7seg_4digits_mode is

    -- Internal clock enable
    signal s_en        : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt       : std_logic_vector(2 - 1 downto 0);
    -- Internal signal to select mode
    signal s_cnt_mode  : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex       : std_logic_vector(4 - 1 downto 0);
    
begin

    --------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 4 ms
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 400000
        )
        port map(
            clk => clk,
            reset => reset,
            ce_o => s_en
        );

    --------------------------------------------------------------------
    -- Instance (copy) of cnt_up entity performs a 2-bit up
    -- counter
    bin_cnt0 : entity work.cnt_up
        generic map(
            g_CNT_WIDTH => 2
        )
        port map(
            clk         => clk,
            reset       => reset,
            en_i        => s_en,
            cnt_o       => s_cnt
        );
        
     --------------------------------------------------------------------
     -- Instance (copy) of cnt_up_mode entity performs a 2-bit up
     -- counter
     bin_cnt1 : entity work.cnt_up_mode
         generic map(
             g_CNT_WIDTH => 2
         )
         port map(
             clk         => clk,
             reset       => reset,
             en_i        => en_i,
             cnt_o       => s_cnt_mode
         );

    --------------------------------------------------------------------
    -- Instance (copy) of hex_7seg entity performs a 7-segment display
    -- decoder
    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );
        
    --------------------------------------------------------------------
    -- p_mux:
    -- A combinational process that implements a multiplexer for
    -- selecting data for a single digit, a decimal point signal, colon and 
    -- switches the common anodes of each display.
    --------------------------------------------------------------------       
    p_mux : process(s_cnt, s_cnt_mode,
                    speed_avg_dig1_i, speed_avg_dig2_i, speed_avg_dig3_i, speed_avg_dig4_i,
                    trip_dig1_i, trip_dig2_i, trip_dig3_i, trip_dig4_i,
                    all_dig1_i, all_dig2_i, all_dig3_i, all_dig4_i,
                    time_trip_dig1_i, time_trip_dig2_i, time_trip_dig3_i, time_trip_dig4_i)
    begin 
        case s_cnt_mode is
            when "00" =>                            -- Average speed is assigned to the mode combination "00"
                dp_o    <= "0100";                  -- Enabled decimal point for average speed (second digit - kilometers)
                LED_o   <= "1000";                  -- Turn on LED 4
                if (s_cnt = "00") then
                    s_hex <= speed_avg_dig1_i;      -- Display tens of kilometers if counter combination is "00"
                    dig_o <= "1000";                -- Enable 1. digit from the left
                elsif (s_cnt = "01") then
                    s_hex <= speed_avg_dig2_i;      -- Display kilometers if counter combination is "01"
                    dig_o <= "0100";                -- Enable 2. digit from the left
                elsif (s_cnt = "10") then
                    s_hex <= speed_avg_dig3_i;      -- Display hundreds of meters if counter combination is "10"
                    dig_o <= "0010";                -- Enable 3. digit from the left
                else
                    s_hex <= speed_avg_dig4_i;      -- Display tens of meters if counter combination is "11"
                    dig_o <= "0001";                -- Enable 4. digit from the left
                end if;
                
            when "01" =>                            -- Trip distance is assigned to the mode combination "01"
                dp_o    <= "0010";                  -- Enabled decimal point for trip distance (third digit - kilometers)
                LED_o   <= "0100";                  -- Turn on LED 5
                if (s_cnt = "00") then
                    s_hex <= trip_dig1_i;           -- Display tens of kilometers if counter combination is "00"
                    dig_o <= "1000";                -- Enable 1. digit from the left
                elsif (s_cnt = "01") then
                    s_hex <= trip_dig2_i;           -- Display kilometers if counter combination is "01"
                    dig_o <= "0100";                -- Enable 2. digit from the left
                elsif (s_cnt = "10") then
                    s_hex <= trip_dig3_i;           -- Display hundreds of meters if counter combination is "10"
                    dig_o <= "0010";                -- Enable 3. digit from the left
                else
                    s_hex <= trip_dig4_i;           -- Display tens of meters if counter combination is "11"
                    dig_o <= "0001";                -- Enable 4. digit from the left
                end if;
                
            when "10" =>                            -- Total distance is assigned to the mode combination "10"
                dp_o    <= "0000";                  -- Disabled decimal point for total distance
                LED_o   <= "0010";                  -- Turn on LED 6
                if (s_cnt = "00") then
                    s_hex <= all_dig1_i;            -- Display tens of kilometers if counter combination is "00"
                    dig_o <= "1000";                -- Enable 1. digit from the left
                elsif (s_cnt = "01") then
                    s_hex <= all_dig2_i;            -- Display kilometers if counter combination is "01"
                    dig_o <= "0100";                -- Enable 2. digit from the left
                elsif (s_cnt = "10") then
                    s_hex <= all_dig3_i;            -- Display hundreds of meters if counter combination is "10"
                    dig_o <= "0010";                -- Enable 3. digit from the left
                else
                    s_hex <= all_dig4_i;            -- Display tens of meters if counter combination is "11"
                    dig_o <= "0001";                -- Enable 4. digit from the left
                end if;
                
            when others =>                          -- Time trip is assigned to the mode combination "11"
                dp_o    <= "0010";                  -- Disabled decimal point for time trip
                LED_o   <= "0001";                  -- Turn on LED 7
                if (s_cnt = "00") then
                    s_hex <= time_trip_dig1_i;      -- Display tens of hours if counter combination is "00"
                    dig_o <= "1000";                -- Enable 1. digit from the left
                elsif (s_cnt = "01") then
                    s_hex <= time_trip_dig2_i;      -- Display hours if counter combination is "01"
                    dig_o <= "0100";                -- Enable 2. digit from the left
                elsif (s_cnt = "10") then
                    s_hex <= time_trip_dig3_i;      -- Display tens of minutes if counter combination is "10"
                    dig_o <= "0010";                -- Enable 3. digit from the left
                else
                    s_hex <= time_trip_dig4_i;      -- Display tens of hours if counter combination is "11"
                    dig_o <= "0001";                -- Enable 4. digit from the left
                end if;
        end case;
    end process p_mux;

end Behavioral;
