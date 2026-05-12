import database from '../config/database.js';

class KategoriModel {
    static async getAllKategori() {
        const [rows] = await database.execute('SELECT * FROM Kategori');
        console.log("KategoriModel.getAllKategori: ", rows);
        return rows;
    }

    static async getKategoriById(kategori_id) {
        const [rows] = await database.execute('SELECT * FROM Kategori WHERE kategori_id = ?', [kategori_id]);
        console.log("KategoriModel.getKategoriById: ", rows);
        return rows[0];
    }

    static async createKategori(nama) {
        const [result] = await database.execute('INSERT INTO Kategori (nama) VALUES (?)', [nama]);
        console.log("KategoriModel.createKategori: ", result);
        return result.insertId;
    }

    static async updateKategori(kategori_id, nama) {
        const [result] = await database.execute('UPDATE Kategori SET nama = ? WHERE kategori_id = ?', [nama, kategori_id]);
        console.log("KategoriModel.updateKategori: ", result);
        return result.affectedRows > 0;
    }

    static async deleteKategori(kategori_id) {
        const [result] = await database.execute('DELETE FROM Kategori WHERE kategori_id = ?', [kategori_id]);
        console.log("KategoriModel.deleteKategori: ", result);
        return result.affectedRows > 0;
    }
}

export default KategoriModel;