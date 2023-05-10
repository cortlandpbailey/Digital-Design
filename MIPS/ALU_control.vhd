library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Control is
    port (
        OPselect        : out std_logic_vector(4 downto 0);
        instr           : in std_logic_vector(5 downto 0);
        ALU_lo_HI       : out std_logic_vector(1 downto 0);
        ALU_OP          : in std_logic_vector(3 downto 0);
        hi_en, low_en   : out std_logic;
        is_mult, jr     : out std_logic);

end ALU_Control;

architecture BHV of ALU_control is
    -- ALU_OP constants:
        constant R          : std_logic_vector(3 downto 0) := x"0";
        constant IMM_ADD    : std_logic_vector(3 downto 0) := x"1";
        constant IMM_SUB    : std_logic_vector(3 downto 0) := x"2";
        constant IMM_AND    : std_logic_vector(3 downto 0) := x"3";
        constant IMM_OR     : std_logic_vector(3 downto 0) := x"4";
        constant IMM_XOR    : std_logic_vector(3 downto 0) := x"5";
        constant IMM_SETU   : std_logic_vector(3 downto 0) := x"6";
        constant IMM_SETS   : std_logic_vector(3 downto 0) := x"7";
        constant BR_EQ      : std_logic_vector(3 downto 0) := x"8";
        constant BR_NEQ     : std_logic_vector(3 downto 0) := x"9";
        constant BR_GT      : std_logic_vector(3 downto 0) := x"A";
        constant BR_LT      : std_logic_vector(3 downto 0) := x"B";
        constant BR_LTE     : std_logic_vector(3 downto 0) := x"C";
        constant BR_GTE     : std_logic_vector(3 downto 0) := x"D";
        constant ALU_PASS   : std_logic_vector(3 downto 0) := x"E";


    -- Function code constants:
        constant ADDU   : std_logic_vector(5 downto 0) := "100001";     -- 0x21
        constant SUBU   : std_logic_vector(5 downto 0) := "100011";     -- 0x23
        constant FSRL   : std_logic_vector(5 downto 0) := "000010";     -- 0x02
        constant MULT   : std_logic_vector(5 downto 0) := "011000";     -- 0x18
        constant MULTU  : std_logic_vector(5 downto 0) := "011001";     -- 0x19
        constant FAND   : std_logic_vector(5 downto 0) := "100100";     -- 0x24
        constant F_OR   : std_logic_vector(5 downto 0) := "100101";     -- 0x25
        constant FXOR   : std_logic_vector(5 downto 0) := "100110";     -- 0x26
        constant FSLL   : std_logic_vector(5 downto 0) := "000000";     -- 0x00
        constant FSRA   : std_logic_vector(5 downto 0) := "000011";     -- 0x03
        constant SLTS   : std_logic_vector(5 downto 0) := "101010";     -- 0x2A
        constant SLTU   : std_logic_vector(5 downto 0) := "101011";     -- 0x2B
        constant MFHI   : std_logic_vector(5 downto 0) := "010000";     -- 0x10
        constant MFLO   : std_logic_vector(5 downto 0) := "010010";     -- 0x12
        constant PASS   : std_logic_vector(5 downto 0) := "001000";     -- 0x08

    -- ALU Control constants:
        constant ALU_ADD                : std_logic_vector(4 downto 0) := "00000"; --HEX 00
        constant ALU_SUB                : std_logic_vector(4 downto 0) := "00001"; --HEX 01
        constant ALU_MULT_SIGNED        : std_logic_vector(4 downto 0) := "00010"; --HEX 02
        constant ALU_MULT_UNSIGNED      : std_logic_vector(4 downto 0) := "00011"; --HEX 03
        constant ALU_AND                : std_logic_vector(4 downto 0) := "00100"; --HEX 04
        constant ALU_OR                 : std_logic_vector(4 downto 0) := "00101"; --HEX 05
        constant ALU_XOR                : std_logic_vector(4 downto 0) := "00110"; --HEX 06
        constant ALU_LOGICAL_SHIFT_R    : std_logic_vector(4 downto 0) := "00111"; --HEX 07
        constant ALU_LOGICAL_SHIFT_L    : std_logic_vector(4 downto 0) := "01000"; --HEX 08
        constant ALU_ARITH_SHIFT_R      : std_logic_vector(4 downto 0) := "01001"; --HEX 09
        constant ALU_LT                 : std_logic_vector(4 downto 0) := "01010"; --HEX 0A
        constant ALU_LT_OR_E            : std_logic_vector(4 downto 0) := "01011"; --HEX 0B
        constant ALU_GT                 : std_logic_vector(4 downto 0) := "01100"; --HEX 0C
        constant ALU_GT_OR_E            : std_logic_vector(4 downto 0) := "01101"; --HEX 0D
        constant ALU_EQ                 : std_logic_vector(4 downto 0) := "01110"; --HEX 0E
        constant ALU_NOT_EQ             : std_logic_vector(4 downto 0) := "01111"; --HEX 0F
        constant ALU_SET_LT_UNS         : std_logic_vector(4 downto 0) := "10000"; --HEX 10
        constant ALU_SET_LT             : std_logic_vector(4 downto 0) := "10001"; --HEX 11
        constant ALU_PASS_THRU          : std_logic_vector(4 downto 0) := "10010"; -- 0x12

