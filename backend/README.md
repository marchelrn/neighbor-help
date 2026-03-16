# Neighbor Help — Backend

REST API backend untuk aplikasi **Neighbor Help**, platform yang menghubungkan warga sekitar untuk saling membantu dalam radius tertentu.

---

## Tech Stack

| Kategori | Teknologi | Versi |
|---|---|---|
| Language | Go | 1.25.7 |
| Framework | Gin | v1.11.0 |
| ORM | GORM | v1.31.1 |
| Database | PostgreSQL | - |
| Authentication | JWT (golang-jwt) | v5.3.1 |
| Password Hashing | bcrypt (x/crypto) | v0.48.0 |
| Hot Reload | Air | - |
| CORS | gin-contrib/cors | v1.7.6 |
| Rate Limiting | ulule/limiter | v3.11.2 |
| Config | godotenv | v1.5.1 |

---

## Struktur Folder

```
backend/
├── cmd/
│   └── app/
│       └── app.go              # Entry point aplikasi
├── config/
│   └── config.go               # Load konfigurasi dari .env
├── contract/
│   ├── repository.go           # Interface repository
│   └── service.go              # Interface service
├── dto/
│   └── dto.go                  # Data Transfer Objects (request & response)
├── handler/
│   ├── error_handler.go        # Helper error response
│   ├── health_handler.go       # Handler health check
│   └── user_handler.go         # Handler user (register, login, dll)
├── internal/
│   ├── database/
│   │   └── database.go         # Koneksi database PostgreSQL
│   └── server/
│       └── server.go           # Setup dan jalankan HTTP server
├── middleware/
│   └── auth_middleware.go      # JWT auth middleware
├── migrations/
│   ├── migrations.go           # Runner migrasi (Up/Down/DownAll)
│   ├── create_table_users.go
│   ├── create_table_help_request.go
│   ├── create_table_messages.go
│   └── create_table_reputation_logs.go
├── models/
│   ├── users.go                # Model users & NearbyUser
│   ├── help_request.go         # Model help_requests
│   ├── messages.go             # Model messages
│   └── reputation_log.go       # Model reputation_logs
├── pkg/
│   ├── error/
│   │   └── error.go            # Custom AppError & helper (BadRequest, NotFound, dll)
│   └── token/
│       └── token.go            # Generate & validate JWT
├── repository/
│   ├── repository.go           # Inisialisasi semua repository
│   ├── health_repository.go
│   └── users_repository.go     # Query database user
├── routes/
│   └── routes.go               # Definisi semua route
├── service/
│   ├── service.go              # Inisialisasi semua service
│   ├── health_service.go
│   └── users_service.go        # Business logic user
├── utils/
│   ├── utils.go                # Utility umum
│   └── validator.go            # Validator username & password
├── main.go
├── go.mod
├── go.sum
├── .env
└── .air.toml                   # Konfigurasi hot reload
```

---

## Skema Database

```
┌─────────────────────────────┐       ┌──────────────────────────────────┐
│           users             │       │          help_requests            │
├─────────────────────────────┤       ├──────────────────────────────────┤
│ id             SERIAL PK    │──┐    │ id          SERIAL PK            │
│ username       VARCHAR(255) │  │    │ user_id     INT FK → users.id    │
│ password       VARCHAR(255) │  └───▶│ title       TEXT                 │
│ full_name      VARCHAR(255) │       │ description TEXT                 │
│ address        VARCHAR(255) │       │ category    TEXT                 │
│ coordinate_lat DECIMAL      │       │ status      TEXT                 │
│ coordinate_lng DECIMAL      │       │ created_at  TIMESTAMP            │
└─────────────────────────────┘       └──────────────────────────────────┘
          │                                         │
          │    ┌────────────────────────────────────┘
          │    │
          │    ▼
          │  ┌──────────────────────────────────────────┐
          │  │              messages                     │
          │  ├──────────────────────────────────────────┤
          │  │ id          SERIAL PK                    │
          │  │ request_id  INT FK → help_requests.id    │
          │  │ sender_id   INT FK → users.id            │
          │  │ receiver_id INT FK → users.id            │
          │  │ message     TEXT                         │
          │  │ sent_at     TIMESTAMP                    │
          │  └──────────────────────────────────────────┘
          │
          │  ┌──────────────────────────────────────────┐
          │  │           reputation_logs                 │
          │  ├──────────────────────────────────────────┤
          └─▶│ id              SERIAL PK                │
             │ helper_id       INT FK → users.id        │
             │ request_id      INT FK → help_requests.id│
             │ points_received INT                      │
             └──────────────────────────────────────────┘
```

---

## Cara Menjalankan

### 1. Clone & masuk ke folder

```bash
git clone <repo-url>
cd backend
```

### 2. Buat file `.env`

```env
PORT=8080
ENV=development

# Database
DB_USER=postgres
DB_PASS=yourpassword
DB_HOST=localhost
DB_PORT=5432
DB_NAME=neighbor_help

# JWT
JWT_SECRET=your_super_secret_key_minimum_32_chars
```

