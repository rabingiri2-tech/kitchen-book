# Installing Kitchen Book on your Android phone

Four files in this folder are the whole app: `index.html`, `manifest.webmanifest`,
`sw.js`, `icon-192.png`. They need to sit at an **https://** address before Android
will install them — that is the one step only you can do, because it needs an account
in your name.

Below is the GitHub Pages route: free, permanent, and done entirely in the browser.
About ten minutes, once.

---

## 1. Make a GitHub account

Go to **github.com** and sign up. Free plan is fine.

## 2. Make a repository

1. Click **+** (top right) → **New repository**.
2. Repository name: `kitchen-book`
3. Set it to **Public**. (GitHub Pages needs public on the free plan. Only the app's
   code is visible — your recipes, prices and suppliers never leave your phone.)
4. Click **Create repository**.

## 3. Upload the four files

1. On the new empty repository page, click **uploading an existing file**.
2. Drag in all four files from this folder: `index.html`, `manifest.webmanifest`,
   `sw.js`, `icon-192.png`.
   **Drag the files themselves, not the folder** — they must sit at the top level.
3. Click **Commit changes**.

## 4. Switch on Pages

1. **Settings** tab (in the repository) → **Pages** in the left sidebar.
2. Under *Source*, choose **Deploy from a branch**.
3. Branch: **main**, folder: **/ (root)**. Click **Save**.
4. Wait a minute or two, then reload that page. It will show your address:

       https://YOUR-USERNAME.github.io/kitchen-book/

## 5. Install it on the phone

1. Open that address in **Chrome on your Android phone**.
2. Chrome shows an **Install app** prompt — tap it. If it does not appear, use
   ⋮ menu → **Install app** (or *Add to Home screen*).
3. You now have a Kitchen Book icon in your app drawer. It opens in its own window
   with no browser bar, and works with no signal.

Say yes to *Install app*, not *Create shortcut*, if Chrome offers both — only the
first gives you the real app window.

---

## Switching on the Claude features

*Write me a recipe*, *Ideas now*, *Paste a recipe* and *Cheaper swaps* need an
Anthropic API key. Everything else — recipes, costing, suppliers, shopping — works
without one.

1. Get a key at **console.anthropic.com** → API keys. It starts `sk-ant-`.
2. In the app: **Settings → Claude features → Anthropic API key**, paste, tap away.

The key is stored in that browser only and is sent to `api.anthropic.com` and nowhere
else. It is not in the uploaded files, so it is not public. Using these features spends
money on your own Anthropic account — the rest of the app costs nothing to run.
*Forget the key* in Settings removes it.

---

## Moving your book between devices

The installed app keeps everything on the device it runs on. To copy it across:

- On the old device: **Settings → Download a backup** (a `.json` file).
- On the new one: **Settings → Restore from backup**, paste the file's contents.

Rows with the same id are overwritten, so restoring twice is harmless. This is also
how you move data to or from the claude.ai version of the book.

---

## Changing the app later

Edit `index.html` here, then upload it to the repository again (same *Add file →
Upload files* flow, or edit it in place on github.com). The phone picks up the new
version next time it opens with a connection.

If a change does not seem to appear, the old version is cached: close the app fully
and reopen it, or bump `VERSION` at the top of `sw.js` when you upload.

## Checking the maths

Open the app's address with `?selftest` on the end, for example
`https://YOUR-USERNAME.github.io/kitchen-book/?selftest` — to run the 74 checks
covering unit conversion, unit pricing, waste, scaling, food-cost percentages and
supplier sourcing.
