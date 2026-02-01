#!/usr/bin/env python3
"""
Audacity Reverb and Pitch Change Script (macOS)
Connects to Audacity via mod-script-pipe, imports audio files, and applies effects.

Requirements:
- Audacity with mod-script-pipe enabled
  (Audacity > Preferences > Modules > mod-script-pipe = Enabled, then restart Audacity)
"""

import os
import sys
import glob
import subprocess
import time

# Supported audio extensions
AUDIO_EXTENSIONS = ("*.wav", "*.mp3", "*.flac", "*.ogg", "*.aiff", "*.m4a")

# Default effect parameters
DEFAULT_REVERB = {
    "RoomSize": 75,
    "Delay": 10,
    "Reverberance": 50,
    "HfDamping": 50,
    "ToneLow": 100,
    "ToneHigh": 100,
    "WetGain": -1,
    "DryGain": -1,
    "StereoWidth": 100,
    "WetOnly": 0,
}

DEFAULT_PITCH_SEMITONES = -3  # Negative = lower pitch, Positive = higher pitch



def find_audacity_pipes():
    """Find Audacity script pipes on macOS."""
    uid = os.getuid()

    # macOS pipe locations (/tmp is symlink to /private/tmp)
    candidates = [
        (f"/private/tmp/audacity_script_pipe.to.{uid}", f"/private/tmp/audacity_script_pipe.from.{uid}"),
        ("/private/tmp/audacity_script_pipe.to", "/private/tmp/audacity_script_pipe.from"),
        (f"/tmp/audacity_script_pipe.to.{uid}", f"/tmp/audacity_script_pipe.from.{uid}"),
        ("/tmp/audacity_script_pipe.to", "/tmp/audacity_script_pipe.from"),
    ]

    # Search both /private/tmp and /tmp for any audacity pipes
    for search_dir in ["/private/tmp", "/tmp"]:
        for f in glob.glob(f"{search_dir}/audacity_script_pipe.to*"):
            from_pipe = f.replace(".to", ".from")
            if os.path.exists(from_pipe):
                candidates.insert(0, (f, from_pipe))

    for to_pipe, from_pipe in candidates:
        if os.path.exists(to_pipe) and os.path.exists(from_pipe):
            return to_pipe, from_pipe

    return None, None


def send_command(pipe_to, pipe_from, command):
    """Send a command to Audacity and return the response."""
    pipe_to.write(command + "\n")
    pipe_to.flush()

    response = ""
    while True:
        line = pipe_from.readline()
        response += line
        if line.strip() == "":
            break
    return response.strip()


