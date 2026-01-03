import easyocr
import os
from PIL import Image


class PyImageUtility:
    """
    Custom Image Utility Library for Robot Framework using EasyOCR.
    """

    # Scope 'GLOBAL' means the class is initialized once per test suite run.
    # This prevents reloading the OCR model (which is slow) for every test case.
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        # Initialize EasyOCR reader with English language
        # Set gpu=True if you have a CUDA GPU, otherwise False
        self.reader = easyocr.Reader(["en"], gpu=False)

    def is_image_dark(self, image_path, threshold=100):
        """
        Determines if an image is considered 'dark' based on its average brightness.

        The method converts the image to grayscale and calculates the mean pixel intensity.
        If the mean is below the specified threshold, the image is classified as dark.

        Args:
            image_path (str): The file path to the image.
            threshold (int, optional): The brightness cutoff (0-255). Lower values
                require the image to be darker to return True. Defaults to 100.

        Returns:
            bool: True if the average brightness is below the threshold, False otherwise.
        """
        # convert image to grayscale
        img = Image.open(image_path).convert("L")
        pixels = list(img.getdata())
        avg_brightness = sum(pixels) / len(pixels)
        return avg_brightness < threshold

    def find_text_centers(self, image_path, target_text):
        """
        Scans the image for ALL occurrences of the target text.

        Args:
            image_path (str): Path to the screenshot file.
            target_text (str): Text to search for (e.g., "05").

        Returns:
            list: A list of coordinates [[x1, y1], [x2, y2]].
                Returns empty list [] if nothing found.
        """
        found_positions = []

        try:
            print(f"Scanning image: {image_path} for text: {target_text}")
            results = self.reader.readtext(image_path)

            for bbox, text, prob in results:
                # Normalize text (strip spaces)
                if text.strip() == target_text:
                    (tl, tr, br, bl) = bbox

                    # Calculate center X, Y
                    center_x = int((tl[0] + br[0]) / 2)
                    center_y = int((tl[1] + br[1]) / 2)

                    found_positions.append([center_x, center_y])

            return found_positions

        except Exception as e:
            print(f"Error processing image: {e}")
            return []

if __name__ == "__main__":
    utility = PyImageUtility()
    # Get the directory where THIS script is currently located
    current_dir = os.path.dirname(os.path.abspath(__file__))
    img_path = os.path.join(current_dir, "time_selector_full_screen.png")
    target = "05"

    # Get list of all coordinates
    positions = utility.find_text_centers(img_path, target)
    print(f"Found '{target}' at positions: {positions}")
