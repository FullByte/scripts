# Compute geohash() using the Munroe algorithm
# https://imgs.xkcd.com/comics/geohashing.png

import hashlib

def geohash(latitude, longitude, datedow):
    hash = hashlib.md5(datedow, usedforsecurity=False).hexdigest()
    lat, long = [('%f' % float.fromhex('0.' + x)) for x in (hash[:16], hash[16:32])]
    print('%d%s %d%s' % (latitude, lat[1:], longitude, long[1:]))

geohash(48.417309100, 9.220723100, b'hello world')
