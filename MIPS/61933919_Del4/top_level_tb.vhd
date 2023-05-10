library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_tb is
end top_level_tb;

architecture TB of top_level_tb is
    signal clk : std_logic := '0';
    signal buttons : std_logic_vector(1 downto 0);  
    signal switches : std_logic_vector(9 downto 0);
    signal LEDS : std_logic_vector(31 downto 0);
begin
    
    UUT : entity work.top_level
        port map (
            clk =>  clk,
            buttons => buttons,
            switches =>  switches,
            LEDS =>  LEDS);
            

            clk <= not clk after 10 ns;

            process
            begin
                buttons <= "10";
                wait for 20 ns;
                buttons <= "00";
                switches <= "1111111111"; --(others => '0');
                wait;
            end process;
    
end architecture TB;