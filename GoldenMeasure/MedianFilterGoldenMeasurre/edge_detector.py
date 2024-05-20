import cv2
import numpy as np
import matplotlib.pyplot as plt
import time

# Read the image
image = cv2.imread('alpha.png', cv2.IMREAD_GRAYSCALE)

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

    # Start timing for Prewitt edge detection
    start_time = time.time()

    # Define Prewitt kernels
    kernel_prewitt_x = np.array([[1, 0, -1], [1, 0, -1], [1, 0, -1]], dtype=np.float32)
    kernel_prewitt_y = np.array([[1, 1, 1], [0, 0, 0], [-1, -1, -1]], dtype=np.float32)

    # Apply Prewitt kernels
    prewitt_x = cv2.filter2D(image, -1, kernel_prewitt_x)
    prewitt_y = cv2.filter2D(image, -1, kernel_prewitt_y)

    # Convert to uint8
    prewitt_x = cv2.convertScaleAbs(prewitt_x)
    prewitt_y = cv2.convertScaleAbs(prewitt_y)

    # Combine Prewitt X and Y
    prewitt_OR = cv2.bitwise_or(prewitt_x, prewitt_y)

    # End timing for Prewitt edge detection
    end_time = time.time()
    prewitt_time = end_time - start_time
    print(f"Time taken for Prewitt edge detection: {prewitt_time} seconds")

    # Laplacian
    laplacian = cv2.Laplacian(image, cv2.CV_64F)
    laplacian = cv2.convertScaleAbs(laplacian)

    # Canny edge detection
    canny = cv2.Canny(image, 50, 120)

    # Save the processed images
    cv2.imwrite('sobel_x.jpeg', sobel_x)
    cv2.imwrite('sobel_y.jpeg', sobel_y)
    cv2.imwrite('sobel_OR.jpeg', sobel_OR)
    cv2.imwrite('prewitt_x.jpeg', prewitt_x)
    cv2.imwrite('prewitt_y.jpeg', prewitt_y)
    cv2.imwrite('prewitt_OR.jpeg', prewitt_OR)
    cv2.imwrite('laplacian.jpeg', laplacian)
    cv2.imwrite('canny.jpeg', canny)

    # Display using matplotlib for better control
    plt.figure(figsize=(12, 10))

    plt.subplot(3, 3, 1)
    plt.title('Original Image')
    plt.imshow(image, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 2)
    plt.title('Sobel X')
    plt.imshow(sobel_x, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 3)
    plt.title('Sobel Y')
    plt.imshow(sobel_y, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 4)
    plt.title('Sobel OR')
    plt.imshow(sobel_OR, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 5)
    plt.title('Prewitt X')
    plt.imshow(prewitt_x, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 6)
    plt.title('Prewitt Y')
    plt.imshow(prewitt_y, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 7)
    plt.title('Prewitt OR')
    plt.imshow(prewitt_OR, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 8)
    plt.title('Laplacian')
    plt.imshow(laplacian, cmap='gray')
    plt.axis('off')

    plt.subplot(3, 3, 9)
    plt.title('Canny')
    plt.imshow(canny, cmap='gray')
    plt.axis('off')

    plt.tight_layout()
    plt.show()
