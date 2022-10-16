import spotipy
import pandas
import sqlite3
import os
import sys
from datetime import date
from pathlib import Path

#ClientCredentials = spotipy.oauth2.SpotifyOAuth(redirect_uri="http://localhost/callback",cache_path='./tokens.txt')
ClientCredentials = spotipy.oauth2.SpotifyClientCredentials()
spotify = spotipy.Spotify(client_credentials_manager = ClientCredentials)

####################
# Get Spotify Data
####################

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

    song_artist = str(trackInfo['artists'][0]['name'])
    song_name = str(trackInfo['name'])

    # Get details about the Song
    album = spotify.album(albumID) # Album Information
    artist = spotify.artist(artistID) # Artist Information
    trackFeatures = spotify.audio_features(trackID) # Track Features

    # TODO use alternative song length value if trackFeatures is not available
    # Get duration_ms, duration_sec and duration_min
    duration_ms = int(trackInfo['duration_ms']) #duration_ms = int(trackFeatures[0]['duration_ms'])
    duration_sec = duration_ms/1000
    duration_min = '%.3f'%(duration_sec/60)

    # Track Features
    danceability = energy = loudness = speechiness = acousticness = instrumentalness = liveness = valence = 0
    try:
        danceability = trackFeatures[0]['danceability']
        energy = trackFeatures[0]['energy']
        loudness = trackFeatures[0]['loudness']
        speechiness = trackFeatures[0]['speechiness']
        acousticness = trackFeatures[0]['acousticness']
        instrumentalness = trackFeatures[0]['instrumentalness']
        liveness = trackFeatures[0]['liveness']
        valence = trackFeatures[0]['valence']
    except:
        print("No track features availble for " + song_artist + "-" + song_name)
    
    # Track Analysis Details (is not always available)    
    end_of_fade_in = start_of_fade_out = tempo = tempo_confidence = time_signature = time_signature_confidence = key = key_confidence = mode = mode_confidence = 0
    try:
        trackAnalysis = spotify.audio_analysis(trackID)       
        end_of_fade_in = trackAnalysis['track']['end_of_fade_in']
        start_of_fade_out = trackAnalysis['track']['start_of_fade_out']
        tempo = trackAnalysis['track']['tempo']
        tempo_confidence = trackAnalysis['track']['tempo_confidence']
        time_signature = trackAnalysis['track']['time_signature']
        time_signature_confidence = trackAnalysis['track']['time_signature_confidence']
        key= trackAnalysis['track']['key'] 
        key_confidence = trackAnalysis['track']['key_confidence'] 
        mode = trackAnalysis['track']['mode'] 
        mode_confidence = trackAnalysis['track']['mode_confidence'] 
    except:
        print("No track analysis availble for "  + song_artist + "-" + song_name)

    # TODO check if track is in top 10 of artist
    #artistTopTracks(artistID, trackID, spotify) 
    
    # Get release date and year
    release_date=(album['release_date'])
    release_year=0
    if (len(release_date)>=4):
        release_year = int(release_date[0:4])
        release_date = pandas.to_datetime(str(album['release_date'])).strftime('%d.%m.%Y')
    else:
        release_year = (album['release_date'])
        release_date = "1.1."+str(release_year)        

    # Get genre if available
    list = (artist['genres'])
    if(len(list)>0): artist_genre1= str(list[0])
    else: artist_genre1 = "N/A"
    if(len(list)>1): artist_genre2= str(list[1])
    else: artist_genre2 = "N/A"
    if(len(list)>2): artist_genre3= str(list[2])
    else: artist_genre3 = "N/A"

    # Write Track Information to DB
    conn = sqlite3.connect(dbname)
    cursor = conn.cursor()
    cursor.execute(
                "INSERT INTO SONGS (ID_track, ID_isrc, ID_artist, ID_album, " + # IDs
                "song_name, song_artist, album_name, " + # Basics
                "album_type, album_label, album_popularity, album_release_date, album_release_year, album_total_tracks, " + # Album
                "artist_popularity, artist_genre1, artist_genre2, artist_genre3, artist_followers, " + # artist
                "danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, duration_ms, " + # trackFeatures
                "duration_sec, duration_min, end_of_fade_in, start_of_fade_out, tempo, tempo_confidence, time_signature, time_signature_confidence, key, key_confidence, mode, mode_confidence)" + # trackAnalysis
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                (
                    # IDs    
                    trackID, trackInfo['external_ids']['isrc'], artistID, albumID,
                    # Album
                    song_name, song_artist, str(album['name']), str(trackInfo['album']['album_type']),
                    str(album['label']), album['popularity'], release_date, release_year, album['total_tracks'],  
                    # Artist Details
                    artist['popularity'], artist_genre1, artist_genre2, artist_genre3, artist['followers']['total'],
                    # track features
                    danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence,
                    # track analysis
                    duration_ms, duration_sec, duration_min, end_of_fade_in, start_of_fade_out,
                    tempo, tempo_confidence, time_signature, time_signature_confidence,
                    key, key_confidence,  mode, mode_confidence
                )
            )
    conn.commit()
    conn.close()

