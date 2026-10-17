# klacointe.github.io

My resume, published with GitHub Pages at <https://klacointe.github.io>.

The content lives in one file, [`_data/resume.json`](_data/resume.json), written in the [JSON Resume](https://jsonresume.org/schema) format. Jekyll renders it into a single page and also publishes it as-is at [`/resume.json`](https://klacointe.github.io/resume.json).

## Layout

| Path | Purpose |
|---|---|
| `_data/resume.json` | All resume content |
| `index.html` | Page template (Liquid) |
| `_includes/` | Template pieces: dates, job details, project lines |
| `assets/style.css` | Styles, including dark mode and the A4 print layout |
| `assets/fonts/` | Self-hosted Inter and Newsreader fonts |
| `resume.json` | Publishes the data at `/resume.json` |
| `resume.md` | Markdown copy of the resume, generated from the JSON |
| `scripts/resume_md.rb` | Regenerates `resume.md` |

A few fields go beyond the JSON Resume schema: `basics.coreSkills` (header chips), `work[].keywords` (stack line), `education[].location`, and `projects[].repositories` (GitHub repos for contribution rows).

## Update the resume

1. Edit `_data/resume.json`.
2. Regenerate the Markdown copy: `ruby scripts/resume_md.rb`.
3. Commit and push to `main`. GitHub Pages rebuilds the site in about a minute.

## Preview locally

```bash
bundle install
bundle exec jekyll serve --livereload
```

Then open <http://localhost:4000>. The `github-pages` gem keeps the local build in line with GitHub's.

The "Save as PDF" link opens the browser's print dialog, which uses the print stylesheet. Opening the page with `?print` does the same.
