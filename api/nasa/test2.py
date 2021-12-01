#python test2.py -LAT 25.99 -LON -80.12 --info
 
import argparse
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont, UnidentifiedImageError
import os
import requests

def image(lat: float, lon: float, dim: float = 0.15, date = datetime.now().strftime(r'%Y-%m-%d')) -> Image.Image:
    payload = {'lat':lat,'lon':lon,'date':date,'dim':dim,'api_key':'TODO',}
    response = requests.get('https://api.nasa.gov/planetary/earth/imagery', params=payload, stream=True,)
    img = Image.open(response.raw)

    #draw = ImageDraw.Draw(img)
    #font = ImageFont.truetype('arial.ttf', 46)
    #draw.text((10, 10), f'LAT {lat}  LON {lon}', font=font, fill=(255, 0, 0))

    return img

def main():
    parser = argparse.ArgumentParser(
        description="""
            Retrieves the Landsat 8 image for the supplied location and date
            from the Nasa Earth API.
        """
    )
    parser.add_argument('-lat', '-LAT', type=float, help='Latitude')
    parser.add_argument('-lon', '-LON', type=float, help='Longitude')
    args = parser.parse_args()

    try:
        img = image(args.lat, args.lon)
        img.show()
    except UnidentifiedImageError:
        print('Could not fetch image. Try adjusting the parameters.')

if __name__ == '__main__':
    main()
