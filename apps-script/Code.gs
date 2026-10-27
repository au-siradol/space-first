// Space First — class version: receives anonymous use from the page and writes one row per event.
// Paste into the Apps Script of a Google Sheet (Extensions → Apps Script), then Deploy → New deployment →
// Web app, "Execute as: Me", "Who has access: Anyone". Put the web app URL in log-url.txt and run ./sync.sh.
const SHEET = 'events';
// The sheet that receives the rows. A web app has no "active" spreadsheet unless the script is bound to it, so open it by id.
const SHEET_ID = '1R2u7gsIiQsxABfI1zD6W0YN7Pf3tq0RHFAXh9klfJXs';

function doPost(e) {
  const sheet = sheetOf_();
  let d = {};
  try { d = JSON.parse(e.postData.contents); } catch (err) { return ok_(); }
  // only the fields the page sends, each cut to a sane length
  const cut = (v, n) => String(v == null ? '' : v).slice(0, n);
  sheet.appendRow([new Date(), cut(d.t, 40), cut(d.session, 20), cut(d.event, 20), cut(d.mode, 8), cut(d.detail, 500)]);
  return ok_();
}

function doGet() { return ok_(); }

function sheetOf_() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sh = ss.getSheetByName(SHEET);
  if (!sh) {
    sh = ss.insertSheet(SHEET);
    sh.appendRow(['received', 'client time', 'session', 'event', 'mode', 'detail']);
    sh.setFrozenRows(1);
  }
  return sh;
}

function ok_() { return ContentService.createTextOutput('ok'); }
