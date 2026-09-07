# 🎙️ Piper TTS Setup (Neural Text-to-Speech)

Piper is a fast, high-quality, offline neural text-to-speech engine. We use it so Antigravity can speak out loud during live presentations with a natural-sounding voice. It runs entirely on CPU and requires no internet connection.

## Quick Install (Linux x86_64)

```bash
# 1. Create the piper directory and download the binary
mkdir -p piper && cd piper
curl -sL https://github.com/rhasspy/piper/releases/download/2023.11.14-2/piper_linux_x86_64.tar.gz | tar xz
cd piper

# 2. Download a voice model (hfc_male - natural US English male voice)
curl -sLO https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx
curl -sLO https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx.json
```

## Quick Install (Windows x64)

Open PowerShell in the root of this repo:
```powershell
# 1. Create the piper directory and download the Windows release
New-Item -ItemType Directory -Force -Path piper | Out-Null
Invoke-WebRequest -Uri "https://github.com/rhasspy/piper/releases/download/2023.11.14-2/piper_windows_amd64.zip" -OutFile "piper\piper.zip"
Expand-Archive -Path "piper\piper.zip" -DestinationPath "piper" -Force
Remove-Item "piper\piper.zip"

# 2. Download a voice model (hfc_male - natural US English male voice)
Invoke-WebRequest -Uri "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx" -OutFile "piper\en_US-hfc_male-medium.onnx"
Invoke-WebRequest -Uri "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx.json" -OutFile "piper\en_US-hfc_male-medium.onnx.json"
```

## Test It

**Linux:**
```bash
echo "Hello, this is Antigravity speaking with a neural voice." | ./piper --model en_US-hfc_male-medium.onnx --output_file /tmp/test.wav && paplay /tmp/test.wav
```

**Windows (or any OS via `speak_slide.py`):**
```bash
python speak_slide.py 1
```

## Other Voices

Browse all available voices at: https://huggingface.co/rhasspy/piper-voices/tree/main

Popular alternatives:
- `en_US-lessac-medium` — Clear, professional US male
- `en_US-amy-medium` — Natural US female
- `en_GB-alan-medium` — British English male

To switch voices, just download the `.onnx` and `.onnx.json` files and point the `--model` flag at them.

## Why Piper over espeak / pico2wave?

| Engine | Quality | Speed | Offline | Install Size |
|--------|---------|-------|---------|-------------|
| espeak / spd-say | 🤖 Robotic | ⚡ Instant | ✅ | ~2MB |
| pico2wave | 🗣️ Decent | ⚡ Instant | ✅ | ~5MB |
| **Piper** | **🎙️ Neural/Natural** | **⚡ Fast** | **✅** | **~80MB** |
| edge-tts | 🎙️ Best | 🌐 Requires internet | ❌ | ~1MB |
