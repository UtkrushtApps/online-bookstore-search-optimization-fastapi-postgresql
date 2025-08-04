from fastapi import APIRouter, Depends, HTTPException
from app.schemas.schemas import Book, BookCreate
from app.database import get_conn
from typing import List

router = APIRouter(prefix="/api", tags=["api"])

@router.post("/books", response_model=Book)
async def add_book(book: BookCreate, conn=Depends(get_conn)):
    query = """
        INSERT INTO books (title, author, category, published_year)
        VALUES ($1, $2, $3, $4)
        RETURNING id, title, author, category, published_year
    """
    row = await conn.fetchrow(query, book.title, book.author, book.category, book.published_year)
    if not row:
        raise HTTPException(status_code=500, detail="Failed to add book")
    return dict(row)

@router.get("/books/by-author/{author}", response_model=List[Book])
async def get_books_by_author(author: str, conn=Depends(get_conn)):
    # Intentionally inefficient: no index, no limit
    rows = await conn.fetch(
        "SELECT id, title, author, category, published_year FROM books WHERE author = $1", author
    )
    return [dict(row) for row in rows]

@router.get("/books/by-category/{category}", response_model=List[Book])
async def get_books_by_category(category: str, conn=Depends(get_conn)):
    # Intentionally inefficient: no index, no limit
    rows = await conn.fetch(
        "SELECT id, title, author, category, published_year FROM books WHERE category = $1", category
    )
    return [dict(row) for row in rows]
