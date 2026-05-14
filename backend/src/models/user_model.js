import database from '../configs/database.js';

class UserModel {
    static async getUserByUsername(username) {
        const [rows] = await database.execute('SELECT * FROM User WHERE username = ?', [username]);
        console.log("UserModel.getUserByUsername: ", rows);
        return rows[0];
    }

    static async getUserByEmail(email) {
        const [rows] = await database.execute('SELECT * FROM User WHERE email = ?', [email]);
        console.log("UserModel.getUserByEmail: ", rows);
        return rows[0];
    }

    static async createUser(email, username, password) {
        const [result] = await database.execute('INSERT INTO User (email, username, password) VALUES (?, ?, ?)', [email, username, password]);
        console.log("UserModel.createUser: ", result);
        return result.insertId;
    }
}

export default UserModel;