# FPGA-Based Real-Time Sobel Edge Detection Accelerator
### High-Throughput Image Processing Pipeline in SystemVerilog

## Project Overview
This project implements a hardware-accelerated Sobel edge detection system designed for high-speed image processing. Unlike software-based approaches that process pixels sequentially, this FPGA implementation utilizes a pipelined architecture to achieve a throughput of one pixel per clock cycle. The design is optimized for low-latency applications such as autonomous navigation, industrial inspection, and real-time video analytics.

## Mathematical Background

### 1. Grayscale Conversion
The input 24-bit RGB stream is converted to 8-bit grayscale (Luminance) using the standard CCIR 601 coefficients:
Y = 0.299R + 0.587G + 0.114B

To minimize hardware resources, the implementation avoids floating-point units by using integer scaling and bit-shifting approximations.

### 2. Sobel Operator
The Sobel kernel calculates the intensity gradient of the image at each point. It uses two 3x3 convolution masks to calculate the horizontal (Gx) and vertical (Gy) components. The final gradient magnitude |G| is approximated for hardware efficiency:
|G| = |Gx| + |Gy|

If |G| exceeds the user-defined threshold, the output is set to 0xFF (Edge), otherwise it remains 0x00 (Background).

## Hardware Architecture

<img width="1413" height="357" alt="image" src="https://github.com/user-attachments/assets/45831003-b64e-400e-abd1-141c2d446439" />

The design follows a streaming pipeline architecture composed of the following stages:
1. **Grayscale Stage**: Transformation of 24-bit RGB data to 8-bit grayscale.
2. **Row Synchronization (Line Buffers)**: Utilization of internal dual-port FIFOs to store two full rows of the image, enabling a 3-row vertical window.
3. **Sliding Window Generator**: Extraction of a 3x3 neighborhood of pixels at every clock cycle.
4. **Sobel Kernel**: Parallel execution of convolution masks using dedicated adder trees.

## File Structure

```text
Sobel-Accelerator/
├── rtl/                    # Hardware Description Files
│   ├── image_processor.sv    # Top-level integration
│   ├── gray_converter.sv     # RGB to Grayscale logic
│   ├── row_fifo_manager.sv   # Row-level synchronization
│   ├── line_buffer.sv        # BRAM-based FIFO memory
│   ├── pixel_matrix_3x3.sv   # 3x3 neighborhood extraction
│   └── sobel_kernel.sv       # Mathematical operators and thresholding
├── tb/                     # Verification Suite
│   └── tb_image_processor.sv # System-level testbench
├── python/                 # Software Toolchain
│   ├── jpg2hex.py            # Pre-processing: Image to Hex
│   └── show_results.py       # Post-processing: Hex to Image visualization
├── data/                   # Simulation Data (Input/Output)
├── images/                 # Asset Directory
└── sim/                    # Simulation Build Directory
```
# Execution Guide

* **Preparation**

  * Ensure Python 3 is installed with the required libraries:

    ```bash
    pip install pillow numpy matplotlib
    ```

* **Generate Input Data**

  * Convert the source image into a hexadecimal pixel stream:

    ```bash
    python3 python/jpg2hex.py
    ```

  * Source:

    ```
    images/cat_image.jpg
    ```

  * Result:

    ```
    data/input_image.hex
    ```

* **Compile Hardware Logic**

  * Compile the SystemVerilog modules and testbench using Icarus Verilog:

    ```bash
    iverilog -g2012 -o sim/sim.vvp \
        tb/tb_image_processor.sv \
        rtl/image_processor.sv \
        rtl/gray_converter.sv \
        rtl/row_fifo_manager.sv \
        rtl/line_buffer.sv \
        rtl/pixel_matrix_3x3.sv \
        rtl/sobel_kernel.sv
    ```

* **Run Simulation**

  * Execute the compiled simulation object:

    ```bash
    vvp sim/sim.vvp
    ```

  * Result:

    ```
    data/output_image.txt
    ```

* **Visualize Results**

  * Display the original image alongside the processed FPGA output:

    ```bash
    python3 python/show_results.py
    ```
