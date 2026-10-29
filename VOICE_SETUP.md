# 🎙️ Voice / TTS Setup Guide

There are **two separate TTS systems** in this repo. Know which one you want before you start.

---

## TTS Option 1: Google TTS via `talk.py` ⭐ (The Good Voice)

**`talk.py`** uses **Google Text-to-Speech (`gtts`)** — a cloud-based, very natural-sounding voice. This is the preferred voice for presentations.

> ⚠️ Requires internet access to generate speech.

### Install on Linux Mint / Ubuntu / Debian
```bash
sudo apt-get install -y python3-pip
python3 -m pip install gtts python-pptx --break-system-packages
```

### Install on Bazzite / Fedora / Immutable OS
```bash
# DO NOT use sudo apt — it doesn't exist on Bazzite
pip install --user gtts python-pptx

# If pip isn't available, use Distrobox:
distrobox enter ubuntu
sudo apt-get install -y python3-pip && python3 -m pip install gtts python-pptx
```

### Install on Windows
```powershell
pip install gtts python-pptx
```

### Test It
```bash
python3 talk.py "Hello, this is Antigravity speaking."
```

---

## TTS Option 2: Piper via `speak_slide.py` (The Offline Backup)

**`speak_slide.py`** uses **Piper** — a local neural TTS. No internet required.
Sounds decent but not as natural as Google TTS. Good fallback when offline.

The Piper binary + model are already in `piper/piper/` — works out of the box on Linux x86_64.

### Test It (Linux)
```bash
echo "Hello from Piper." | ./piper/piper/piper --model ./piper/piper/en_US-hfc_male-medium.onnx --output_file /tmp/test.wav && paplay /tmp/test.wav
```

> ⚠️ The binary is at `piper/piper/piper` (double-nested). Always use the full path.

---

## Which One to Use?

| Situation | Use |
|-----------|-----|
| Live presentation, internet available | `talk.py` (Google TTS) ⭐ |
| No internet / offline demo | `speak_slide.py` (Piper) |
| Slide-by-slide narration from PowerPoint | `speak_slide.py` |
| Quick one-off spoken line | `talk.py` |

---

## Troubleshooting

### `ModuleNotFoundError: No module named 'gtts'`
Run the install for your OS above. On Bazzite: `pip install --user gtts` (no sudo).

### No audio plays on Linux
```bash
sudo apt-get install -y pulseaudio-utils   # for paplay (Linux Mint)
sudo apt-get install -y ffmpeg             # for ffplay (fallback)
```
On Bazzite, `paplay` is already present.
