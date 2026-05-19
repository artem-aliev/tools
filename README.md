# tools

A collection of CLI tools.

## Tools

| Tool   | Description |
|--------|-------------|
| dbless | Interactive Parquet/CSV/JSON/Markdown viewer using DuckDB (`less`-like) |

## Install

```sh
uv venv && uv pip install -r requirements.txt
./install.sh
```

`install.sh` also works standalone via `pip --user` if you don't use uv.

## dbless

Interactive terminal viewer for Parquet, CSV, JSON, JSONL, Markdown, and plain text files.

```
Usage:
    dbless file.csv
    dbless file.parquet
    dbless file.md
    dbless output/*.csv
```

**Markdown support** — `.md` files get syntax-aware rendering:

- Headings (`#`–`######`) are **bold**
- Todo checkboxes (`- [x]` / `- [ ]`) highlighted
- Pipe tables rendered with aligned columns and box-drawing frames
- Numeric columns right-aligned (detected from `---:` separator)
- Blockquotes (`>`), code fences (`` ``` ``), and horizontal rules styled dim

**Navigation:**

| Key              | Action                       |
|------------------|------------------------------|
| arrows / j k     | scroll line by line          |
| Space / PgDn     | page down                    |
| b / PgUp         | page up                      |
| g / Home         | go to top                    |
| G / End          | go to tail                   |
| Tab              | switch to next file          |

**Search:**

| Key              | Action                       |
|------------------|------------------------------|
| `/`              | search forward               |
| `n`              | next match                   |
| `N`              | previous match               |

**SQL:**

| Key              | Action                       |
|------------------|------------------------------|
| `.`              | enter SQL query              |
|                  | Tables: `t0`, `t1`, ... per file |

**Other:**

| Key              | Action                       |
|------------------|------------------------------|
| `h`              | show help                    |
| `q`              | quit                         |
| `Ctrl+L`         | redraw screen                |
