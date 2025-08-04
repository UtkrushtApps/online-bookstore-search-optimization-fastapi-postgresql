# Online Bookstore Search Optimization: FastAPI & PostgreSQL

## Task Overview
- You are working with the backend system for QuickBooks, a simple online bookstore.
- The FastAPI REST API is already developed with endpoints to add books and search books by author or category, but as the bookstore's catalogue grows, search endpoints have become sluggish.
- The main business issue is that book search by author or category is slow, affecting the ability of customers to quickly find relevant books and impacting user experience during peak hours.

## Performance Issues
- Slow API responses when searching for books by author or category due to inefficient SQL logic or missing indexes
- The existing PostgreSQL database schema has basic flaws such as lack of proper indexes and suboptimal relationships
- Synchronous or blocking DB operations causing bottlenecks in concurrent FastAPI endpoints
- No async/await support in database access functions, leading to potential event loop blocking

## Database Access
- Host: `<DROPLET_IP>`
- Port: 5432
- Database: quickbooks
- Username: qbooks_user
- Password: qb_pass
- You may use any PostgreSQL database client (psql, pgAdmin, DBeaver) for direct access, query analysis, and schema changes.

## Objectives
- Add appropriate indexes to the books table to speed up searches by author and category
- Refactor the existing database schema for normalization and add constraints where necessary
- Implement async-compatible, non-blocking database queries within the API data-access logic (no route modifications)
- Demonstrate significant improvements in API search responsiveness for book lookup endpoints
- Ensure that all CRUD operations use safe and efficient SQL with basic error handling

## How to Verify
- Use API endpoints for searching by author and category before and after optimization to observe reduced latency
- Use EXPLAIN/ANALYZE in PostgreSQL to confirm that searches use indexes and avoid full table scans
- Validate that all database operations are working asynchronously and do not block the FastAPI event loop
- Review query and server logs for improvement in handling concurrent requests efficiently
