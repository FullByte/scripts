from tinydb import TinyDB, Query

# Create DB
db = TinyDB('db.json')
db.insert({ 'type': 'OSFY', 'count': 700 })
db.insert({ 'type': 'EFY', 'count': 800 })
db.all()

# Update DB
db.update({'count': 1000}, Magazine.type == 'OSFY')
db.all()

# Search and List
Magazine = Query()
db.search(Magazine.type == 'OSFY')
db.search(Magazine.count > 750)

# Remove / Purge
db.remove(Magazine.count < 900)
db.all()
db.purge()
db.all()

# In-Memory Use
from tinydb.storages import MemoryStorage
db = TinyDB(storage=MemoryStorage)