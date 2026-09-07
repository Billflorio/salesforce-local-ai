import sys
import os
import platform
import subprocess
from pptx import Presentation

def speak_text(text):
    system = platform.system()
    if system == "Windows":
        clean_text = text.replace("'", "''").replace('"', '`"')
        ps_cmd = f"Add-Type -AssemblyName System.Speech; $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer; $synth.Rate = 1; $synth.Speak('{clean_text}')"
        subprocess.run(["powershell", "-Command", ps_cmd])
    elif system == "Linux":
        # Check for spd-say or espeak-ng / espeak
        if subprocess.run(["which", "spd-say"], capture_output=True).returncode == 0:
            subprocess.run(["spd-say", text])
        elif subprocess.run(["which", "espeak-ng"], capture_output=True).returncode == 0:
            subprocess.run(["espeak-ng", text])
        elif subprocess.run(["which", "espeak"], capture_output=True).returncode == 0:
            subprocess.run(["espeak", text])
        else:
            print("No Linux TTS engine found! Install espeak-ng or speech-dispatcher (`sudo apt install espeak-ng` or `sudo apt install speech-dispatcher`).")
    elif system == "Darwin":  # macOS
        subprocess.run(["say", text])
    else:
        print(f"Unsupported OS: {system}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python speak_slide.py <slide_number_1_indexed> [optional_deck_path]")
        return
    
    slide_num = int(sys.argv[1])
    deck_path = sys.argv[2] if len(sys.argv) > 2 else 'Final_AIOnDimesDeck.pptx'
    
    if not os.path.exists(deck_path):
        # Fallback to absolute or other known names if relative fails
        script_dir = os.path.dirname(os.path.abspath(__file__))
        alt_path = os.path.join(script_dir, deck_path)
        if os.path.exists(alt_path):
            deck_path = alt_path
        else:
            print(f"Error: Presentation file not found at '{deck_path}'")
            return

    prs = Presentation(deck_path)
    
    if slide_num < 1 or slide_num > len(prs.slides):
        print(f"Error: Slide must be between 1 and {len(prs.slides)}")
        return
        
    slide = prs.slides[slide_num - 1]
    if slide.has_notes_slide and slide.notes_slide.notes_text_frame:
        notes = slide.notes_slide.notes_text_frame.text
        print(f"\n--- SPEAKING SLIDE {slide_num} NOTES ---")
        print(notes)
        print("---------------------------------------\n")
        speak_text(notes)
    else:
        print(f"No notes found on slide {slide_num}")

if __name__ == '__main__':
    main()
