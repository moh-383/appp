# Backend API — Rover

## Variables (`.env`)

| Variable | Défaut | Rôle |
| --- | --- | --- |
| `ESP32_BASE_URL` | `http://192.168.100.50` | IP ESP32 |
| `API_KEY` | `rover-secret-key` | Auth clients |
| `ESP32_API_KEY` | = `API_KEY` | Auth → ESP32 |
| `MINE_*_THRESHOLD` | 300 / 100 / 20 | Seuils détection |
| `AUTO_OBSTACLE_CM` | 25 | Évitement auto |
| `ENABLE_DOCS` | `1` | `/docs` OpenAPI |
| `PUBLIC_HEALTH_MINIMAL` | `1` | `/health` sans détails |

## Sécurité

- Clé via `X-API-Key` (comparaison `secrets.compare_digest`)
- `/health` minimal en public ; détails avec clé ou `/health/full`
- Headers sécu HTTP ; CORS via `CORS_ORIGINS`
- **HTTPS** : reverse proxy (Caddy / nginx) — pas de TLS dans uvicorn

## Auto

Boucle backend : forward, virage si obstacle, stop + coupe auto si mine.  
`auto_mode` **jamais** restauré au démarrage.
