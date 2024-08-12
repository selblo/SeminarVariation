# Source Code for Cahn-Hilliard chapter
This directory contains all the Python scripts
used for generating the images in the Cahn-Hilliard equation chapter.

## Requirements

### Docker
To run the simulation scripts `ch_simulation.py` and `ach_simulation.py`,
Docker needs to be installed.
The Docker image is defined within the `Dockerfile`.

### LaTeX
For generating images with `energy.py`,
a LaTeX installation is required.
The author recommends using [TeX Live](https://www.tug.org/texlive/).

## Scripts
- `ch_simulation.py`: Performs a FEM simulation of the Cahn-Hilliard equation.
This script generates images similar to Figure 25.1 in the chapter.
- `ach_simulation.py`: Conducts a FEM simulation of the Cahn-Hilliard equation
under the influence of stirring velocity fields.
You can experiment with different values for $`\alpha`$
to observe how the results change.
This script produces images similar to Figure 25.3 in the chapter
- `energy.py`: Plots the temperature dependency of the free energy $`F(c)`$.
- `plotting.py`: Configures the plot styles to ensure consistency
with the style used in the first part of the book.

## Usage
1. Build docker image:
```bash
./build.sh
```
2. Start docker container:
```bash
./run.sh
```
3. Execute the desired Python script within the Docker container.
For example,
to run the Cahn-Hilliard simulation:
```bash
python3 ch_simulation.py
```
4. Stop the docker container by pressing `Ctrl+D` or
by running the following command in another terminal:
```bash
./stop.sh
```
