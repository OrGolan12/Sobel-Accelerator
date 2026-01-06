import cv2
import numpy as np
import os
import sys

script_dir = os.path.dirname(os.path.abspath(__file__))
image_path = os.path.join(script_dir, 'cat_image.jpg') 
hex_path = os.path.join(script_dir, 'input_image.hex')
resized_path = os.path.join(script_dir, 'resized_input_rgb.jpg')

img = cv2.imread(image_path)

if img is None:
    print(f"Error: Could not find {image_path}")
    sys.exit()

img_small = cv2.resize(img, (100, 100))

cv2.imwrite(resized_path, img_small)

with open(hex_path, 'w') as f:
    for row in img_small:
        for pixel in row:
            b, g, r = pixel
            hex_val = "{:02x}{:02x}{:02x}".format(r, g, b)
            
            f.write(hex_val + '\n')

print(f"Success: {hex_path} is ready with RAW RGB data (24-bit)")
print(f"Image dimensions: 100x100, Total pixels: 10,000")