const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    const randomNumber = Math.random() * 100000
    let flagInfos = {}

    if (req.headers['x-fs-flagvalues']) {
        const flags = decodeURIComponent(req.headers['x-fs-flagvalues'])
        const flagsSplit = flags.split(';').map(flagKV => flagKV.split(':'))
        flagsSplit.forEach(([k, v]) => flagInfos[k] = v)
    }

    const html = `
        <h1>Hello World</h1>
        <h2>Dynamic data: ${randomNumber}</h2>

        <h2>Flagship flags: </h2>
        <pre>${JSON.stringify(flagInfos, null, 4)}</pre>

        <h2>Headers: </h2>
        <pre>${JSON.stringify(req.headers, null, 4)}</pre>
    `

    // Simulate workload
    setTimeout(() => {
        res.send(html)
    }, 1000)
})

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})