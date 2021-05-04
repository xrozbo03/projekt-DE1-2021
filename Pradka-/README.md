# TOP Design Console

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port 
    (
     -- Inputs
     SW             : in STD_LOGIC_VECTOR(3 - 1 downto 0);
     hall_sens_i    : in STD_LOGIC;
     clk            : in STD_LOGIC;
     reset          : in STD_LOGIC;
     button_mode_i  : in STD_LOGIC;
     button_diff_i  : in STD_LOGIC;
     -- Speed_cur display
     CA             : out STD_LOGIC;
     CB             : out STD_LOGIC;
     CC             : out STD_LOGIC;
     CD             : out STD_LOGIC;
     CE             : out STD_LOGIC;
     CF             : out STD_LOGIC;
     CG             : out STD_LOGIC;
     dig_o          : out STD_LOGIC_VECTOR(4 - 1 downto 0);
     dp_o           : out STD_LOGIC;
     -- mode display
     CA_mode        : out STD_LOGIC;                       
     CB_mode        : out STD_LOGIC;                       
     CC_mode        : out STD_LOGIC;                       
     CD_mode        : out STD_LOGIC;                       
     CE_mode        : out STD_LOGIC;                       
     CF_mode        : out STD_LOGIC;                       
     CG_mode        : out STD_LOGIC;                       
     dig_mode_o     : out STD_LOGIC_VECTOR(4 - 1 downto 0);
     dp_mode_o      : out STD_LOGIC; 
     LED_o          : out STD_LOGIC_VECTOR(4 - 1 downto 0);
     -- difficult LED display
     Tri_color_LED  : out STD_LOGIC_VECTOR(3 - 1 downto 0)
    );
end top;

architecture Behavioral of top is

    signal s_diameter         : STD_LOGIC_VECTOR(5 - 1 downto 0);
    
    signal s_cycle            : STD_LOGIC;
    
    signal s_count            : STD_LOGIC;
    
    signal s_speed_cur_dig1   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_cur_dig2   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_cur_dig3   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_cur_dig4   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    
    signal s_time_count       : STD_LOGIC_VECTOR(19 - 1 downto 0);
    signal s_time_trip_dig1   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_time_trip_dig2   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_time_trip_dig3   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_time_trip_dig4   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    
    signal s_trip_dig1        : STD_LOGIC_VECTOR(4 - 1 downto 0);   
    signal s_trip_dig2        : STD_LOGIC_VECTOR(4 - 1 downto 0);  
    signal s_trip_dig3        : STD_LOGIC_VECTOR(4 - 1 downto 0);   
    signal s_trip_dig4        : STD_LOGIC_VECTOR(4 - 1 downto 0);   
    signal s_all_dig1         : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_all_dig2         : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_all_dig3         : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_all_dig4         : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_distance         : STD_LOGIC_VECTOR(19 - 1 downto 0);

    signal s_speed_avg_dig1   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_avg_dig2   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_avg_dig3   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal s_speed_avg_dig4   : STD_LOGIC_VECTOR(4 - 1 downto 0);
    

