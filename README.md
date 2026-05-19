# Simple Go Server!

A minimal HTTP server in Go that serves JSON responses.

## Running

```bash
go run main.go
```

Server starts on port `4444`.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Returns JSON with name, description, and host |

## Example Response

```json
{"Name":"Hello","Description":"World","Url":"localhost:4444"}
```