import psycopg2

conn = psycopg2.connect(user='nikittossii',
                        password='111261',
                        host='localhost',
                        database='dblessons')

cursor = conn.cursor()

for it in data:
    if True:
        curent = '8911' + it['num'][4:]
        cursor.execute(
        '''Update Phone Set Phonenumber = %s
            where phoneid = %s;''',
        (curent, it['id'])
        )


cursor.close()
conn.close()    