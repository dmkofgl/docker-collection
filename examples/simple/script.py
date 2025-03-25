from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    try:
        with open("Readme.md", "r") as file:
            content = file.read()
    except FileNotFoundError:
        content = "File not found!"
    return content