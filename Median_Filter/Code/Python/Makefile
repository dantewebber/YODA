# Makefile for CSC3022 RL Assignment
# Date: 12 May 2024
# Student: WBBDAN003

# default target
all: venv

# create python virtual environment
venv:
	python3 -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	source venv/bin/activate

# clean up
clean:
	rm -rf venv
	find -iname "*.pyc" -delete
