library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    generic (width :     positive := 32);
    port (
        clk    : in  std_logic;
        rst    : in  std_logic := '0';
        en     : in  std_logic := '1';
        input  : in  std_logic_vector(WIDTH-1 downto 0) := (others => '0');
        output : out std_logic_vector(WIDTH-1 downto 0)
	);

end reg;

architecture EN_REG of reg is
    
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            output <= (others => '0');           
        elsif (rising_edge(clk)) then
            if (en = '1') then
                output <= input;
            end if;
        end if;
    end process;
end architecture EN_REG;