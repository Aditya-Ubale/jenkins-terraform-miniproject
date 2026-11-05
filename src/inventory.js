const items = [
  { id: 1, name: "Keyboard", qty: 25, price: 1200 },
  { id: 2, name: "Mouse", qty: 5, price: 600 },
  { id: 3, name: "Monitor", qty: 3, price: 9500 },
];

function totalValue(list = items) {
  return list.reduce((sum, item) => sum + item.qty * item.price, 0);
}

function lowStock(list = items, threshold = 5) {
  return list.filter((item) => item.qty <= threshold);
}

function addItem(list, name, qty, price) {
  if (!name || qty < 0 || price < 0) {
    throw new Error("invalid item");
  }
  const item = { id: list.length + 1, name, qty, price };
  list.push(item);
  return item;
}

module.exports = { items, totalValue, lowStock, addItem };
