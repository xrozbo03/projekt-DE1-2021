------------------------------------------------------------------------
-- Copyright (c) 2021-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_speed_cur is
end tb_speed_cur;

architecture testbench of tb_speed_cur is

        constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

        signal s_clk              : std_logic;
        signal s_reset            : std_logic;
        signal s_cycle            : std_logic;                            
        signal s_cnt_1sec         : std_logic;
        signal s_tire_diameter    : std_logic_vector(5 - 1 downto 0);
        signal s_speed_cur_dig1   : std_logic_vector(4 - 1 downto 0);
        signal s_speed_cur_dig2   : std_logic_vector(4 - 1 downto 0);
        signal s_speed_cur_dig3   : std_logic_vector(4 - 1 downto 0);
        signal s_speed_cur_dig4   : std_logic_vector(4 - 1 downto 0);

begin

        uut_multiply : entity work.speed_cur
        port map(
            clk                =>   s_clk,
            cycle_i            =>   s_cycle,
            cnt_1sec_i         =>   s_cnt_1sec,
            reset              =>   s_reset,
            tire_diameter_i    =>   s_tire_diameter,
            speed_cur_dig1_o   =>   s_speed_cur_dig1,
            speed_cur_dig2_o   =>   s_speed_cur_dig2,
            speed_cur_dig3_o   =>   s_speed_cur_dig3,
            speed_cur_dig4_o   =>   s_speed_cur_dig4
        );

        --------------------------------------------------------------------
        -- Clock generation process
        --------------------------------------------------------------------
        p_clk_gen : process
        begin
            while now < 1500 ns loop
                s_clk <= '0';
                wait for c_CLK_100MHZ_PERIOD / 2;
                s_clk <= '1';
                wait for c_CLK_100MHZ_PERIOD / 2;
            end loop;
            wait;                           -- Process is suspended forever
        end process p_clk_gen;

        --------------------------------------------------------------------
        -- Reset generation process
        --------------------------------------------------------------------
        p_rst_gen : process
        begin
            s_reset <= '0';
            wait for 1140 ns;

            s_reset <= '1';
            wait for 50 ns;
            assert(s_speed_cur_dig1 = "0000" and s_speed_cur_dig2 = "0000"
                   and s_speed_cur_dig3 = "0000" and s_speed_cur_dig4 = "0000")
            report "Test failed for reset value '1'" severity error;

            s_reset <= '0';
            wait;                           -- Process is suspended forever
        end process p_rst_gen;

        --------------------------------------------------------------------
        -- 1 sec generation process
        --------------------------------------------------------------------
        p_1sec : process
        begin
            s_cnt_1sec <= '0';
            wait for 105 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 490ns;
            assert(s_speed_cur_dig1 = "0000" and s_speed_cur_dig2 = "1000"
                   and s_speed_cur_dig3 = "0011" and s_speed_cur_dig4 = "0011")
            report "Test failed for speed with the diameter of 29'" severity error;

            wait for 100 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 10 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait for 115 ns;
            assert(s_speed_cur_dig1 = "0000" and s_speed_cur_dig2 = "0001"
                   and s_speed_cur_dig3 = "0000" and s_speed_cur_dig4 = "0110")
            report "Test failed for speed with the diameter of 26'" severity error;

            wait for 45 ns;

            s_cnt_1sec <= '1';
            wait for 10 ns;

            s_cnt_1sec <= '0';
            wait;                           -- Process is suspended forever
        end process p_1sec;

        --------------------------------------------------------------------
        -- Cycles generation process
        --------------------------------------------------------------------
        p_cycle : process
        begin

            s_cycle <= '0';
            wait for 20 ns;

            s_cycle <= '1';
            wait for 35 ns;

            s_cycle <= '0';
            wait for 750 ns;

            s_cycle <= '1';
            wait for 5 ns;

            s_cycle <= '0';
            wait for 45 ns;

            s_cycle <= '1';
            wait for 5 ns;

            s_cycle <= '0';
            wait for 5 ns;

            s_cycle <= '1';
            wait for 5 ns;

            s_cycle <= '0';
            wait for 5 ns;

            s_cycle <= '1';
            wait for 5 ns;

            s_cycle <= '0';          
            wait;                           -- Process is suspended forever
        end process p_cycle;

        -------------------------------------------------------------------
        -- Data generation process
        --------------------------------------------------------------------
        p_stimulus : process
        begin
            report "Stimulus process started" severity note;

            -- Set diameter to 29'' (737 mm)
            s_tire_diameter <= "11101";
            wait for 200 ns;

            -- Set diameter to 26'' (660 mm)
            s_tire_diameter <= "11010";

            report "Stimulus process finished" severity note;
            wait;
        end process p_stimulus;
end architecture testbench;