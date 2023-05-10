library ieee;
use ieee.std_logic_1164.all;

entity mux_3x1 is
  generic (
    width  :     positive := 8);
  port(
    in1,in2,in3        : in  std_logic_vector(width-1 downto 0);
    sel                : in  std_logic_vector(1 downto 0);
    output             : out std_logic_vector(width-1 downto 0));
end mux_3x1;


architecture WITH_SELECT of mux_3x1 is
begin
  with sel select
    output <= in1 when "00",
    in2           when "01",
    in3           when "10",
    in3           when others;
end WITH_SELECT;

