all: cpp julia python octave

cpp:
	@cp ../00_utils/ES123.hpp ./
	@cp ../00_utils/ES123.cpp ./
	g++ -o input ES123.cpp input.cpp
	@rm ES123.hpp
	@rm ES123.cpp
	./input
	@rm input

julia:
	@cp ../00_utils/ES123.jl ./
	julia input.jl
	@rm ES123.jl

python:
	@cp ../00_utils/ES123.py ./
	python3 input.py
	@rm ES123.py
	@rm -f ES123.pyc
	@rm -rf __pycache__

octave:
	octave -W input.m

flowchart:
	pdflatex input.tex
	@rm *.aux *.log
