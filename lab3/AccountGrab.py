import asyncio
import aiohttp
import json


class AccountGrab:

    def __init__(self):
        self.json_seq = list()
        self.url = "https://randus.org/api_en.php"

    async def get_one(self):
        async with aiohttp.ClientSession() as session:
            async with session.get(self.url) as resp:
                print(resp.status)
                self.json_seq.append(await resp.json())

    def die(self):
        try:
            with open("people.json", "r") as read:
                self.json_seq += json.load(read)
        except FileNotFoundError:
            print("once")
        with open("people.json", "w") as write:
            json.dump(self.json_seq, write, ensure_ascii=False)


if __name__ == "__main__":
    event_loop = asyncio.get_event_loop()
    for _ in range(100):
        acc = AccountGrab()
        futureSet = [event_loop.create_task(acc.get_one()) for _ in
                     range(10)]
        waiting = asyncio.wait(futureSet)
        event_loop.run_until_complete(waiting)
        acc.die()
    event_loop.close()
    print("end")
