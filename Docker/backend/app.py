from flask import Flask, request, jsonify
from pymongo import MongoClient
import dotenv, os

dotenv.load_dotenv()
app = Flask(__name__)

client = MongoClient(os.getenv("MONGO_URI"))
db = client["test_flask"]
collection = db["form"]

@app.route("/submit", methods=["POST"])
def submit():
    try:
        if request.is_json:
            data = request.get_json()
        else:
            data = {"name": request.form.get("name"), "email": request.form.get("email")}
        collection.insert_one(data)
        return jsonify({"message": "Data submitted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)