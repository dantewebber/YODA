import cv2
import numpy as np
import matplotlib.pyplot as plt
import time

# Read the image
image = cv2.imread('/home/francis/Desktop/2024/EEE4120F/YODA Project/Edge-detection/edge_detector/image.jpeg', cv2.IMREAD_GRAYSCALE)

if image is None:
    print("Error: The image could not be loaded.")
else:
    # Start timing for Sobel edge detection
    start_time = time.time()

    # Extract Sobel edges - emphasize horizontal and vertical edges
    sobel_x = cv2.Sobel(image, cv2.CV_64F, 1, 0, ksize=3)
    sobel_y = cv2.Sobel(image, cv2.CV_64F, 0, 1, ksize=3)

    # Convert to uint8
    sobel_x = cv2.convertScaleAbs(sobel_x)
    sobel_y = cv2.convertScaleAbs(sobel_y)

    # Combine Sobel X and Y
    sobel_OR = cv2.bitwise_or(sobel_x, sobel_y)

    # End timing for Sobel edge detection
    end_time = time.time()
    sobel_time = end_time - start_time
    print(f"Time taken for Sobel edge detection: {sobel_time} seconds")

    # Laplacian
    laplacian = cv2.Laplacian(image, cv2.CV_64F)
    laplacian = cv2.convertScaleAbs(laplacian)

    # Canny edge detection
    canny = cv2.Canny(image, 50, 120)

    # Save the processed images
    cv2.imwrite('sobel_x.jpeg', sobel_x)
    cv2.imwrite('sobel_y.jpeg', sobel_y)
    cv2.imwrite('sobel_OR.jpeg', sobel_OR)
    cv2.imwrite('laplacian.jpeg', laplacian)
    cv2.imwrite('canny.jpeg', canny)

    # Display using matplotlib for better control
    plt.figure(figsize=(10, 8))

    plt.subplot(3, 2, 1)
    plt.title('Original Image')
    plt.imshow(image, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 2, 2)
    plt.title('Sobel X')
    plt.imshow(sobel_x, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 2, 3)
    plt.title('Sobel Y')
    plt.imshow(sobel_y, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 2, 4)
    plt.title('Sobel OR')
    plt.imshow(sobel_OR, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 2, 5)
    plt.title('Laplacian')
    plt.imshow(laplacian, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 2, 6)
    plt.title('Canny')
    plt.imshow(canny, cmap='gray')
    plt.axis('off')

    plt.tight_layout()
    plt.show()
