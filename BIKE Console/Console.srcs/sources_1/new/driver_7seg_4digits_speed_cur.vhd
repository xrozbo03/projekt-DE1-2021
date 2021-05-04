------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------------------
entity driver_7seg_4digits_speed_cur is
    port(
        clk              : in  std_logic;                           -- Main clock
        reset            : in  std_logic;                           -- Synchronous reset
        -- 4-bit input values for individual digits
        speed_cur_dig1_i : in  std_logic_vector(4 - 1 downto 0);    -- Current speed value for 1. digit (tens of kilometers)
        speed_cur_dig2_i : in  std_logic_vector(4 - 1 downto 0);    -- Current speed value for 2. digit (kilometers)
        speed_cur_dig3_i : in  std_logic_vector(4 - 1 downto 0);    -- Current speed value for 3. digit (hundreds of meters)
        speed_cur_dig4_i : in  std_logic_vector(4 - 1 downto 0);    -- Current speed value for 4. digit (tens of meters)
        -- Cathode values for individual segments
        seg_o            : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays
        dig_o            : out std_logic_vector(4 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o             : out std_logic
    );
end entity driver_7seg_4digits_speed_cur;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of driver_7seg_4digits_speed_cur is

    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);
    -- Internal decimal point value
    signal dp    : std_logic_vector(4 - 1 downto 0);

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
    -- selecting data for a single digit, a decimal point signal and
    -- switches the common anodes of each display.
    --------------------------------------------------------------------
    p_mux : process(s_cnt, speed_cur_dig1_i, speed_cur_dig2_i, speed_cur_dig3_i, speed_cur_dig4_i)
    begin
        dp            <= "1011";
        case s_cnt is
            when "11" =>
                s_hex <= speed_cur_dig4_i;
                dig_o <= "0001";
                dp_o  <= dp(0);

            when "10" =>
                s_hex <= speed_cur_dig3_i;
                dig_o <= "0010";
                dp_o  <= dp(1);

            when "01" =>
                s_hex <= speed_cur_dig2_i;
                dig_o <= "0100";
                dp_o  <= dp(2);

            when others =>
                s_hex <= speed_cur_dig1_i;
                dig_o <= "1000";
                dp_o  <= dp(3);

        end case;
    end process p_mux;

end architecture Behavioral;