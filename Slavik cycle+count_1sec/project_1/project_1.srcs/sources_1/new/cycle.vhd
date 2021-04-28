----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.04.2021 22:04:50
-- Design Name: 
-- Module Name: cycle - Behavioral
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
            cycle_o     : out std_logic;
            clk         : in std_logic;
            rst         : in std_logic
          );
end cycle;

architecture Behavioral of cycle is
 -- signal s_cycle_local : unsigned(2 - 1 downto 0);
begin

p_cycle : process(clk)
begin
   if rising_edge(clk) then
        
            if (rst = '1') then
             elsif hall_sens_i = '0' then     
             --s_cycle_o <= (others => '0');   
             cycle_o <= '1';
             end if;
             end if;

end process p_cycle;

--cycle_o <= std_logic_vector(s_cycle_local);

end architecture behavioral;