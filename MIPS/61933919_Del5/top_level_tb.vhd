library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_tb is
end top_level_tb;

architecture TB of top_level_tb is
    signal clk      : std_logic := '0';
    signal button   : std_logic_vector(1 downto 0);  
    signal switches : std_logic_vector(9 downto 0);
    signal led0     : std_logic_vector(6 downto 0);
    signal led0_dp  : std_logic;
    signal led1     : std_logic_vector(6 downto 0);
    signal led1_dp  : std_logic;
    signal led2     : std_logic_vector(6 downto 0);
    signal led2_dp  : std_logic;
    signal led3     : std_logic_vector(6 downto 0);
    signal led3_dp  : std_logic;
    signal led4     : std_logic_vector(6 downto 0);
    signal led4_dp  : std_logic;
    signal led5     : std_logic_vector(6 downto 0);
    signal led5_dp  : std_logic;
begin
    
    UUT : entity work.top_level
        port map (
            clk =>  clk,
            button => button,
            switches =>  switches,
            led0 => led0,
            led0_dp => led0_dp,
            led1 => led1,
            led1_dp => led1_dp,
            led2 => led2, 
            led2_dp => led2_dp,
            led3 => led3,
            led3_dp => led3_dp,
            led4 => led4,
            led4_dp => led4_dp,
            led5 => led5,
            led5_dp => led5_dp);
            

            clk <= not clk after 10 ns;

            process
            begin
                button <= "11";
                wait for 20 ns;
                button <= "10";
                switches <= "1000001100"; --(others => '0');
                wait for 20 ns;
                switches <= "0000001000";
                wait for 20 ns;
                button <= "01";
                wait for 20 ns;
                button <= "11";






                wait;
            end process;
    
end architecture TB;