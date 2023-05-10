library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is
    signal input1,input2,result, result_hi : std_logic_vector(31 downto 0);
    signal shift_in : unsigned(4 downto 0);
    signal sel : std_logic_vector(4 downto 0);
    signal branch_taken : std_logic;
begin
    
    UUT : entity work.alu
    port map (
        input1 => input1,
        input2 => input2,
        shift_in => shift_in,
        sel => sel,
        result => result,
        result_hi => result_hi,
        branch_taken => branch_taken);

process
begin
    shift_in <= (others => '0');
    --Test addition of 10+15
    sel    <= "00000";
    input1 <= std_logic_vector(to_unsigned(10, input1'length));
    input2 <= std_logic_vector(to_unsigned(15, input2'length));
    wait for 40 ns;
    assert(result = std_logic_vector(to_unsigned(25, result'length))) report "Error : 10+15 = " & integer'image(to_integer(unsigned(result))) & " instead of 25" severity warning;
        
    --Test subtraction of 25-10 
    sel    <= "00001";
    input1 <= std_logic_vector(to_unsigned(25, input1'length));
    input2 <= std_logic_vector(to_unsigned(10, input2'length));
    wait for 40 ns;
    assert(result = std_logic_vector(to_unsigned(15, result'length))) report "Error : 25-10 = " & integer'image(to_integer(unsigned(result))) & " instead of 15" severity warning;

--Test signed multiplication of 10* -4
    sel    <= "00010";
    input1 <= std_logic_vector(to_signed(10, input1'length));
    input2 <= std_logic_vector(to_signed(-4, input2'length));
    wait for 40 ns;
    assert(result = std_logic_vector(to_signed(-40, result'length))) report "Error : 10 * -4 = " & integer'image(to_integer(signed(result))) & " instead of -40" severity warning;

    --Test unsigned multiplication of 65536 * 131072
    sel    <= "00011";
    input1 <= std_logic_vector(to_unsigned(65536, input1'length));
    input2 <= std_logic_vector(to_unsigned(131072, input2'length));
    wait for 40 ns;
    --assert(result_hi & result = std_logic_vector(to_unsigned(8589934592, result'length*2))) report "Error : 65536 * 131072 = " & integer'image(to_integer(unsigned(result_hi & result))) & " instead of 8,589,934,592" severity warning;


    --Test logical AND of 0x0000FFFF and 0xFFFF1234
    sel    <= "00100";
    input1 <= "00000000000000001111111111111111"; 
    input2 <= "11111111111111110001001000110100";
    wait for 40 ns;
    assert(result = "00000000000000000001001000110100") report "Error: 0x0000FFFF AND 0xFFFF1234 = " & "instead of 0x00001234" severity warning;
  
    -- Test shift right logical of 0x0000000F by 4 
    sel <= "00111";
    input1 <= "00000000000000000000000000001111";
    shift_in <= "00100";
    wait for 40 ns;
    assert (result = "00000000000000000000000000000000") report "Error: 0x0000000F shifted right logically by 4 = something " & "instead of 0x00000000" severity warning;


    -- Test shift right arithmetic of 0xF0000008 by 1 
    sel <= "01001";
    input1 <= "11110000000000000000000000001000";
    shift_in <= "00001";
    wait for 40 ns;
    assert (result = "11111000000000000000000000000100") report "Error: 0xF0000008 shifted right arithmetically by 1 : something " & "instead of 0xF8000004" severity warning;


    --test shift right arithmetic of 0x00000008 by 1 
    sel <= "01001";
    input1 <= "00000000000000000000000000001000";    
    shift_in <= "00001";
    wait for 40 ns;
    assert (result = "00000000000000000000000000000100") report "Error: 0x00000008 shifted right arithmetically by 1 : " &  integer'image(to_integer(unsigned(result))) & "instead of 0x00000004" severity warning;


    --Test set on less than using 10 and 15 
    sel <= "10000";
    input1 <= std_logic_vector(to_unsigned(10, input1'length));
    input2 <= std_logic_vector(to_unsigned(15, input2'length));
    wait for 40 ns;
    assert (result = std_logic_vector(to_unsigned(1,result'length))) report "Error: Set not correct for 10 Less than 15" severity warning;

    --Test set on less than using 15 and 10 
    sel <= "10000";
    input1 <= std_logic_vector(to_unsigned(15, input1'length));
    input2 <= std_logic_vector(to_unsigned(10, input2'length));
    wait for 40 ns;
    assert (result = "00000000000000000000000000000000") report "Error: Set not correct for 15 Less than 10" severity warning;

    --Test Branch Taken output = ‘0’ for for 5 <= 0 
    sel <= "01011";
    input1 <= std_logic_vector(to_unsigned(5, input1'length));
    wait for 40 ns;
    assert (branch_taken = '0') report "Error: Branch not correct for 5 Less than 0" severity warning;


    --Test Branch Taken output = ‘1’ for for 5 > 0
    sel <= "01100";
    input1 <= std_logic_vector(to_unsigned(5, input1'length));
    wait for 40 ns;
    assert (branch_taken = '1') report "Error: Branch not correct for 5 greater than 0" severity warning;


    wait;
end process;

end architecture TB;