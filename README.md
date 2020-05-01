# forest-fire-simulation

This project is the final project for my Concepts of Computer Systems class at RIT

The project was written entirely in MIPS R2000 and made to run on RSIM

# overview

For this project you will write a program that runs the Forest-Fire model with some modifications. This model was originally introduced by Per Bak, Kan Chen, and Chao Tang in the 1990 paper "A forest-fire model and some thoughts on turbulence" and later refined by B. Drossel and F. Schwabl in 1992 in the paper Self-Organized Critical Forest-Fire Model.

This is a simple two-dimensional cellular automaton where each cell exists in one of three states: empty (grass), occupied (tree), or burning. The game progresses one generation at a time where the state of the grid from the previous generation is queried, and based on the state of the cells there, the grid for the new generation will be constructed (in this way it is similar to Conway's Game of Life).
3. Modified Rules of Forest Fire
The original forest fire model includes four rules; however, the try program cannot account for random results generated with probability, so for this project we will need to modify the rules a bit from the above references.

First we add a factor called wind direction which the user will enter before the simulation begins. Every generation the trees will spread their seeds in the direction of the wind. With that noted, here are the complete set of rules you will implement that determine what the next generation will look like:

A burning cell from the previous generation turns into an empty (grass) cell in the current generation.
A tree in the previous generation will burn (turn into a burning cell) if at least one of its cardinal direction (north, south, east, or west) neighbors in the previous generation is burning. Otherwise it will stay a tree in the current generation.
A previous generation tree will turn an adjacent empty (grass) cell into a current generation tree if that empty cell is in the given wind direction.
Besides above, a grass cell will not change from generation to generation.
For this project, the grid will be a square of a fixed size determined by user input. The edges of the grid do not wrap.

# input

In order to run the simulation, the user must provide some basic information, and the initial grid. The input for the simulation will be provided to you on STDIN (from the keyboard). The input will consist of multiple line:
The first line will be the grid size that specifies the length of the sides of the square grid.
The second line specifies the number of generations to run.
The third will be the wind direction, which is the direction that the wind is blowing to (so E means the wind is blowing from the west to the east).
After this line, the grid will be entered as a set of strings. The strings for the grid uses the following key: 'B' is a burning cell, 't' is a tree, and '.' is an unoccupied (grass) cell.
