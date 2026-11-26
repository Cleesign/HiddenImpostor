# Hidden Impostor for iOS

The Hidden Impostor party game as a native iPhone app, ready to install with Sideloadly.
The app shows the game in a full-screen web view. Everything (game, fonts, icons, styles) is
bundled inside the app, so it works offline. Players and the leaderboard are saved on the phone.

## Get the .ipa

Every push to `main` builds the app on GitHub's macOS machines (see **Actions**).
When the build finishes, download `HiddenImpostor.ipa` from the newest entry under **Releases**.
To rebuild without changes: Actions → Build IPA → Run workflow.

## Install with Sideloadly

1. Connect your iPhone to your computer with a cable and open Sideloadly.
2. Drag `HiddenImpostor.ipa` into Sideloadly, enter your Apple ID, and press **Start**.
3. On the iPhone, turn on **Settings → Privacy & Security → Developer Mode** (the phone restarts).
4. Trust your Apple ID under **Settings → General → VPN & Device Management**.

With a free Apple ID the app expires after 7 days; install it again with Sideloadly to renew.
Your players and leaderboard are kept when you reinstall over the existing app.

## Project layout

- `HiddenImpostor/Web/index.html`: the game (from the claude.ai artifact, pointed at local files)
- `HiddenImpostor/Web/vendor/`: precompiled Tailwind CSS, Lucide icons, and fonts
- `HiddenImpostor/GameView.swift`: the web view, plus the bridge that turns vibration calls into iPhone haptics
- `project.yml`: XcodeGen project spec (the `.xcodeproj` is generated, not committed)
- `.github/workflows/build-ipa.yml`: the cloud build

## Updating the game

Replace `HiddenImpostor/Web/index.html` with the new version, keeping the local `vendor/` links
and the `if(window.HI_NATIVE_APP) return;` line in `connectDB()`. If the new version uses Tailwind
classes the old one didn't, recompile the stylesheet:

    npx tailwindcss@3.4.17 --content HiddenImpostor/Web/index.html -o HiddenImpostor/Web/vendor/tailwind.css --minify
