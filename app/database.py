import asyncpg
import asyncio

class Database:
    def __init__(self):
        self.pool = None

    async def connect(self):
        self.pool = await asyncpg.create_pool(
            user='qbooks_user',
            password='qb_pass',
            database='quickbooks',
            host='postgres',
            min_size=1,
            max_size=10
        )

    async def close(self):
        await self.pool.close()

db = Database()

async def get_conn():
    if db.pool is None:
        await db.connect()
    async with db.pool.acquire() as conn:
        yield conn
