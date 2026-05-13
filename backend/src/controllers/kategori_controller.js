import KategoriModel from "../models/kategori_model.js";

class KategoriController {
    static async getAllKategori(req, res) {
        try {
            const kategori = await KategoriModel.getAllKategori();
            console.log("KategoriController.getAllKategori: ", kategori);
            res.json(kategori);
        } catch (error) {
            console.error("KategoriController.getAllKategori: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async getKategoriById(req, res) {
        const { id } = req.params;
        try {
            const kategori = await KategoriModel.getKategoriById(id);
            if (!kategori) {
                return res.status(404).json({ message: 'Kategori tidak ditemukan' });
            }
            console.log("KategoriController.getKategoriById: ", kategori);
            res.json(kategori);
        } catch (error) {
            console.error("KategoriController.getKategoriById: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async createKategori(req, res) {
        const { nama } = req.body;
        if (!nama) {
            return res.status(400).json({ message: 'Nama kategori wajib diisi' });
        }
        try {
            const kategoriId = await KategoriModel.createKategori(nama);
            console.log("KategoriController.createKategori: ", { kategoriId, nama });
            res.status(201).json({ kategori_id: kategoriId });
        } catch (error) {
            console.error("KategoriController.createKategori: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async updateKategori(req, res) {
        const { id } = req.params;
        const { nama } = req.body;
        if (!nama) {
            return res.status(400).json({ message: 'Nama kategori wajib diisi' });
        }
        try {
            const success = await KategoriModel.updateKategori(id, nama);
            if (!success) {
                return res.status(404).json({ message: 'Kategori tidak ditemukan' });
            }
            console.log("KategoriController.updateKategori: ", { id, nama });
            res.json({ message: 'Kategori berhasil diperbarui' });
        } catch (error) {
            console.error("KategoriController.updateKategori: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async deleteKategori(req, res) {
        const { id } = req.params;
        try {
            const success = await KategoriModel.deleteKategori(id);
            if (!success) {
                return res.status(404).json({ message: 'Kategori tidak ditemukan' });
            }
            console.log("KategoriController.deleteKategori: ", { id });
            res.json({ message: 'Kategori berhasil dihapus' });
        } catch (error) {
            console.error("KategoriController.deleteKategori: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
}

export default KategoriController;