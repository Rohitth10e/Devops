from flask import Flask, request, redirect, render_template
from pymongo import MongoClient
import dotenv, os
dotenv.load_dotenv()

app = Flask(__name__)

# Connect to MongoDB Compass/Atlas
client = MongoClient(os.getenv("MONGO_URI"))
db = client["test_flask"]
collection = db["form"]


try:
    client.admin.command('ping')
    print("Connected to MongoDB successfully!")
except Exception as e:
    print("Connection failed:", e)


@app.route("/", methods=["GET", "POST"])
def form():
    if request.method == "POST":
        try:
            data = {"name": request.form["name"], "email": request.form["email"]}
            collection.insert_one(data)
            return redirect("/success")
        except Exception as e:
            return render_template("form.html", error=str(e))
    return render_template("form.html")

@app.route("/success")
def success():
    return "Data submitted successfully"

if __name__ == "__main__":
    app.run(debug=True)
