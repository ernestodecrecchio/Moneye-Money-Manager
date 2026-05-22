const fs = require('fs');
const path = require('path');

/**
 * Script to analyze localization key usage in the project.
 * It searches for 'appLocalizations.<key>' occurrences in all .dart files within the lib folder.
 * 
 * call it using: node scripts/analyze_l10n.js
 */

const ARB_FILE = path.join(__dirname, '../lib/l10n/app_en.arb');
const LIB_DIR = path.join(__dirname, '../lib');

function getKeys(filePath) {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        const json = JSON.parse(content);
        return Object.keys(json).filter(key => !key.startsWith('@'));
    } catch (e) {
        console.error(`Error reading ARB file: ${e.message}`);
        return [];
    }
}

function getAllFiles(dirPath, arrayOfFiles) {
    const files = fs.readdirSync(dirPath);
    arrayOfFiles = arrayOfFiles || [];

    files.forEach(function (file) {
        const fullPath = path.join(dirPath, file);
        if (fs.statSync(fullPath).isDirectory()) {
            arrayOfFiles = getAllFiles(fullPath, arrayOfFiles);
        } else {
            if (file.endsWith('.dart')) {
                arrayOfFiles.push(fullPath);
            }
        }
    });

    return arrayOfFiles;
}

const keys = getKeys(ARB_FILE);
const files = getAllFiles(LIB_DIR);

if (keys.length === 0) {
    console.log('No keys found in app_en.arb.');
    process.exit(1);
}

console.log(`\n--- Localization Analysis ---`);
console.log(`Main ARB File: ${ARB_FILE}`);
console.log(`Searching in: ${LIB_DIR}`);
console.log(`Analyzing ${keys.length} keys across ${files.length} .dart files...\n`);

const usage = {};
keys.forEach(key => usage[key] = []);

// Pre-read file contents to avoid multiple reads
const fileContents = files.map(file => ({
    path: path.relative(path.join(__dirname, '..'), file),
    content: fs.readFileSync(file, 'utf8')
}));

keys.forEach(key => {
    // Regex that matches appLocalizations, l10n, or localizations followed by a dot and the key,
    // allowing for optional whitespace or newlines around the dot.
    const regex = new RegExp(`(appLocalizations|l10n|localizations)\\s*\\.\\s*${key}\\b`, 'm');
    fileContents.forEach(fileObj => {
        if (regex.test(fileObj.content)) {
            usage[key].push(fileObj.path);
        }
    });
});

const unused = keys.filter(key => usage[key].length === 0);
const used = keys.filter(key => usage[key].length > 0);

console.log(`Usage Summary:`);
console.log(`- Total Keys: ${keys.length}`);
console.log(`- Used Keys:  ${used.length}`);
console.log(`- Unused Keys: ${unused.length}\n`);

if (unused.length > 0) {
    console.log('Unused Keys (No occurrences found):');
    unused.forEach(key => console.log(` [x] Deleting ${key}`));

    // Load the ARB again to perform deletion
    const arbContent = fs.readFileSync(ARB_FILE, 'utf8');
    const arbJson = JSON.parse(arbContent);

    unused.forEach(key => {
        delete arbJson[key];
        delete arbJson[`@${key}`];
    });

    // Write back to file
    fs.writeFileSync(ARB_FILE, JSON.stringify(arbJson, null, 4) + '\n');
    console.log(`\nSuccessfully removed ${unused.length} unused keys from ${ARB_FILE}.`);
} else {
    console.log('All keys are being used!\n');
}

// --- Cross-Language Consistency Check ---
console.log('--- Cross-Language Consistency Check ---');
const l10nDir = path.dirname(ARB_FILE);
const arbFiles = fs.readdirSync(l10nDir).filter(f => f.startsWith('app_') && f.endsWith('.arb') && f !== 'app_en.arb');

const referenceKeys = getKeys(ARB_FILE);

arbFiles.forEach(file => {
    const filePath = path.join(l10nDir, file);
    const otherKeys = getKeys(filePath);
    
    // 1. Check for missing keys (present in EN but not in this file)
    const missingKeys = referenceKeys.filter(k => !otherKeys.includes(k));

    // 2. Check for extra keys (present in this file but not in EN)
    const extraKeys = otherKeys.filter(k => !referenceKeys.includes(k));

    if (missingKeys.length > 0 || extraKeys.length > 0) {
        console.log(`\nFile: ${file}`);
        
        if (missingKeys.length > 0) {
            console.log(` [!] Missing ${missingKeys.length} keys from app_en.arb`);
            // Usually we'd just report these, as adding translations requires human input or AI
            missingKeys.forEach(k => console.log(`  - Missing: ${k}`));
        }

        if (extraKeys.length > 0) {
            console.log(` [x] Extra keys found (not in app_en.arb). Deleting ${extraKeys.length} keys...`);
            const content = fs.readFileSync(filePath, 'utf8');
            const json = JSON.parse(content);

            extraKeys.forEach(k => {
                console.log(`  - Deleting: ${k}`);
                delete json[k];
                delete json[`@${k}`];
            });

            fs.writeFileSync(filePath, JSON.stringify(json, null, 4) + '\n');
            console.log(` [v] Updated ${file}`);
        }
    } else {
        console.log(`- ${file}: OK (Synchronized)`);
    }
});

console.log(`\nAnalysis complete.\n`);
