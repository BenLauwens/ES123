all: cpp julia python octave

cpp:
	@cp ../00_utils/ES123.hpp ./
	@cp ../00_utils/ES123.cpp ./
	g++ -o main ES123.cpp main.cpp
	@rm ES123.hpp
	@rm ES123.cpp
	./main
	@rm main

julia:
	@cp ../00_utils/ES123.jl ./
	julia main.jl
	@rm ES123.jl

python:
	@cp ../00_utils/ES123.py ./
	python3 main.py
	@rm ES123.py
	@rm -f ES123.pyc
	@rm -rf __pycache__

octave:
	octave -W main.m

flowchart:
	@cp ../00_utils/ES123.tex ./
	pdflatex ES123.tex
	mv ES123.pdf flowchart.pdf
	@rm ES123.tex
	@rm *.aux *.log
