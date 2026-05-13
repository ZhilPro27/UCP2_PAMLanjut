import database from '../configs/database.js';

class KatalogModel {
    static async getAllKatalog() {
        const [rows] = await database.execute('SELECT * FROM Katalog');
        console.log("KatalogModel.getAllKatalog: ", rows);
        return rows;
    }

    static async getKatalogById(katalog_id) {
        const [rows] = await database.execute('SELECT * FROM Katalog WHERE katalog_id = ?', [katalog_id]);
        console.log("KatalogModel.getKatalogById: ", rows);
        return rows[0];
    }

    static async createKatalog(nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi) {
        const [result] = await database.execute('INSERT INTO Katalog (nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi) VALUES (?, ?, ?, ?, ?, ?, ?)', [nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi]);
        console.log("KatalogModel.createKatalog: ", result);
        return result.insertId;
    }

    static async updateKatalog(katalog_id, nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi) {
        const [result] = await database.execute('UPDATE Katalog SET nama = ?, deskripsi = ?, kategori_id = ?, harga = ?, kondisi = ?, status = ?, nomor_polisi = ? WHERE katalog_id = ?', [nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi, katalog_id]);
        console.log("KatalogModel.updateKatalog: ", result);
        return result.affectedRows > 0;
    }

    static async deleteKatalog(katalog_id) {
        const [result] = await database.execute('DELETE FROM Katalog WHERE katalog_id = ?', [katalog_id]);
        console.log("KatalogModel.deleteKatalog: ", result);
        return result.affectedRows > 0;
    }

    static async searchKatalog(keyword) {
        const [rows] = await database.execute('SELECT * FROM Katalog WHERE nama LIKE ? OR nomor_polisi LIKE ?', [`%${keyword}%`, `%${keyword}%`]);
        console.log("KatalogModel.searchKatalog: ", rows);
        return rows;
    }

    static async getKatalogByNomorPolisi(nomor_polisi) {
        const [rows] = await database.execute('SELECT * FROM Katalog WHERE nomor_polisi = ?', [nomor_polisi]);
        console.log("KatalogModel.getKatalogByNomorPolisi: ", rows);
        return rows[0];
    }
}

export default KatalogModel;