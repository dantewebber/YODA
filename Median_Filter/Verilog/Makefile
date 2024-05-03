# Makefile for Verilog program

# Compiler used is iverilog
CC=iverilog 

# Source files to be compiled
SOURCES=median_filter.v median_filter_tb.v

# Compile Flag
FLAGS=-g2009 # To add support for system verilog

# Run command used
RC=vvp 

median_filter: $(SOURCES)
	$(CC) $(FLAGS) $(SOURCES) -o median_filter

run:
	$(RC) median_filter

clean:
	rm -f median_filter
