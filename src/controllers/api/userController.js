const modelUser = require("../../models/userModel");

class UserController {
  async getAllUsers(req, res) {
    try {
      const users = await modelUser.getAllUsers();
      res.status(200).json(users);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async createUser(req, res) {
    try {
      const { AccountID, FullName, Email, PhoneNumber } = req.body;
      await modelUser.createUser(AccountID, FullName, Email, PhoneNumber);
      res.status(201).json({ message: "User created successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async updateUser(req, res) {
    try {
      const { id } = req.params;
      const { AccountID, FullName, Email, PhoneNumber } = req.body;
      await modelUser.updateUser(id, AccountID, FullName, Email, PhoneNumber);
      res.status(200).json({ message: "User updated successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async deleteUser(req, res) {
    try {
      const { id } = req.params;
      await modelUser.deleteUser(id);
      res.status(200).json({ message: "User deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new UserController();
