library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_left2 is
    generic (width : positive := 8);
    port (
        input : in std_logic_vector(width-1 downto 0);
        output : out std_logic_vector(width-1 downto 0));
end shift_left2;

architecture bhv of shift_left2 is
    
begin
    process(input)
    begin
    output <= std_logic_vector(shift_left(unsigned(input),2));
    end process;
end architecture bhv;