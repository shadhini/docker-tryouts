const express = require('express');
const config = require('./config-loader');
const promClient = require('prom-client');

// Load configuration
config.load();

const app = express();
const register = new promClient.Registry();

// Metrics
promClient.collectDefaultMetrics({ register });

const httpRequestDuration = new promClient.Histogram({
    name: 'http_request_duration_seconds',
    help: 'Duration of HTTP requests in seconds',
    labelNames: ['method', 'route', 'status'],
    registers: [register]
});

// Middleware
app.use(express.json({ limit: config.get('server.body_limit') }));

// Request timing
app.use((req, res, next) => {
    const start = Date.now();
    res.on('finish', () => {
        const duration = (Date.now() - start) / 1000;
        httpRequestDuration.labels(req.method, req.path, res.statusCode).observe(duration);
    });
    next();
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        environment: config.get('application.environment'),
        version: config.get('application.version'),
        timestamp: new Date().toISOString()
    });
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
});

// API endpoint
app.get('/api/config', (req, res) => {
    // Return sanitized config (without secrets)
    const sanitized = {
        application: config.get('application'),
        server: {
            host: config.get('server.host'),
            port: config.get('server.port'),
            timeout_ms: config.get('server.timeout_ms')
        },
        features: config.get('features'),
        logging: {
            level: config.get('logging.level'),
            format: config.get('logging.format')
        }
    };

    res.json(sanitized);
});

// Sample endpoint
app.get('/api/hello', (req, res) => {
    res.json({
        message: 'Hello from MyApp!',
        environment: config.get('application.environment'),
        features: config.get('features')
    });
});

// Error handler
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal server error',
        message: config.get('application.environment') === 'development' ? err.message : undefined
    });
});

// Start server
const port = config.get('server.port');
const host = config.get('server.host');

const server = app.listen(port, host, () => {
    console.log(`
╔════════════════════════════════════════════════════════════╗
║  🚀 MyApp Server Started                                   ║
╠════════════════════════════════════════════════════════════╣
║  Environment: ${config.get('application.environment').padEnd(44)} ║
║  Version:     ${config.get('application.version').padEnd(44)} ║
║  Host:        ${host.padEnd(44)} ║
║  Port:        ${String(port).padEnd(44)} ║
║  Log Level:   ${config.get('logging.level').padEnd(44)} ║
╠════════════════════════════════════════════════════════════╣
║  📊 Endpoints:                                             ║
║    • http://${host}:${port}/health                           ║
║    • http://${host}:${port}/metrics                          ║
║    • http://${host}:${port}/api/hello                        ║
║    • http://${host}:${port}/api/config                       ║
╚════════════════════════════════════════════════════════════╝
  `);
});

// Graceful shutdown
const shutdown = (signal) => {
    console.log(`\n${signal} received, shutting down gracefully...`);
    server.close(() => {
        console.log('Server closed');
        process.exit(0);
    });

    // Force shutdown after 10s
    setTimeout(() => {
        console.error('Forced shutdown after timeout');
        process.exit(1);
    }, 10000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
