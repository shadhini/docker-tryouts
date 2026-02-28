const fs = require('fs');
const yaml = require('js-yaml');

class ConfigLoader {
    constructor(configPath = process.env.CONFIG_PATH || '/app/runtime/config.yml') {
        this.configPath = configPath;
        this.config = null;
    }

    load() {
        if (this.config) {
            return this.config;
        }

        try {
            console.log(`Loading configuration from: ${this.configPath}`);
            const fileContents = fs.readFileSync(this.configPath, 'utf8');
            this.config = yaml.load(fileContents);

            console.log('Configuration loaded successfully');
            console.log(`Environment: ${this.config.application.environment}`);
            console.log(`Log level: ${this.config.logging.level}`);

            return this.config;
        } catch (error) {
            console.error('Failed to load configuration:', error.message);
            process.exit(1);
        }
    }

    get(path) {
        if (!this.config) {
            this.load();
        }

        const parts = path.split('.');
        let value = this.config;

        for (const part of parts) {
            if (value && typeof value === 'object' && part in value) {
                value = value[part];
            } else {
                return undefined;
            }
        }

        return value;
    }

    reload() {
        this.config = null;
        return this.load();
    }
}

module.exports = new ConfigLoader();
