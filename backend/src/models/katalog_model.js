import database from '../config/database.js';

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

    static async createKatalog(nama, kategori_id) {
        const [result] = await database.execute('INSERT INTO Katalog (nama, kategori_id) VALUES (?, ?)', [nama, kategori_id]);
        console.log("KatalogModel.createKatalog: ", result);
        return result.insertId;
    }

    static async updateKatalog(katalog_id, nama, kategori_id) {
        const [result] = await database.execute('UPDATE Katalog SET nama = ?, kategori_id = ? WHERE katalog_id = ?', [nama, kategori_id, katalog_id]);
        console.log("KatalogModel.updateKatalog: ", result);
        return result.affectedRows > 0;
    }

    static async deleteKatalog(katalog_id) {
        const [result] = await database.execute('DELETE FROM Katalog WHERE katalog_id = ?', [katalog_id]);
        console.log("KatalogModel.deleteKatalog: ", result);
        return result.affectedRows > 0;
    }

    static async searchKatalog(keyword) {
        const [rows] = await database.execute('SELECT * FROM Katalog WHERE nama LIKE ?', [`%${keyword}%`]);
        console.log("KatalogModel.searchKatalog: ", rows);
        return rows;
    }
}

export default KatalogModel;