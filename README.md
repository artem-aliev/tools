# tools

A collection of CLI tools.

## Tools

| Tool   | Description |
|--------|-------------|
| dbless | Interactive Parquet/CSV/JSON viewer using DuckDB (`less`-like) |

## Install

**Linux / macOS:**

```sh
./install.sh
```

**Windows:**

```batch
install.bat
```

This installs dependencies via `pip --user` and copies the scripts to `~/.local/bin`.

## dbless

Interactive terminal viewer for tabular data files — Parquet, CSV, JSON, JSONL, and plain text.

```
Usage:
    dbless file.csv
    dbless file.parquet
    dbless output/*.csv
    dbless -n 50 file.parquet
```

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
