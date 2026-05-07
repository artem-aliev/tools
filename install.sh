#!/usr/bin/env sh
set -eu

# dbless installer — creates a self-contained install in ~/.local/dbless
# Independent of the source repo; repo can be deleted after install.

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
APP_DIR="${DBLESS_HOME:-$HOME/.local/dbless}"
VENV_DIR="$APP_DIR/.venv"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' is required but not found." >&2; exit 1; }
}

echo "==> Checking prerequisites..."
need_cmd python3
echo "    python3: $(python3 --version)"

# --- install app files ---
echo "==> Installing to $APP_DIR..."
mkdir -p "$APP_DIR"
cp "$PROJECT_DIR/bin/dbless" "$APP_DIR/dbless"
if [ -f "$PROJECT_DIR/requirements.txt" ]; then
    cp "$PROJECT_DIR/requirements.txt" "$APP_DIR/requirements.txt"
fi

# --- venv ---
if [ ! -d "$VENV_DIR" ]; then
    echo "==> Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

echo "==> Installing Python dependencies..."
if [ -f "$APP_DIR/requirements.txt" ]; then
    "$VENV_DIR/bin/pip" install -r "$APP_DIR/requirements.txt"
else
    "$VENV_DIR/bin/pip" install duckdb pandas
fi

# --- wrapper ---
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/dbless" <<WRAPPER
#!/usr/bin/env sh
APP_DIR="\${DBLESS_HOME:-$APP_DIR}"
exec "\$APP_DIR/.venv/bin/python3" "\$APP_DIR/dbless" "\$@"
WRAPPER
chmod +x "$BIN_DIR/dbless"
echo "    wrapper -> $BIN_DIR/dbless"

# --- PATH ---
case ":$PATH:" in
    *:"$BIN_DIR":*)
        echo "==> $BIN_DIR is already in PATH."
        ;;
    *)
        found=0
        for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
            if grep -q "\.local/bin" "$f" 2>/dev/null; then found=1; break; fi
        done
        if [ "$found" -eq 0 ]; then
            printf '\n# added by dbless install\nexport PATH="%s:$PATH"\n' "$BIN_DIR" >> "$HOME/.profile"
            echo "==> Added $BIN_DIR to PATH in ~/.profile"
            echo "    Restart your shell or run: source ~/.profile"
        fi
        ;;
esac

# --- verify ---
echo "==> Verifying..."
"$BIN_DIR/dbless" --help >/dev/null 2>&1 && echo "    dbless OK" || echo "    WARNING: dbless --help failed"

echo
echo "Done. App installed to $APP_DIR (repo-independent)."
echo "Run 'dbless' to get started."
