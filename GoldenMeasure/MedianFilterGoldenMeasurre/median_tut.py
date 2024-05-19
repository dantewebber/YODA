import os
import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt

def median():
    
    imgPath = '/home/francis/Desktop/2024/EEE4120F/YODA Project/x1.jpg'
    # Load the image
    img = cv.imread(imgPath,1)
    
    # Check if the image was loaded successfully
    if img is None:
        print("Error: Unable to load image.")
        return
    
    # Convert the image to grayscale
    imgRGB = cv.cvtColor(img, cv.COLOR_BGR2RGB)
    
    # Create a copy of the grayscale image for filtering
    img2 = imgRGB.copy()
    
    # Apply median filter
    imgfilter = cv.medianBlur(img2, 9)
    
    # Plot the original and filtered images using matplotlib
    plt.figure(figsize=(10, 5))
    
    plt.subplot(1, 2, 1)
    plt.title('Original Image')
    plt.imshow(imgRGB, cmap='gray')
    plt.axis('off')
    
    plt.subplot(1, 2, 2)
    plt.title('Median Filtered Image')
    plt.imshow(imgfilter, cmap='gray')
    plt.axis('off')
    
    plt.show()

# Call the median function
median()
