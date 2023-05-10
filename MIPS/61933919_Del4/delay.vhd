library ieee;
use ieee.std_logic_1164.all;

entity delay is
  generic(cycles : natural;
          width  : positive);
  port( clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(width-1 downto 0);
        output : out std_logic_vector(width-1 downto 0));
end delay;

architecture STR of delay is

  type reg_array is array (0 to cycles) of std_logic_vector(width-1 downto 0);
  signal regs : reg_array;

begin

  U_CYCLES_GT_0 : if cycles > 0 generate

    regs(0) <= input;

    U_DELAY_REGS : for i in 0 to cycles-1 generate
      U_REG      : entity work.reg
        generic map (width => width)     
        port map (clk      => clk,
                  rst      => rst,
                  en       => en,
                  input    => regs(i),
                  output   => regs(i+1));
    end generate U_DELAY_REGS;

    output <= regs(cycles);

  end generate U_CYCLES_GT_0;

  U_CYCLES_EQ_0 : if cycles = 0 generate

    output <= input;

  end generate U_CYCLES_EQ_0;

end STR;