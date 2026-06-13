const admin = require("firebase-admin");
const fs = require("fs");

const key = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(key),
});

const db = admin.firestore();

// CSVを手動パース（確実）
const csv = fs.readFileSync("TOEIC_import.csv", "utf8");

// BOM除去
const clean = csv.replace(/^\uFEFF/, "");

const lines = clean.split("\n");

// ヘッダー削除
lines.shift();

for (const line of lines) {
  if (!line.trim()) continue;

  const [no,english, japanese, level, choices,groupNo] = line.split(",");

  console.log("🚀 書き込み:", english);

  db.collection("words").doc(english.trim()).set({
    no: Number(no.trim()),
    english: english.trim(),
    answer: japanese.trim(),
    level: level.trim(),
    choices: choices.trim().split(";"),
    groupNo: Number(groupNo.trim()),
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  })
  .then(() => console.log("✅ 成功:", english))
  .catch((err) => console.error("❌ エラー:", err));
}

console.log("🎉 処理開始");