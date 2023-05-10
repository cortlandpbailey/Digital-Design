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
    begin
        if (is_sign = '1') then
            output <= (others => input(width-1));
        else
            output <= "0000000000000000" & input;
        end if;
    end process;
    
    
end architecture BHV;