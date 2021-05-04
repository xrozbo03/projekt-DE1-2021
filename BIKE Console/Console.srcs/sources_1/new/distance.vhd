library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity distance is
    Port ( 
           clk              : in STD_LOGIC;
           size_i           : in STD_LOGIC_VECTOR (5 - 1 downto 0);           -- size of the bike 
           cycle_i          : in STD_LOGIC;                                  -- 1 when theres signal from sond, 0 others
           reset            : in STD_LOGIC;                                   -- to reset trip
           dis_trip_o       : out STD_LOGIC_VECTOR (19 - 1 downto 0);     -- distance in km trip
      --   dis_all_o        : out STD_LOGIC_VECTOR (14 - 1 downto 0);     -- total distance in km   -- only for testing
           
           trip_dig1_o        : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 1. digit (100)
           trip_dig2_o        : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 2. digit (10)
           trip_dig3_o        : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 3. digit (1)
           trip_dig4_o        : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- 1 trip distance value for 4. digit (.1)
           
           all_dig1_o         : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 1. digit (1000)
           all_dig2_o         : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 2. digit (100)
           all_dig3_o         : out STD_LOGIC_VECTOR  (4 - 1 downto 0);     -- Total distance value for 3. digit (10)
           all_dig4_o         : out STD_LOGIC_VECTOR  (4 - 1 downto 0)      -- Total distance value for 4. digit (1)
          
          );
           
       
end distance;

architecture Behavioral of distance is

      
        signal s_size_local             : unsigned (11 - 1 downto 0);   
        signal s_size_local_trip        : unsigned (11 - 1 downto 0);                        -- local number, how many cycles are needed to one km distance
        signal s_count                  : unsigned (11 - 1 downto 0) := "00000000000";          -- counting cycles
        signal s_count_trip             : unsigned (11 - 1 downto 0) := "00000000000"; 


        signal s_dis_trip_local    : unsigned (19 - 1 downto 0) := "0000000000000000000";     -- local signal for trip dist (output to avg speed) and for local testing and other use)
     -- signal s_dis_all_local     : unsigned (14 - 1 downto 0) := "00000000000000";    -- local signal for all dist    (-||-)
        
        signal s_trip_dig1_o        : unsigned (4 - 1 downto 0) := "0000";              -- local outputs fot digits on 7-seg
        signal s_trip_dig2_o        : unsigned (4 - 1 downto 0) := "0000";
        signal s_trip_dig3_o        : unsigned (4 - 1 downto 0) := "0000";
        signal s_trip_dig4_o        : unsigned (4 - 1 downto 0) := "0000";

        signal s_all_dig1_o        : unsigned (4 - 1 downto 0) := "0000";
        signal s_all_dig2_o        : unsigned (4 - 1 downto 0) := "0000";
        signal s_all_dig3_o        : unsigned (4 - 1 downto 0) := "0000";
        signal s_all_dig4_o        : unsigned (4 - 1 downto 0) := "0000";
        

      
