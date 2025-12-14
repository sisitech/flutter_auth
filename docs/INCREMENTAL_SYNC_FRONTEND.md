# Incremental Sync - Frontend Integration Guide

This document provides frontend developers with everything needed to integrate the incremental sync feature for offline caching.

## Base URL

All endpoints require authentication via OAuth2 Bearer token.

```
Base: /api/v1/
Authorization: Bearer <access_token>
```

---

## Overview

The incremental sync feature allows clients to fetch only items that have been modified since a given timestamp. This enables efficient offline caching by:

1. Fetching all items on first sync
2. On subsequent syncs, only fetching items modified after the last sync
3. Results are ordered by `modified` ASC (oldest first) to support resumable sync

---

## Supported Endpoints

The following endpoints support the `modified_after` query parameter:

| Endpoint | Description |
|----------|-------------|
| `GET /api/v1/categories` | List categories (system + user's custom) |
| `GET /api/v1/sub-categories` | List subcategories (system + user's custom) |
| `GET /api/v1/tagging-rules/me/` | List user's tagging rules |

---

## Query Parameter

### `modified_after`

**Type:** ISO8601 timestamp string

**Format:** `YYYY-MM-DDTHH:MM:SSZ` or `YYYY-MM-DDTHH:MM:SS+00:00`

**Behavior:**
- Filters results to only include items where `modified > timestamp`
- Results are ordered by `modified` ASC (oldest modified first)
- If the parameter is missing or invalid, returns all items ordered by `modified` ASC

---

## API Examples

### 1. Initial Sync (No modified_after)

Fetch all items on first sync.

```
GET /api/v1/categories
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "count": 15,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "Food & Dining",
      "description": "Meals and restaurants",
      "image": null,
      "user": null,
      "created": "2024-01-01T00:00:00Z",
      "modified": "2024-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "Transportation",
      "description": "Travel and commute",
      "image": null,
      "user": null,
      "created": "2024-01-01T00:00:00Z",
      "modified": "2024-06-15T10:30:00Z"
    }
  ]
}
```

**Important:** Store the `modified` timestamp of the last item in the response for the next sync.

---

### 2. Incremental Sync (With modified_after)

Fetch only items modified after a specific timestamp.

```
GET /api/v1/categories?modified_after=2024-06-15T10:30:00Z
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "count": 2,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 5,
      "name": "Entertainment",
      "description": "Movies and games",
      "image": null,
      "user": null,
      "created": "2024-01-01T00:00:00Z",
      "modified": "2024-07-01T14:22:00Z"
    },
    {
      "id": 12,
      "name": "My Custom Category",
      "description": "Personal category",
      "image": null,
      "user": 42,
      "created": "2024-08-01T09:00:00Z",
      "modified": "2024-08-01T09:00:00Z"
    }
  ]
}
```

---

### 3. SubCategories Sync

```
GET /api/v1/sub-categories?modified_after=2024-06-15T10:30:00Z
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "count": 3,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 10,
      "name": "Groceries",
      "description": "Supermarket purchases",
      "category": 1,
      "budget_category": "needs",
      "user": null,
      "created": "2024-01-01T00:00:00Z",
      "modified": "2024-07-10T08:00:00Z"
    }
  ]
}
```

---

### 4. Tagging Rules Sync

```
GET /api/v1/tagging-rules/me/?modified_after=2024-06-15T10:30:00Z
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "count": 5,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 101,
      "name": "Uber",
      "sub_category": 15,
      "sub_category_name": "Ride Sharing",
      "category_name": "Transportation",
      "category": 2,
      "mpesa_code": null,
      "account": "UBER",
      "confidence_score": 95,
      "created": "2024-05-01T12:00:00Z",
      "modified": "2024-07-20T16:45:00Z"
    }
  ]
}
```

---

## Sync Flow

### Initial Sync
```
1. Call endpoint WITHOUT modified_after
2. Process all items in response
3. Store the `modified` timestamp of the LAST item
4. Use this timestamp for the next sync
```

### Subsequent Syncs
```
1. Call endpoint WITH modified_after=<last_modified_timestamp>
2. Process items in response (update local cache)
3. If results returned, update last_modified to the LAST item's modified timestamp
4. Repeat until no more results or next sync cycle
```

### Resumable Sync

If sync is interrupted (network error, app closed):
```
1. On resume, use the last successfully processed item's modified timestamp
2. Items are ordered oldest-first, so you'll continue from where you left off
3. Already-processed items won't be duplicated (they have earlier timestamps)
```

---

## Response Fields

All responses include pagination and a `results` array:

| Field | Type | Description |
|-------|------|-------------|
| `count` | integer | Total number of matching items |
| `next` | string/null | URL for next page (if paginated) |
| `previous` | string/null | URL for previous page (if paginated) |
| `results` | array | Array of items |

Each item includes:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier |
| `modified` | string | ISO8601 timestamp of last modification |
| `created` | string | ISO8601 timestamp of creation |
| `user` | integer/null | User ID (null for system items) |

---

## Error Handling

### Invalid Timestamp Format

If the `modified_after` parameter cannot be parsed, the API gracefully ignores it and returns all items.

```
GET /api/v1/categories?modified_after=invalid-date
```

**Response:** Returns all items (same as no filter)

### Authentication Errors

```json
{
  "detail": "Authentication credentials were not provided."
}
```
**Status:** 401 Unauthorized

---

## Best Practices

1. **Store Last Modified Timestamp**
   - After each successful sync, store the `modified` value of the last item
   - Use this for the next `modified_after` query

2. **Handle Empty Results**
   - Empty results mean no items were modified since the timestamp
   - Don't update your stored timestamp in this case

3. **Use Pagination**
   - For large result sets, use the `next` URL to fetch additional pages
   - Process each page and update your last modified timestamp

4. **Offline-First Architecture**
   - Always read from local cache first
   - Sync in the background when network is available
   - Merge server changes with local data

5. **Conflict Resolution**
   - Server timestamp is authoritative
   - If local changes exist, merge or resolve before applying server updates

---

## curl Testing Commands

```bash
# Initial sync - get all categories
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://api.expensetracker.wavvy.dev/api/v1/categories"

# Incremental sync - get modified items only
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://api.expensetracker.wavvy.dev/api/v1/categories?modified_after=2024-06-15T10:30:00Z"

# SubCategories incremental sync
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://api.expensetracker.wavvy.dev/api/v1/sub-categories?modified_after=2024-06-15T10:30:00Z"

# Tagging rules incremental sync
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://api.expensetracker.wavvy.dev/api/v1/tagging-rules/me/?modified_after=2024-06-15T10:30:00Z"
```

---

## Changelog

| Date | Change |
|------|--------|
| 2025-12-14 | Initial documentation |
