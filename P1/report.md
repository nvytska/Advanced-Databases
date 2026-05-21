## 1. Installed Software

- PostgreSQL
- DataGrip

# 2. Active Sessions

```sql
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    state,
    backend_start,
    query_start,
    query
FROM pg_stat_activity;
```

### Conclusion

This query shows all current database sessions, connected users, active states, and executed queries.

# 3. Currently Active Queries

```sql
SELECT
    pid,
    usename,
    now() - query_start AS duration,
    state,
    query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY duration DESC;
```

### Conclusion

This query helps identify currently running queries and their execution duration.

# 4. Performance Statistics (pg_stat_statements)

```
SHOW config_file;
```

```
sudo nano /Library/PostgreSQL/18/data/postgresql.conf
```

Configuration:

```
shared_preload_libraries = 'pg_stat_statements'
```

Verification:

```
SHOW shared_preload_libraries;
```

```
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

Statistics query:

```sql
SELECT
    calls,
    total_exec_time,
    mean_exec_time,
    query
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
```

### Conclusion

pg_stat_statements provides execution statistics for SQL queries and helps identify expensive or frequently executed queries.


# 5. Long-Running Queries

```
SELECT
    pid,
    usename,
    now() - query_start AS running_time,
    query
FROM pg_stat_activity
WHERE state = 'active'
  AND now() - query_start > interval '5 minutes';
```

### Conclusion

This query detects queries running longer than expected and helps diagnose performance problems.


# 6. Blocked Sessions and Locks

```sql
SELECT
    blocked.pid     AS blocked_pid,
    blocked.query   AS blocked_query,
    blocking.pid    AS blocking_pid,
    blocking.query  AS blocking_query
FROM pg_stat_activity blocked
JOIN pg_locks blocked_locks ON blocked.pid = blocked_locks.pid
JOIN pg_locks blocking_locks
    ON blocked_locks.locktype = blocking_locks.locktype
   AND blocked_locks.database IS NOT DISTINCT FROM blocking_locks.database
   AND blocked_locks.relation IS NOT DISTINCT FROM blocking_locks.relation
   AND blocked_locks.pid != blocking_locks.pid
JOIN pg_stat_activity blocking
    ON blocking.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
```

### Conclusion

This query identifies blocked sessions and processes causing locks in the database.


# 7. Role Management (Read-Only User)

```sql
CREATE ROLE monitor_user WITH LOGIN PASSWORD 'secure_password';

GRANT CONNECT ON DATABASE postgres TO monitor_user;

GRANT USAGE ON SCHEMA public TO monitor_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO monitor_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO monitor_user;
```

### Verification

```
INSERT INTO test_table VALUES (1);
```

result:

```
permission denied
```

### Conclusion

The `monitor_user` role has read-only access and cannot modify database data.
