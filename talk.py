#!/usr/bin/env python3
import sys
import subprocess
import os
import re
import json
import tempfile
import platform
from gtts import gTTS

if len(sys.argv) < 2:
    print("Usage: ./talk.py 'Your text here'")
    sys.exit(1)

text = " ".join(sys.argv[1:])

# Load pronunciation guide if available
script_dir = os.path.dirname(os.path.abspath(__file__))
guide_path = os.path.join(script_dir, "pronunciations.json")
if os.path.exists(guide_path):
    try:
        with open(guide_path, "r", encoding="utf-8") as f:
            pronunciations = json.load(f)
            for word, replacement in pronunciations.items():
                pattern = re.compile(re.escape(word), re.IGNORECASE)
                text = pattern.sub(replacement, text)
    except Exception as err:
        print(f"Warning: Failed to load pronunciations.json: {err}")

# Use a cross-platform temp path instead of hardcoded /tmp
import uuid; audio_path = os.path.join(tempfile.gettempdir(), f"talk_{uuid.uuid4().hex[:8]}.mp3")

try:
    tts = gTTS(text=text, lang='en', slow=False)
    tts.save(audio_path)

    system = platform.system()
    if system == "Windows":
        # Use PowerShell's built-in media player on Windows
        ps_cmd = f'(New-Object Media.SoundPlayer).SoundLocation = ""; Add-Type -AssemblyName presentationCore; $mp = New-Object System.Windows.Media.MediaPlayer; $mp.Open([uri]"{audio_path}"); Start-Sleep -Milliseconds 500; $mp.Play(); Start-Sleep -Seconds ([math]::Ceiling($mp.NaturalDuration.TimeSpan.TotalSeconds + 1))'
        # Simpler fallback: use the default media handler
        subprocess.run(["powershell", "-Command", ps_cmd])
        import time
        time.sleep(5)  # Give time for audio to play
    elif system == "Darwin":
        subprocess.run(["afplay", audio_path])
    else:
        # Linux: try ffplay, then mpv, then paplay
        players = [
            ["ffplay", "-nodisp", "-autoexit", "-loglevel", "quiet", audio_path],
            ["mpv", "--no-video", audio_path],
            ["cvlc", "--play-and-exit", audio_path],
        ]
        played = False
        for player_cmd in players:
            if subprocess.run(["which", player_cmd[0]], capture_output=True).returncode == 0:
                subprocess.run(player_cmd)
                played = True
                break
        if not played:
            print(f"No audio player found! Install ffmpeg, mpv, or vlc. Audio saved to: {audio_path}")
except Exception as e:
    print(f"Error: {e}")
finally:
    # Clean up on non-Windows (Windows may still be playing)
    if platform.system() != "Windows" and os.path.exists(audio_path):
        os.remove(audio_path)
