const http = require("http");
const os = require("os");
const { items, totalValue, lowStock } = require("./inventory");

const APP_ENV = process.env.APP_ENV || "development";
const RELEASE_ID = process.env.RELEASE_ID || "local";
const BUILD_NUMBER = process.env.BUILD_NUMBER || "0";

function send(res, status, body) {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(body));
}

function createServer() {
  return http.createServer((req, res) => {
    if (req.url === "/health") return send(res, 200, { status: "healthy" });
    if (req.url === "/api/items") return send(res, 200, items);
    if (req.url === "/api/summary") {
      return send(res, 200, {
        totalItems: items.length,
        totalValue: totalValue(),
        lowStock: lowStock().map((i) => i.name),
      });
    }
    if (req.url === "/") {
      return send(res, 200, {
        app: "Inventory API",
        student: "Aditya Ubale",
        prn: "202301040111",
        environment: APP_ENV,
        release: RELEASE_ID,
        build: BUILD_NUMBER,
        host: os.hostname(),
      });
    }
    return send(res, 404, { error: "not found" });
  });
}

if (require.main === module) {
  const port = process.env.PORT || 3000;
  createServer().listen(port, "0.0.0.0", () =>
    console.log(`Inventory API listening on port ${port} (${APP_ENV}, release ${RELEASE_ID})`)
  );
}

module.exports = { createServer };
