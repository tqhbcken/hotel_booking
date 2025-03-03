const pool = require("../config/dbConfig");

const getAllCustomers = async () => {
    const query = "SELECT * FROM Customers";
    try {
        const [result] = await pool.execute(query);
        return result;
    } catch (error) {
        throw error;
    }
}
const createCustomer = async (customer) => {
    const query = "INSERT INTO Customers (AccountID, FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender) VALUES (?, ?, ?, ?, ?, ?, ?)";
    const { AccountID, FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender } = customer;
    try {
        const [result] = await pool.execute(query, [AccountID, FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender]);
        return result;
    } catch (error) {
        throw error;
    }
}
const updateCustomer = async (id, customer) => {
    const query = "UPDATE Customers SET FullName = ?, Email = ?, PhoneNumber = ?, DateOfBirth = ?, Nation = ?, Gender =? WHERE CustomerID = ?";
    const { FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender } = customer;
    try {
        const [result] = await pool.execute(query, [FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender, id]);
        return result;
    } catch (error) {
        throw error;
    }
}
const deleteCustomer = async (id) => {
    const query = "DELETE FROM Customers WHERE CustomerID = ?";
    try {
        const [result] = await pool.execute(query, [id]);
        return result;
    } catch (error) {
        throw error;
    }
}

module.exports = { getAllCustomers, createCustomer, updateCustomer, deleteCustomer };