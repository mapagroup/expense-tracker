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

.PHONY: help deps clean test test-cov lint format format-fix icons \
        apk apk-split aab run run-emulator security check-all

# ── Help ──────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "  Mapa Money – available make targets"
	@echo "  ─────────────────────────────────────────"
	@echo "  deps         Install / fetch all pub dependencies"
	@echo "  clean        Remove all build artefacts"
	@echo "  test         Run unit and widget tests"
	@echo "  test-cov     Run tests + check 100%% line coverage (fails if not)"
	@echo "  lint         Static analysis (flutter analyze --fatal-infos)"
	@echo "  format       Check code formatting (exits non-zero if dirty)"
	@echo "  format-fix   Auto-fix code formatting in-place"
	@echo "  icons        Re-generate launcher icons from assets/icons/app_icon.png"
  @echo "  apk          Build universal release APK (icons regenerated first)"
  @echo "  apk-split    Build per-ABI release APKs (icons regenerated first)"
  @echo "  aab          Build release AAB for Play Store (icons regenerated first)"
  @echo "  run          Build debug APK, install on default device, and launch app"
  @echo "  run-emulator Build debug APK, install on emulator, and launch app"
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

# Fast run — no coverage instrumentation.
test:
	cd $(APP_DIR) && $(FLUTTER) test

# Full coverage run + 100% gate.  Fails if any coverable line is not hit.
test-cov:
	cd $(APP_DIR) && $(FLUTTER) test --coverage
	cd $(APP_DIR) && dart tool/check_coverage.dart

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
# Icons are regenerated before every release build to keep them in sync with
# assets/icons/app_icon.png.  Skip with: make apk SKIP_ICONS=1
apk: $(if $(SKIP_ICONS),,icons)
	cd $(APP_DIR) && $(FLUTTER) build apk --release
	@echo ""
	@echo "  APK → $(APK_OUT)/app-release.apk"

# Per-ABI split APKs – significantly smaller downloads.
#   arm64-v8a  : modern 64-bit phones (most common)
#   armeabi-v7a: older 32-bit phones
#   x86_64     : emulators / Chromebooks
apk-split: $(if $(SKIP_ICONS),,icons)
	cd $(APP_DIR) && $(FLUTTER) build apk --release --split-per-abi
	@echo ""
	@echo "  APKs → $(APK_OUT)/"
	@ls -lh $(APK_OUT)/*.apk 2>/dev/null || dir /b $(APK_OUT)\\*.apk 2>NUL

# Android App Bundle for Play Store.
aab: $(if $(SKIP_ICONS),,icons)
	cd $(APP_DIR) && $(FLUTTER) build appbundle --release
	@echo ""
	@echo "  AAB → $(AAB_OUT)/app-release.aab"

# ── Run on device / emulator ──────────────────────────────────────────────────

# Build a debug APK and hot-start it on whatever device is connected.
# Use DEVICE=<id> to target a specific device: make run DEVICE=emulator-5554
run:
	cd $(APP_DIR) && $(FLUTTER) run $(if $(DEVICE),--device-id $(DEVICE),)

# Convenience alias that explicitly targets the first available emulator
# (device IDs matching emulator-*).  Fails fast if no emulator is running.
run-emulator:
	cd $(APP_DIR) && $(FLUTTER) run --device-id $(shell $(FLUTTER) devices 2>/dev/null | grep emulator | head -1 | awk '{print $$1}' || echo "emulator-5554")

# ── Security ─────────────────────────────────────────────────────────────────
# Reports outdated and vulnerable pub packages.
security:
	@echo "=== Dependency audit ==="
	cd $(APP_DIR) && $(FLUTTER) pub outdated --dependency-overrides --dev-dependencies

# ── CI composite target ───────────────────────────────────────────────────────
# Mirrors what ci.yml does: lint → format check → tests.
check-all: lint format test
	@echo ""
	@echo "  All checks passed."
