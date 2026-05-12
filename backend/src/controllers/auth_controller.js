import jsonwebtoken from 'jsonwebtoken';
import UserModel from '../models/user_model.js';

class AuthController {
    static async login(req, res) {
        const { username, password } = req.body;

        try {
            const user = await UserModel.getUserByUsername(username);
            if (!user || user.password !== password) {
                return res.status(401).json({ message: 'username atau password tidak valid' });
            }
            const token = jsonwebtoken.sign({ userId: user.user_id }, process.env.JWT_SECRET, { expiresIn: '1h' });
            console.log("AuthController.login: ", { userId: user.user_id, token });
            res.json({ token });
        } catch (error) {
            console.error("AuthController.login: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
}

export default AuthController;