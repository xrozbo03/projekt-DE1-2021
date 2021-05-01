# driver_7seg_4digits_mode

## Design

```vhdl
------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_driver_7seg_4digits_mode is
end tb_driver_7seg_4digits_mode;

architecture testbench of tb_driver_7seg_4digits_mode is
    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    -- Local signals
    signal s_clk_100MHz         : std_logic;
    signal s_reset              : std_logic;
    signal s_en                 : std_logic;
    signal s_speed_avg_dig1     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig2     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig3     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig4     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig1          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig2          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig3          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig4          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig1           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig2           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig3           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig4           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig1     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig2     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig3     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig4     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_seg                : std_logic_vector  (7 - 1 downto 0);
    signal s_LED                : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_dig                : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_dp                 : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_colon              : STD_LOGIC;
    signal s_colon_cathode      : STD_LOGIC;                                  

begin
    -- Connecting testbench signals with multiplexer entity
    uut_mux : entity work.driver_7seg_4digits_mode
        port map(
            clk                     => s_clk_100MHz,
            reset                   => s_reset,
            en_i                    => s_en,           
            speed_avg_dig1_i        => s_speed_avg_dig1,
            speed_avg_dig2_i        => s_speed_avg_dig2,
            speed_avg_dig3_i        => s_speed_avg_dig3,
            speed_avg_dig4_i        => s_speed_avg_dig4,
            trip_dig1_i             => s_trip_dig1,   
            trip_dig2_i             => s_trip_dig2,  
            trip_dig3_i             => s_trip_dig3,  
            trip_dig4_i             => s_trip_dig4,  
            all_dig1_i              => s_all_dig1,
            all_dig2_i              => s_all_dig2,  
            all_dig3_i              => s_all_dig3,   
            all_dig4_i              => s_all_dig4,   
            time_trip_dig1_i        => s_time_trip_dig1,
            time_trip_dig2_i        => s_time_trip_dig2,
            time_trip_dig3_i        => s_time_trip_dig3,
            time_trip_dig4_i        => s_time_trip_dig4,
            seg_o                   => s_seg,
            LED_o                   => s_LED,
            dig_o                   => s_dig,   
            dp_o                    => s_dp,    
            colon_o                 => s_colon,
            colon_cathode_o         => s_colon_cathode     
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 40 ms loop
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    -------------------------------------------------------------------
    -- Data generation process (push buttons)
    --------------------------------------------------------------------
    p_btn_push : process
    begin        
        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0100")
        report "Test failed for 1st push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0010")
        report "Test failed for 2nd push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0001")
        report "Test failed for 3rd push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "1000")
        report "Test failed for 4th push mode button" severity error;

        s_en <= '0';
        wait;
    end process p_btn_push;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 26 ms;

        s_reset <= '1';
        wait for 3 ms;
        assert(s_LED = "1000" and s_dig = "1000")
        report "Test failed for reset value '1'" severity error;

        s_reset <= '0';
        wait;
    end process p_reset_gen;

    -------------------------------------------------------------------
    -- Data generation process (digit values)
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Set values time trip digits
        s_time_trip_dig1 <= "0000";
        s_time_trip_dig2 <= "0001";
        s_time_trip_dig3 <= "0010";
        s_time_trip_dig4 <= "0011";

        -- Set values for speed average digits
        s_speed_avg_dig1 <= "0101";
        s_speed_avg_dig2 <= "0110";
        s_speed_avg_dig3 <= "0111";
        s_speed_avg_dig4 <= "1000";

        -- Set values for total distance digits
        s_all_dig1 <= "0001";
        s_all_dig2 <= "0011";
        s_all_dig3 <= "0101";
        s_all_dig4 <= "0111";

        -- Set values for trip distance digits
        s_trip_dig1 <= "0010";
        s_trip_dig2 <= "0100";
        s_trip_dig3 <= "1000";
        s_trip_dig4 <= "0000";

        -------------------------------------------------

        wait for 7ms;
        assert(s_dig = "0100" and s_LED = "0100")
        report "Test failed for digit 2 based on counting" severity error;

        wait for 20 ms;
        assert(s_dig = "1000" and s_LED = "1000")
        report "Test failed for digit 1 during reset" severity error;

        wait for 7 ms;
        assert(s_dig = "0100" and s_LED = "1000")
        report "Test failed for digit 2 after reset" severity error;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end architecture testbench;
```

## Testbench

