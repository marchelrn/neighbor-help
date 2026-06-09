#!/bin/bash

# Pastikan script berhenti jika ada error
set -e

echo "🚀 Memulai proses packaging NeighborHelpApp..."
BASE_DIR=$(pwd)
RELEASE_DIR="$BASE_DIR/NeighborHelpApp"

# 1. Bersihkan folder release lama jika ada
if [ -d "$RELEASE_DIR" ]; then
    echo "🧹 Membersihkan folder release lama..."
    rm -rf "$RELEASE_DIR"
fi
mkdir -p "$RELEASE_DIR/frontend"

# 2. Build Backend
echo "🔨 Melakukan build pada Backend (Go)..."
cd "$BASE_DIR/backend"
go build -o neighbor_help_backend main.go
cp neighbor_help_backend "$RELEASE_DIR/"

# 3. Build Frontend
echo "🔨 Melakukan build pada Frontend (Flutter)..."
cd "$BASE_DIR/frontend/radius"
# Menggunakan flutter build linux --release
flutter build linux --release
cp -r build/linux/x64/release/bundle/* "$RELEASE_DIR/frontend/"

# 4. Buat Script Peluncur (start.sh)
echo "📝 Membuat script peluncur (start.sh)..."
cat << 'EOF' > "$RELEASE_DIR/start.sh"
#!/bin/bash

# Pindah ke direktori tempat script ini berada
cd "$(dirname "$0")"

echo "Memulai Backend API..."
./neighbor_help_backend &
BACKEND_PID=$!

# Tunggu sejenak agar backend siap
sleep 1

echo "Memulai UI Frontend..."
./frontend/radius

# Jika frontend ditutup, matikan proses backend
echo "Mematikan Backend..."
kill $BACKEND_PID
exit 0
EOF

# Jadikan executable
chmod +x "$RELEASE_DIR/start.sh"

# 5. Kompres menjadi tar.gz
echo "📦 Mengompres hasil build menjadi NeighborHelpApp.tar.gz..."
cd "$BASE_DIR"
tar -czf NeighborHelpApp.tar.gz NeighborHelpApp/

echo "✅ Selesai! File distribusi Anda sudah siap di: $BASE_DIR/NeighborHelpApp.tar.gz"
echo "Orang lain hanya perlu mengekstrak file tersebut dan klik ganda/jalankan start.sh"
