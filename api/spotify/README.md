# Spotify Playlist Analyizer

This tool uses [spotipy](https://spotipy.readthedocs.io/en/latest/).
For details on the spotify api [read these docs](https://developer.spotify.com/console/).

## Prerequisits

Install Python.

Install or upgrade Spotipy:

``` py
pip install spotipy --upgrade
```

## Environemnt Variables

### Windows

``` bat
$Env:SPOTIPY_CLIENT_ID = "XXXX"
$Env:SPOTIPY_CLIENT_SECRET = "XXXX"
```

### Linux

``` bash
export SPOTIPY_CLIENT_ID='XXXX'
export SPOTIPY_CLIENT_SECRET='XXXX'
```

## Testing

Example IDs are

- playlistID = 'spotify:playlist:32O0SSXDNWDrMievPkV0Im'
- artistID = '0gxyHStUsqpMadRV0Di1Qt'
- albumID = '5Z9iiGl2FcIfa3BMiv6OIw'
- trackID = "4cOdK2wGLETKBW3PvgPWqT"