begin
    -----------------------------------------------------------------------------------
    -- Instance (copy) of tire_diameter entity
    tire_diameter : entity work.tire_diameter
        port map
        (
            sw_i                   =>  SW,
            tire_diameter_o        =>  s_diameter
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of cycle entity
     cycle : entity work.cycle
        port map
        (
            hall_sens_i            =>  hall_sens_i,
            cycle_o                =>  s_cycle
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of count_1sec entity
     count_1sec : entity work.count_1sec
        port map
        (
            clk                    =>  clk,
            cnt_o                  =>  s_count
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of speed_cur entity
     speed_cur : entity work.speed_cur
        port map
        (
            clk                    =>  clk,
            reset                  =>  reset,
            cycle_i                =>  s_cycle,
            cnt_1sec_i             =>  s_count,
            tire_diameter_i        =>  s_diameter,
            speed_cur_dig1_o       =>  s_speed_cur_dig1,
            speed_cur_dig2_o       =>  s_speed_cur_dig2,
            speed_cur_dig3_o       =>  s_speed_cur_dig3,
            speed_cur_dig4_o       =>  s_speed_cur_dig4      
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of driver_7seg_4digits_speed_cur entity
     driver_7seg_4digits_speed_cur : entity work.driver_7seg_4digits_speed_cur
        port map
        (
            clk                    =>  clk,
            reset                  =>  reset,
            speed_cur_dig1_i       =>  s_speed_cur_dig1,
            speed_cur_dig2_i       =>  s_speed_cur_dig2,
            speed_cur_dig3_i       =>  s_speed_cur_dig3,
            speed_cur_dig4_i       =>  s_speed_cur_dig4,
            seg_o(6)               =>  CA,
            seg_o(5)               =>  CB,
            seg_o(4)               =>  CC,
            seg_o(3)               =>  CD,
            seg_o(2)               =>  CE,
            seg_o(1)               =>  CF,
            seg_o(0)               =>  CG,
            dig_o                  =>  dig_o,
            dp_o                   =>  dp_o     
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of time_trip entity
     time_trip : entity work.time_trip
        port map
        (
            clk                    =>  clk,
            cycle_i                =>  s_cycle,
            cnt_1sec_i             =>  s_count,
            reset                  =>  reset,
            time_count_o           =>  s_time_count,
            time_trip_dig1_o       =>  s_time_trip_dig1,
            time_trip_dig2_o       =>  s_time_trip_dig2,
            time_trip_dig3_o       =>  s_time_trip_dig3,
            time_trip_dig4_o       =>  s_time_trip_dig4
        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of distance entity
     distance : entity work.distance
        port map
        (
            clk                    =>  clk, 
            size_i                 =>  s_diameter,
            cycle_i                =>  s_cycle,    
            reset                  =>  reset,
            dis_trip_o             =>  s_distance,         

                                     
            trip_dig1_o            =>  s_trip_dig1,
            trip_dig2_o            =>  s_trip_dig2,
            trip_dig3_o            =>  s_trip_dig3,
            trip_dig4_o            =>  s_trip_dig4,
                                   
            all_dig1_o             =>  s_all_dig1,
            all_dig2_o             =>  s_all_dig2,
            all_dig3_o             =>  s_all_dig3,
            all_dig4_o             =>  s_all_dig4 



        );
     ----------------------------------------------------------------------------------
     -- Instance (copy) of speed_avg entity
     speed_avg : entity work.speed_avg
        port map
        (
            clk                    =>  clk,
            reset                  =>  reset,
            cnt_1sec_i             =>  s_count,
            time_count_i           =>  s_time_count,
            distance_i             =>  s_distance, 
            speed_avg_dig1_o       =>  s_speed_avg_dig1,
            speed_avg_dig2_o       =>  s_speed_avg_dig2,
            speed_avg_dig3_o       =>  s_speed_avg_dig3,
            speed_avg_dig4_o       =>  s_speed_avg_dig4
        );
--     ----------------------------------------------------------------------------------
     -- Instance (copy) of driver_7seg_4digits_mode entity
     driver_7seg_4digits_mode : entity work.driver_7seg_4digits_mode
        port map
        (
            clk                    =>  clk,
            reset                  =>  reset,
            en_i                   =>  button_mode_i,
            
            speed_avg_dig1_i       =>  s_speed_avg_dig1,
            speed_avg_dig2_i       =>  s_speed_avg_dig2,
            speed_avg_dig3_i       =>  s_speed_avg_dig3,
            speed_avg_dig4_i       =>  s_speed_avg_dig4,
             
            trip_dig1_i            =>  s_trip_dig1,
            trip_dig2_i            =>  s_trip_dig2,
            trip_dig3_i            =>  s_trip_dig3,
            trip_dig4_i            =>  s_trip_dig4,
            
            all_dig1_i             =>  s_all_dig1,  
            all_dig2_i             =>  s_all_dig2,  
            all_dig3_i             =>  s_all_dig3,  
            all_dig4_i             =>  s_all_dig4,  
             
            time_trip_dig1_i       =>  s_time_trip_dig1,
            time_trip_dig2_i       =>  s_time_trip_dig2,
            time_trip_dig3_i       =>  s_time_trip_dig3,
            time_trip_dig4_i       =>  s_time_trip_dig4, 
            
            seg_o(6)               =>  CA_mode,
            seg_o(5)               =>  CB_mode,
            seg_o(4)               =>  CC_mode,
            seg_o(3)               =>  CD_mode,
            seg_o(2)               =>  CE_mode,
            seg_o(1)               =>  CF_mode,
            seg_o(0)               =>  CG_mode,  
            LED_o                  =>  LED_o,
            dig_o                  =>  dig_mode_o,
            dp_o                   =>  dp_mode_o
        );                    
     ----------------------------------------------------------------------------------
     -- Instance (copy) of derailleur entity
     derailleur : entity work.derailleur
        port map
        (
            clk                    =>  clk,
            reset                  =>  reset,
            btn_i                  =>  button_diff_i,
            level_of_difficulty_o  =>  Tri_color_LED
        );
     ----------------------------------------------------------------------------------
                              
end Behavioral;               
```


# tb_TOP Design Console

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
--    Port
--      (
--      );
end tb_top;

architecture Behavioral of tb_top is

     constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
     
    -- signal s_clk_100MHz     : STD_LOGIC;

     -- Inputs
     signal s_SW             : STD_LOGIC_VECTOR(3 - 1 downto 0);
     signal s_hall_sens_i    : STD_LOGIC;
     signal s_clk_100MHz     : STD_LOGIC;
     signal s_reset          : STD_LOGIC;
     signal s_button_mode_i  : STD_LOGIC;
     signal s_button_diff_i  : STD_LOGIC;
     -- Speed_cur display
     signal s_CA             : STD_LOGIC;
     signal s_CB             : STD_LOGIC;
     signal s_CC             : STD_LOGIC;
     signal s_CD             : STD_LOGIC;
     signal s_CE             : STD_LOGIC;
     signal s_CF             : STD_LOGIC;
     signal s_CG             : STD_LOGIC;
     signal s_dig_o          : STD_LOGIC_VECTOR(4 - 1 downto 0);
     signal s_dp_o           : STD_LOGIC_VECTOR(4 - 1 downto 0);
     -- mode display
     signal s_CA_mode        : STD_LOGIC;                       
     signal s_CB_mode        : STD_LOGIC;                       
     signal s_CC_mode        : STD_LOGIC;                       
     signal s_CD_mode        : STD_LOGIC;                       
     signal s_CE_mode        : STD_LOGIC;                       
     signal s_CF_mode        : STD_LOGIC;                       
     signal s_CG_mode        : STD_LOGIC;                       
     signal s_dig_mode_o     : STD_LOGIC_VECTOR(4 - 1 downto 0);
     signal s_dp_mode_o      : STD_LOGIC_VECTOR(4 - 1 downto 0); 
     signal s_LED_o          : STD_LOGIC_VECTOR(4 - 1 downto 0);
     -- difficult LED disp
     signal s_Tri_color_LED  : STD_LOGIC_VECTOR(3 - 1 downto 0);
     

begin

    uut_top: entity work.top
        port map
            (
            -- Inputs                                            
            SW              => s_SW,            
            hall_sens_i     => s_hall_sens_i,                       
            clk             => s_clk_100MHz,                    
            reset           => s_reset,                             
            button_mode_i   => s_button_mode_i,                     
            button_diff_i   => s_button_diff_i,                     
            -- Speed_cur display                                    
            CA              => s_CA,            
            CB              => s_CB,            
            CC              => s_CC,            
            CD              => s_CD,            
            CE              => s_CE,            
            CF              => s_CF,            
            CG              => s_CG,            
            dig_o           => s_dig_o,         
            dp_o            => s_dp_o,          
            -- mode display                                                 
            CA_mode         => s_CA_mode,       
            CB_mode         => s_CB_mode,      
            CC_mode         => s_CC_mode,       
            CD_mode         => s_CD_mode,       
            CE_mode         => s_CE_mode,       
            CF_mode         => s_CF_mode,       
            CG_mode         => s_CG_mode,       
            dig_mode_o      => s_dig_mode_o,    
            dp_mode_o       => s_dp_mode_o,     
            LED_o           => s_LED_o,         
            -- difficult LED display                             
            Tri_color_LED   => s_Tri_color_LED   
            );
            
    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 20000 ms loop
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;        

    --------------------------------------------------------------------
    -- Data generation process for tire_diameter inputs
    --------------------------------------------------------------------
    p_diameter : process
    begin
        report "tire_diameter process started" severity note;
        while now < 20000 ms loop
        -- Enable combination 000
        s_SW <= "000";
        wait for 1500ms;

        -- Enable combination 001
        s_SW <= "001";
        wait for 1500ms;

        -- Enable combination 010
        s_SW <= "010";
        wait for 1500ms;

        -- Enable combination 011
        s_SW <= "011";
        wait for 1500ms;

        -- Enable combination 100
        s_SW <= "100";
        wait for 1500ms;

        -- Enable combination 101
        s_SW <= "101";
        wait for 1500ms;

        -- Enable combination 110
        s_SW <= "110";
        wait for 1500ms;

        -- Enable combination 111
        s_SW <= "111";
        wait for 1500ms;
        end loop;
        wait;
        report "tire_diameter process finished" severity note;
    end process p_diameter;
    
    --------------------------------------------------------------------
    -- Data generation process for cycle inputs
    --------------------------------------------------------------------
    p_cycle : process
    begin
        report "Cycle process started" severity note;
        while now < 20000 ms loop
         -- Generation of hall pulses
        s_hall_sens_i <= '1';
        wait for 1 ms;

        s_hall_sens_i <= '0';
        wait for 1 ms;
               
        end loop;
        wait;
        report "Cycle process finished" severity note;
    end process p_cycle;
    
    --------------------------------------------------------------------
    -- Data generation process for reset inputs
    --------------------------------------------------------------------
    p_reset : process
    begin
        report "Reset process started" severity note;

        s_reset <= '0';
        wait for 100 ms;

        s_reset <= '1';
        wait for 100 ms;

        s_reset <= '0';
 --       wait for 100 ms;

--        s_reset <= '1';
--        wait for 100 ms;
        
--        s_reset <= '0';
--        wait for 100 ms;
        
--        s_reset <= '1';
--        wait for 100 ms;
        
--        s_reset <= '0';
--        wait for 100 ms;
        
--        report "Reset process finished" severity note;
        wait;
    end process p_reset;
    
    -------------------------------------------------------------------
    -- Data generation process for mode buttons
    --------------------------------------------------------------------
    p_button_mode : process
    begin
        while now < 20000 ms loop        
        s_button_mode_i <= '0';
        wait for 300 ms;

        s_button_mode_i <= '1';
        wait for 10 ms;
        end loop;
        wait;
    end process p_button_mode;
    
    --------------------------------------------------------------------
    -- Data generation process for button_difficulty input
    --------------------------------------------------------------------
    p_button_difficulty : process
    begin
        report "button_difficulty process started" severity note;
        while now < 20000 ms loop
        s_button_diff_i <= '0';
        wait for 68 ms;

        s_button_diff_i <= '1';
        wait for 12 ms;

        s_button_diff_i <= '0';
        wait for 58 ms;

        s_button_diff_i <= '1';
        wait for 32 ms;

        s_button_diff_i <= '0';
        wait for 250 ms;

        s_button_diff_i <= '1';
        wait for 58 ms;

        s_button_diff_i <= '0';
        wait for 23 ms;

        s_button_diff_i <= '1';
        wait for 12 ms;

        s_button_diff_i <= '0';
        end loop;
        report "button_difficulty process finished" severity note;
        wait;
    end process p_button_difficulty;

end Behavioral;

```
