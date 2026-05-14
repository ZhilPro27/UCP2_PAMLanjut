import jsonwebtoken from 'jsonwebtoken';
import UserModel from '../models/user_model.js';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';

dotenv.config();

class AuthController {
    static async login(req, res) {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: 'email dan password wajib diisi' });
        }

        try {
            const user = await UserModel.getUserByEmail(email);
            if (!user) {
                return res.status(400).json({ message: 'email atau password salah' });
            }
            const passwordMatch = bcrypt.compareSync(password, user.password);
            if (!passwordMatch) {
                return res.status(400).json({ message: 'Username atau password salah' });
            }
            const token = jsonwebtoken.sign({ userId: user.user_id }, process.env.JWT_SECRET, { expiresIn: '1h' });
            console.log("AuthController.login: ", { userId: user.user_id, token });
            res.json({ token });
        } catch (error) {
            console.error("AuthController.login: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }

    static async register(req, res) {
        const { email, username, password } = req.body;
        try {
            const existingUser = await UserModel.getUserByUsername(username);
            if (existingUser) {
                return res.status(400).json({ message: 'Username sudah digunakan' });
            }
            const existingEmail = await UserModel.getUserByEmail(email);
            if (existingEmail) {
                return res.status(400).json({ message: 'Email sudah digunakan' });
            }
            const hashedPassword = bcrypt.hashSync(password, 10);
            const userId = await UserModel.createUser(email, username, hashedPassword);
            console.log("AuthController.register: ", { email, userId, username });
            res.status(201).json({ user_id: userId });
        } catch (error) {
            console.error("AuthController.register: ", error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
}

export default AuthController;