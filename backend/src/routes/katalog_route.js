import KatalogController from "../controllers/katalog_controller.js";
import express from 'express';

const router = express.Router();

router.get('/katalog/search', KatalogController.searchKatalog);
router.get('/katalog/', KatalogController.getAllKatalog);
router.get('/katalog/:id', KatalogController.getKatalogById);
router.post('/katalog/', KatalogController.createKatalog);
router.put('/katalog/:id', KatalogController.updateKatalog);
router.delete('/katalog/:id', KatalogController.deleteKatalog);

export default router;