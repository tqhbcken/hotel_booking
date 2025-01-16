const express = require('express')
const app = express()
require('dotenv').config()
const path = require('path')
const router = require('./routes/web')


const host = process.env.HOST
const port = process.env.PORT

app.use(router)

app.listen(port, () =>{
    console.log(`Server listening at http://${host}:${port}`)
})