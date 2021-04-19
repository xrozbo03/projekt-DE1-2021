# cnt_up

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
entity cnt_up is
    generic(
        g_CNT_WIDTH : natural := 2      -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;       -- Main clock
        arst     : in  std_logic;       -- Asynchronous reset
        en_i     : in  std_logic;       -- Enable input
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end entity cnt_up;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_up is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); -- default value of "00"

begin
    --------------------------------------------------------------------
    -- p_cnt_up:
    -- Clocked process with asynchronous reset which implements n-bit
    -- up counter.
    --------------------------------------------------------------------
    p_cnt_up : process(clk, arst)
    begin
         if (arst = '1') then               -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits

         elsif rising_edge(clk) then

                if (en_i = '1') then       -- Test if counter is enabled
                    s_cnt_local <= s_cnt_local + 1;

            end if;
        end if;
    end process p_cnt_up;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;
```

## Testbench

```vhdl
------------------------------------------------------------------------
-- Copyright (c) 2020-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_cnt_up is
end entity tb_cnt_up;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cnt_up is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 2;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_arst       : std_logic;
    signal s_en         : std_logic;
    signal s_cnt        : std_logic_vector(c_CNT_WIDTH - 1 downto 0);

begin
    -- Connecting testbench signals with cnt_up entity
    -- (Unit Under Test)
    uut_cnt : entity work.cnt_up
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            arst     => s_arst,
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
        s_arst <= '0';
        wait for 12 ns;

        -- Reset activated
        s_arst <= '1';
        wait for 73 ns;
        assert(s_cnt = "00")
        report "Test failed for reset value 1" severity error;

        -- Reset deactivated
        s_arst <= '0';
        wait for 257 ns;

        -- Reset activated
        s_arst <= '1';
        wait for 73 ns;
        assert(s_cnt = "00")
        report "Test failed for reset value 1" severity error;

        -- Reset deactivated
        s_arst <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Enable counting
        s_en     <= '1';
        wait for 600 ns;

        -- Disable counting
        s_en     <= '0';

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;
```

## Screenshots of the simulation

  - 0-260 ns
    ![Time_waveforms1](Images/cnt_up/time_waveforms1.PNG)

  - 260-520 ns
    ![Time_waveforms2](Images/cnt_up/time_waveforms2.PNG)

  - 520-750 ns
    ![Time_waveforms3](Images/cnt_up/time_waveforms3.PNG)
