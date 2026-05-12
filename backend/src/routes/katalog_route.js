import KatalogController from "../controllers/katalog_controller";
import express from 'express';

const router = express.Router();

router.get('katalog/', KatalogController.getAllKatalog);
router.get('katalog/:id', KatalogController.getKatalogById);
router.post('katalog/', KatalogController.createKatalog);
router.put('katalog/:id', KatalogController.updateKatalog);
router.delete('katalog/:id', KatalogController.deleteKatalog);
router.get('katalog/search/:keyword', KatalogController.searchKatalog);

export default router;