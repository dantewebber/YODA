from PIL import Image

def convert_mem_to_image(mem_file_path, output_image_path, width, height):
    pixels = []

    with open(mem_file_path, 'r') as mem_file:
        for line in mem_file:
            line = line.strip()  # Remove any leading/trailing whitespace
            if len(line) == 6:
                try:
                    r = int(line[0:2], 16)
                    g = int(line[2:4], 16)
                    b = int(line[4:6], 16)
                    pixels.append((r, g, b))
                except ValueError:
                    print(f"Skipping invalid line: {line}")
    
    print("Image Size = " + str(len(pixels)))
    if len(pixels) != width * height:
        raise ValueError("The number of pixels does not match the specified image dimensions.")

    img = Image.new('RGB', (width, height))
    img.putdata(pixels)
    img.save(output_image_path)

input_file = '../Median_Filter/Median_Filter.sim/sim_1/behav/xsim/processed_image.mem'
output_file = 'processed_image.png'
width = 225
height = 225
convert_mem_to_image(input_file, output_file, width, height)
print(f"Successfully printed mem to png image: {output_file}")
