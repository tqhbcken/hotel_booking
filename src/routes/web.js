const express = require('express')
const router = express.Router()

router.get('/', (req, res) => {
    //controller
    res.send('hello')
})

module.exports = router