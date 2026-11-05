const test = require("node:test");
const assert = require("node:assert");
const { items, totalValue, lowStock, addItem } = require("../src/inventory");

test("totalValue calculates stock value", () => {
  assert.strictEqual(totalValue(items), 61500);
});

test("lowStock returns items at or below threshold", () => {
  const names = lowStock(items, 5).map((i) => i.name);
  assert.deepStrictEqual(names, ["Mouse", "Monitor"]);
});

test("addItem adds a valid item", () => {
  const list = [];
  const item = addItem(list, "Cable", 10, 150);
  assert.strictEqual(item.id, 1);
  assert.strictEqual(list.length, 1);
});

test("addItem rejects invalid input", () => {
  assert.throws(() => addItem([], "", 1, 1), /invalid item/);
  assert.throws(() => addItem([], "X", -1, 1), /invalid item/);
});
