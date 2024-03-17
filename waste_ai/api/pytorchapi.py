from flask import Flask, jsonify, request
import torch
import torch.nn as nn
from torchvision import models
from werkzeug.utils import secure_filename
from PIL import Image
import io
import os
import certifi
from flask_cors import CORS
from torchvision import transforms
from torchvision.datasets import ImageFolder
import torchvision.transforms as transforms

os.environ['SSL_CERT_FILE'] = certifi.where()
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

app = Flask(__name__)

CORS(app)


data_dir  = '/Users/matthewwalter/Downloads/archive (5)/Garbage classification/Garbage classification'
transformations = transforms.Compose([transforms.Resize((256, 256)), transforms.ToTensor()])
dataset = ImageFolder(data_dir, transform = transformations)

class ImageClassificationBase(nn.Module):
    def training_step(self, batch):
        images, labels = batch
        out = self(images)                  # Generate predictions
        loss = F.cross_entropy(out, labels) # Calculate loss
        return loss

    def validation_step(self, batch):
        images, labels = batch
        out = self(images)                    # Generate predictions
        loss = F.cross_entropy(out, labels)   # Calculate loss
        acc = accuracy(out, labels)           # Calculate accuracy
        return {'val_loss': loss.detach(), 'val_acc': acc}

    def validation_epoch_end(self, outputs):
        batch_losses = [x['val_loss'] for x in outputs]
        epoch_loss = torch.stack(batch_losses).mean()   # Combine losses
        batch_accs = [x['val_acc'] for x in outputs]
        epoch_acc = torch.stack(batch_accs).mean()      # Combine accuracies
        return {'val_loss': epoch_loss.item(), 'val_acc': epoch_acc.item()}

    def epoch_end(self, epoch, result):
        print("Epoch {}: train_loss: {:.4f}, val_loss: {:.4f}, val_acc: {:.4f}".format(
            epoch+1, result['train_loss'], result['val_loss'], result['val_acc']))

class ResNet(ImageClassificationBase):
    def __init__(self):
        super().__init__()
        # Use a pretrained model
        self.network = models.resnet50(pretrained=True)
        # Replace last layer
        num_ftrs = self.network.fc.in_features
        self.network.fc = nn.Linear(num_ftrs, len(['Glass','Paper','Metal', 'Cardboard', 'Plastic', 'Trash']))

    def forward(self, xb):
        return torch.sigmoid(self.network(xb))


# Get the directory of the current file
current_dir = os.path.dirname(__file__)

# Construct the path to the model file
model_path = os.path.join(current_dir, 'trained_model1.pth')
model = ResNet()
model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')), strict=False)
model.eval()



def to_device(data, device):
    """Move tensor(s) to chosen device"""
    if isinstance(data, (list,tuple)):
        return [to_device(x, device) for x in data]
    return data.to(device, non_blocking=True)

def preprocess_data(image_bytes):
    # Preprocess the image data to the format your model expects
    img = Image.open(io.BytesIO(image_bytes))
    # Apply necessary transformations, e.g., resize, convert to tensor
    # For example:
    transformations = transforms.Compose([
        transforms.Resize((256, 256)),
        transforms.ToTensor()
    ])
    return transformations(img)

def predict_image(img, model):
    # Convert to a batch of 1
    xb = to_device(img.unsqueeze(0), device)
    # Get predictions from model
    yb = model(xb)
    # Pick index with highest probability
    prob, preds  = torch.max(yb, dim=1)
    # Retrieve the class label
    return dataset.classes[preds[0].item()]

@app.route('/predict', methods=['POST'])
def predict():
    file = request.files['file']
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400




    # Read the image file and preprocess
    image_bytes = file.read()
    input_tensor = preprocess_data(image_bytes)

    # Get the prediction
    with torch.no_grad():
        prediction = predict_image(input_tensor, model)


    return jsonify({'prediction': prediction})

def postprocess_prediction(prediction):
    # Convert prediction to JSON-serializable format
    # ...
    return prediction.tolist()

if __name__ == '__main__':
    app.run(debug=True)  # Use a different port


# from flask import Flask, jsonify


# from flask_cors import CORS, cross_origin

# app = Flask(__name__)
# CORS(app)



# @app.route('/predict', methods=['POST'])
# def predict():
#     print('hello world from flask')
#     return jsonify({'prediction': 'test'})


# if __name__ == '__main__':
#     app.run(debug=True)  # Start the Flask app