#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$HOME/rat-git"

if [[ ! -d "$ROOT/.git" ]]; then
    echo "ERROR: $ROOT is not a Git repository."
    exit 1
fi

cd "$ROOT"

if [[ "$(git branch --show-current)" != "reorganize/project-structure" ]]; then
    echo "ERROR: Switch to reorganize/project-structure first."
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "ERROR: Working tree is not clean."
    echo "Commit or stash existing changes before running this script."
    git status --short
    exit 1
fi

echo "Creating a backup of repository history..."
git bundle create "$HOME/rat-before-reorganization.bundle" --all

echo "Creating project structure..."

mkdir -p \
    Scenes \
    Kerui_Inventory/{data,scripts,scenes,ui} \
    Joel_Player/{scripts,scenes,assets,prototype/scenes} \
    Joel_Enemies/{bomb,bombCat,tests} \
    yuhao_MapDesign/{scenes,scripts,assets} \
    yuhao_SettingsUI/{settings,pause,inventory,testing} \
    assets/{shared,Joel/stage,third_party/verdant_tileset} \
    shared/{scripts,resources,data} \
    archive/{conflicts,corrupted_scenes,legacy_config,legacy_ui} \
    docs \
    tools

# Safe mover: never overwrites an existing file.
move_item() {
    local src="$1"
    local dst="$2"

    [[ -e "$src" ]] || return 0

    mkdir -p "$(dirname "$dst")"

    if [[ -e "$dst" ]]; then
        local backup="$ROOT/archive/conflicts/$src"
        mkdir -p "$(dirname "$backup")"

        if [[ -e "$backup" ]]; then
            backup="${backup}.duplicate"
        fi

        echo "Preserving collision: $src -> $backup"
        mv "$src" "$backup"
    else
        echo "Moving: $src -> $dst"
        mv "$src" "$dst"
    fi
}

# Merge directory contents without overwriting.
merge_dir() {
    local src="$1"
    local dst="$2"

    [[ -d "$src" ]] || return 0

    mkdir -p "$dst"

    while IFS= read -r -d '' item; do
        move_item "$item" "$dst/$(basename "$item")"
    done < <(find "$src" -mindepth 1 -maxdepth 1 -print0)

    rmdir "$src" 2>/dev/null || true
}

echo "Organizing shared game scenes..."

merge_dir "rat and level/Scenes" "Scenes"

echo "Organizing Joel's player implementation..."

merge_dir "rat and level/Scripts" "Joel_Player/scripts"
merge_dir "rat and level/Rat Assets" "Joel_Player/assets"
merge_dir "rat-prototype/Scenes" "Joel_Player/prototype/scenes"

echo "Organizing enemies..."

merge_dir "enemies" "Joel_Enemies"
merge_dir "enemiesTestScene" "Joel_Enemies/tests"

echo "Organizing inventory..."

merge_dir "Storage" "Kerui_Inventory/data"
merge_dir "ui_forSettings/MenuANDui/inventory" "Kerui_Inventory/ui"

echo "Organizing map design..."

move_item \
    "mapDesign/character_body_2d.gd" \
    "yuhao_MapDesign/scripts/character_body_2d.gd"

move_item \
    "mapDesign/character_body_2d.gd.uid" \
    "yuhao_MapDesign/scripts/character_body_2d.gd.uid"

move_item \
    "mapDesign/character_body_2d.tscn" \
    "yuhao_MapDesign/scenes/character_body_2d.tscn"

merge_dir \
    "mapDesign/yuhaosTestingMapDONTOUCH" \
    "yuhao_MapDesign/scenes"

move_item "mapDesign/icon.svg" "assets/shared/icon.svg"
move_item "mapDesign/icon.svg.import" "assets/shared/icon.svg.import"

move_item \
    "mapDesign/testing.tscn" \
    "archive/corrupted_scenes/testing.tscn"

move_item \
    "mapDesign/tile_map.tscn" \
    "archive/corrupted_scenes/tile_map.tscn"

echo "Organizing settings and pause UI..."

merge_dir \
    "ui_forSettings/MenuANDui/Settings" \
    "yuhao_SettingsUI/settings"

merge_dir \
    "ui_forSettings/MenuANDui/Pause Game" \
    "yuhao_SettingsUI/pause"

