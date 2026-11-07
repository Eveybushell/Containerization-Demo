const express = require('express');
const os = require('os');
const app = express();

const PORT = process.env.PORT || 3000;

// Landing Page
app.get('/', (req, res) => {
    res.send(`
        <h1>System Online</h1>
        <p>Serviced by container/hostname: <strong>${os.hostname()}</strong></p>
    `);
});

// Health-check Endpoint
app.get('/healthz', (req, res) => {
    // In a real application, you would also verify database connectivity here
    res.status(200).json({ 
        status: 'healthy', 
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
    });
});

// Simulate a fatal application crash
app.get('/crash', (req, res) => {
    console.error("Fatal error simulated. Crashing process...");
    process.exit(1); 
});

// Runtime Metadata Endpoint
app.get('/info', (req, res) => {
    res.status(200).json({
        hostname: os.hostname(),
        uptime_seconds: process.uptime(),
        memory_usage: process.memoryUsage(),
        cpu_cores: os.cpus().length,
        node_version: process.version
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT} - Host: ${os.hostname()}`);
});