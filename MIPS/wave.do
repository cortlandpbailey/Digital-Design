onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_level_tb/UUT/DP/clk
add wave -noupdate /top_level_tb/UUT/DP/rst
add wave -noupdate /top_level_tb/UUT/FSM/state
add wave -noupdate /top_level_tb/UUT/FSM/next_state
add wave -noupdate -divider PC
add wave -noupdate /top_level_tb/UUT/DP/PCWrite
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/PC_out
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/PC_Mux_Out
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/ctrl_Mux_out
add wave -noupdate /top_level_tb/UUT/DP/ctrl_Mux/sel
add wave -noupdate /top_level_tb/UUT/DP/PCSource
add wave -noupdate /top_level_tb/UUT/DP/IorD
add wave -noupdate -divider -height 20 {Reg File}
add wave -noupdate -radix hexadecimal -childformat {{/top_level_tb/UUT/DP/Register_File/regs(0) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(1) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(2) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(3) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(4) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(5) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(6) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(7) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(8) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(9) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(10) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(11) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(12) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(13) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(14) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(15) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(16) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(17) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(18) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(19) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(20) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(21) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(22) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(23) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(24) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(25) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(26) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(27) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(28) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(29) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(30) -radix hexadecimal} {/top_level_tb/UUT/DP/Register_File/regs(31) -radix hexadecimal}} -subitemconfig {/top_level_tb/UUT/DP/Register_File/regs(0) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(1) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(2) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(3) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(4) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(5) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(6) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(7) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(8) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(9) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(10) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(11) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(12) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(13) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(14) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(15) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(16) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(17) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(18) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(19) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(20) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(21) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(22) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(23) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(24) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(25) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(26) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(27) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(28) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(29) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(30) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Register_File/regs(31) {-height 15 -radix hexadecimal}} /top_level_tb/UUT/DP/Register_File/regs
add wave -noupdate /top_level_tb/UUT/DP/regwrite
add wave -noupdate /top_level_tb/UUT/DP/memwrite
add wave -noupdate /top_level_tb/UUT/DP/MemtoReg
add wave -noupdate -divider {Instruction Register}
add wave -noupdate /top_level_tb/UUT/DP/irwrite
add wave -noupdate -radix hexadecimal -childformat {{/top_level_tb/UUT/DP/Instr_Reg_out(31) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(30) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(29) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(28) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(27) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(26) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(25) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(24) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(23) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(22) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(21) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(20) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(19) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(18) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(17) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(16) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(15) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(14) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(13) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(12) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(11) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(10) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(9) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(8) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(7) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(6) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(5) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(4) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(3) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(2) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(1) -radix hexadecimal} {/top_level_tb/UUT/DP/Instr_Reg_out(0) -radix hexadecimal}} -subitemconfig {/top_level_tb/UUT/DP/Instr_Reg_out(31) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(30) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(29) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(28) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(27) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(26) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(25) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(24) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(23) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(22) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(21) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(20) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(19) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(18) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(17) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(16) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(15) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(14) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(13) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(12) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(11) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(10) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(9) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(8) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(7) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(6) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(5) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(4) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(3) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(2) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(1) {-height 15 -radix hexadecimal} /top_level_tb/UUT/DP/Instr_Reg_out(0) {-height 15 -radix hexadecimal}} /top_level_tb/UUT/DP/Instr_Reg_out
add wave -noupdate /top_level_tb/UUT/DP/RegDST
add wave -noupdate -radix binary /top_level_tb/UUT/DP/IR_Mux_out
add wave -noupdate -divider MEMORY
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/Mem_out
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/mem_data_mux_out
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_Memory/Address
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_Memory/U_RAM/data
add wave -noupdate -divider ALU
add wave -noupdate /top_level_tb/UUT/DP/ALUsrcA
add wave -noupdate /top_level_tb/UUT/DP/ALUsrcB
add wave -noupdate /top_level_tb/UUT/DP/ALU_OP
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_ALU/input1
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_ALU/input2
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/alu_result
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/alu_result_hi
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/alu_out
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/ALU_HI_reg/output
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/ALU_LO_reg/output
add wave -noupdate -divider I/O
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/switch_data
add wave -noupdate /top_level_tb/UUT/DP/U_Memory/inPort0_en
add wave -noupdate /top_level_tb/UUT/DP/U_Memory/inPort1_en
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_Memory/inport0
add wave -noupdate -radix hexadecimal /top_level_tb/UUT/DP/U_Memory/inport1
add wave -noupdate /top_level_tb/UUT/DP/U_Memory/LEDs
add wave -noupdate -divider {MISC CTRL SIGNALS}
add wave -noupdate /top_level_tb/UUT/FSM/is_mult
add wave -noupdate /top_level_tb/UUT/FSM/IsSigned
add wave -noupdate /top_level_tb/UUT/FSM/JumpandLink
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {710000 ps} 1} {{Cursor 5} {730000 ps} 1} {{Cursor 6} {942395 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 291
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {911234 ps} {1301014 ps}
