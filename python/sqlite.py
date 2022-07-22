import sqlite3

# Create DB
conn = sqlite3.connect('sqlite.db')
cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS exampletable (id integer PRIMARY KEY, login text, email text)")
conn.commit()

# Add entry
def sql_insert(data):
    login = data[0]
    cursor.execute(f'SELECT login FROM exampletable WHERE login = "{login}"')
    results = cursor.fetchall()
    if not results:
        cursor.execute('INSERT INTO exampletable (login, email) VALUES (?, ?)', data)
        conn.commit()
    else:
        print(f'User {login} already in database')

data = ('0xfab1', 'mail@example.com')
sql_insert(data)

# Read entry
def sql_fetch():
    cursor.execute('SELECT * FROM exampletable')
    rows = cursor.fetchall()
    return rows

print(sql_fetch())