### 3. Install dependencies

```bash
go mod tidy
```

### 4. Jalankan (dengan hot reload)

```bash
air
```

### 4b. Jalankan (tanpa hot reload)

```bash
go run main.go
```

> Migrasi database akan **berjalan otomatis** saat server pertama kali start.

---

## API Endpoints

### Base URL
```
http://localhost:8080
```

---

### Public Routes

Tidak membutuhkan token.

#### `GET /health`
Mengecek status API.

**Response:**
```json
{
  "message": "API is healthy"
}
```

---

#### `POST /register`
Mendaftarkan user baru.

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "Password123",
  "full_name": "John Doe",
  "address": "Jl. Merdeka No. 1, Jakarta",
  "coordinate_lat": -6.2088,
  "coordinate_long": 106.8456
}
```

**Response `201`:**
```json
{
  "message": "User Registered Successfully"
}
```

---

#### `POST /login`
Login dan mendapatkan JWT token.

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "Password123"
}
```

**Response `200`:**
```json
{
  "message": "Login success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### Protected Routes

Semua route di bawah membutuhkan header:
```
Authorization: Bearer <token>
```

---

#### `GET /users`
Mengambil semua data user.

**Response `200`:**
```json
{
  "message": "Users retrieved successfully",
  "data": {
    "data": [
      {
        "id": 1,
        "username": "john_doe",
        "full_name": "John Doe",
        "address": "Jl. Merdeka No. 1, Jakarta",
        "coordinate_lat": -6.2088,
        "coordinate_long": 106.8456
      }
    ]
  }
}
```

---

#### `GET /user/:id`
Mengambil data user berdasarkan ID.

**Path Param:** `id` — ID user (integer)

**Response `200`:**
```json
{
  "status": 200,
  "message": "User retrieved successfully",
  "data": [
    {
      "id": 1,
      "username": "john_doe",
      "full_name": "John Doe",
      "address": "Jl. Merdeka No. 1, Jakarta",
      "coordinate_lat": -6.2088,
      "coordinate_long": 106.8456
    }
  ]
}
```

---

#### `PUT /user/:username`
Update data user berdasarkan username.

**Path Param:** `username` — username saat ini

**Request Body** (semua field opsional):
```json
{
  "username": "john_new",
  "password": "NewPassword123",
  "full_name": "John Doe Updated",
  "address": "Jl. Baru No. 10",
  "coordinate_lat": -6.2100,
  "coordinate_long": 106.8300
}
```

> Kosongkan field yang tidak ingin diubah. `username` di body diisi hanya jika ingin mengganti username.

**Response `200`:**
```json
{
  "message": "Update Success"
}
```

---

#### `GET /nearby`
Mengambil daftar user yang berada dalam radius **500 meter** dari lokasi user yang sedang login. Lokasi diambil otomatis dari data user yang tersimpan di database.

> Username diambil dari JWT token secara otomatis — tidak perlu mengirim parameter apapun.

**Response `200`:**
```json
{
  "users": [
    {
      "id": 3,
      "username": "budi_santoso",
      "full_name": "Budi Santoso",
      "address": "Jl. Melati No. 5",
      "coordinate_lat": -6.2100,
      "coordinate_long": 106.8300,
      "distance": 123.45
    },
    {
      "id": 7,
      "username": "siti_rahayu",
      "full_name": "Siti Rahayu",
      "address": "Jl. Kenanga No. 2",
      "coordinate_lat": -6.2110,
      "coordinate_long": 106.8350,
      "distance": 387.20
    }
  ]
}
```

> `distance` dalam satuan **meter**. Hasil diurutkan dari yang terdekat.

---

## Error Response

Semua error mengikuti format:

```json
{
  "status_code": 400,
  "message": "Invalid Request Body"
}
```

| Status Code | Keterangan |
|---|---|
| `400` | Bad Request — input tidak valid |
| `401` | Unauthorized — token tidak ada atau tidak valid |
| `403` | Forbidden — tidak punya akses |
| `404` | Not Found — data tidak ditemukan |
| `409` | Conflict — data duplikat (misal username sudah dipakai) |
| `429` | Too Many Requests — rate limit tercapai |
| `500` | Internal Server Error |

---

## Arsitektur

Project menggunakan **Layered Architecture**:

```
Request → Handler → Service → Repository → Database
                  ↑         ↑
              (contract  (contract
               interface)  interface)
```

| Layer | Folder | Tanggung Jawab |
|---|---|---|
| Handler | `handler/` | Menerima HTTP request, validasi input, return response |
| Service | `service/` | Business logic, orchestrasi antar repository |
| Repository | `repository/` | Akses langsung ke database |
| Contract | `contract/` | Interface untuk decoupling antar layer |

---

## Rate Limiting

| Environment | Limit |
|---|---|
| Development | 1000 request / menit |
| Production | 100 request / menit |
