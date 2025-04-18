from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import pickle

app = Flask(__name__)
CORS(app)

# Load model and columns
with open("mumbai_price_model.pkl", "rb") as f:
    model = pickle.load(f)

with open("model_columns.pkl", "rb") as f:
    model_columns = pickle.load(f)

# Root route (to test if server is running)
@app.route("/", methods=["GET"])
def home():
    return "Mumbai House Price Prediction API is running!"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()

        print("Received JSON:", data)
        print("Model expects columns:", model_columns)

        x_input = [data.get(col, 0) for col in model_columns]
        print("Input array for model:", x_input)

        x_array = np.array([x_input])
        pred_log = model.predict(x_array)[0]

        # Apply 7 years of inflation at 6% per year (compounded)
        inflation_rate = 0.06
        years = 10
        adjusted_price = np.expm1(pred_log) * ((1 + inflation_rate) ** years)

        return jsonify({"predicted_price": float(round(adjusted_price, 2))})

    except Exception as e:
        print("Error during prediction:", e)
        return jsonify({"error": str(e)})


if __name__ == "__main__":
    app.run(debug=True)
