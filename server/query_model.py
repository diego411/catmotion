import torch
import torch.nn as nn
import torch.nn.functional as F
import torchaudio
from torchvision import transforms
import torchvision.models as models
import numpy as np
import matplotlib.pyplot as plt
import sys
from PIL import Image
import time
import os

base_width = 224
base_height = 224

resnet18 = models.resnet18(pretrained=True)
resnet18_features = nn.Sequential(*(list(resnet18.children())[:-1]))

class ResCNNet(nn.Module):
  def __init__(self, n_output=1, freeze=True):
    super().__init__()
    self.resnet = resnet18_features
    if freeze:
      self.freeze()
    self.l1 = nn.Linear(512, n_output)

  def forward(self, x):
    x = self.resnet(x).squeeze()
    return self.l1(x)

  def freeze(self):
    for param in self.resnet.parameters():
      param.requires_grad = False

class CNNet(nn.Module):
    def __init__(self, n_output=1, conv_kernel_size=5, conv_stride=1, pool_kernel_size=2, pool_stride=2, l1=64, l2=50):
        super().__init__()
        
        self.conv_kernel_size = conv_kernel_size
        self.conv_stride = conv_stride
        self.pool_kernel_size = pool_kernel_size
        self.pool_stride = pool_stride

        self.conv1 = nn.Conv2d(3, 32, kernel_size=self.conv_kernel_size, stride=self.conv_stride)

        (width, height) = self.update_shape(base_width, base_height)
        (width, height) = self.update_shape(width, height, is_pool=True)

        self.conv2 = nn.Conv2d(32, l1, kernel_size=self.conv_kernel_size, stride=self.conv_stride)

        (width, height) = self.update_shape(width, height)
        (width, height) = self.update_shape(width, height, is_pool=True)

        self.conv2_drop = nn.Dropout2d()
        self.flatten = nn.Flatten()
        self.fc1 = nn.Linear(width * height * l1, l2)
        self.fc2 = nn.Linear(l2, n_output)


    def forward(self, x):
        x = self.conv1(x)
        x = F.max_pool2d(x, kernel_size=self.pool_kernel_size, stride=self.pool_stride)
        x = F.relu(x)
        x = self.conv2(x)
        x = self.conv2_drop(x)
        x = F.max_pool2d(x, kernel_size=self.pool_kernel_size, stride=self.pool_stride)
        x = F.relu(x)
        x = self.flatten(x)
        x = self.fc1(x)
        x = F.relu(x)
        x = F.dropout(x, training=self.training)
        x = self.fc2(x)
        x = F.relu(x)
        
        return F.log_softmax(x,dim=1)

    def update_shape(self, width, height, is_pool=False):
        kernel_size = self.pool_kernel_size if is_pool else self.conv_kernel_size
        stride = self.pool_stride if is_pool else self.conv_stride

        width = int(((width - kernel_size) / stride) + 1)
        height = int(((height - kernel_size) / stride) + 1)

        return (width, height)

beti = None
kisha = None

def init():
    global beti, kisha 

    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    torch_device = torch.device(device)
    
    beti = CNNet(n_output = 4).to(device)
    beti.load_state_dict(torch.load('./models/beti.pth', map_location=torch_device))
    beti.eval()
    
    if beti is None:
        print("Failed to initialize beti model")
    else:
        print("Initialized beti model")
    
    kisha = ResCNNet(n_output = 3, freeze = False).to(device)
    kisha.load_state_dict(torch.load('./models/kisha.pth', map_location=torch_device))
    kisha.eval()

    if kisha is None:
        print("Failed to initialize kisha model")
    else: 
        print("Initialized kisha model")

def create_spectrogram(audio_path):
    waveform, sample_rate = torchaudio.load(audio_path)
    waveform = waveform + 1e-9

    spectrogram_tensor = torchaudio.transforms.Spectrogram()(waveform)
    spectrogram_numpy = spectrogram_tensor.log2()[0,:,:].numpy()
    filter = spectrogram_numpy != np.NINF
    filtered_spectrogram = np.where(filter, spectrogram_numpy, sys.float_info.min) # replace remaining -inf with smallest float

    plt.figure()
    spec_name = f'audio/spec_img_{time.ctime(time.time())}.png'
    plt.imsave(spec_name, filtered_spectrogram, cmap='viridis')
    plt.close()
    
    return spec_name

def get_model_prediction(model, image_path):
    image = Image.open(image_path)
    image = image.convert('RGB')

    # Define the transformation to be applied to the input image
    transform=transforms.Compose([
        transforms.Resize((base_width, base_height)),
        transforms.ToTensor()
    ])

    # Apply the transformation to the image
    input_tensor = transform(image)

    # Add a batch dimension to the tensor (as the model expects a batch of images)
    input_batch = input_tensor.unsqueeze(0)

    # Forward pass to get predictions
    with torch.no_grad():
        output = model(input_batch)

    # The 'output' variable now contains the model predictions for the given input image
    probabilities = torch.exp(output) # maybe not needed
    # Find the index of the class with the highest probability (argmax)
    return torch.argmax(probabilities).item()


class_map1 = {
    0: 'chirp', 
    1: 'hiss', 
    2: 'meow', 
    3: 'purr'
}

class_map2 = {
    0: 'angry', 
    1: 'happy', 
    2: 'sad'
}

def classify(audio_path):
    image_path = create_spectrogram(audio_path)
    
    predicted_class_beti = get_model_prediction(beti, image_path)
    
    if predicted_class_beti == 2: # Model 1 predicted meow
        predicted_class_kisha = get_model_prediction(kisha, image_path)
        os.remove(image_path)
        return f'{class_map2[predicted_class_kisha]} (Meow)'

    os.remove(image_path)
    return class_map1[predicted_class_beti]
