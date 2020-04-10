import asyncio
import asyncpg
import json
import datetime
import random


class pgLoader:



    def __init__(self):
        self.list_of_object = list()
        with open("people.json", "r") as read:
            self.list_of_object += json.load(read)
        self.count = 0
        self.mail_postfix = ("gmail", "mail", "yandex", "rambler")
        self.mail_local = ("ru", "com", "onion")

    async def connect(self):
        self.conn = await asyncpg.connect(
            'postgresql://localhost:5432/dblessons',
            user='nikittossii',
            password='111261',
            port=5432)
        print("connect")

    async def init_mark(self):
        await self.conn.execute('''
                INSERT INTO Mark(Type) values
                ('Семья')''')
        await self.conn.execute('''
                INSERT INTO Mark(Type) values 
                ('Друзья')''')
        await self.conn.execute('''
                INSERT INTO Mark(Type) values 
                ('Коллеги')''')
        await self.conn.execute('''
                INSERT INTO Mark(Type) values 
                ('Соседи')''')

    async def push_once(self, cur_object):
        acab = cur_object['date']['digital_time'].split("-")
        await self.conn.execute(
            '''INSERT INTO Person(
            PersonID ,Name, Surname, Photo, DateOfBirth) VALUES (
            $1, $2, $3, $4, $5)''',
            self.count, cur_object['name']['fname'],
            cur_object['name']['lname'],
            cur_object['userpic'],
            datetime.datetime(int(acab[2]), int(acab[0]), int(acab[1]))
        )
        indexList = []
        if (random.randint(0,100) > 85):
            for _ in range(random.randint(0, 4)):
                index = random.randint(1, 4)
                if index in indexList:
                    continue
                indexList.append(index)
                await self.conn.execute(
                    '''INSERT INTO MarkSet(PersonID, MarkID) values (
                        $1, $2
                    )''',
                    self.count,
                    index
                )
        await self.conn.execute('''
                INSERT INTO Phone(PersonID, PhoneNumber) VALUES (
                $1, $2)''',
                self.count,
                "8" + ''.join(cur_object['phone'][2:].split(" "))
                )
        await self.conn.execute('''
                INSERT INTO Email(PersonID, Adres, Domain, Local)
                values ($1, $2, $3, $4)''',
                self.count, cur_object['login'],
                self.mail_postfix[random.randint(0,
                        len(self.mail_postfix) - 1)],
                self.mail_local[random.randint(0,
                        len(self.mail_local) - 1)]
                )
        self.count += 1

    async def catch_and_push(self):
        # loop = asyncio.new_event_loop()
        # tasks = [loop.create_task(self.push_once(i)
        #                           for i in self.list_of_object)]
        # loop.run_until_complete(tasks)
        # loop.close()
        # # # maybe this work async # # #
        tasks = [await self.push_once(i) for i in self.list_of_object]
        return tasks

    async def detatch(self):
        await self.conn.close()
        print("disconect")

    async def main(self):
        #rubish
        await self.connect()
        # await self.init_mark()
        await self.catch_and_push()
        await self.detatch()


if __name__ == "__main__":
    pg = pgLoader()
    loop = asyncio.get_event_loop()
    loop.run_until_complete(pg.main())
    # asyncio.run(pg.connect())
    # pg.catch_and_push()