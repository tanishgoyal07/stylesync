from flask import Flask, request, jsonify
from flask_cors import CORS 
import json
import os
import pandas as pd

from main import recommend_designers_for_new_user 

app = Flask(__name__)
CORS(app) 

@app.route('/recommend', methods=['POST'])
def recommend():
    # Parse the incoming JSON data
    data = request.json
    try:
        # Extract necessary input from the received data
        user_preferences = {
            "usage": data.get("usage"),
            "category": data.get("category"),
            "articleType": data.get("articleType"),
            "age": data.get("age"),
            "gender": data.get("gender"),
            "amount": data.get("amount"),
        }

        # Call the recommendation function
        top_designers_df = recommend_designers_for_new_user(user_preferences)
         
        top_designers = top_designers_df.to_dict(orient="records")

        # Return the recommended designers as a JSON response
        return jsonify({"status": "success", "data": top_designers}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=5000)
