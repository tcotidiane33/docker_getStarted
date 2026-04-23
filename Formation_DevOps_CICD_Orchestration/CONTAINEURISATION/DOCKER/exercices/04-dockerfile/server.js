const http = require('http');
const os = require('os');

const PORT = 3000;

const server = http.createServer((req, res) => {
    if (req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(`
      <h1>Hello from Docker! 🐳</h1>
      <p>Container: ${os.hostname()}</p>
      <p>Node.js: ${process.version}</p>
      <p>Platform: ${process.platform}</p>
    `);
    } else if (req.url === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'healthy' }));
    } else {
        res.writeHead(404);
        res.end('Not found');
    }
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
