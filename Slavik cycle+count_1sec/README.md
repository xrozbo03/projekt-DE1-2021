# count_1sec

##design

```vhdl
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2021 22:32:35
-- Design Name: 
-- Module Name: count_1sec - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity count_1sec is
   
    port(
        clk      : in  std_logic;       -- Main clock
        rst    : in  std_logic;       -- Synchronous reset
        en_i     : in  std_logic;       -- Enable input
        cnt_up_i : in  std_logic;       -- Direction of the counter
        cnt_o    : out std_logic
    );
end entity count_1sec;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of count_1sec is

    -- Local counter
  signal s_cnt_local : unsigned(26 downto 0);

begin
    --------------------------------------------------------------------
    -- p_cnt_up_down:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up/down counter.
    --------------------------------------------------------------------
    p_count_1sec : process(clk)
    begin
        if rising_edge(clk) then
        
            if (rst = '1') then               -- Synchronous reset
              s_cnt_local <= (others => '0');               -- Clear all bits

            elsif (en_i = '1') then       -- Test if counter is enabled


                -- TEST COUNTER DIRECTION HERE

               
                s_cnt_local <= s_cnt_local + 1;
                if(s_cnt_local = "101111101011110000100000000") then
                cnt_o <= '1';
           
           end if;
            end if;
        end if;
    end process p_count_1sec;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
  

end architecture behavioral;

```

## test bench

```vhdl
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_count_1sec is
    -- Entity of testbench is always empty
end entity tb_count_1sec; 

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_count_1sec is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 2;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_rst        : std_logic;
    signal s_en         : std_logic;
    signal s_cnt_up     : std_logic;
    signal s_cnt        : std_logic_vector(c_CNT_WIDTH - 1 downto 0);

begin
    -- Connecting testbench signals with cnt_up_down entity
    -- (Unit Under Test)
    uut_cnt : entity work.count_1sec
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            rst    => s_rst,
            en_i     => s_en,
            cnt_up_i => s_cnt_up,
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
           s_rst <= '0';
        wait for 20 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cnt = "00"  --error report
        report "Stimulus process failed" severity error;  

        
        s_rst <= '0';
        wait for 200 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cnt = "00"
        report "Stimulus process failed" severity error;

        
        s_rst <= '0';
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
        wait for 500 ns;

                                       -- Disable counting
        s_en     <= '0';

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;

```

## cycle
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cycle is
         Port ( 
            hall_sens_i : in std_logic;
            cycle_o     : out std_logic_vector(2 - 1 downto 0);
            clk         : in std_logic;
            rst         : in std_logic
          );
end cycle;

architecture Behavioral of cycle is
  signal s_cycle_local : unsigned(2 - 1 downto 0);
begin

p_cycle : process(clk)
begin
   if rising_edge(clk) then
        
            if (rst = '1') then
             elsif hall_sens_i = '0' then     
             s_cycle_local <= (others => '0');   
             s_cycle_local <= s_cycle_local + 1;
             end if;
             end if;

end process p_cycle;

cycle_o <= std_logic_vector(s_cycle_local);

end architecture behavioral;

```

## tb_cycle

```vhdl
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_cycle is
    -- Entity of testbench is always empty
end entity tb_cycle; 

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cycle is

    -- Number of bits for testbench counter
   -- constant c_CNT_WIDTH         : natural := 2;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_rst        : std_logic;
    signal s_en         : std_logic;
    signal s_cycle      : std_logic_vector(2 - 1 downto 0);
    signal s_hall_sens_i : std_logic
    

begin
  
    uut_cycle : entity work.cycle
       
        port map(
            clk      => s_clk_100MHz,
            rst    => s_rst,
            en_i     => s_en,
            cycle_o  => s_cycle,
            hall_sens_i => s_hall_sens_i
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
           s_rst <= '0';
        wait for 20 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cycle = "00"  --error report
        report "Stimulus process failed" severity error;  

        
        s_rst <= '0';
        wait for 200 ns;

        
        s_rst <= '1';
        wait for 80 ns;
        assert s_cycle = "00"
        report "Stimulus process failed" severity error;

        
        s_rst <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
     report "Stimulus process started" severity note;
        
        s_cycle <= '0';
        s_rst <= '0';
        
        
        while now < 1000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
       
       s_rst <= '1';
       wait for 1 ps;
       s_rst <= '0';
       
        while now < 10000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
        
        wait for 2000 ns;
        
        while now < 52000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
       
       s_rst <= '1';
       wait for 1 ns;
       s_rst <= '0';

        
        while now < 10000 ns loop         
             wait for 10 ns;
            s_cycle <= '1';
            wait for 10 ns;
            s_cycle <= '0';
        end loop;
                  
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;

```

##simulation

