# Kint John Libot — portfolio

A static website: plain HTML, one CSS file, one small JavaScript file. No build step, no frameworks, no paid services. Hosted free on GitHub Pages.

```
index.html                     Home page (hero, selected work, experience, capabilities, about, contact)
work/*.html                    One page per case study
404.html                       "Page not found"
assets/css/site.css            All styles. Colours, fonts and spacing are tokens at the top.
assets/js/site.js              Mobile menu, header divider, active nav link. Site works without it.
assets/img/                    Web-ready images (JPEG, two widths each: name-640.jpg / name-1280.jpg, etc.)
assets/files/                  Résumé PDF
tools/resize.ps1               Turns a source image into web-ready JPEGs
tools/make-graphics.ps1        Rebuilds favicons and the social preview image
tools/serve.ps1                Local preview server
```

## Preview on your computer

Open PowerShell in this folder and run:

```
powershell -ExecutionPolicy Bypass -File tools\serve.ps1
```

Then open http://localhost:8080/ in your browser. Press Ctrl+C to stop.

## Common updates

All text lives directly in the HTML files. Open them in any text editor (VS Code works well), change the words between the tags, save, then publish (see below).

**Replace the résumé.** Save the new PDF as `assets/files/Kint-John-Libot-Resume.pdf` (same name), replacing the old one. If the size changes a lot, update "PDF, 100 KB" in `index.html`.

**Change email or location.** Search all files for `kintlibot@gmail.com` or `Cagayan de Oro` and replace every match.

**Add LinkedIn.** In `index.html`, inside `<div class="contact-actions">`, add:
`<a class="btn" href="https://www.linkedin.com/in/YOUR-PROFILE/">LinkedIn</a>`
Also add the URL to the `"sameAs": ["..."]` field in the structured data near the top of `index.html`.

**Add or edit an experience entry.** In `index.html`, find `<ol class="timeline">`. Copy one `<li class="job">…</li>` block, paste it in date order, and edit the years, title, company and bullet points. The current job uses `class="job job--current"`.

**Add an image.** Put the original anywhere on your computer, then run, for example:

```
powershell -ExecutionPolicy Bypass -File tools\resize.ps1 -Src "C:\path\to\original.png" -Name "new-project-cover" -Widths 640,1280
```

This writes `assets/img/new-project-cover-640.jpg` and `-1280.jpg`. Use them like the existing images: always fill in `alt` (what the image shows), `width` and `height` (the pixel size printed by the script), and `loading="lazy"` unless it is the first image on the page.

**Add a case study.**
1. Copy `work/lesson-visuals.html` to `work/your-project.html`.
2. Change the `<title>`, `description`, `canonical` and `og:` lines at the top.
3. Rewrite the title, intro, the "My part / With" note, and the sections. Keep to what you actually did.
4. In `index.html`, copy one `<article class="project">…</article>` block under "Selected work" and point its links to the new page. Use `project project--flip` to put the image on the left.
5. Update the "Next project" links at the bottom of the case studies so they still form a loop.
6. Add the page to `sitemap.xml`.

**Change colours or fonts.** Edit the variables at the top of `assets/css/site.css` (see the colour table below).

**After changing the CSS or JS file**, raise the version number in every HTML file (search for `site.css?v=` and `site.js?v=`, e.g. `?v=2` → `?v=3`). Browsers cache these files for about 10 minutes, and the new number makes visitors get the update right away.

## Publish changes (GitHub Pages)

The live site is built from the `main` branch of the GitHub repository. Any change pushed there goes live within a minute or two.

Easiest way, in the browser: open the repository on github.com → navigate to the file → click the pencil icon to edit text, or **Add file → Upload files** to replace an image or the résumé → **Commit changes**.

From this folder with Git:

```
git add -A
git commit -m "Describe the change"
git push
```

## Design tokens

| Role | Value |
| --- | --- |
| Main background | `#F3F4F0` |
| Surface (image wells, panels) | `#E7E9E3` |
| Primary text | `#141613` |
| Secondary text | `#4A4F49` (7.6:1 on background) |
| Borders and dividers | `#CFD3CA` |
| Accent (links, buttons, notes) | `#2B3AD6` (7.1:1 on background) |
| Accent hover / pressed | `#1C279F` |
| Selection / highlight | `#DFE3FF` |
| Contact section background | `#141613` |
| Contact section text / secondary / accent | `#F3F4F0` / `#B9BEB5` / `#AAB4FF` |

Typeface: Schibsted Grotesk (Google Fonts, SIL Open Font License), one variable font file with weights 400–900 and italics. Fallback: Helvetica Neue, Arial.

Motion: hero work strip rises in once (420 ms, staggered); buttons and links respond in 180 ms; page-to-page cross-fade where the browser supports view transitions. Everything is switched off when the visitor's system asks for reduced motion.
