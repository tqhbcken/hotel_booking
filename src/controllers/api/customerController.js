const customerModel = require("../../models/customerModel");

class CustomerController {
  async getAllCustomers(req, res) {
    try {
      const customers = await customerModel.getAllCustomers();
      res.status(200).json(customers);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async createCustomer(req, res) {
    try {
      const {
        AccountID,
        FullName,
        Email,
        PhoneNumber,
        DateOfBirth,
        Nation,
        Gender,
      } = req.body;
      //check if required fields are missing
      if (
        !AccountID ||
        !FullName ||
        !Email ||
        !PhoneNumber ||
        !DateOfBirth ||
        !Nation ||
        !Gender
      ) {
        return res.status(400).json({ message: "Missing required fields" });
      }
      //check email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(Email)) {
        return res.status(400).json({ message: "Invalid email format" });
      }
      const customer = req.body;
      await customerModel.createCustomer(customer);
      res.status(201).json({ message: "Customer created successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async updateCustomer(req, res) {
    try {
      const id = req.params.id;
      const customer = req.body;
      await customerModel.updateCustomer(id, customer);
      res.status(200).json({ message: "Customer updated successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
  async deleteCustomer(req, res) {
    try {
      const id = req.params.id;
      await customerModel.deleteCustomer(id);
      res.status(200).json({ message: "Customer deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new CustomerController();
