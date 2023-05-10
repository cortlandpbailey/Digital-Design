library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        clk, rst, is_mult               : in std_logic;
        irwrite, IorD                   : out std_logic;
        memwrite                        : out std_logic;
        MemtoReg, regwrite              : out std_logic;
        IsSigned, JumpandLink, ALUsrcA  : out std_logic;
        RegDST, PCWrite                 : out std_logic;
        ALU_OP                          : out std_logic_vector(2 downto 0);
        ALUsrcB, PCSource               : out std_logic_vector(1 downto 0);
        IR_IN                           : in std_logic_vector(5 downto 0);
        BR_IN                           : in std_logic_vector(4 downto 0)
    );
end controller;


architecture fsm of controller is
    type MIPS_STATE is (LOAD_INSTR, R_TYPE, INSTR_DECODE, INSTR_WAIT,MEM_COMPUTATION,R_MULT, 
        LW_READ, R_NOTMULT, LW, SW, ADDI, SUBI, ANDI, ORI, XORI, SETSI, INIT, SW_WAIT, SETUI, LW_WAIT, I_TYPE_STORE, fin);
    signal state, next_state : MIPS_STATE;
    signal PCWriteCond : std_logic;
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
    --ALU_OP Constants:
    constant ALU_R      : std_logic_vector(2 downto 0) := "000";
    constant IMM_ADD    : std_logic_vector(2 downto 0) := "001";
    constant IMM_SUB    : std_logic_vector(2 downto 0) := "010";
    constant IMM_AND    : std_logic_vector(2 downto 0) := "011";
    constant IMM_OR     : std_logic_vector(2 downto 0) := "100";
    constant IMM_XOR    : std_logic_vector(2 downto 0) := "101";
    constant IMM_SETU   : std_logic_vector(2 downto 0) := "110";
    constant IMM_SETS   : std_logic_vector(2 downto 0) := "111";


begin
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= INIT;
        elsif (rising_edge(clk)) then
            state <=  next_state;
        end if;
    end process;

    process(state, IR_IN, is_mult, BR_IN)
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
        ALU_OP <= IMM_ADD;
        ALUsrcA <= '0';
        ALUsrcB <= "01";
        PCSource <= "00";
        PCWrite <= '0';

        case state is
            -- First instruction: 
            -- IorD = '0' to load memory address
            -- mem_write = 0 (because we're reading and not writing from memory
            when INIT => 
                PCSource <= "01";
                next_state <= LOAD_INSTR;

            when LOAD_INSTR => 
                IorD <= '0';
                PCWrite <= '1';
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

                elsif (IR_IN = halt) then
                    next_state <= fin;
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
                    next_state <= R_MULT;
                else
                    next_state <= R_NOTMULT;
                end if;

            when R_MULT => 
                ALU_OP <= ALU_R;
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                RegDST <= '0';
                regwrite <= '0';
                next_state <= LOAD_INSTR;

            when R_NOTMULT => 
                ALU_OP <= ALU_R;
                ALUsrcA <= '1';
                ALUsrcB <= "00";
                RegDST <= '1';
                regwrite <= '1';
                next_state <= LOAD_INSTR;

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
                IsSigned <= '1';
                ALU_OP <= IMM_ADD;
                MemtoReg <= '1';
                next_state <= I_TYPE_STORE;

            when SUBI => 
                ALUsrcA <= '1';
                ALUsrcB <= "10";
                IsSigned <= '1';
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

            when fin => 
                next_state <=  fin;    

            end case;
    
        end process;
end architecture fsm;