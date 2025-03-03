const pool = require("../config/dbConfig");

const getAllUsers = async () => {
  const query = "SELECT * FROM Users";
  try {
    const [result] = await pool.execute(query);
    return result;
  } catch (error) {
    throw error;
  }
};
const createUser = async (AccountID, FullName, Email, PhoneNumber) => {
  const query = "INSERT INTO Users (AccountID, FullName, Email, PhoneNumber) VALUES (?, ?, ?, ?)";
  try {
    const [result] = await pool.execute(query, [AccountID, FullName, Email, PhoneNumber]);
    return result;
  } catch (error) {
    throw error;
  }
}
const updateUser = async (id, AccountID, FullName, Email, PhoneNumber) => {
    const query = "UPDATE Users SET AccountID = ?, FullName = ?, Email = ?, PhoneNumber = ? WHERE UserID = ?";
    try {
        const [result] = await pool.execute(query, [AccountID, FullName, Email, PhoneNumber, id]);
        return result;
    } catch (error) {
        throw error;
    }
}
const deleteUser = async (id) => {
    const query = "DELETE FROM Users WHERE UserID = ?";
    try {
        const [result] = await pool.execute(query, [id]);
        return result;
    } catch (error) {
        throw error;
    }
}

module.exports = { getAllUsers, createUser, updateUser, deleteUser };
