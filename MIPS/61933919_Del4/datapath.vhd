library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
    port (
        --I/O:
        switches                        : in std_logic_vector(9 downto 0);
        buttons                         : in std_logic_vector(1 downto 0);
        LEDS                            : out std_logic_vector(31 downto 0);
        clk, rst                        : in std_logic;
        -- Controller Signals:
        irwrite, IorD                   : in std_logic;
        memwrite                        : in std_logic;
        MemtoReg, regwrite              : in std_logic;
        IsSigned, JumpandLink, ALUsrcA  : in std_logic;
        RegDST, PCWrite                 : in std_logic;
        is_mult                         : out std_logic;
        ALU_OP                          : in std_logic_vector(2 downto 0);
        ALUsrcB, PCSource               : in std_logic_vector(1 downto 0);
        IR_OUT                          : out std_logic_vector(5 downto 0);
        BR_OUT                          : out std_logic_vector(4 downto 0)
    );

end datapath;

architecture str of datapath is
    signal alu_result           : std_logic_vector(31 downto 0);
    signal alu_result_hi        : std_logic_vector(31 downto 0);
    signal PC_out               : std_logic_vector(31 downto 0); 
    signal PC_Mux_Out           : std_logic_vector(31 downto 0);
    signal ctrl_Mux_out         : std_logic_vector(31 downto 0);
    signal Mem_out              : std_logic_vector(31 downto 0);
    signal Instr_Reg_out        : std_logic_vector(31 downto 0);
    signal Mem_data_reg_out     : std_logic_vector(31 downto 0);
    signal read_data1           : std_logic_vector(31 downto 0);
    signal read_data2           : std_logic_vector(31 downto 0);
    signal alu_out              : std_logic_vector(31 downto 0);
    signal lo                   : std_logic_vector(31 downto 0);
    signal hi                   : std_logic_vector(31 downto 0);
    signal ALU_mux_out          : std_logic_vector(31 downto 0);
    signal mem_data_mux_out     : std_logic_vector(31 downto 0);
    signal Reg_A_Mux_out        : std_logic_vector(31 downto 0);
    signal Reg_B_Mux_out        : std_logic_vector(31 downto 0);
    signal Reg_A_out            : std_logic_vector(31 downto 0);
    signal Reg_B_out            : std_logic_vector(31 downto 0);
    SIGNAL sl1_out              : std_logic_vector(31 downto 0);
    signal Sign_ext_out         : std_logic_vector(31 downto 0);
    signal sl2_out              : std_logic_vector(25 downto 0);
    signal con_2                : std_logic_vector(31 downto 0);
    signal switch_data          : std_logic_vector(31 downto 0);
    signal IR_Mux_out           : std_logic_vector(4 downto 0);
    signal OPselect             : std_logic_vector(4 downto 0);
    signal ALU_lo_HI            : std_logic_vector(1 downto 0);
    signal low_en, hi_en, branch_taken : std_logic;


