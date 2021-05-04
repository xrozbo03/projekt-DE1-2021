# cnt_up_mode

## Design

```vhdl
------------------------------------------------------------------------
-- Copyright (c) 2032-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_up_mode is
    generic(
        g_CNT_WIDTH : natural := 2                                  -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;                                   -- Main clock
        reset    : in  std_logic;                                   -- Synchronous reset
        en_i     : in  std_logic;                                   -- Push button input
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)   -- Output to internal signal
    );
end cnt_up_mode;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture Behavioral of cnt_up_mode is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); -- Default value of "00"
    signal s_cnt_btn   : std_logic := '0';                                      -- Signal to process button

begin
   --------------------------------------------------------------------
    -- p_cnt_up:
    -- Clocked process with synchronous reset which implements n-bit
    -- up counter.
    --------------------------------------------------------------------
    p_cnt_up : process(clk)
    begin

        if rising_edge(clk) then
            if (reset = '1') then                       -- Synchronous reset
                s_cnt_local <= (others => '0');         -- Clear all bits
                s_cnt_btn   <= '0';
            elsif (en_i = '1' and s_cnt_btn = '0') then -- if button is pushed after release
                s_cnt_local <= s_cnt_local + 1;
                s_cnt_btn   <= '1';
            elsif (en_i = '0' and s_cnt_btn = '1') then -- if button was released
                s_cnt_btn   <= '0';   
            end if;
        end if;
    end process p_cnt_up;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_o <= std_logic_vector(s_cnt_local);


end Behavioral;
```

## Testbench

```vhdl
------------------------------------------------------------------------
-- Copyright (c) 2020-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cnt_up_mode is
end tb_cnt_up_mode;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cnt_up_mode is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 2;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_en         : std_logic;
    signal s_cnt        : std_logic_vector(c_CNT_WIDTH - 1 downto 0);

begin
    -- Connecting testbench signals with cnt_up entity
    -- (Unit Under Test)
    uut_cnt : entity work.cnt_up_mode
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_o    => s_cnt
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
        s_reset <= '0';
        wait for 128 ns;

        -- Reset activated
        s_reset <= '1';
        wait for 73 ns;
        assert(s_cnt = "00")
        report "Test failed for reset value 1" severity error;

        -- Reset deactivated
        s_reset <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        s_en     <= '0';
        wait for 50 ns;
        assert(s_cnt = "00")
        report "Test failed for default state" severity error;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "01")
        report "Test failed for 1. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "00")
        report "Test failed for 2. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "01")
        report "Test failed for 3. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "10")
        report "Test failed for 4. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "11")
        report "Test failed for 5. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "00")
        report "Test failed for 6. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "01")
        report "Test failed for 7. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "10")
        report "Test failed for 8. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "11")
        report "Test failed for 9. button push" severity error;

        -- Release button
        s_en     <= '0';
        wait for 50 ns;

        -- Push button
        s_en     <= '1';
        wait for 25 ns;
        assert(s_cnt = "00")
        report "Test failed for 10. button push" severity error;

        -- Release button
        s_en     <= '0';
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;
```

## Screenshots of the simulation

![Time_waveforms](Images/cnt_up_mode/time_waveforms.PNG)

  - 40-300 ns
    ![Time_waveforms](Images/cnt_up_mode/time_waveforms1.PNG)