def is_audacity_running():
    """Check if Audacity is running on macOS."""
    try:
        result = subprocess.run(
            ["pgrep", "-x", "Audacity"],
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    except Exception:
        return False


def launch_audacity():
    """Launch Audacity on macOS."""
    print("Launching Audacity...")
    try:
        subprocess.Popen(
            ["open", "-a", "Audacity"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return True
    except Exception as e:
        print(f"Error launching Audacity: {e}")
        return False


def wait_for_audacity_pipes(timeout=30):
    """Wait for Audacity pipes to become available."""
    print("Waiting for Audacity to initialize scripting...")
    start_time = time.time()
    while time.time() - start_time < timeout:
        pipe_to, pipe_from = find_audacity_pipes()
        if pipe_to and pipe_from:
            return pipe_to, pipe_from
        time.sleep(1)
        print(".", end="", flush=True)
    print()
    return None, None


def find_audio_files(directory):
    """Find all audio files in the given directory."""
    files = []
    for ext in AUDIO_EXTENSIONS:
        files.extend(glob.glob(os.path.join(directory, ext)))
        files.extend(glob.glob(os.path.join(directory, ext.upper())))
    return sorted(files)


def select_files(audio_files):
    """Let user select which files to process."""
    print("\nAvailable audio files:")
    for i, f in enumerate(audio_files, 1):
        print(f"  [{i}] {os.path.basename(f)}")
    print("  [a] All files")
    print("  [q] Quit")

    while True:
        choice = input("\nSelect files (comma-separated numbers, 'a' for all, 'q' to quit): ").strip().lower()

        if choice == 'q':
            print("Exiting.")
            sys.exit(0)

        if choice == 'a':
            return audio_files

        try:
            indices = [int(x.strip()) for x in choice.split(',')]
            selected = []
            for idx in indices:
                if 1 <= idx <= len(audio_files):
                    selected.append(audio_files[idx - 1])
                else:
                    print(f"Invalid number: {idx}")
            if selected:
                return selected
            print("No valid files selected. Try again.")
        except ValueError:
            print("Invalid input. Enter numbers separated by commas, 'a', or 'q'.")


def get_effect_settings():
    """Let user adjust pitch and reverb settings or use defaults."""
    print("\n--- Effect Settings ---")
    print(f"Default pitch: {DEFAULT_PITCH_SEMITONES} semitones")
    print(f"Default reverb: Room {DEFAULT_REVERB['RoomSize']}%, Reverberance {DEFAULT_REVERB['Reverberance']}%")

    choice = input("\nUse default settings? [Y/n]: ").strip().lower()

    if choice in ('', 'y', 'yes'):
        return DEFAULT_PITCH_SEMITONES, DEFAULT_REVERB.copy()

    # Custom pitch
    while True:
        try:
            pitch_input = input(f"Enter pitch shift in semitones (default {DEFAULT_PITCH_SEMITONES}): ").strip()
            if pitch_input == '':
                pitch = DEFAULT_PITCH_SEMITONES
            else:
                pitch = float(pitch_input)
            break
        except ValueError:
            print("Invalid number. Try again.")

    # Custom reverb
    reverb = DEFAULT_REVERB.copy()
    print("\nReverb settings (press Enter to keep default):")

    while True:
        try:
            room_input = input(f"  Room size 0-100 (default {reverb['RoomSize']}): ").strip()
            if room_input != '':
                reverb['RoomSize'] = max(0, min(100, int(room_input)))
            break
        except ValueError:
            print("  Invalid number. Try again.")

    while True:
        try:
            rev_input = input(f"  Reverberance 0-100 (default {reverb['Reverberance']}): ").strip()
            if rev_input != '':
                reverb['Reverberance'] = max(0, min(100, int(rev_input)))
            break
        except ValueError:
            print("  Invalid number. Try again.")

    while True:
        try:
            wet_input = input(f"  Wet gain dB (default {reverb['WetGain']}): ").strip()
            if wet_input != '':
                reverb['WetGain'] = int(wet_input)
            break
        except ValueError:
            print("  Invalid number. Try again.")

    while True:
        try:
            dry_input = input(f"  Dry gain dB (default {reverb['DryGain']}): ").strip()
            if dry_input != '':
                reverb['DryGain'] = int(dry_input)
            break
        except ValueError:
            print("  Invalid number. Try again.")

    return pitch, reverb


def semitones_to_percent(semitones):
    """Convert semitones to percentage change for Audacity's ChangePitch effect."""
    return round((2 ** (semitones / 12) - 1) * 100, 2)


def escape_path(path):
    """Escape path for Audacity command (handle spaces and special chars)."""
    # Audacity scripting uses quotes around paths, escape internal quotes
    return path.replace('\\', '\\\\').replace('"', '\\"')


def wait_for_audacity(pipe_to, pipe_from, delay=1):
    """Wait for Audacity to finish processing."""
    time.sleep(delay)
    # Send a simple query to confirm Audacity is responsive
    response = send_command(pipe_to, pipe_from, "GetInfo: Type=Commands Format=JSON")
    return response


def process_files(selected_files, pitch_semitones, reverb_params, pipe_to, pipe_from):
    """Process the selected audio files."""
    for filepath in selected_files:
        filename = os.path.basename(filepath)
        print(f"Processing: {filename}")

        # Import the audio file (escape path for spaces)
        print("  Importing...")
        escaped_input = escape_path(filepath)
        cmd = f'Import2: Filename="{escaped_input}"'
        response = send_command(pipe_to, pipe_from, cmd)
        if "error" in response.lower():
            print(f"  Error importing: {response}")
            continue
        wait_for_audacity(pipe_to, pipe_from, delay=2)

        # Select all audio
        send_command(pipe_to, pipe_from, "SelectAll:")
        wait_for_audacity(pipe_to, pipe_from, delay=1)

        # Apply Reverb
        print(f"  Applying reverb (Room: {reverb_params['RoomSize']}%, Reverberance: {reverb_params['Reverberance']}%)...")
        reverb_str = " ".join(f'{k}="{v}"' for k, v in reverb_params.items())
        cmd = f"Reverb: {reverb_str}"
        response = send_command(pipe_to, pipe_from, cmd)
        if "error" in response.lower():
            print(f"  Reverb error: {response}")
        print("  Waiting for reverb to complete...")
        wait_for_audacity(pipe_to, pipe_from, delay=5)

        # Select all again before pitch change
        send_command(pipe_to, pipe_from, "SelectAll:")
        wait_for_audacity(pipe_to, pipe_from, delay=1)

        # Apply Pitch Change
        print(f"  Changing pitch by {pitch_semitones} semitones...")
        cmd = f'ChangePitch: Percentage="{semitones_to_percent(pitch_semitones)}"'
        response = send_command(pipe_to, pipe_from, cmd)
        if "error" in response.lower():
            print(f"  Pitch change error: {response}")
        print("  Waiting for pitch change to complete...")
        wait_for_audacity(pipe_to, pipe_from, delay=5)

        print("  Done.\n")

    print("All files processed.")


def main():
    print("=" * 50)
    print("  Audacity Reverb + Pitch Script (macOS)")
    print("=" * 50)

    # Check if Audacity is running, offer to launch if not
    if not is_audacity_running():
        print("\nAudacity is not running.")
        choice = input("Would you like to launch Audacity? [Y/n]: ").strip().lower()
        if choice in ('', 'y', 'yes'):
            if not launch_audacity():
                print("Failed to launch Audacity. Please start it manually.")
                sys.exit(1)
            # Wait for Audacity to start and create pipes
            time.sleep(3)  # Give Audacity time to start
            pipe_to, pipe_from = wait_for_audacity_pipes(timeout=30)
            if not pipe_to:
                print("\nError: Audacity pipes not found after launch.")
                print("Make sure mod-script-pipe is enabled in Audacity > Preferences > Modules")
                print("Then restart Audacity.")
                sys.exit(1)
        else:
            print("Please start Audacity with mod-script-pipe enabled, then run this script again.")
            sys.exit(1)
    else:
        pipe_to, pipe_from = find_audacity_pipes()

    # Check if pipes exist
    if pipe_to is None or pipe_from is None:
        print("\nError: Audacity pipes not found.")
        print("Make sure Audacity is running with mod-script-pipe enabled.")
        print("Enable it in: Audacity > Preferences > Modules > mod-script-pipe")
        print("Then restart Audacity.")
        sys.exit(1)

    print(f"Found pipes: {pipe_to}")

    # Main loop - allow processing multiple batches
    while True:
        # Determine search directory
        if len(sys.argv) > 1:
            search_dir = sys.argv[1]
        else:
            search_dir = os.getcwd()

        print(f"\nSearching for audio files in: {search_dir}")
        audio_files = find_audio_files(search_dir)

        if not audio_files:
            print("No audio files found.")
        else:
            print(f"Found {len(audio_files)} audio file(s).")

            # Let user select files
            selected_files = select_files(audio_files)
            print(f"\nSelected {len(selected_files)} file(s) for processing.")

            # Get effect settings
            pitch_semitones, reverb_params = get_effect_settings()

            # Open pipes
            print("\nConnecting to Audacity...")
            try:
                pipe_to_file = open(pipe_to, "w")
                pipe_from_file = open(pipe_from, "r")
            except OSError as e:
                print(f"Error opening pipes: {e}")
                sys.exit(1)

            print("Connected.\n")

            try:
                process_files(selected_files, pitch_semitones, reverb_params, pipe_to_file, pipe_from_file)
            finally:
                pipe_to_file.close()
                pipe_from_file.close()

        # Ask if user wants to continue
        print("\n" + "-" * 40)
        choice = input("Process another batch? [y/N]: ").strip().lower()
        if choice not in ('y', 'yes'):
            print("Goodbye!")
            break


if __name__ == "__main__":
    main()
