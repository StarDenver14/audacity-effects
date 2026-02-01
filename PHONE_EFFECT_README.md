# Audacity Phone Call Effect Scripts

These are Nyquist plugins for Audacity to make audio sound like it's over a telephone call.

## Installation

1. Copy the `.ny` files to your Audacity plugins folder:
   - **Windows**: `C:\Users\YourName\AppData\Roaming\audacity\Plug-Ins\`
   - **Mac**: `~/Library/Application Support/audacity/Plug-Ins/`
   - **Linux**: `~/.audacity-files/plug-ins/`

2. Restart Audacity

3. Enable the plugins:
   - Go to **Effect → Add / Remove Plug-ins...**
   - Select the phone effects and click **Enable**

## Usage

1. Select audio in Audacity
2. Go to **Effect** menu
3. Choose either:
   - **Phone Call Effect** - Basic effect with adjustable controls
   - **Telephone Filter** - Pre-configured phone types

## Phone Call Effect Controls

- **Band Center**: Center frequency of the phone band (default: 1850 Hz)
- **Band Width**: Width of the frequency band (default: 1550 Hz)
- **Distortion**: Amount of telephone distortion (0-1)
- **Noise Level**: Background noise amount (0-0.1)

## Telephone Filter Options

**Phone Types:**
- Landline: 300-3400 Hz (traditional phone)
- Cellphone: 300-4000 Hz (wider range)
- Radio: 400-3000 Hz (radio broadcast)
- Old Telephone: 400-2500 Hz (vintage sound)

## Tips

- Works best with voice audio
- Apply EQ before this plugin for better results
- Adjust noise level to match your scene's environment