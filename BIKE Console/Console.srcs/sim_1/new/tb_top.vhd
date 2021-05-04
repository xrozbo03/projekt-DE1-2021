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
     signal s_dp_o           : STD_LOGIC;
     -- mode display
     signal s_CA_mode        : STD_LOGIC;                       
     signal s_CB_mode        : STD_LOGIC;                       
     signal s_CC_mode        : STD_LOGIC;                       
     signal s_CD_mode        : STD_LOGIC;                       
     signal s_CE_mode        : STD_LOGIC;                       
     signal s_CF_mode        : STD_LOGIC;                       
     signal s_CG_mode        : STD_LOGIC;                       
     signal s_dig_mode_o     : STD_LOGIC_VECTOR(4 - 1 downto 0);
     signal s_dp_mode_o      : STD_LOGIC; 
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
        s_SW <= "000";
        wait for 1500ms;

        s_SW <= "001";
        wait for 1500ms;

        s_SW <= "010";
        wait for 1500ms;

        s_SW <= "011";
        wait for 1500ms;

        s_SW <= "100";
        wait for 1500ms;

        s_SW <= "101";
        wait for 1500ms;

        s_SW <= "110";
        wait for 1500ms;

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

        s_hall_sens_i <= '1';
        wait for 1 ms;

        s_hall_sens_i <= '0';
        wait for 100 ms;
               
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
        wait for 14400 ms;

--        s_reset <= '1';
--        wait for 100 ms;
        
--        s_reset <= '0';
--        wait for 100 ms;
        
        s_reset <= '1';
        wait for 250 ms;
        
        s_reset <= '0';
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






















