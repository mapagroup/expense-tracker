# ─────────────────────────────────────────────────────────────────────────────
# Mapa Money – Developer Makefile
#
# Usage (from repo root):
#   make <target>
#
# On Windows: install GNU Make via winget (winget install GnuWin32.Make)
#             or run targets directly in Git Bash / WSL.
# ─────────────────────────────────────────────────────────────────────────────

FLUTTER  ?= flutter
APP_DIR  := app
APK_OUT  := $(APP_DIR)/build/app/outputs/flutter-apk
AAB_OUT  := $(APP_DIR)/build/app/outputs/bundle/release

.DEFAULT_GOAL := help

.PHONY: help deps clean test lint format format-fix icons \
        apk apk-split aab security check-all

# ── Help ──────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "  Mapa Money – available make targets"
	@echo "  ─────────────────────────────────────────"
	@echo "  deps         Install / fetch all pub dependencies"
	@echo "  clean        Remove all build artefacts"
	@echo "  test         Run unit and widget tests"
	@echo "  lint         Static analysis (flutter analyze --fatal-infos)"
	@echo "  format       Check code formatting (exits non-zero if dirty)"
	@echo "  format-fix   Auto-fix code formatting in-place"
	@echo "  icons        Re-generate launcher icons from assets/icons/app_icon.png"
	@echo "  apk          Build universal release APK (all ABIs, ~30 MB)"
	@echo "  apk-split    Build per-ABI release APKs (arm64 ~15 MB, armeabi ~12 MB)"
	@echo "  aab          Build release AAB for Play Store"
	@echo "  security     Audit pub dependencies for known vulnerabilities"
	@echo "  check-all    Run lint + format + test in sequence (used in CI)"
	@echo ""

# ── Dependencies ─────────────────────────────────────────────────────────────
deps:
	cd $(APP_DIR) && $(FLUTTER) pub get

# ── Clean ─────────────────────────────────────────────────────────────────────
clean:
	cd $(APP_DIR) && $(FLUTTER) clean

# ── Tests ─────────────────────────────────────────────────────────────────────
test:
	cd $(APP_DIR) && $(FLUTTER) test --coverage

# ── Lint & Format ─────────────────────────────────────────────────────────────

# Run Flutter's static analyser. Treats infos as errors (same as CI).
lint:
	cd $(APP_DIR) && $(FLUTTER) analyze --fatal-infos

# Check formatting without modifying files (CI-safe).
format:
	cd $(APP_DIR) && dart format --set-exit-if-changed .

# Auto-fix formatting in place.
format-fix:
	cd $(APP_DIR) && dart format .

# ── Icons ─────────────────────────────────────────────────────────────────────
# Re-run whenever assets/icons/app_icon.png is replaced.
icons:
	cd $(APP_DIR) && dart run flutter_launcher_icons

# ── Builds ───────────────────────────────────────────────────────────────────

# Universal release APK (includes all ABIs – bigger but works on any device).
apk:
	cd $(APP_DIR) && $(FLUTTER) build apk --release
	@echo ""
	@echo "  APK → $(APK_OUT)/app-release.apk"

# Per-ABI split APKs – significantly smaller downloads.
#   arm64-v8a  : modern 64-bit phones (most common)
#   armeabi-v7a: older 32-bit phones
#   x86_64     : emulators / Chromebooks
apk-split:
	cd $(APP_DIR) && $(FLUTTER) build apk --release --split-per-abi
	@echo ""
	@echo "  APKs → $(APK_OUT)/"
	@ls -lh $(APK_OUT)/*.apk 2>/dev/null || dir /b $(APK_OUT)\\*.apk 2>NUL

# Android App Bundle for Play Store.
aab:
	cd $(APP_DIR) && $(FLUTTER) build appbundle --release
	@echo ""
	@echo "  AAB → $(AAB_OUT)/app-release.aab"

# ── Security ─────────────────────────────────────────────────────────────────
# Reports outdated and vulnerable pub packages.
security:
	@echo "=== Dependency audit ==="
	cd $(APP_DIR) && $(FLUTTER) pub outdated
	@echo ""
	@echo "=== Dart vulnerability check ==="
	cd $(APP_DIR) && dart pub audit

# ── CI composite target ───────────────────────────────────────────────────────
# Mirrors what ci.yml does: lint → format check → tests.
check-all: lint format test
	@echo ""
	@echo "  All checks passed."
