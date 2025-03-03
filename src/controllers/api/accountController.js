const accountModel = require("../../models/accountModel");

class AccountController {
  //list all accounts
  async getAllAccounts(req, res) {
    try {
      const accounts = await accountModel.getAllAccounts();
      res.status(200).json(accounts);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  //create account
  async createAccount(req, res) {
    try {
      // console.log(">>>> req.body: ", req.body);
      let name = req.body.Username;
      let passwordHash = req.body.PasswordHash;
      let role = req.body.Role;
      // console.log(name, passwordHash, role);
      await accountModel.createAccount(name, passwordHash, role);
      res.status(201).json({ message: "Account created successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  //update account
  async updateAccount(req, res) {
    try {
      const { id } = req.params;
      const { name, passwordHash, role } = req.body;
      await accountModel.updateAccount(id, name, passwordHash, role);
      res.status(200).json({ message: "Account updated successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  //delete account
  async deleteAccount(req, res) {
    try {
      const { id } = req.params;
      await accountModel.deleteAccount(id);
      res.status(200).json({ message: "Account deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  //login
  async login(req, res) {
    try {
      const { Username, PasswordHash } = req.body;
      // console.log(">>>> req.body: ", req.body);
      const result = await accountModel.checkAccount(Username, PasswordHash);
      if (result.length > 0) {
        await accountModel.lastLogin(Username);
        res.status(200).json({ message: "Login successful" });
      } else {
        res.status(401).json({ message: "Login failed" });
      }
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}
module.exports = new AccountController();
