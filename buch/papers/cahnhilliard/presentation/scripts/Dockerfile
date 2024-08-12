FROM dolfinx/dolfinx:v0.8.0
RUN mkdir -p /workspace && apt update && apt install -y python3-pyqt5
RUN python3 -m pip install pyqt5 pyvistaqt pyvista
WORKDIR /workspace
