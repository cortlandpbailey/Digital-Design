library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        clk, rst, is_mult, branch_taken : in std_logic;
        irwrite, IorD                   : out std_logic;
        memwrite                        : out std_logic;
        MemtoReg, regwrite              : out std_logic;
        IsSigned, JumpandLink, ALUsrcA  : out std_logic;
        RegDST, PCWrite                 : out std_logic;
        jr                              : in std_logic;
        ALU_OP                          : out std_logic_vector(3 downto 0);
        ALUsrcB, PCSource               : out std_logic_vector(1 downto 0);
        IR_IN                           : in std_logic_vector(5 downto 0);
        BR_IN                           : in std_logic_vector(4 downto 0)
    );
end controller;


architecture fsm of controller is
    type MIPS_STATE is (LOAD_INSTR, R_TYPE, INSTR_DECODE, JL_LOAD,BRANCH_WAIT, INSTR_WAIT,MEM_COMPUTATION, 
        LW_READ, R_NOTMULT, LW, SW, ADDI, SUBI, ANDI, ORI, BRANCH, XORI, SETSI, INIT, SW_WAIT, 
        SETUI, LW_WAIT, I_TYPE_STORE, BRANCH_EQ, BRANCH_GT, BRANCH_GTE, BRANCH_LT, BRANCH_LTE, 
        BRANCH_NEQ, JL, JP, J_WAIT, R_STORE);
    signal state, next_state : MIPS_STATE;
    signal PCWriteCond, PCW  : std_logic;
    -- OPcode constants:
        constant R              : std_logic_vector(5 downto 0) := "000000";
        constant store_word     : std_logic_vector(5 downto 0) := "101011";
        constant read_word      : std_logic_vector(5 downto 0) := "100011";
        constant add_imm        : std_logic_vector(5 downto 0) := "001001";
        constant sub_imm        : std_logic_vector(5 downto 0) := "010000";
        constant and_imm        : std_logic_vector(5 downto 0) := "001100";
        constant or_imm         : std_logic_vector(5 downto 0) := "001101";
        constant xor_imm        : std_logic_vector(5 downto 0) := "001110";
        constant slts_imm       : std_logic_vector(5 downto 0) := "001010";
        constant sltu_imm       : std_logic_vector(5 downto 0) := "001011";
        constant halt           : std_logic_vector(5 downto 0) := "111111";
        constant br_eq          : std_logic_vector(5 downto 0) := "000100";
        constant br_neq         : std_logic_vector(5 downto 0) := "000101";
        constant br_lte         : std_logic_vector(5 downto 0) := "000110";
        constant br_lt          : std_logic_vector(5 downto 0) := "000001";
        constant br_gte         : std_logic_vector(5 downto 0) := "000001";
        constant br_gt          : std_logic_vector(5 downto 0) := "000111";
        constant jump           : std_logic_vector(5 downto 0) := "000010";
        constant jal            : std_logic_vector(5 downto 0) := "000011";
    
    
    --ALU_OP Constants:
        constant ALU_R       : std_logic_vector(3 downto 0) := x"0";
        constant IMM_ADD     : std_logic_vector(3 downto 0) := x"1";
        constant IMM_SUB     : std_logic_vector(3 downto 0) := x"2";
        constant IMM_AND     : std_logic_vector(3 downto 0) := x"3";
        constant IMM_OR      : std_logic_vector(3 downto 0) := x"4";
        constant IMM_XOR     : std_logic_vector(3 downto 0) := x"5";
        constant IMM_SETU    : std_logic_vector(3 downto 0) := x"6";
        constant IMM_SETS    : std_logic_vector(3 downto 0) := x"7";
        constant BRA_EQ      : std_logic_vector(3 downto 0) := x"8";
        constant BRA_NEQ     : std_logic_vector(3 downto 0) := x"9";
        constant BRA_GT      : std_logic_vector(3 downto 0) := x"A";
        constant BRA_LT      : std_logic_vector(3 downto 0) := x"B";
        constant BRA_LTE     : std_logic_vector(3 downto 0) := x"C";
        constant BRA_GTE     : std_logic_vector(3 downto 0) := x"D";
        constant ALU_PASS    : std_logic_vector(3 downto 0) := x"E";

