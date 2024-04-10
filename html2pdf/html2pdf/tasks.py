from robocorp.tasks import task
from RPA.PDF import PDF
import os, sys
from pathlib import Path
from RPA.Browser.Selenium import Selenium

pdf = PDF()
html_files = 'devdata/html'
pdf_files =  'devdata/pdf'

@task
def iterate_files_in_folder():
    check_dir_exists(html_files)
    current_dir = Path(__file__).parent
    folder_path = current_dir / html_files
    print(f"folder path: {folder_path}")
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            print(f"Processing file: {filename}")

            file_path = f"file:///{file_path}"
            view_html_file(file_path)
            create_pdf_from_html(file_path, filename)

def view_html_file(file_path):
    """opens HTML file in a web browser"""
    browser = Selenium()
    browser.open_available_browser(file_path)
    browser.close_browser()

    return
def create_pdf_from_html(html_file, filename):
    pdf.html_to_pdf(html_file, f"{pdf_files}/{filename}")

def check_dir_exists(folder):
    print(f"Current working directory: {Path.cwd()}")

    full_path = Path.cwd()
    devdata_path = full_path / html_files
    if devdata_path.exists() and devdata_path.is_dir():
        print(f"The {html_files} directory exists.")
    else:
        print("The '/devdata/html' directory does not exist.")
        sys.exit(1)  # Exit the function with an error code