begin

process(instr, ALU_OP)
begin
    -- Default control signals:
    ALU_lo_HI <= "00";
    jr <= '0';
    hi_en <= '0';
    low_en <= '0';
    is_mult <= '0';
    OPselect <= ALU_ADD;
    case ALU_OP is
    when R => 
        case instr is
            when ADDU => 
                OPselect <= ALU_ADD;

            when SUBU => 
                OPselect <= ALU_SUB;

            when FSRL => 
                OPselect <= ALU_LOGICAL_SHIFT_R;

            when MULT =>
                OPselect <= ALU_MULT_SIGNED;
                low_en <= '1';
                hi_en <= '1';
                is_mult <= '1';

            when MULTU =>
                OPselect <= ALU_MULT_UNSIGNED;
                low_en <= '1';
                hi_en <= '1';
                is_mult <= '1';
                
            when FAND =>
                OPselect <= ALU_AND;

            when F_OR =>
                OPselect <= ALU_OR;

            when FXOR =>
                OPselect <= ALU_XOR;

            when FSLL =>
                OPselect <= ALU_LOGICAL_SHIFT_L;

            when FSRA =>
                OPselect <= ALU_ARITH_SHIFT_R;

            when SLTS => 
                OPselect <= ALU_SET_LT;

            when SLTU =>
                OPselect <= ALU_SET_LT_UNS;

            when MFHI => 
                --OPselect <= (others => '0');
                ALU_lo_HI <= "10";

            when MFLO => 
                --OPselect <= (others => '0');
                ALU_lo_HI <= "01";
            
            when PASS => 
                jr <= '1';
                OPselect <= ALU_PASS_THRU;

            when others => null;

        end case;
    
    when IMM_ADD => 
        -- IF ALU_OP is set for a LW/SW operation just to an add function with the ALU
        OPselect <= ALU_ADD;

    when IMM_SUB => 
        OPselect <= ALU_SUB;

    when IMM_AND => 
        OPselect <= ALU_AND;

    when IMM_OR => 
        OPselect <= ALU_OR;

    when IMM_XOR => 
        OPselect <= ALU_XOR;

    when IMM_SETS => 
        OPselect <= ALU_SET_LT;

    when IMM_SETU => 
        OPselect <= ALU_SET_LT_UNS;
        
    when BR_EQ => 
        OPselect <= ALU_EQ;

    when BR_NEQ => 
        OPselect <= ALU_NOT_EQ;

    when BR_GT => 
        OPselect <= ALU_GT;

    when BR_GTE => 
        OPselect <= ALU_GT_OR_E;

    when BR_LT => 
        OPselect <= ALU_LT;

    when BR_LTE => 
        OPselect <= ALU_LT_OR_E;

    when ALU_PASS => 
        OPselect <= ALU_PASS_THRU;

    when others => 
        OPselect <= ALU_ADD;
    end case;


end process;
    
end architecture BHV;
