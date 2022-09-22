import spotipy
import pandas
import sqlite3
import os.path
import sys
from datetime import date

spotify = spotipy.Spotify(client_credentials_manager=spotipy.oauth2.SpotifyClientCredentials())

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

    # Get details about the Song
    album = spotify.album(albumID) # Album Information
    artist = spotify.artist(artistID) # Artist Information
    trackFeatures = spotify.audio_features(trackID) # Track Features
    trackAnalysis = spotify.audio_analysis(trackID) # Track Analysis Details

    #artistTopTracks(artistID, trackID, spotify) # TODO check if track is in top 10 of artist
    #artist['genres'], #artist_genres (TODO: this is a list : "genres": [    "dance pop",    "miami hip hop",    "pop",    "pop rap"  ])

    #TODO: Prüfen ob TrackID schon vorhanden ist

    # Get release date and year
    release_date= str(album['release_date'])
    release_year=0
    if (len(release_date)>=4):
        release_year = int(release_date[0:4])

    # Get duration_ms, duration_sec and duration_min
    duration_ms = int(trackFeatures[0]['duration_ms'])
    duration_sec = duration_ms/1000
    duration_min = '%.3f'%(duration_sec/60)

    # Write Track Information to DB
    conn = sqlite3.connect(dbname)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO SONGS (ID_track, ID_isrc, ID_artist, ID_album, " + # IDs
            "song_name, song_artist, album_name, " + # Basics
            "album_type, album_label, album_popularity, album_release_date, album_release_year, album_total_tracks, " + # Album
            "artist_popularity, artist_genres, artist_followers, " + # artist
            "danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, duration_ms, " + # trackFeatures
            "duration_sec, duration_min, end_of_fade_in, start_of_fade_out, tempo, tempo_confidence, time_signature, time_signature_confidence, key, key_confidence, mode, mode_confidence)" + # trackAnalysis
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
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
        release_date, #album_release_date
        release_year, #album_release_year
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
        duration_ms, #duration_ms
        duration_sec, #duration_sec
        duration_min, #duration_min
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
        artist_popularity int, artist_genres VARCHAR(50), artist_followers int,
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

# Input
playlistID = '37i9dQZEVXcLjbrcsHa1aK'

# File names
file_dir = os.path.dirname(sys.argv[0]) + "\\" + str(date.today())
os.makedirs(file_dir, exist_ok=True)
db_name= os.path.normpath(file_dir + "\\" + playlistID + '.sqlite')
csv_name= os.path.normpath(file_dir + "\\" + playlistID + '.csv')
xlsx_name= os.path.normpath(file_dir + "\\" + playlistID + '.xlsx')
json_name= os.path.normpath(file_dir + "\\" + playlistID + '.json')

# Build and fill DB
if not (os.path.exists(db_name)): createDB(db_name)
tracksFromPlaylist(spotify, playlistID, db_name)

# Export files
exportJSON(db_name, json_name)
exportExcel(db_name, xlsx_name)
exportCSV(db_name, csv_name)
