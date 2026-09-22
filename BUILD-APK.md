# Building the Kitchen Book APK on GitHub

GitHub's machines have the Android build tools, so nothing needs installing on your
computer. You upload this folder once; GitHub builds the APK and gives you a download
link. Each rebuild takes about 5–10 minutes and is free on a public repository.

What you get is a real Android app: its own icon, its own window, no browser bar, and
it works with no signal because the whole app is inside the APK.

---

## 1. Put this folder on GitHub

If you already made the `kitchen-book` repository, open it and use **Add file → Upload
files**. Otherwise:

1. Sign in at **github.com** → **+** (top right) → **New repository**.
2. Name: `kitchen-book`. Set it **Public** (free Actions minutes and free Pages).
3. **Create repository** → on the empty page click **uploading an existing file**.

Then drag in everything from this folder:

```
index.html   manifest.webmanifest   sw.js   icon-192.png
package.json   capacitor.config.json
assets/        (contains icon.png)
.github/       (contains workflows/build-apk.yml)
```

**Dragging hidden folders:** browsers often skip `.github`. If it doesn't appear in the
upload list, create it by hand instead:

- **Add file → Create new file**
- In the name box type exactly: `.github/workflows/build-apk.yml`
  (typing the slashes creates the folders)
- Paste the contents of `.github/workflows/build-apk.yml` from this folder
- **Commit changes**

Same trick works for `assets/icon.png` if the folder is skipped — though for a binary
file you must use **Upload files** and drag the `assets` folder itself.

## 2. Build it

1. Open the **Actions** tab of your repository.
2. If it asks, click **I understand my workflows, go ahead and enable them**.
3. Pick **Build Android APK** on the left → **Run workflow** → **Run workflow**.
4. Wait for the green tick (5–10 minutes the first time).

The build also starts by itself whenever you upload a new `index.html`.

## 3. Install it on the phone

When the build finishes, open the **Releases** section on your repository's front page.
The newest release has **kitchen-book.apk** attached.

On the phone:

1. Open your repository in Chrome and tap that **kitchen-book.apk** link.
2. Chrome warns the file may be harmful — that warning appears for every APK not from
   the Play Store. Tap **Download anyway**.
3. Open it. Android asks to allow installing from Chrome: **Settings → Allow from this
   source**, then back and **Install**.
4. Kitchen Book appears in your app drawer.

Android may also show "Play Protect doesn't recognise this developer" — tap **Install
anyway**. That is expected for an app you built yourself rather than one from the store.

---

## Things worth knowing

**The APK is signed with a debug key.** That is fine for installing on your own phones.
It cannot go on the Play Store, and phones treat it as an unknown developer. Making a
Play-Store-ready build means creating a signing key and storing it as a GitHub secret —
say the word and I will add that.

**Its data is separate.** The app keeps its book in its own storage. The claude.ai
version, the browser version and the APK are three separate books. Move data between
them with **Settings → Download a backup** and **Restore from backup**. Inside the APK
the backup appears as text to copy, because an installed app has no browser download.

**Uninstalling deletes the data.** Take a backup first.

**Updating.** Upload the new `index.html`, let the build run, then install the new APK
over the old one. Your data stays as long as you install over it rather than uninstalling
first.

**Claude features** need your Anthropic API key under Settings, and a connection.
Everything else — recipes, costing, suppliers, shopping, pantry — works offline.

**Photos of bills** work through the app's file picker, which offers your camera and
gallery.

---

## If the build fails

Open the failed run in **Actions** and read the red step.

- *Something about licences or missing SDK* — rerun the job; the SDK step is allowed to
  fail and is usually not the real cause.
- *`npx cap add android` failed* — check `capacitor.config.json` uploaded correctly.
- *Gradle error* — copy the last 30 lines of the log to me and I will fix it.

The workflow also uploads the APK as a build **artifact**, which is a zip you can
download from the run page if the release step is the part that failed.
