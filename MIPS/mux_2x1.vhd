library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
  generic (
    width  :     positive := 8);
  port(
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    sel    : in  std_logic;
    output : out std_logic_vector(width-1 downto 0));
end mux_2x1;


architecture WITH_SELECT of mux_2x1 is
begin
  with sel select
    output <= in1 when '0',
    in2           when others;
end WITH_SELECT;

-- remove with select to fix vivado issue

