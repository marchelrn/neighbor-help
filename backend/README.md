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

## Folder Structure

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


# Prod
DB_URL=

# Database
DB_USER={user}
DB_PASS={password}
DB_HOST={host}
DB_PORT={port}
DB_NAME={name}

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

#### `GET /health`
Status API.

**Response `200`:**
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
  "status": 201,
  "message": "User Registered Successfully",
  "data": {
    "id": 1,
    "username": "john_doe",
    "full_name": "John Doe",
    "address": "Jl. Merdeka No. 1, Jakarta",
    "coordinate_lat": -6.2088,
    "coordinate_long": 106.8456
  }
}
```

---

#### `POST /login`
Menerima JWT token.

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
  "status": 200,
  "message": "Login Success",
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
Mengambil semua user.

**Response `200`:**
```json
{
  "status": 200,
  "message": "Users retrieved successfully",
  "users": [
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

#### `GET /user/:id`
Mengambil satu user berdasarkan ID path parameter.

**Response `200`:**
```json
{
  "status": 200,
  "message": "User retrieved successfully",
  "user": {
    "id": 1,
    "username": "john_doe",
    "full_name": "John Doe",
    "address": "Jl. Merdeka No. 1, Jakarta",
    "coordinate_lat": -6.2088,
    "coordinate_long": 106.8456
  }
}
```

---

#### `PUT /user/:username`
Memperbarui profil user sendiri. Semua field pada body bersifat opsional.

**Request Body Contoh:**
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

**Response `200`:**
```json
{
  "status": 200,
  "message": "Update Success",
  "data": {
    "id": 1,
    "username": "john_new",
    "full_name": "John Doe Updated",
    "address": "Jl. Baru No. 10",
    "coordinate_lat": -6.2100,
    "coordinate_long": 106.8300
  }
}
```

---

#### `GET /nearby`
Menampilkan user lain yang berada dalam radius 500 meter dari posisi yang tersimpan di profile.

**Response `200`:**
```json
{
  "status": 200,
  "message": "Nearby users retrieved successfully",
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

`distance` dalam meter; hasil diurutkan dari yang terdekat.

---

#### `POST /help`
Meminta bantuan baru. `category` wajib bernilai `urgent` atau `normal`.

**Request Body:**
```json
{
  "title": "Butuh obat",
  "description": "Permisi, saya butuh obat demam satu strip",
  "category": "urgent"
}
```

**Response `200`:**
```json
{
  "status": 200,
  "message": "Help request created successfully",
  "help_requests": [
    {
      "id": 1,
      "user_id": 5,
      "title": "Butuh obat",
      "description": "Permisi, saya butuh obat demam satu strip",
      "category": "urgent",
      "status": "pending"
    }
  ]
}
```

---

#### `GET /help/nearby`
Menampilkan request dari user lain yang berada dalam radius 500 meter serta jarak dan waktu dibuat.

**Response `200`:**
```json
{
  "status": 200,
  "message": "Nearby help requests retrieved successfully",
  "help_requests": [
    {
      "id": 10,
      "user_id": 2,
      "username": "sarah_maulana",
      "title": "Kebutuhan sembako",
      "description": "Butuh beras 5kg",
      "category": "normal",
      "status": "pending",
      "created_at": "2026-03-20T12:45:00Z",
      "distance_m": 342.78
    }
  ]
}
```

`distance_m` dalam meter.

---

#### `GET /help`
Menampilkan semua help request (semua user).

**Response `200`:**
```json
{
  "status": 200,
  "message": "All Help requests retrieved successfully",
  "help_requests": [
    {
      "id": 1,
      "user_id": 5,
      "username": "john_doe",
      "title": "Butuh obat",
      "description": "Permisi, saya butuh obat demam satu strip",
      "category": "urgent",
      "status": "pending"
    }
  ]
}
```

---

#### `PUT /help/:id`
Memperbarui help request yang dibuat sendiri (status hanya `pending`/`resolved`, category hanya `urgent`/`normal`).

**Request Body Contoh:**
```json
{
  "title": "Butuh obat dan susu",
  "category": "normal",
  "status": "resolved"
}
```

**Response `200`:**
```json
{
  "message": "Help request updated successfully",
  "status": 200
}
```

---

#### `GET /help/:id/messages`
Mengambil history pesan untuk help request tertentu. Status harus `pending` agar bisa chat.

**Response `200`:**
```json
{
  "status": 200,
  "message": "Messages retrieved successfully",
  "message_data": [
    {
      "id": 23,
      "request_id": 1,
      "sender_id": 2,
      "reciever_id": 5,
      "content": "Apakah masih butuh bantuan?",
      "created_at": "2026-03-21T09:30:00Z"
    }
  ]
}
```

---

#### `GET /my-help`
Menampilkan semua help request yang dibuat oleh user saat ini.

**Response `200`:**
```json
{
  "status": 200,
  "message": "Help requests for user 5 retrieved successfully",
  "help_requests": [
    {
      "id": 1,
      "user_id": 5,
      "username": "john_doe",
      "title": "Butuh obat",
      "description": "Permisi, saya butuh obat demam satu strip",
      "category": "urgent",
      "status": "pending"
    }
  ]
}
```

---

#### `GET /ws/help/:id/chat`
WebSocket untuk chat satu help request (token harus disertakan sebagai query string). 

1. Ambil JWT dari `/login`.
2. Sambungkan ke `ws://localhost:8080/ws/help/{id}/chat?token=<jwt>`.
3. Server langsung mengirim payload `{"type":"history","messages":[...]}` lalu meneruskan pesan baru ke semua peserta.
4. Ketika mengirim pesan, cukup kirim body string (Hub menambahkan metadata, simpan ke database, lalu mem-broadcast JSON `{ "sender_id", "sender_username", "message", "sent_at" }` ke peserta lain).

Peserta hanya dapat masuk jika jarak ke requester kurang dari 500 meter dan request masih `pending`.

---

Error responses mengikuti format:

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

Arsitektur

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

Rate Limiting

| Environment | Limit |
|---|---|
| Development | 1000 request / menit |
| Production | 100 request / menit |
