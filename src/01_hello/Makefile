all: cpp julia python octave

cpp:
	@cp ../00_utils/ES123.hpp ./
	@cp ../00_utils/ES123.cpp ./
	g++ -o hello ES123.cpp hello.cpp
	@rm ES123.hpp
	@rm ES123.cpp
	./hello
	@rm hello

julia:
	@cp ../00_utils/ES123.jl ./
	julia hello.jl
	@rm ES123.jl

python:
	@cp ../00_utils/ES123.py ./
	python3 hello.py
	@rm ES123.py
	@rm -rf __pycache__

octave:
	octave -W hello.m

flowchart:
	pdflatex hello.tex
	open hello.pdf
	@rm *.aux *.log
