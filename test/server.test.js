const test = require("node:test");
const assert = require("node:assert");
const { createServer } = require("../src/server");

function withServer(fn) {
  return new Promise((resolve, reject) => {
    const server = createServer();
    server.listen(0, async () => {
      try {
        await fn(`http://localhost:${server.address().port}`);
        server.close(resolve);
      } catch (err) {
        server.close(() => reject(err));
      }
    });
  });
}

test("GET /health returns healthy", () =>
  withServer(async (base) => {
    const res = await fetch(`${base}/health`);
    assert.strictEqual(res.status, 200);
    assert.deepStrictEqual(await res.json(), { status: "healthy" });
  }));

test("GET /api/summary returns totals", () =>
  withServer(async (base) => {
    const body = await (await fetch(`${base}/api/summary`)).json();
    assert.strictEqual(body.totalItems, 3);
    assert.strictEqual(body.totalValue, 61500);
  }));

test("GET / identifies the student", () =>
  withServer(async (base) => {
    const body = await (await fetch(`${base}/`)).json();
    assert.strictEqual(body.prn, "202301040111");
  }));

test("unknown route returns 404", () =>
  withServer(async (base) => {
    const res = await fetch(`${base}/nope`);
    assert.strictEqual(res.status, 404);
  }));
