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