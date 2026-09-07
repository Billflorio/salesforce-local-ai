#!/usr/bin/env python3
import sys
import subprocess
import os
import re
import json
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

try:
    tts = gTTS(text=text, lang='en', slow=False)
    tts.save("/tmp/talk.mp3")
    subprocess.run(["ffplay", "-nodisp", "-autoexit", "-loglevel", "quiet", "/tmp/talk.mp3"])
except Exception as e:
    print(f"Error: {e}")
finally:
    if os.path.exists("/tmp/talk.mp3"):
        os.remove("/tmp/talk.mp3")

