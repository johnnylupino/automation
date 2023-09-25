from robocorp.tasks import task
from robocorp import browser

@task
def open_web_and_screenshot():
    open_the_web()

def open_the_web():
    browser.goto("http://www.kermeet.pl")
    page = browser.page()
    