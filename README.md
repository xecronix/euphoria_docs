# EuphoriaDocsChm

Make a usable **CHM** (Compiled HTML Help) for the OpenEuphoria docs—complete with a working **Search** tab and sane result titles.

This repo holds:

* a minimal **`.hhp`** project (`manual.hhp`)
* the **TOC** (`manual.hhc`) and optional **Index** (`manual.hhk`)
* simple scripts/instructions to build a CHM from the OE HTML docs
* (optional) a title-fixer script so CHM search results don’t all say the same thing

> Why this exists: the stock OE HTML pages often share the same `<title>`, so CHM Search shows identical labels. We fix that and provide a repeatable way to build the help file locally.

---

## Quick start

1. **Clone this repo**

```powershell
git clone https://github.com/yourname/EuphoriaDocsChm.git
cd EuphoriaDocsChm
```

2. **Place the OE docs HTML here**

Your folder should end up like:

```
EuphoriaDocsChm/
  manual.hhp
  manual.hhc
  manual.hhk
  html/
    index.html
    ...lots-of-pages.html
    images/  (optional, if OE uses it)
    js/      (optional, if OE uses it)
```

3. **Install the HTML Help Compiler (once)**

If you don’t know what Chocolatey is: it’s a Windows package manager. We’ll use it to install Microsoft’s **HTML Help Workshop** (the compiler is `hhc.exe`).

Open **PowerShell as Administrator**, then run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex

choco install html-help-workshop -y
```

This installs **HTML Help Workshop** (and the DLLs like `hha.dll`) so you can compile CHM files.

4. **(Optional but recommended) Normalize page titles**

CHM shows the page **`<title>`** in Search results. If many pages share the same title, results look identical. Run the provided script to set each page’s `<title>` to its filename (or first `<h1>`—you choose).

```powershell
# Optional – only if you want better search result labels
pwsh -File .\tools\update_titles.ps1
```

5. **Build the CHM**

```powershell
# From the repo root:
& "$Env:ProgramFiles(x86)\HTML Help Workshop\hhc.exe" ".\manual.hhp"
# or if the path differs:
hhc.exe .\manual.hhp
```

You should see `OpenEuphoria.chm` created in the same folder.

---

## What you get

* **Tabs:** Contents, Index (if `manual.hhk` present), and Search
* **Search that’s usable:** results labeled by unique page titles
* **Zero content edits:** we don’t rewrite docs, only the `<title>` tag (optional step)

---

## Requirements

* Windows 10/11
* PowerShell (built-in)
* Admin rights (only for the package install)
* HTML Help Workshop (installed via Chocolatey as shown above)

---

## Building details

* **Project file:** `manual.hhp` (controls output name, default topic, window layout, search on, etc.)
* **Files included:** all `html\*.html` (and `html\images\*.*`, `html\js\*.*` if present)
* **Default topic:** `html/index.html` (change if needed)

If you add or remove pages, no need to edit the project as long as they’re in `html\*.html`.

---

## Optional: better Search labels

If you use `tools/update_titles.ps1`:

* It makes a one-time `.orig` backup next to each HTML file.
* By default it sets `<title>` to the filename (no extension).
  You can flip a flag inside the script to prefer the first `<h1>` instead.
* Re-run anytime after you add new pages.

---

## Troubleshooting

**“MS Help opens but shows no tabs”**

* Usually a malformed `[WINDOWS]` line in `manual.hhp` (line wraps or missing commas). Use the provided `manual.hhp` as-is to start.
* Ensure `Contents file=manual.hhc` and (if you want Index) `Index file=manual.hhk` are set, and `Full-text search=Yes` is present.

**“Search tab exists, but every result looks the same”**

* Pages share the same `<title>`. Run the title normalizer script, then rebuild.

**“Compiler runs but the CHM won’t open / freezes”**

* Try setting `Default topic` to a very simple page (not a heavy JS homepage), rebuild.
* Right-click the `.chm` → **Properties** → if there’s an **Unblock** checkbox, check it and apply.
* If MS Help is still grumpy, try a third-party viewer (e.g., uChmViewer). The CHM should still be valid.

**“hhc.exe complains about `hha.dll` or can’t be found”**

* Re-run the Chocolatey install step (Admin PowerShell). That lays down both `hhc.exe` and the required DLLs.

**“Compile succeeded but search tab is missing”**

* Make sure `Full-text search=Yes` is in `[OPTIONS]`.
* If you edited `[WINDOWS]`, keep the entire window line on **one** line.

---

## Contributing

* Keep PRs small (e.g., “enable search”, “title normalization”, “.hhk additions”).
* If you add **index keywords**, edit `manual.hhk` (or add embedded sitemap `<OBJECT type="text/sitemap">` blocks inside pages). Normal HTML `<meta>` keywords/descriptions don’t affect CHM index/search.
* Please don’t commit installer binaries. The Chocolatey bootstrap script keeps things reproducible and safe.

---

## Why CHM in 2025?

It’s old, but for **offline docs with instant FTS** and a compact single file, CHM is still handy—especially when we can make Search results readable with a tiny title pass. This repo gives OpenEuphoria users that “just works” experience.

---

## License

The project files here are MIT (or your preferred OSS license). OpenEuphoria docs remain their respective license. Microsoft HTML Help Workshop is installed separately via Chocolatey; we do **not** redistribute it here.
