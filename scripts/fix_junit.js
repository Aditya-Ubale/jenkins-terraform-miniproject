// Makes the Node test-runner JUnit output compatible with Jenkins (wraps testcases in a testsuite).
const fs = require("fs");
const file = process.argv[2];
let xml = fs.readFileSync(file, "utf8");
if (!/<testsuite[ >]/.test(xml)) {
  const tests = (xml.match(/<testcase/g) || []).length;
  const failures = (xml.match(/<failure/g) || []).length;
  xml = xml
    .replace("<testsuites>", `<testsuites><testsuite name="inventory-api" tests="${tests}" failures="${failures}">`)
    .replace("</testsuites>", "</testsuite></testsuites>");
  fs.writeFileSync(file, xml);
}
console.log(`JUnit report ready: ${file}`);
