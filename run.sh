#!/bin/bash
set -e
cd /root/task

echo "Starting docker containers..."
docker-compose up -d
# Wait for PostgreSQL to be ready
until docker exec quickbooks_postgres pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "Creating database and user..."
docker exec -u postgres quickbooks_postgres psql -c "CREATE USER qbooks_user WITH PASSWORD 'qb_pass';" || true
docker exec -u postgres quickbooks_postgres psql -c "CREATE DATABASE quickbooks OWNER qbooks_user;" || true

echo "Applying schema..."
docker cp schema.sql quickbooks_postgres:/schema.sql
docker exec -u postgres quickbooks_postgres psql -d quickbooks -f /schema.sql

echo "Loading sample data..."
docker cp data/sample_data.sql quickbooks_postgres:/sample_data.sql
docker exec -u postgres quickbooks_postgres psql -d quickbooks -f /sample_data.sql

echo "Setup complete! Validating FastAPI app is responding..."
for i in {1..10}; do
  status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health 2>/dev/null || echo 000)
  if [ "$status" == "200" ]; then
    echo "FastAPI app is healthy."
    exit 0
  fi
  sleep 2
done
echo "FastAPI app did not start as expected. Please check logs."
exit 1
