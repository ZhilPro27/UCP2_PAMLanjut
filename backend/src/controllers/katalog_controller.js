import KatalogModel from "../models/katalog_model.js";

class KatalogController {
    static async getAllKatalog(req, res) {
        try {
            const katalog = await KatalogModel.getAllKatalog();
            console.log("KatalogController.getAllKatalog: ", katalog);
            res.json(katalog);
        } catch (error) {
            console.error("KatalogController.getAllKatalog: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async getKatalogById(req, res) {
        const { id } = req.params;
        try {
            const katalog = await KatalogModel.getKatalogById(id);
            if (!katalog) {
                return res.status(404).json({ message: 'Katalog tidak ditemukan' });
            }
            console.log("KatalogController.getKatalogById: ", katalog);
            res.json(katalog);
        } catch (error) {
            console.error("KatalogController.getKatalogById: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async createKatalog(req, res) {
        const { nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi  } = req.body; 
        if (!nama || !deskripsi || !kategori_id || !harga || !kondisi || !status || !nomor_polisi) {
            return res.status(400).json({ message: 'semua kolom wajib diisi' });
        }
        try {
            const katalogId = await KatalogModel.createKatalog(nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi);
            console.log("KatalogController.createKatalog: ", { katalogId, nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi });
            res.status(201).json({ katalog_id: katalogId });
        } catch (error) {
            console.error("KatalogController.createKatalog: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async updateKatalog(req, res) {
        const { id } = req.params;
        const { nama, deskripsi,  kategori_id, harga, kondisi, status, nomor_polisi } = req.body;
        if (!nama || !deskripsi || !kategori_id || !harga || !kondisi || !status || !nomor_polisi) {
            return res.status(400).json({ message: 'semua kolom wajib diisi' });
        }
        try {
            const success = await KatalogModel.updateKatalog(id, nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi);
            if (!success) {
                return res.status(404).json({ message: 'Katalog tidak ditemukan' });
            }
            console.log("KatalogController.updateKatalog: ", { id, nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi });
            res.json({ message: 'Katalog berhasil diperbarui' });
        } catch (error) {
            console.error("KatalogController.updateKatalog: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async deleteKatalog(req, res) {
        const { id } = req.params;
        try {
            const success = await KatalogModel.deleteKatalog(id);
            if (!success) {
                return res.status(404).json({ message: 'Katalog tidak ditemukan' });
            }
            console.log("KatalogController.deleteKatalog: ", { id });
            res.json({ message: 'Katalog berhasil dihapus' });
        } catch (error) {
            console.error("KatalogController.deleteKatalog: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async searchKatalog(req, res) {
        const { keyword } = req.query;
        try {
            const katalog = await KatalogModel.searchKatalog(keyword);
            console.log("KatalogController.searchKatalog: ", katalog);
            res.json(katalog);
        } catch (error) {
            console.error("KatalogController.searchKatalog: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
}

export default KatalogController;