import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json
import sqlite3
from os.path import exists

spotify = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())

# TODO
def artistTopTracks(artistID, trackID, spotify):
    results = spotify.artist_top_tracks(artistID)
    for track in results['tracks'][:10]:
        print(track) #song_is_one_of_artist_top_tracks

def songInfo(trackID, spotify, dbname):
    # Get Track Information
    trackInfo = spotify.track(trackID)
    artistID = trackInfo['artists'][0]['id'] # artistID
    albumID = trackInfo['album']['id'] # albumID

    # Get details about the Song
    album = spotify.album(albumID) # Album Information
    artist = spotify.artist(artistID) # Artist Information
    trackFeatures = spotify.audio_features(trackID) # Track Features
    trackAnalysis = spotify.audio_analysis(trackID) # Track Analysis Details

    #artistTopTracks(artistID, trackID, spotify) # TODO check if track is in top 10 of artist
    #artist['genres'], #artist_genres (TODO: this is a list : "genres": [    "dance pop",    "miami hip hop",    "pop",    "pop rap"  ])

    #TODO: Prüfen ob TrackID schon vorhanden ist

    # Write Track Information to DB
    conn = sqlite3.connect(dbname)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO SONGS (ID_track, ID_isrc, ID_artist, ID_album, " + # IDs
            "song_name, song_artist, album_name, " +                        # Basics
            "album_type, album_label, album_popularity, album_release_date, album_total_tracks, " +   # Album
            "artist_popularity, artist_genres, artist_followers, " + # artist
            "danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, duration_ms, " + # trackFeatures
            "duration, end_of_fade_in, start_of_fade_out, tempo, tempo_confidence, time_signature, time_signature_confidence, key, key_confidence, mode, mode_confidence)" + # trackAnalysis
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", # not 42 :(
        (trackID, # ID_track
        trackInfo['external_ids']['isrc'], # ID_isrc
        artistID, #ID_artist
        albumID, # ID_album
        trackInfo['name'], #song_name
        trackInfo['artists'][0]['name'], #song_artist
        album['name'], #album_name
        trackInfo['album']['album_type'], #album_type
        album['label'], #album_label        
        album['popularity'], #album_popularity
        album['release_date'], #album_release_date
        album['total_tracks'], #album_total_tracks 
        artist['popularity'], #artist_popularity
        "genres TODO",
        artist['followers']['total'], #artist_followers    
        trackFeatures[0]['danceability'], #danceability
        trackFeatures[0]['energy'], #energy
        trackFeatures[0]['loudness'], #loudness
        trackFeatures[0]['speechiness'], #speechiness
        trackFeatures[0]['acousticness'], #acousticness
        trackFeatures[0]['instrumentalness'], #instrumentalness
        trackFeatures[0]['liveness'], #liveness
        trackFeatures[0]['valence'], #valence
        trackFeatures[0]['duration_ms'], #duration_ms
        trackAnalysis['track']['duration'], #duration
        trackAnalysis['track']['end_of_fade_in'], #end_of_fade_in
        trackAnalysis['track']['start_of_fade_out'], #start_of_fade_out
        trackAnalysis['track']['tempo'], #tempo
        trackAnalysis['track']['tempo_confidence'], #tempo_confidence
        trackAnalysis['track']['time_signature'], #time_signature
        trackAnalysis['track']['time_signature_confidence'], #time_signature_confidence
        trackAnalysis['track']['key'], #key
        trackAnalysis['track']['key_confidence'], #key_confidence
        trackAnalysis['track']['mode'], #mode
        trackAnalysis['track']['mode_confidence']) #mode_confidence
        )
    conn.commit()
    conn.close()

def tracksFromPlaylist(spotify, pl_id, dbname):
    response = spotify.playlist_items(pl_id, fields='items.track.id,total', additional_types=['track'])
    if len(response['items']) != 0:
        for x in range(response['total']):
            songInfo(response['items'][x]['track']['id'],spotify, dbname)

def createDB(dbname):
    conn = sqlite3.connect(dbname)
    cursor = conn.cursor()
    table ="""CREATE TABLE SONGS(
        ID_track VARCHAR(255),
        ID_isrc VARCHAR(255),
        ID_artist VARCHAR(255),
        ID_album VARCHAR(255),
        song_name VARCHAR(255),
        song_artist VARCHAR(255),
        album_name VARCHAR(255),
        album_type VARCHAR(255),
        album_label VARCHAR(255),
        album_popularity VARCHAR(255),
        album_release_date VARCHAR(255),
        album_total_tracks VARCHAR(255),
        artist_popularity VARCHAR(255),
        artist_genres VARCHAR(255),
        artist_followers VARCHAR(255),
        danceability VARCHAR(255),
        energy VARCHAR(255),
        loudness VARCHAR(255),
        speechiness VARCHAR(255),
        acousticness VARCHAR(255),
        instrumentalness VARCHAR(255),
        liveness VARCHAR(255),
        valence VARCHAR(255),
        duration_ms VARCHAR(255),
        duration VARCHAR(255),
        end_of_fade_in VARCHAR(255),
        start_of_fade_out VARCHAR(255),
        tempo VARCHAR(255),
        tempo_confidence VARCHAR(255),
        time_signature VARCHAR(255),
        time_signature_confidence VARCHAR(255),
        key VARCHAR(255),
        key_confidence VARCHAR(255),
        mode VARCHAR(255),
        mode_confidence VARCHAR(255)
        );"""
    cursor.execute(table)
    conn.close()

dbname='spotify.sqlite'
pl_id = 'spotify:playlist:37i9dQZEVXcLjbrcsHa1aK'

if not (exists(dbname)): createDB(dbname)
tracksFromPlaylist(spotify, pl_id, dbname)



#EXPORT
#import pandas
#pandas.read_json("input.json").to_excel("output.xlsx")
##https://pandas.pydata.org/pandas-docs/stable/reference/io.html#excel

# Writing to sample.json
#with open("sample.json", "w") as outfile:
#    outfile.write(json_object)

# https://anthonydebarros.com/2020/09/06/generate-json-from-sql-using-python/