def tracksFromPlaylist(spotify, playlistID, dbname):
    response = spotify.playlist_items('spotify:playlist:' + playlistID, fields='items.track.id,total', additional_types=['track'])
    if len(response['items']) != 0:
        for x in range(response['total']):
            songInfo(response['items'][x]['track']['id'],spotify, dbname)

def createDB(dbname):
    conn = sqlite3.connect(dbname)
    cursor = conn.cursor()
    table ="""CREATE TABLE IF NOT EXISTS SONGS(
        ID_track VARCHAR(50), ID_isrc VARCHAR(50), ID_artist VARCHAR(50), ID_album VARCHAR(50),
        song_name VARCHAR(255), song_artist VARCHAR(255), album_name VARCHAR(255), album_type VARCHAR(255), album_label VARCHAR(255),
        album_popularity int, album_release_date int, album_release_year int, album_total_tracks int,
        artist_popularity int, artist_genre1 VARCHAR(50), artist_genre2 VARCHAR(50), artist_genre3 VARCHAR(50), artist_followers int,
        danceability int, energy int, loudness int, speechiness int, acousticness int, instrumentalness int, liveness int, valence int,
        duration_ms int, duration_sec int, duration_min int, end_of_fade_in int, start_of_fade_out int,
        tempo int, tempo_confidence int, time_signature int, time_signature_confidence int,
        key int, key_confidence int, mode int, mode_confidence int);"""
    cursor.execute(table)
    conn.close()

####################
# EXPORT
####################

def exportCSV(dbname, exportpath):
    conn = sqlite3.connect(dbname)
    clients = pandas.read_sql('SELECT * FROM SONGS;' ,conn)
    clients.to_csv(exportpath, index=False)

def exportExcel(dbname, exportpath):
    conn = sqlite3.connect(dbname)
    clients = pandas.read_sql('SELECT * FROM SONGS;' ,conn)
    clients.to_excel(exportpath)

def exportJSON(dbname, exportpath):
    conn = sqlite3.connect(dbname)
    clients = pandas.read_sql('SELECT * FROM SONGS;' ,conn)
    clients.to_json(exportpath, orient="records")

####################
# Start here
####################

def start(playlistID):
    # File names
    current_path = Path(os.path.dirname(sys.argv[0]))
    file_dir = current_path / str(date.today())
    os.makedirs(file_dir, exist_ok=True)
    db_name = file_dir / str(playlistID + '.sqlite')
    csv_name = file_dir /  str(playlistID + '.csv')
    xlsx_name = file_dir /  str(playlistID + '.xlsx')
    json_name = file_dir /  str(playlistID + '.json')

    if not (os.path.exists(db_name)):
        createDB(db_name) # Build DB
        tracksFromPlaylist(spotify, playlistID, db_name) # Fill DB with song details

        # Export files
        exportJSON(db_name, json_name)
        exportExcel(db_name, xlsx_name)
        exportCSV(db_name, csv_name)
    else:
        print("DB already exists")

# Input
start('1jMKFDyRcsqlQwRgkRQe0I')

#DAA playlist 2021: 1jMKFDyRcsqlQwRgkRQe0I
#DAA playlist 2022: 5pbME6fphTNqnVit3Xx9HU