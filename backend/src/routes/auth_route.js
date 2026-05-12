import AuthController from "../controllers/auth_controller.js";
import express from 'express';

const router = express.Router();

router.post('/login', AuthController.login);

export default router;