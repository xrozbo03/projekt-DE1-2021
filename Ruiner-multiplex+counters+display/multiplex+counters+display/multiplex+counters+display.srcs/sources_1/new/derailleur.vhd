------------------------------------------------------------------------
-- Copyright (c) 2032-Present Michal Ruiner
-- This work is licensed under the terms of the MIT license.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity derailleur is
    Port ( 
        clk                   : in STD_LOGIC;                           -- Main clock
        reset                 : in STD_LOGIC;                           -- Synchronous reset
        btn_i                 : in STD_LOGIC;                           -- Input button to set level of difficulty
        level_of_difficulty_o : out STD_LOGIC_VECTOR (3 - 1 downto 0)   -- Output to display on tri-color LED which level of difficulty is active
    );
end derailleur;

architecture Behavioral of derailleur is

    -- States of difficulty
    type   t_state is (ONE, TWO, THREE);
    
    -- Define the signal that uses different states
    signal s_state     : t_state   := TWO;      -- Default state is TWO
    signal s_cnt_btn   : std_logic := '0';      -- Signal to proces button

begin

    p_output_derailleur : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then           -- Synchronous reset
                s_state     <= TWO ;        -- Set initial state
                s_cnt_btn   <= '0';
            elsif (btn_i = '1' and s_cnt_btn = '0') then    -- if button is pushed after release
                case s_state is
                    when ONE =>
                          -- Move to the next state
                          s_state <= TWO;

                    when TWO =>
                          -- Move to the next state
                          s_state <= THREE;
                        
                    when THREE =>
                        -- Move to the next state
                        s_state <= ONE;
                       
                    when others =>
                        s_state <= TWO;  -- Default state if there is different output

                end case;
                s_cnt_btn   <= '1';
            elsif (btn_i = '0' and s_cnt_btn = '1') then    -- if button was released
                s_cnt_btn   <= '0';
            end if;
        end if;   
    end process p_output_derailleur;
    
    p_output_states : process(s_state)
    begin
        case s_state is
            when ONE =>
                level_of_difficulty_o  <= "100";   -- Red (RGB = 100)
            when TWO =>
                level_of_difficulty_o  <= "010";   -- Green (RGB = 010)
            when THREE =>
                level_of_difficulty_o  <= "001";   -- Blue (RGB = 001)
            when others =>
                level_of_difficulty_o  <= "010";   -- Green (RGB = 010)
        end case;
    end process p_output_states;

end Behavioral;
