# Backend DriveEase

| | |
|---|---|
| **Nama** | `Zhilal Fadiah Krisna` |
| **NIM** | `20230140095` |  

## Tujuan
Backend ini dibuat untuk kebutuhan UCP 2 mata kuliah PAM Lanjut.  

## Dokumentasi Endpoint
Total ada 13 endpoint yang ada pada backend ini. Seluruh endpoint ini dapat dibagi menjadi 3 bagian. `Auth`, `Katalog`, dan `Kategori`. Seluruh endpoint dapat diakses dengan base url `localhost:3000/api`.  

---
### 1. Auth
Ada dua endpoint yang terdapat pada bagian ini.  
#### 1.1 POST /register
Endpoint ini digunakan untuk melakukan register sebagai user dari aplikasi.  

Contoh data yang dikirimkan:
```
{
    "email":"zhilal@mail.com",
    "username":"Zhilal Krisna",
    "password":"123"
}
```

Contoh response yang diberikan jika sukses  
```
{
    "user_id": 2
}
```

Contoh response yang diberikan jika username sudah digunakan:
```
{
    "message": "Username sudah digunakan"
}
```

Contoh response yang diberikan jika email sudah digunakan:
```
{
    "message": "Email sudah digunakan"
}
```

#### 1.2 POST /login
Endpoint ini digunakan untuk melakukan login sebagai user dari aplikasi.

Contoh data yang dikirimkan:
```
{
    "email":"zhilal@mail.com",
    "password":"123"
}
```

Contoh response yang diberikan jika sukses:
```
{
    "user_id": 1,
    "email": "zhilal@mail.com",
    "username": "Zhilal Krisna",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3ODc3NDAyOSwiZXhwIjoxNzc4Nzc3NjI5fQ.xesqLPGlmNl-peoSre9jZ3RZO0M_T2sHoWHAD-BHcN4"
}
```

Contoh response yang diberikan jika password atau username salah:
```
{
    "message": "Username atau password salah"
}
```
---
### 2. Kategori
Ada 5 endpoint yang terdapat pada bagian ini. Endpoint-endpoint yang ada pada bagian ini digunakan untuk CRUD tabel `Kategori` pada database.
#### 2.1 GET /kategori
Endpoint ini digunakan untuk mengambil seluruh baris data dari tabel `Kategori`  

Contoh response yang diberikan:
```
[
    {
        "kategori_id": 1,
        "nama": "Standart upgrade",
        "created_at": "2026-05-12T06:14:18.000Z",
        "updated_at": "2026-05-12T06:21:30.000Z"
    },
    {
        "kategori_id": 2,
        "nama": "Standart normal",
        "created_at": "2026-05-12T06:21:46.000Z",
        "updated_at": "2026-05-12T06:21:46.000Z"
    },
    {
        "kategori_id": 4,
        "nama": "Luxury",
        "created_at": "2026-05-13T13:49:09.000Z",
        "updated_at": "2026-05-13T13:49:09.000Z"
    }
]
```

#### 2.2 GET /kategori/:id
Endpoint ini digunakan untuk mengambil baris data dari tabel `kategori` dengan id tertentu  

Contoh response yang diberikan:
```
{
    "kategori_id": 4,
    "nama": "Luxury",
    "created_at": "2026-05-13T13:49:09.000Z",
    "updated_at": "2026-05-13T13:49:09.000Z"
}
```

Contoh response yang diberikan jika data tidak ditemukan:
```
{
    "message": "Kategori tidak ditemukan"
}
```

#### 2.3 POST /kategori
Endpoint ini digunakan untuk membuat baris data baru pada tabel `kategori`.

Contoh data yang dikirimkan:
```
{
    "nama":"Luxury"
}
```

Contoh response yang dikirimkan:
```
{
    "nama":"Luxury"
}
```

Contoh response yang dikirimkan jika nama kategori sudah ada:
```
{
    "message": "Nama kategori sudah ada"
}
```

Contoh response yang dikirimkan jika nama kategori kosong:
```
{
    "message": "Nama kategori wajib diisi"
}
```

#### 2.5 PUT /kategori/:id
Endpoint ini digunakan untuk mengupdate baris data pada tabel `kategori` berdasarkan id.

Contoh data yang dikirimkan:
```
{
    "nama":"Standart upgrade"
}
```

Contoh response yang dikirimkan jika berhasil:
```
{
    "message": "Kategori berhasil diperbarui"
}
```

Contoh response yang dikirimkan jika nama sama dengan yang sudah ada:
```
{
    "message": "Nama kategori sudah ada"
}
```

Contoh response yang dikirimkan jika kategori tidak ditemukan:
```
{
    "message": "Kategori tidak ditemukan"
}
```

#### 2.5 DELETE /kategori/:id
Endpoint ini digunakan untuk menghapus baris data pada tabel `Kategori` berdasarkan id.

Contoh response yang dikirimkan jika berhasil:
```
{
    "message": "Kategori berhasil dihapus"
}
```

Contoh response yang dikirimkan jika kategori tidak ditemukan:
```
{
    "message": "Kategori tidak ditemukan"
}
```
---
### 3. Katalog
Ada 6 endpoint yang terdapat pada bagian ini. Endpoint-endpoint yang ada pada bagian ini digunakan untuk CRUDS tabel `Katalog` pada database.

