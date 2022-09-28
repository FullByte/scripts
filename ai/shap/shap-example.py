import matplotlib.pylab as plt
import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
import shap
import os.path
from PIL import Image

directory_path = os.getcwd()

model = tf.keras.Sequential([
  hub.KerasLayer(
    name='inception_v1',
    handle='https://tfhub.dev/google/imagenet/inception_v1/classification/4',
    trainable=False),
])
model.build([None, 500, 500, 3])
model.summary()

tf.keras.utils.plot_model(
  model,
  to_file='model.png',
  show_shapes=False,
  show_dtype=False,
  show_layer_names=True,
  rankdir='TB',
  expand_nested=False,
  dpi=96,
  layer_range=None,
  show_layer_activations=False
)

config = model.get_config()

def load_imagenet_labels(file_path):
  labels_file = tf.keras.utils.get_file('ImageNetLabels.txt', file_path)
  with open(labels_file) as reader:
    f = reader.read()
    labels = f.splitlines()
  return np.array(labels)
#imagenet_labels = load_imagenet_labels('https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt')

f = open(directory_path + "/ImageNetLabels.txt").read()
labels = f.splitlines()
imagenet_labels = np.array(labels)

len(imagenet_labels)

images=[]
file_list=['/content/panda1.jpeg','/content/panda2.jpeg','/content/panda3.jpeg','/content/panda4.jpeg','/content/panda5.jpeg']
for name in file_list: 
  image=Image.open(directory_path + "/" + name)
  image=image.resize(config["layers"][0]["config"]["batch_input_shape"][1:-1])
  imgarr = np.array(image)
  images.append(imgarr)
images=np.array(images)

fig, axs = plt.subplots(1,5, figsize=(20, 4),)

for i in range(5):
  axs[i].imshow(images[i])

def f(x):
  return model(x/255)

# define a masker that is used to mask out partitions of the input image.
masker = shap.maskers.Image("blur(500,500)", images[0].shape)

# create an explainer with model and image masker
explainer = shap.Explainer(f, masker, output_names=imagenet_labels )

# here we explain two images using 500 evaluations of the underlying model to estimate the SHAP values
shap_values = explainer(images, max_evals=2000, batch_size=50, outputs=shap.Explanation.argsort.flip[:3])

# output with shap values
shap.image_plot(shap_values)