```vhdl
------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_driver_7seg_4digits_mode is
end tb_driver_7seg_4digits_mode;

architecture testbench of tb_driver_7seg_4digits_mode is
    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    -- Local signals
    signal s_clk_100MHz         : std_logic;
    signal s_reset              : std_logic;
    signal s_en                 : std_logic;
    signal s_speed_avg_dig1     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig2     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig3     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_speed_avg_dig4     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig1          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig2          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig3          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_trip_dig4          : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig1           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig2           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig3           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_all_dig4           : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig1     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig2     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig3     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_time_trip_dig4     : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_seg                : std_logic_vector  (7 - 1 downto 0);
    signal s_LED                : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_dig                : STD_LOGIC_VECTOR  (4 - 1 downto 0);
    signal s_dp                 : STD_LOGIC_VECTOR  (4 - 1 downto 0);                                  

begin
    -- Connecting testbench signals with multiplexer entity
    uut_mux : entity work.driver_7seg_4digits_mode
        port map(
            clk                     => s_clk_100MHz,
            reset                   => s_reset,
            en_i                    => s_en,           
            speed_avg_dig1_i        => s_speed_avg_dig1,
            speed_avg_dig2_i        => s_speed_avg_dig2,
            speed_avg_dig3_i        => s_speed_avg_dig3,
            speed_avg_dig4_i        => s_speed_avg_dig4,
            trip_dig1_i             => s_trip_dig1,   
            trip_dig2_i             => s_trip_dig2,  
            trip_dig3_i             => s_trip_dig3,  
            trip_dig4_i             => s_trip_dig4,  
            all_dig1_i              => s_all_dig1,
            all_dig2_i              => s_all_dig2,  
            all_dig3_i              => s_all_dig3,   
            all_dig4_i              => s_all_dig4,   
            time_trip_dig1_i        => s_time_trip_dig1,
            time_trip_dig2_i        => s_time_trip_dig2,
            time_trip_dig3_i        => s_time_trip_dig3,
            time_trip_dig4_i        => s_time_trip_dig4,
            seg_o                   => s_seg,
            LED_o                   => s_LED,
            dig_o                   => s_dig,   
            dp_o                    => s_dp        
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 40 ms loop
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    -------------------------------------------------------------------
    -- Data generation process (push buttons)
    --------------------------------------------------------------------
    p_btn_push : process
    begin        
        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0100")
        report "Test failed for 1st push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0010")
        report "Test failed for 2nd push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "0001")
        report "Test failed for 3rd push mode button" severity error;

        s_en <= '0';
        wait for 5 ms;

        s_en <= '1';
        wait for 1 ms;
        assert(s_LED = "1000")
        report "Test failed for 4th push mode button" severity error;

        s_en <= '0';
        wait;
    end process p_btn_push;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 26 ms;

        s_reset <= '1';
        wait for 3 ms;
        assert(s_LED = "1000" and s_dig = "1000")
        report "Test failed for reset value '1'" severity error;

        s_reset <= '0';
        wait;
    end process p_reset_gen;

    -------------------------------------------------------------------
    -- Data generation process (digit values)
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Set values time trip digits
        s_time_trip_dig1 <= "0000";
        s_time_trip_dig2 <= "0001";
        s_time_trip_dig3 <= "0010";
        s_time_trip_dig4 <= "0011";

        -- Set values for speed average digits
        s_speed_avg_dig1 <= "0101";
        s_speed_avg_dig2 <= "0110";
        s_speed_avg_dig3 <= "0111";
        s_speed_avg_dig4 <= "1000";

        -- Set values for total distance digits
        s_all_dig1 <= "0001";
        s_all_dig2 <= "0011";
        s_all_dig3 <= "0101";
        s_all_dig4 <= "0111";

        -- Set values for trip distance digits
        s_trip_dig1 <= "0010";
        s_trip_dig2 <= "0100";
        s_trip_dig3 <= "1000";
        s_trip_dig4 <= "0000";

        -------------------------------------------------

        wait for 7ms;
        assert(s_dig = "0100" and s_LED = "0100")
        report "Test failed for digit 2 based on counting" severity error;

        wait for 20 ms;
        assert(s_dig = "1000" and s_LED = "1000")
        report "Test failed for digit 1 during reset" severity error;

        wait for 7 ms;
        assert(s_dig = "0100" and s_LED = "1000")
        report "Test failed for digit 2 after reset" severity error;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end architecture testbench;
```

## Screenshot of the simulation

![Time_waveforms1](Images/driver_7seg_4digits_mode/time_waveforms.PNG)
