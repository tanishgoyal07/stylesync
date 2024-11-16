from flask import Flask, request, jsonify
from flask_cors import CORS
from main import recommend_designers_for_new_user, designer_data, algo

app = Flask(__name__)
CORS(app)

@app.route('/recommend', methods=['POST'])
def recommend():
    """
    Endpoint to recommend designers based on user input.
    """
    data = request.json
    try:
        user_preferences = {
            "usage": data.get("usage"),
            "category": data.get("category"),
            "articleType": data.get("articleType"),
            "age": data.get("age"),
            "gender": data.get("gender"),
            "amount": data.get("amount"),
        }

        top_designers_df = recommend_designers_for_new_user(user_preferences, designer_data, algo)
        top_designers = top_designers_df.to_dict(orient="records")

        return jsonify({"status": "success", "data": top_designers}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=5000)