# Space First — class version

The structural system explorer after Heino Engel, on its own, for students: no link to the rest of the site,
and anonymous use recorded to a Google Sheet.

Published at <https://au-siradol.github.io/space-first/>.

## What is recorded

One row per event, with a random id per visit — no names, e-mails or addresses:

| event | detail |
|---|---|
| `open` | screen width, Types or Drawings |
| `space` | building type, L × W × H, requirements on |
| `relax` | a requirement given up from the suggestion under the tree |
| `type` | a type put in or taken out of Compare, and what Compare holds |
| `variant` | a variant picked (+) or stepped to (‹ ›) |
| `replace` | a column replaced when Compare held five |
| `enlarge` | a system opened large |
| `view` | 3D / Section / Plan, Types / Drawings |
| `mode` | Lite / Full |
| `suggest` | "Suggest five" with its criteria (Full) |
| `leave` | seconds on the page, what Compare held, the views |

The page says so in a line at its end.

## Set up the sheet (once)

1. Make a Google Sheet. Extensions → Apps Script, paste `apps-script/Code.gs`, save.
2. Deploy → New deployment → type **Web app**; Execute as **Me**; Who has access **Anyone**. Authorise.
3. Copy the web app URL into `log-url.txt` (one line).
4. `./sync.sh`, then commit and push.

Rows appear in the sheet's `events` tab.

## Update after changing the page

The page itself lives in the main site (`~/Github/works/space-first.html`). After changing it there:

```sh
./sync.sh && git add -A && git commit -m "Sync Space First" && git push
```

`sync.sh` stops with a message if the page no longer has what it expects to change.
