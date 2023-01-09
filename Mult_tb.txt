#testbench for the multiplication instructions: 
#lui $1, 0x2 #r1 = 2
#lui $2, 0x3 #r2 = 3
#multu $3, $1, $2 #result: r3 = r1 * r2 = 6
#mflo $4, $3 #r4 = lower 32 bits of r3 = 6
#mfhi $5, $3 $r5 = upper 32 bits of r3 = 0
#contents of regs 4 and 5 gets stored in these offset locations: 
#sw $4, 0($3) 
#sw $5, 16($3)

#forcing a clock with 10 ns period
add_force clk 1 {0 5ns} -repeat_every 10ns

# Forcing a program (instruction memory)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
# the first 4 memory locations are initialized with the instruction codes correpsonding to the 4 instructions above.
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C010002}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3C020003}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00220019}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {00002012}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00002810}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {AC640000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {AC650010}

#give a reset signal
add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 200 ns

#test: correct answer check
if{[get_value - radix unsigned {\cpu_tb/U_1/mw_U_0ram_table[8]}] != 0x6} {
	puts "Incorrect result. Value is {\cpu_tb/U_1/mw_U_0ram_table[8]}."
	puts [get_value - radix hex {\cpu_tb/U_1/mw_U_0ram_table[8]}] 
} else { 
	puts "Multiplication test 1 passed"
}

#test: correct answer check
if{[get_value - radix unsigned {\cpu_tb/U_1/mw_U_0ram_table[9]}] != 0x00} {
	puts "Incorrect result. Value is {\cpu_tb/U_1/mw_U_0ram_table[9]}."
	puts [get_value - radix hex {\cpu_tb/U_1/mw_U_0ram_table[9]}] 
} else { 
	puts "Multiplication test 2 passed"
}
