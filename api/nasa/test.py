# source: https://github.com/v0di/landsat8image

import argparse
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont, UnidentifiedImageError
import os
import requests

date = datetime.now().strftime(r'%Y-%m-%d')
lat: float = 25.99
lon: float = -80.12
dim: float = 0.15

payload = {'lat':lat,'lon':lon,'date':date,'dim':dim,'api_key':'TODO',}
response = requests.get('https://api.nasa.gov/planetary/earth/imagery', params=payload, stream=True,)

img = Image.open(response.raw)

#draw = ImageDraw.Draw(img)
#font = ImageFont.truetype('arial.ttf', 46)
#draw.text((10, 10), f'LAT {lat}  LON {lon}', font=font, fill=(255, 0, 0))

#img.show()
