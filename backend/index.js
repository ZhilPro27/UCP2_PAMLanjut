import authRoutes from "./src/routes/auth_route.js";
import kategoriRouter from "./src/routes/kategori_route.js";
import katalogRouter from "./src/routes/katalog_route.js";
import validateToken from "./src/middleware/auth_middleware.js";
import express from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();

app.use(express.json());

app.use('/api', authRoutes);
app.use('/api', validateToken, kategoriRouter);
app.use('/api', validateToken, katalogRouter);

const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Server berjalan di port ${PORT}`);
});