begin
    
    U_ALU : entity work.alu
        port map (
            input1 => Reg_A_Mux_out,
            input2 => Reg_B_Mux_out,
            shift_in => unsigned(Instr_Reg_out(10 downto 6)),
            sel => OPselect,
            result => alu_result,
            result_hi => alu_result_hi,
            branch_taken => branch_taken);

    PC : entity work.reg
        generic map (width => 32)
        port map (
            input => ctrl_Mux_out,
            clk => clk,
            rst => rst,
            en => PCWrite,            
            output => PC_out);

    PC_Mux : entity work.mux_2x1
        generic map (width => 32)
        port map (
            in1 => PC_out,
            in2 => alu_out,
            output => PC_Mux_Out,
            sel => IorD);

    U_Memory : entity work.memory
        port map (
            clk => clk,
            en => '1',
            rst => rst,
            MemWrite => MemWrite,
            Address => PC_Mux_Out,
            WrData => Reg_B_out,
            switch_in => switch_data,
            buttons => buttons,
            Output => Mem_out,
            LEDs => LEDS,
            Inport_sel => switches(9)
        );

    Instruction_Register : entity work.reg
        generic map (width => 32)
        port map ( 
            input => Mem_out,
            output => Instr_Reg_out,
            clk => clk,
            rst => rst,
            en => irwrite);

    IR_Mux : entity work.mux_2x1
        generic map (width => 5)
        port map (
            in1 => Instr_Reg_out(20 downto 16),
            in2 => Instr_Reg_out(15 downto 11),
            output => IR_Mux_out,
            sel => RegDST);
    
    Mem_data_mux : entity work.mux_2x1
        generic map (width => 32)
        port map (
            in1 => ALU_mux_out,
            in2 => Mem_out,
            output => mem_data_mux_out,
            sel => MemtoReg);

    Register_File : entity work.register_file
        port map (
            clk => clk,
            rst => rst,
            JumpandLink => JumpandLink,
            rd_addr0 => Instr_Reg_out(25 downto 21),
            rd_addr1 => Instr_Reg_out(20 downto 16),
            wr_addr => IR_Mux_out,
            wr_en => regwrite,
            wr_data => mem_data_mux_out,
            rd_data1 => read_data1,
            rd_data2 => read_data2
                    --=> JumpandLink
                    );

    Reg_A : entity work.reg
        generic map(width => 32)
        port map (
            input => read_data1,
            output => Reg_A_out,
            clk => clk,
            rst => rst,
            en => '1');
    
    Reg_B : entity work.reg
        generic map(width => 32)
        port map (
            input => read_data2,
            output => Reg_B_out,
            clk => clk,
            rst => rst,
            en => '1');

    Reg_A_Mux : entity work.mux_2x1
        generic map (width => 32)
        port map (
            in1 => PC_out,
            in2 => Reg_A_out,
            sel => ALUsrcA,
            output => Reg_A_Mux_out);
        
    Reg_B_Mux : entity work.mux_4x1
        generic map (width => 32)
        port map (
            in1 => Reg_B_out,
            in2 => std_logic_vector(to_unsigned(4, 32)),
            in3 => Sign_ext_out,
            in4 => sl1_out,
            sel => ALUsrcB,
            output => Reg_B_Mux_out);

    ctrl_Mux : entity work.mux_3x1
        generic map (width => 32)
        port map (
            in1 => alu_result, 
            in2 => alu_out,
            in3 => con_2, 
            sel => PCSource,
            output => ctrl_Mux_out);

    ALU_Control : entity work.ALU_Control
        port map (
            OPselect => OPselect,
            instr => Instr_Reg_out(5 downto 0),
            ALU_lo_HI => ALU_lo_HI,
            ALU_OP => ALU_OP,
            is_mult => is_mult,
            hi_en => hi_en,
            low_en => low_en);

    ALU_Out_reg : entity work.reg
        generic map (width => 32)
        port map (
            input => alu_result,
            output => alu_out,
            clk => clk,
            rst => rst,
            en => '1');

    ALU_LO_reg : entity work.reg
        generic map (width => 32)
        port map (
            input => alu_result,
            output => lo,
            clk => clk,
            rst => rst,
            en => low_en);

    ALU_HI_reg : entity work.reg
        generic map (width => 32)
        port map (
            input => alu_result_hi,
            output => hi,
            clk => clk,
            rst => rst,
            en => hi_en);

    ALU_Out_mux : entity work.mux_3x1
        generic map (width => 32)
        port map (
            in1 => alu_out,
            in2 => lo,
            in3 => hi,
            sel => ALU_lo_HI,
            output => ALU_mux_out);

    U_SIGN_EXTEND : entity work.sign_ext
        generic map (width => 16)
        port map (
            input => Instr_Reg_out(15 downto 0),
            output => Sign_ext_out,
            is_sign => IsSigned
        );

    SL1  : entity work.shift_left2
        generic map (width => 32)
        port map(
            input => Sign_ext_out,
            output => sl1_out);

    SL2 : entity work.shift_left2
        generic map ( width => 26)
        port map (
            input => Instr_Reg_out(25 downto 0),
            output => sl2_out);
    
process(sl2_out, switches, Instr_Reg_out)
begin
    con_2 <= PC_out(31 downto 28) & sl2_out & "00";

    -- Establish I/O selects, enables, and concat here:
    switch_data <= "00000000000000000000000" & switches(8 downto 0);
    IR_OUT <= Instr_Reg_out(31 downto 26);
    BR_OUT <= Instr_Reg_out(20 downto 16);
end process;

end architecture str;