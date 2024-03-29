from flask import Flask, request, render_template, jsonify
from PIL import Image
import io
from ultralytics import YOLO
from flask_cors import CORS
import os


app = Flask(__name__)
CORS(app)

# Load the YOLO model
abs_path=os.path.abspath(__file__)
rel_path= "detection.pt"
model_path = os.path.join(os.path.dirname(abs_path), rel_path)
model = YOLO(model_path)

# @app.route('/', methods=['GET'])
# def home():
#     return render_template('upload.html')

@app.route('/test', methods=['GET'])
def test():
    return "Hello World"

@app.route('/detect', methods=['POST'])
def classify_image():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    file_content = file.read()  # Read the content of the file
    image = Image.open(io.BytesIO(file_content))
    results = model(image)

    detections = []
    for result in results:
        # Assuming 'result' is a Results object containing Boxes, and 'results.names' holds class names
        boxes = result.boxes.xyxy.tolist() if result.boxes.xyxy is not None else None
        scores = result.boxes.conf.tolist() if result.boxes.conf is not None else None
        classes = result.boxes.cls.tolist() if result.boxes.cls is not None else None
        names = result.names if result.names is not None else None
        
        for i, box in enumerate(boxes):
            conf = scores[i] if scores is not None else None
            class_id = classes[i] if classes is not None else None
            class_name = names[class_id] if names is not None and class_id < len(names) else None

            detection = {
            'boxes': boxes,
            'scores': scores,
            'classes': classes,
            'names': names
            }
            detections.append(detection)
    
    return jsonify({'detections': detections})