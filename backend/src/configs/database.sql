CREATE DATABASE drive_ease;
USE drive_ease;

CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE Katalog (
    katalog_id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga DECIMAL(10, 2) NOT NULL CHECK (harga >= 0),
    kondisi ENUM('bagus', 'rusak kecil', 'butuh perawatan', 'rusak berat') NOT NULL,
    status ENUM('tersedia', 'tidak tersedia', 'maintenance') NOT NULL,
    nomor_polisi VARCHAR(10) NOT NULL UNIQUE CHECK (LENGTH(nomor_polisi) <= 10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    kategori_id INT,
    FOREIGN KEY (kategori_id) REFERENCES Kategori(kategori_id),
    CONSTRAINT chk_pola_nomor_polisi CHECK (nomor_polisi REGEXP '^[A-Z]{1,2}[[:space:]][0-9]{1,4}[[:space:]][A-Z]{0,3}$')
);

CREATE TABLE Kategori (
    kategori_id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);