merge_dir \
    "ui_forSettings/MenuANDui/testing" \
    "yuhao_SettingsUI/testing"

merge_dir \
    "ui_forSettings/MenuANDui/rat-main" \
    "archive/legacy_ui/rat-main"

echo "Organizing shared assets..."

merge_dir "Stage Assets" "assets/Joel/stage"

merge_dir "importers/Godot" \
    "assets/third_party/verdant_tileset/godot"

merge_dir "importers/Tiled" \
    "assets/third_party/verdant_tileset/tiled"

merge_dir "importers/RPGMakerMZ" \
    "assets/third_party/verdant_tileset/rpg_maker_mz"

merge_dir "proof" \
    "assets/third_party/verdant_tileset/proof"

merge_dir "sample_maps" \
    "assets/third_party/verdant_tileset/sample_maps"

merge_dir "sheets" \
    "assets/third_party/verdant_tileset/sheets"

merge_dir "store_assets" \
    "assets/third_party/verdant_tileset/store_assets"

merge_dir "tiles" \
    "assets/third_party/verdant_tileset/tiles"

move_item "pack.json" \
    "assets/third_party/verdant_tileset/pack.json"

move_item "tiles.json" \
    "assets/third_party/verdant_tileset/tiles.json"

echo "Preserving nested configuration files..."

move_item "rat and level/.editorconfig" ".editorconfig"
move_item "rat and level/.gitattributes" "archive/legacy_config/rat-level.gitattributes"
move_item "rat and level/.gitignore" "archive/legacy_config/rat-level.gitignore"

echo "Updating Godot resource paths..."

python3 <<'PY'
from pathlib import Path

root = Path(".").resolve()

replacements = [
    ("res://rat and level/Scenes/", "res://Scenes/"),
    ("res://rat and level/Scripts/", "res://Joel_Player/scripts/"),
    ("res://rat and level/Rat Assets/", "res://Joel_Player/assets/"),

    ("res://rat-prototype/Scenes/", "res://Joel_Player/prototype/scenes/"),
    ("res://rat-prototype/", "res://Joel_Player/prototype/"),

    ("res://Storage/", "res://Kerui_Inventory/data/"),
    ("res://rat-prototype/Storage/playerInventory.json",
     "res://Kerui_Inventory/data/playerInventory.json"),

    ("res://enemiesTestScene/", "res://Joel_Enemies/tests/"),
    ("res://enemies/", "res://Joel_Enemies/"),

    ("res://mapDesign/character_body_2d.gd",
     "res://yuhao_MapDesign/scripts/character_body_2d.gd"),
    ("res://mapDesign/character_body_2d.tscn",
     "res://yuhao_MapDesign/scenes/character_body_2d.tscn"),
    ("res://mapDesign/icon.svg", "res://assets/shared/icon.svg"),
    ("res://mapDesign/yuhaosTestingMapDONTOUCH/",
     "res://yuhao_MapDesign/scenes/"),

    ("res://ui_forSettings/MenuANDui/inventory/",
     "res://Kerui_Inventory/ui/"),
    ("res://ui_forSettings/MenuANDui/Pause Game/",
     "res://yuhao_SettingsUI/pause/"),
    ("res://ui_forSettings/MenuANDui/Settings/",
     "res://yuhao_SettingsUI/settings/"),
    ("res://ui_forSettings/MenuANDui/testing/",
     "res://yuhao_SettingsUI/testing/"),

    ("res://Stage Assets/", "res://assets/Joel/stage/"),

    ("res://importers/Godot/",
     "res://assets/third_party/verdant_tileset/godot/"),
    ("res://importers/Tiled/",
     "res://assets/third_party/verdant_tileset/tiled/"),
    ("res://importers/RPGMakerMZ/",
     "res://assets/third_party/verdant_tileset/rpg_maker_mz/"),

    ("res://proof/", "res://assets/third_party/verdant_tileset/proof/"),
    ("res://sample_maps/", "res://assets/third_party/verdant_tileset/sample_maps/"),
    ("res://sheets/", "res://assets/third_party/verdant_tileset/sheets/"),
    ("res://store_assets/", "res://assets/third_party/verdant_tileset/store_assets/"),
    ("res://tiles/", "res://assets/third_party/verdant_tileset/tiles/"),

    ("res://pickup.tscn", "res://Scenes/pickup.tscn"),
]

