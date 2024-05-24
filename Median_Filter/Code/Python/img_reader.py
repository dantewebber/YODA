from PIL import Image
import numpy as np
import pandas as pd
import csv

def image_to_csv(image_path, output_file):
  """
  Reads an image (PNG or JPEG) and writes pixel RGB values to a CSV file.

  Args:
    image_path: Path to the input image file (PNG or JPEG).
    output_file: Path to the output CSV file.
  """
  # Open the image
  try:
    img = Image.open(image_path)
  except FileNotFoundError:
    print(f"Error: Could not find image file: {image_path}")
    return

  # Get image data as a list of RGB tuples
  pixels = list(img.getdata())

  # Open the output CSV file for writing
  try:
    with open(output_file, 'w', newline='') as csvfile:
      writer = csv.writer(csvfile)
      # Write header row with column names "R", "G", "B"
      writer.writerow(['R', 'G', 'B'])
      # Write each pixel's RGB values to a row (excluding alpha)
      for pixel in pixels:
          writer.writerow(pixel[:3])  # Write only the first 3 elements (R, G, B) incase there is an alpha value in the image as well
  except IOError:
      print(f"Error: Could not write to CSV file: {output_file}")

def get_pixels(input_image, output_file):
  img = Image.open(input_image).convert('RGB') # Open image file

  img_data = np.array(img) # Read in pixel values to numpy array
  
  height, width, _ = img_data.shape # Get height and width of image
  print("Height = " + str(height) + "  |  Width = " + str(width))

  padding_size = 1 # set padding size

  padded_img_data = np.pad(img_data, ((padding_size, padding_size), (padding_size, padding_size), (0, 0)), mode='constant')

  reshaped_data = padded_img_data.reshape(-1, padded_img_data.shape[-1])

  pd.DataFrame(reshaped_data).to_csv(output_file, index=False)

def convert_image_to_mem(image_path, mem_file_path, padding):
  img = Image.open(image_path)
  img = img.convert("RGB")
  width, height = img.size
  print("(Original) Height = " + str(height) + "  |  Width = " + str(width))
  padded_w = width + padding*2
  padded_h = height + padding*2
  print("(Padded) Height = " + str(padded_h) + "  |  Width = " + str(padded_w))

  # Create new zero padded image
  padded_img = Image.new("RGB", (padded_w, padded_h), (0, 0, 0))
  padded_img.paste(img, (padding, padding))

  # Get list of padded pixels
  pixels = list(padded_img.getdata())

  with open(mem_file_path, 'w') as mem_file:
      for pixel in pixels:
          r, g, b = pixel
          mem_file.write(f"{r:02x}{g:02x}{b:02x}\n")
  
  return height, width
  
   
def convert_mem_to_image(mem_file_path, output_image_path, width, height):
  with open(mem_file_path, 'r') as mem_file:
      pixels = [tuple(int(mem_file.read(2), 16) for _ in range(3)) for line in mem_file]

  img = Image.new('RGB', (width, height))
  img.putdata(pixels)
  img.save(output_image_path)

image_path = "telephone_noisy.png"
input_image = "macaw_noisy.jpeg"
output_file = "telephone_noisy_pixels.csv"
output_mem = '../Median_Filter/Median_Filter.sim/sim_1/behav/xsim/image.mem'

# image_to_csv(image_path, output_file)
# get_pixels(input_image, output_file)
# convert_image_to_mem(input_image, 'image.mem')

# print(f"Successfully wrote pixel data to CSV file: {output_file}")

window_size = 5
padding = window_size//2
print("Window Size = " + str(window_size) + "x" + str(window_size))
print("Padding = " + str(padding))
height, width = convert_image_to_mem(input_image, '../Median_Filter/Median_Filter.sim/sim_1/behav/xsim/image.mem', padding)
padded_w = width + padding
padded_h = height + padding
print(f"Successfully wrote pixel data to mem file: {output_mem}")
# convert_mem_to_image('processed_image.mem', 'processed_image.png', width, height)

