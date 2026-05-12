import jwt from 'jsonwebtoken';

const validateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Akses ditolak. Tidak ada token yang disediakan' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.userId = decoded.userId;
        console.log("authMiddleware: ", { userId: req.userId });
        next();
    } catch (error) {
        console.error("authMiddleware: ", error);
        res.status(401).json({ message: 'Token tidak valid' });
    }
};

export default validateToken;