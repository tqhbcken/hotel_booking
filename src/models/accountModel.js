const pool = require("../config/dbConfig");
const {QUERY} = require("../models/query.db")

const getAllAccounts = async () => {
  const query = "SELECT * FROM Accounts";
  try {
    const [result] = await pool.execute(query);
    return result;
  } catch (error) {
    throw error;
  }
};
const createAccount = async (name, passwordHash, role) => {
  const query =
    "INSERT INTO Accounts (Username, PasswordHash, Role) VALUES (?, ?, ?)";
  try {
    await pool.execute(query, [name, passwordHash, role]);
  } catch (error) {
    throw error;
  }
};
const updateAccount = async (id, name, passwordHash, role) => {
  const query =
    "UPDATE Accounts SET name = ?, passwordHash = ?, role = ? WHERE AccountID = ?";
  try {
    await pool.execute(query, [name, passwordHash, role, id]);
  } catch (error) {
    throw error;
  }
};
const deleteAccount = async (id) => {
  const query = "DELETE FROM Accounts WHERE AccountID = ?";
  try {
    await pool.execute(query, [id]);
  } catch (error) {
    throw error;
  }
};
const checkAccount = async (name, passwordHash) => {
  const query =
    "SELECT Username,PasswordHash FROM Accounts WHERE Username = ? AND PasswordHash = ?";
  try {     
    const [result] = await pool.execute(query, [name, passwordHash]);
    return result;
  } catch (error) {
    throw error;
  }
};
const lastLogin = async (name) => {
    try {
        await pool.execute(QUERY.LASTLOGIN, [name]);
    } catch (error) {
        throw error;
    }
}

module.exports = {
  getAllAccounts,
  createAccount,
  updateAccount,
  deleteAccount,
  checkAccount,
  lastLogin
};
