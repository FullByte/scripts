import sqlite3

dbname='spotify.sqlite'

def create(dbname):
      conn = sqlite3.connect(dbname)
      cursor = conn.cursor()
      table ="""CREATE TABLE STUDENT(NAME VARCHAR(255), CLASS VARCHAR(255),
      SECTION VARCHAR(255));"""
      cursor.execute(table)

def write(dbname):
      conn = sqlite3.connect(dbname)
      cursor = conn.cursor()
      cursor.execute('''INSERT INTO STUDENT VALUES ('Raju', '7th', 'A')''')
      cursor.execute('''INSERT INTO STUDENT VALUES ('Shyam', '8th', 'B')''')
      cursor.execute('''INSERT INTO STUDENT VALUES ('Baburao', '9th', 'C')''')
      conn.commit()
      conn.close()

def read(dbname):
      conn = sqlite3.connect(dbname)
      cursor = conn.cursor()
      data=cursor.execute('''SELECT * FROM SONGS''')
      for row in data:
            print(row)
      #conn.commit()
      conn.close()

#create(dbname)
#write(dbname)
read(dbname)

