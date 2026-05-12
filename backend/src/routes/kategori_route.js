import KategoriController from "../controllers/kategori_controller.js";
import express from 'express';

const router = express.Router();

router.get('/kategori/', KategoriController.getAllKategori);
router.get('/kategori/:id', KategoriController.getKategoriById);
router.post('/kategori/', KategoriController.createKategori);
router.put('/kategori/:id', KategoriController.updateKategori);
router.delete('/kategori/:id', KategoriController.deleteKategori);

export default router;