#### 3.1 GET /katalog
Endpoint ini digunakan untuk mengambil seluruh baris data pada tabel `Katalog`.

Contoh response yang dikirimkan:
```
[
    {
        "katalog_id": 4,
        "nama": "Avanza Update",
        "deskripsi": "Testing deskripsi avanza",
        "created_at": "2026-05-13T13:51:27.000Z",
        "updated_at": "2026-05-13T15:28:42.000Z",
        "kategori_id": 2,
        "harga": "200000.00",
        "kondisi": "bagus",
        "status": "tersedia",
        "nomor_polisi": "BA 123 CZ"
    },
    {
        "katalog_id": 6,
        "nama": "Avanza",
        "deskripsi": "Testing deskripsi avanza",
        "created_at": "2026-05-13T15:17:38.000Z",
        "updated_at": "2026-05-13T15:17:38.000Z",
        "kategori_id": 2,
        "harga": "200000.00",
        "kondisi": "bagus",
        "status": "tersedia",
        "nomor_polisi": "BD 123 CZ"
    }
]
```

#### 3.2 GET /katalog/:id
Endpoint ini digunakan untuk mengambil baris data pada tabel `Katalog` berdasarkan id.

Contoh response yang dikirimkan:
```
{
    "katalog_id": 4,
    "nama": "Avanza Update",
    "deskripsi": "Testing deskripsi avanza",
    "created_at": "2026-05-13T13:51:27.000Z",
    "updated_at": "2026-05-13T13:54:27.000Z",
    "kategori_id": 2,
    "harga": "200000.00",
    "kondisi": "bagus",
    "status": "tersedia",
    "nomor_polisi": "B 123 CZ"
}
```

Contoh response yang dikirimkan jika data tidak ditemukan:
```
{
    "message": "Katalog tidak ditemukan"
}
```

#### 3.3 POST /katalog
Endpoint ini digunakan untuk membuat baris data baru pada tabel `Katalog`.

Contoh data yang dikirimkan:
```
{
    "nama":"Avanza",
    "deskripsi":"Testing deskripsi avanza",
    "kategori_id":"2",
    "harga":"200000",
    "kondisi":"bagus",
    "status":"tersedia",
    "nomor_polisi":"BD 123 CZ"
}
```

Contoh response yang dikirimkan jika sukses:
```
{
    "katalog_id": 6
}
```

Contoh response yang dikirimkan jika field ada yang kosong:
```
{
    "message": "semua kolom wajib diisi"
}
```

Contoh response yang dikirimkan jika nomor polisi sudah ada:
```
{
    "message": "Nomor polisi sudah ada"
}
```

#### 3.4 PUT /katalog/:id
Endpoint ini digunakan untuk update baris data pada tabel `Katalog` berdasarkan id.

Contoh data yang dikirimkan: 
```
{
    "nama":"Avanza Update",
    "deskripsi":"Testing deskripsi avanza",
    "kategori_id":"2",
    "harga":"200000",
    "kondisi":"bagus",
    "status":"tersedia",
    "nomor_polisi":"BA 123 CZ"
}
```

Contoh response yang dikirimkan jika sukses:
```
{
    "message": "Katalog berhasil diperbarui"
}
```

Contoh response yang dikirimkan jika field ada yang kosong:
```
{
    "message": "semua kolom wajib diisi"
}
```

Contoh response yang diberikan jika nomor polisi sudah ada:
```
{
    "message": "Nomor polisi sudah ada"
}
```

Contoh response yang diberikan jika id tidak ditemukan:
```
{
    "message": "Katalog tidak ditemukan"
}
```

#### 3.5 DELETE /katalog/:id
Endpoint ini digunakan untuk menghapus baris data pada tabel `Katalog` berdasarkan id.

Contoh response yang dikirimkan jika sukses:
```
{
    "message": "Katalog berhasil dihapus"
}
```

Contoh response yang dikirimkan jika id tidak ditemukan:
```
{
    "message": "Katalog tidak ditemukan"
}
```

#### 3.6 GET /katalog/search
Endpoint ini digunakan untuk mencari data pada tabel `Katalog` berdasarkan nama atau nomor polisi.

contoh penggunaan:
```
localhost:3000/api/katalog/search/?keyword=avanza
```
```
localhost:3000/api/katalog/search/?keyword=BD
```

Contoh response yang diberikan jika data ditemukan:
```
[
    {
        "katalog_id": 6,
        "nama": "Avanza",
        "deskripsi": "Testing deskripsi avanza",
        "created_at": "2026-05-13T15:17:38.000Z",
        "updated_at": "2026-05-13T15:17:38.000Z",
        "kategori_id": 2,
        "harga": "200000.00",
        "kondisi": "bagus",
        "status": "tersedia",
        "nomor_polisi": "BD 123 CZ"
    }
]
```
Contoh response jika data tidak ada:
```
{
    "message": "Katalog tidak ditemukan"
}
```

---
### Catatan Penting
Setiap endpoint harus menyertakan token yang diberikan oleh response login. Setiap token hanya memiliki masa berlaku selama **1 jam**.

Contoh response jika token tidak disediakan:
```
{
    "message": "Akses ditolak. Tidak ada token yang disediakan"
}
```

Contoh response jika token sudah expired:
```
{
    "message": "Token tidak valid"
}
```