import os
import unittest
import requests

class TestFileUpload(unittest.TestCase):
    base_url = 'http://app:5000/upload'

    def make_request(self, filename):
        current_dir = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(current_dir, filename)
        with open(file_path, 'rb') as file:
            resp = requests.post(self.base_url, files={'file': file})
        return resp.json()['files']

    def test_upload_files(self):
        test_files = ['1.jpg', '1.py', '1.txt']
        for filename in test_files:
            with self.subTest(filename=filename):
                resp = self.make_request(filename)
                self.assertIn(filename, resp)
                print(f"File '{filename}' successfully uploaded.")

if __name__ == "__main__":
    unittest.main()
