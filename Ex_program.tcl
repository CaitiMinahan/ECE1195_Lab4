# restart the simulation
restart

add_force clock -radix bin {0 0ns} {1 5000ps} -repeat_every 10000ps

#Test 8 - Pass
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3c011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {342d0020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {2009ffd3}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {71205021}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {adaa0000}

add_force reset -radix bin 1
run 10 ns

add_force reset -radix bin 0
run 600 ns

if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] != 0x1a} {
	puts "Result is not correct. Value is {/cpu_tb/U_1/mw_U_0ram_table[8]}."
	puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[8]}]
} else {
	puts "Test 8 Passed!"
}