begin
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= INIT;
        elsif (rising_edge(clk)) then
            state <=  next_state;
        end if;
    end process;

    process(state, IR_IN, is_mult, BR_IN, jr)
    begin
        --Default control outputs
        memwrite <= '0';
        irwrite <= '0';
        IorD <= '0';
        MemtoReg <= '0';
        regwrite <= '0';
        IsSigned <= '0';
        JumpandLink <= '0';
        RegDST <= '0';
        ALU_OP <= ALU_PASS;
        ALUsrcA <= '0';
        ALUsrcB <= "01";
        PCSource <= "00";
        PCW <= '0';
        PCWriteCond <= '0';
        next_state <= state;

        case state is
            when INIT => 
                PCSource <= "01";
                next_state <= LOAD_INSTR;
                ALU_OP <= IMM_ADD;

            when LOAD_INSTR => 
                IorD <= '0';
                PCW <= '1';
                ALU_OP <= IMM_ADD;
                next_state <= INSTR_WAIT;

                -- wait for data - 1 clocks - a whole state to itself
            when INSTR_WAIT => 
                IRWrite <= '1';
                next_state <= INSTR_DECODE;
                
                -- IRWrite - enable for Instruction register = 1
                -- PC increment operation: 
                -- PC+4 op: ALUsrcA -> '0'
                -- ALUsrcB -> '1'
                -- PCSource ->'00'
                -- PCWrite -> '1' to enable PC
                -- Read OP Code:
            when INSTR_DECODE => 
                --PCWrite <= '1';           
                --ALU_OP <= ALU_R;
                ALUsrcB <= "01";
                ALUsrcA <= '0';
                              
                if (IR_IN = R) then
                    next_state <= R_TYPE;

                elsif (IR_IN = read_word or IR_IN = store_word) then
                    next_state <= MEM_COMPUTATION;
                    IsSigned <= '0';
                    ALUsrcB <= "10";
                    ALUsrcA <= '1';

                elsif (IR_IN = add_imm) then
                    next_state <= ADDI;

                elsif (IR_IN = sub_imm) then
                    next_state <= SUBI;

                elsif (IR_IN = and_imm) then 
                    next_state  <= ANDI;

                elsif (IR_IN = or_imm) then
                    next_state <= ORI;


                elsif (IR_IN = xor_imm) then
                    next_state <= XORI;

                elsif (IR_IN = slts_imm) then
                    next_state <= SETSI;

                elsif (IR_IN = sltu_imm) then
                    next_state <= SETUI;

                elsif (IR_IN = jump) then
                    next_state <= JP;

                elsif (IR_IN = jal) then
                    next_state <= JL;
                
                elsif(IR_IN = br_eq or IR_IN = br_neq OR IR_IN = br_lte OR IR_IN = br_lt OR IR_IN = br_gte OR IR_IN = br_gt) then 
                    next_state <= BRANCH;

                --elsif(IR_IN = jal) then 
                    --JumpandLink <= '1';     -- Control signal to Reg File to store address in r31
                    --PCSource <= "10";       -- Jump to given instr address
                    --PCW <= '1';

                    --MemtoReg <= '1';
                  --  next_state <= JL;

                else
                    next_state <= LOAD_INSTR;
                end if;

                        
            when MEM_COMPUTATION => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                ALU_OP <= IMM_ADD;
                if (IR_IN = read_word) then
                    next_state <= LW;
                else
                    next_state <= SW;
                end if;

            when R_TYPE => 
                ALU_OP <= ALU_R;
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                if (is_mult = '1') then
                    RegDST <= '0';
                    regwrite <= '0';
                    next_state <= LOAD_INSTR;
                else
                    next_state <= R_NOTMULT;
                end if;

            when R_STORE => 
                ALU_OP <= ALU_R;
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                RegDST <= '1';
                --regwrite <= '1';
                next_state <= LOAD_INSTR;

            when R_NOTMULT => 
                ALU_OP <= ALU_R;
                if (jr = '1') then
                    PCW <= '1';
                end if;
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                RegDST <= '1';
                regwrite <= '1';
                next_state <= R_STORE;

            when LW => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IorD <= '1';
                --MemtoReg <= '1';
                RegDST <= '0';
                next_state <= LW_WAIT;

            when LW_WAIT => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IorD <= '1';
                --MemtoReg <= '1';
                RegDST <= '0';
                --regwrite <= '1';
                MemtoReg <= '1';
                next_state <= LW_READ;

            when LW_READ =>
                ALUsrcA <= '1';
                ALUsrcB <= "10"; 
                --IorD <= '1';
                RegDST <= '0';
                regwrite <= '1';
                MemtoReg <= '1';
                next_state <= LOAD_INSTR;

            when SW => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '1';
                IorD <= '1';
                memwrite <= '1';
                irwrite <= '1';
                next_state <= SW_WAIT;

            when SW_WAIT => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                --IorD <= '1';
                --memwrite <= '1';
                next_state <= LOAD_INSTR;

            when ADDI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '0';
                ALU_OP <= IMM_ADD;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;

            when SUBI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '0';
                ALU_OP <= IMM_SUB;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;
            
            when ANDI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                ALU_OP <= IMM_AND;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;

            when ORI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                ALU_OP <= IMM_OR;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;
            
            when XORI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                ALU_OP <= IMM_XOR;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;

            when SETSI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '1';
                ALU_OP <= IMM_SETS;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;

            when SETUI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '1';
                ALU_OP <= IMM_SETU;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;
            
            when I_TYPE_STORE => 
                regwrite <= '1';
                next_state <= LOAD_INSTR;
   
            when JP => 
                PCW <= '1';
                PCSource <= "10"; 
                next_state <= J_WAIT;   
                
                
            when J_WAIT => 
                next_state <= LOAD_INSTR;
            
            when JL => 
                PCSource <= "10";       
                PCW <= '1';
                next_state <= JL_LOAD;
                
            when JL_LOAD => 
                ALU_OP <= ALU_PASS;
                JumpandLink <= '1';
                next_state <= LOAD_INSTR;
          
            when BRANCH => 
                IsSigned <= '1';
                ALUsrcB <= "11";
                ALU_OP <= IMM_ADD;
                PCSource <= "01";
                
                if (IR_IN = br_eq) then
                    next_state <= BRANCH_EQ;

                elsif (IR_IN = br_neq) then
                    next_state <= BRANCH_NEQ;

                elsif( IR_IN = br_lte) then
                    next_state <= BRANCH_LTE;

                elsif (IR_IN = br_lt) then
                    next_state <= BRANCH_LT;

                elsif (IR_IN = br_gte) then
                    next_state <= BRANCH_GTE;

                elsif (IR_IN <= br_gt) then
                    next_state <= BRANCH_GT;
                end if;
                
            when BRANCH_EQ => 
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                ALU_OP <= BRA_EQ;
                PCSource <= "01";
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_NEQ => 
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                ALU_OP <= BRA_NEQ;  
                PCSource <= "01";
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_GT => 
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                ALU_OP <= BRA_GT;
                PCSource <= "01"; 
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_GTE => 
                ALU_OP <= BRA_GTE;  
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                PCSource <= "01";  
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_LT => 
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                PCSource <= "01"; 
                ALU_OP  <= BRA_LT;   
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_LTE => 
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                PCSource <= "01"; 
                ALU_OP <= BRA_LTE;   
                PCWriteCond <= '1';
                next_state <= BRANCH_WAIT;

            when BRANCH_WAIT => 
                next_state <= LOAD_INSTR;

            when others => null;
            end case;
    
        end process;
        PCWrite <=  PCW OR (PCWriteCond AND branch_taken);
end architecture fsm;