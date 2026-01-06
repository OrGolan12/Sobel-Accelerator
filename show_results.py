import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

pixels = []
with open("output_image.txt", "r") as f:
    for line in f:
        val = line.strip()
        try:
            pixels.append(int(val, 16))
        except ValueError:
            pixels.append(0)

original_img = Image.open("resized_input.jpg").convert('L').resize((100, 100))
original_data = np.array(original_img)

if len(pixels) >= 10000:
    output_data = np.array(pixels[-10000:]).reshape((100, 100))
    
    fig, axes = plt.subplots(1, 2, figsize=(12, 6))
    
    axes[0].imshow(original_data, cmap='gray')
    axes[0].set_title("Original Image (Input)")
    axes[0].axis('off')
    
    axes[1].imshow(output_data, cmap='gray')
    axes[1].set_title("Sobel Result (FPGA)")
    axes[1].axis('off')
    
    plt.tight_layout()
    plt.show()
else:
    print(f"Error: Found {len(pixels)} pixels, need 10000.")