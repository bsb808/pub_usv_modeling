#!/bin/bash
pdflatex usv_modeling.tex
bibtex usv_modeling
pdflatex usv_modeling.tex