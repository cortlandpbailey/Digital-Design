library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_ext is
    generic (
        width : positive := 8);
    port (
        input : in std_logic_vector(width-1 downto 0);
        output : out std_logic_vector(2*width-1 downto 0);    
        is_sign : in std_logic);
end sign_ext;

architecture BHV of sign_ext is
    
begin
    process(input, is_sign)
        variable temp : std_logic;
    begin
        if (is_sign = '1') then
            temp := input(width-1);
            output(2*width-1 downto width) <= (others => temp);
            output(width-1 downto 0) <= input;
        else
            output <= x"0000" & input;
        end if;
    end process;
    
    
end architecture BHV;