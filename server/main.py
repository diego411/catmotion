from flask import Flask, request
import query_model
import time
import os

app = Flask(__name__)
query_model.init()

@app.route('/')
def index():
    return "Catmotion Server v0.0.3"


@app.route('/classify', methods=['POST'])
def classify():
    binary_data = request.data

    extension = 'wav'
    date = time.ctime(time.time())
    file_path = f'audio/req_file_{date}.{extension}'
    with open(file_path, 'wb') as f:
        f.write(binary_data)

    predicted_class = query_model.classify(file_path)
    os.remove(file_path)
    return predicted_class, 200

if __name__ == '__main__':
    app.run(debug=True)
    
