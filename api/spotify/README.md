# Spotify Playlist Analyizer

This overview shows how the components work together:

![overview](overview.drawio.svg)

## Prerequisits

You require a [spoitfy premium](https://www.spotify.com/de/premium/) account and must register as [spoitfy developer](https://developer.spotify.com/dashboard/applications) to get an API ID + Secret.

Install Python and install/upgrade the following libs using PIP:

``` py
pip install -r requirements.txt --upgrade
```

## Environemnt Variables

To test locally, set the API details recieved from your spoitfy developer as temporary environment variables:

Windows

``` bat
$Env:SPOTIPY_CLIENT_ID = "XXXX"
$Env:SPOTIPY_CLIENT_SECRET = "XXXX"
```

Linux

``` bash
export SPOTIPY_CLIENT_ID='XXX'
export SPOTIPY_CLIENT_SECRET='XXX'
```

## Dev

### Spotify

If you want to debug the code, here are some Spotify example IDs you can use:

- playlistID = 'spotify:playlist:32O0SSXDNWDrMievPkV0Im'
- artistID = '0gxyHStUsqpMadRV0Di1Qt'
- albumID = '5Z9iiGl2FcIfa3BMiv6OIw'
- trackID = "4cOdK2wGLETKBW3PvgPWqT"

## Documentation

- [spotify api](https://developer.spotify.com/console/)
- [spotipy](https://spotipy.readthedocs.io)
