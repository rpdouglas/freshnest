const fs = require('fs');
const path = require('path');

const metaPath = path.resolve(__dirname, '../build-meta.json');

try {
  const meta = require(metaPath);
  meta.buildNumber += 1;
  fs.writeFileSync(metaPath, JSON.stringify(meta, null, 2));
  console.log(`🚀 Build number bumped to: ${meta.buildNumber}`);
} catch (error) {
  console.error('Error incrementing build number:', error);
  process.exit(1);
}
