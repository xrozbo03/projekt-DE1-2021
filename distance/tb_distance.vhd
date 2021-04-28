----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2021 13:35:31
-- Design Name: 
-- Module Name: tb_distance - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_distance is
--  Port ( );
end tb_distance;

architecture Behavioral of tb_distance is

           signal s_size_i : STD_LOGIC_VECTOR (5 - 1 downto 0);    
           signal s_cycle : STD_LOGIC;
           signal s_arst : STD_LOGIC;
           signal s_dis_trip_o : STD_LOGIC_VECTOR (14 - 1 downto 0);
           signal s_dis_all_o : STD_LOGIC_VECTOR (14 - 1 downto 0);

begin

uut_distance : entity work.distance
    port map(
    
            size_i => s_size_i,
            cycle_i => s_cycle,
            arst_i => s_arst,
            dis_trip_o => s_dis_trip_o,
            dis_all_o => s_dis_all_o
            
    );

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        
        s_cycle <= '0';
        s_arst <= '0';

       


 
        
        s_size_i <= "11101";
        
        
        while now < 1000 ns loop         
             wait for 10 ps;
            s_cycle <= '1';
            wait for 10 ps;
            s_cycle <= '0';
        end loop;
       
       s_arst <= '1';
       wait for 1 ps;
       s_arst <= '0';
       
        while now < 10000 ns loop         
             wait for 10 ps;
            s_cycle <= '1';
            wait for 10 ps;
            s_cycle <= '0';
        end loop;
        
        wait for 2000 ns;
        
        while now < 52000 ns loop         
             wait for 10 ps;
            s_cycle <= '1';
            wait for 10 ps;
            s_cycle <= '0';
        end loop;
       
       s_arst <= '1';
       wait for 1 ps;
       s_arst <= '0';

        
        while now < 100000 ns loop         
             wait for 10 ps;
            s_cycle <= '1';
            wait for 10 ps;
            s_cycle <= '0';
        end loop;
                
       
               
      

        
        
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;
