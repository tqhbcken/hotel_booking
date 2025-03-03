
const express = require("express");
const router = express.Router();
const accountController = require("../../controllers/api/accountController")

router.get("/", accountController.getAllAccounts);
router.post("/", accountController.createAccount);
router.put("/:id", accountController.updateAccount);
router.delete("/:id", accountController.deleteAccount);

router.post("/login", accountController.login);


module.exports = router;