begin
    
    


    p_distance : process(cycle_i, size_i, clk)  
    begin
    

   
        
        case size_i is                                              
            when "11101" =>            -- 29
                s_size_local        <= "00110110000";   -- how many turns takes to 1 km of ride (when bike size 29) -- 432 turns
                s_size_local_trip   <= "00000101011";   -- same but 100 m
            when "11100" =>            -- 28
                s_size_local        <= "00111000000";   -- 448
                s_size_local_trip   <= "00000101101";
            when "11011" =>            -- 27,5
                s_size_local        <= "00111001000";   -- 456
                s_size_local_trip   <= "00000101110";
            when "11010" =>            -- 26
                s_size_local        <= "00111100010";   -- 482
                s_size_local_trip   <= "00000110000";
            when "11000" =>            -- 24
                s_size_local        <= "01000001010";   --  522
                s_size_local_trip   <= "00000110100";
            when "10100" =>            -- 20
                s_size_local        <= "01001110011";   --  627
                s_size_local_trip   <= "00000111111";
            when "10000" =>            -- 16
                s_size_local        <= "01100001111";   -- 783
                s_size_local_trip   <= "00001001110";
            when "01100" =>            -- 12
                s_size_local        <= "10000010100";   -- 1044
                s_size_local_trip   <= "00001101000";
            when others =>
                s_size_local        <= "00111000000";   -- 448 
                s_size_local_trip   <= "00000101101"; 
                    
                    
                    
        end case;
        
        if rising_edge(cycle_i) then
            
            if (s_count < s_size_local) then                        -- add one to count, when cycle_i
                s_count <= s_count + 1;
                
            else                                                    -- when counter is full, resets counter and increase the local distance signals
                s_count <= (others => '0');
        
             -- s_dis_all_local   <= s_dis_all_local   + 1;                 
                
                
                if (s_all_dig4_o < "1001") then             -- the same only for all trip
                    s_all_dig4_o <= s_all_dig4_o +1;
                else
                    s_all_dig4_o <= "0000";
                    
                    if (s_all_dig3_o < "1001") then
                        s_all_dig3_o <= s_all_dig3_o +1;
                    else
                        s_all_dig3_o <= "0000";
                        
                        if (s_all_dig2_o < "1001") then
                            s_all_dig2_o <= s_all_dig2_o +1;
                        else
                            s_all_dig2_o <= "0000";
                            if (s_all_dig1_o < "1001") then
                                s_all_dig1_o <= s_all_dig1_o +1;
                            else
                                s_all_dig1_o <= "0000";
                                
                            end if;
                        end if;
                    end if;
                end if;
                
        end if;
            
            
        if (s_count_trip < s_size_local_trip) then                        -- add one to count, when cycle_i
                s_count_trip <= s_count_trip + 1;
                
            else       
                
                s_dis_trip_local  <= s_dis_trip_local  + 1;
                s_count_trip <= (others => '0');
            
                
                
                if (s_trip_dig4_o < "1001") then                    -- twice the same (ones for "trip" and ones for "all"), counting for 7-seg displays, 
                    s_trip_dig4_o <= s_trip_dig4_o +1;              -- counts from "0000" to "9999" and solves overflow for  decimal system
                else
                    s_trip_dig4_o <= "0000";
                    
                    if (s_trip_dig3_o < "1001") then
                        s_trip_dig3_o <= s_trip_dig3_o +1;
                    else
                        s_trip_dig3_o <= "0000";
                        
                        if (s_trip_dig2_o < "1001") then
                            s_trip_dig2_o <= s_trip_dig2_o +1;
                        else
                            s_trip_dig2_o <= "0000";
                            if (s_trip_dig1_o < "1001") then
                                s_trip_dig1_o <= s_trip_dig1_o +1;
                            else
                                s_trip_dig1_o <= "0000";
                                
                            end if;
                        end if;
                    end if;
                end if;
                
                
                
                
                
                
            end if;


        end if;
        
        if rising_edge(clk) then
            if (reset = '1') then                     -- when arst singla from user resets trip singal and digits (all signal and digits can not be reset

            s_dis_trip_local  <=  (others => '0');
            
            s_trip_dig1_o   <=  (others => '0');
            s_trip_dig2_o   <=  (others => '0');
            s_trip_dig3_o   <=  (others => '0');
            s_trip_dig4_o   <=  (others => '0');
         
            end if;
            
        end if;
        
        
        

                 
    end process;                                    -- sets local signals to logic vector outputs

        dis_trip_o <= std_logic_vector(s_dis_trip_local);
     -- dis_all_o <= std_logic_vector(s_dis_all_local);  -- only for testing
        
        
        trip_dig1_o   <= std_logic_vector(s_trip_dig1_o);
        trip_dig2_o   <= std_logic_vector(s_trip_dig2_o);
        trip_dig3_o   <= std_logic_vector(s_trip_dig3_o);
        trip_dig4_o   <= std_logic_vector(s_trip_dig4_o);
   
        all_dig1_o    <= std_logic_vector(s_all_dig1_o);
        all_dig2_o    <= std_logic_vector(s_all_dig2_o);
        all_dig3_o    <= std_logic_vector(s_all_dig3_o);
        all_dig4_o    <= std_logic_vector(s_all_dig4_o); 
    
  
    

end Behavioral;