extensions = {".gd", ".tscn", ".tres", ".godot", ".json", ".cfg"}

for path in root.rglob("*"):
    if not path.is_file():
        continue

    if ".git" in path.parts or ".godot" in path.parts:
        continue

    if path.suffix not in extensions:
        continue

    try:
        original = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        continue

    updated = original

    for old, new in replacements:
        updated = updated.replace(old, new)

    if updated != original:
        path.write_text(updated, encoding="utf-8")
        print(f"Updated references: {path.relative_to(root)}")

PY

echo "Updating project icon path..."

python3 <<'PY'
from pathlib import Path

p = Path("project.godot")
text = p.read_text(encoding="utf-8")
text = text.replace(
    'config/icon="res://icon.svg"',
    'config/icon="res://assets/shared/icon.svg"'
)
p.write_text(text, encoding="utf-8")
PY

echo "Updating Git ignore rules..."

cat >> .gitignore <<'EOF'

# Additional generated Godot files
.godot/
.mono/
data_*/
mono_crash.*.json

# Temporary files
*.tmp
*~

# Export files
export.cfg
export_credentials.cfg
EOF

echo "Removing generated engine data..."

git rm -r --cached --ignore-unmatch .godot .mono || true

rm -rf .godot .mono

find . \
    -path './.git' -prune -o \
    -type f \( -name '*.tmp' -o -name 'mono_crash.*.json' \) \
    -delete

echo "Removing empty legacy directories..."

find \
    "rat and level" \
    "rat-prototype" \
    "enemies" \
    "enemiesTestScene" \
    "Storage" \
    "mapDesign" \
    "ui_forSettings" \
    "importers" \
    "proof" \
    "sample_maps" \
    "sheets" \
    "Stage Assets" \
    "store_assets" \
    "tiles" \
    -depth -type d -empty -delete 2>/dev/null || true

echo "Creating project structure documentation..."

cat > docs/PROJECT_STRUCTURE.md <<'EOF'
# Project Structure

## Shared game scenes
- Scenes/: Main game scenes shared by all developers.

## Developer feature directories
- Kerui_Inventory/: Inventory UI, logic, and data.
- Joel_Player/: Player implementation and prototype scenes.
- Joel_Enemies/: Enemy implementation and tests.
- yuhao_MapDesign/: Map design scenes and scripts.
- yuhao_SettingsUI/: Settings, pause menu, and UI tests.

All developers may edit all directories. These names describe organization,
not access restrictions.

## Shared resources
- assets/shared/: Shared project assets.
- assets/Joel/: Art and assets contributed by Joel.
- assets/third_party/: Third-party asset packs.
- shared/: Cross-feature scripts, resources, and data.

## Maintenance
- archive/: Preserved legacy and conflicting files.
- docs/: Project documentation.
- tools/: Development utilities.
EOF

cat > CONTRIBUTING.md <<'EOF'
# Contributing

All developers have equal access to the project.

## Git workflow

1. Update your local main branch before starting work.
2. Create a feature branch for each task.
3. Commit focused changes.
4. Push your feature branch.
5. Open a pull request into main.
6. Communicate before editing shared scenes or project.godot.

## Shared resources

Coordinate changes to:
- Scenes/
- project.godot
- shared/
- assets/shared/

Avoid having multiple developers edit the same .tscn or .tres file
simultaneously.

## Godot files

Keep .gd.uid and required .import files with their resources.
Do not commit generated .godot/ or .mono/ caches.
EOF

echo
echo "========================================"
echo "REORGANIZATION FINISHED"
echo "========================================"

echo
echo "Current branch:"
git branch --show-current

echo
echo "New directory structure:"
find . -maxdepth 3 \
    -not -path './.git*' \
    -not -path './.godot*' \
    -type d | sort

echo
echo "Git status:"
git status --short

echo
echo "Scene count:"
find . -type f -name '*.tscn' -not -path './.git/*' | wc -l

echo
echo "Scene files:"
find . -type f -name '*.tscn' -not -path './.git/*' | sort

echo
echo "Migration complete. Do not push until Godot validation succeeds."
