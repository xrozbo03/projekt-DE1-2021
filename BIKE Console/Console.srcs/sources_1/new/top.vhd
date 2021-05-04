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

















