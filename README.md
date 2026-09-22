# Kitchen Book

Recipes costed from your own supplier prices — what each dish costs, who to buy
each ingredient from, and a shopping list that works out the cheapest split.

Runs in a browser, installs as an app on a phone, and builds to an Android APK
here on GitHub.

## What it does

- **Costing.** Every price is normalised to a base unit, so a 25 kg sack and a
  1.5 kg bag compare honestly. Waste, scaling, labour and overhead all fold in.
  Business figures — selling price, food-cost %, margin — are per serving.
- **Suppliers.** Every quote side by side at a real unit price, cheapest flagged,
  stale quotes marked. Pin one supplier if you always buy from them.
- **Shopping.** Pick recipes and batches; it consolidates ingredients, subtracts
  what is in your pantry, routes each item to the cheapest supplier, and writes a
  ready-to-send order per supplier in whole packs.
- **Price history.** Old quotes are kept. Ingredients and recipes show how their
  cost moved over the last month; recipes that moved more than 10% are flagged.
- **Scan a bill.** Photograph an invoice or paste its text and Claude turns each
  line into a pack size and price for you to check before saving.
- **Claude features** (write a recipe, ideas, paste a recipe, cheaper swaps, bill
  scanning) need an Anthropic API key entered in Settings. Everything else works
  offline with no key and no account.

Data lives on the device. Move it between devices with Settings → Download a
backup / Restore from backup.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app — no build step, no dependencies |
| `manifest.webmanifest`, `sw.js`, `icon-192.png` | What makes it installable and offline |
| `.github/workflows/build-apk.yml` | Builds the Android APK on GitHub's machines |
| `capacitor.config.json`, `package.json`, `assets/` | Used only by that build |

## Getting it on a phone

- **As an installable web app:** see [SETUP.md](SETUP.md)
- **As an APK:** see [BUILD-APK.md](BUILD-APK.md) — Actions tab → Build Android APK →
  Run workflow, then download the APK from Releases

## Checking the maths

Open the app with `?selftest` on the end of the address to run 74 checks covering
unit conversion, unit pricing, waste, scaling, food-cost percentages, price
history, pantry stock, whole-pack orders and supplier sourcing.
