# Audacity Movie Voice Effects - Project Initialization

**Welcome! This is your entry point.** Read this first to understand the project structure and how to use the other documentation files.

---

## Project Overview

Building Nyquist plugins for Audacity to create movie-quality voice effects. 40 total effects:
- **30 Individual Effects** - Modular voice transformations
- **10 Recipe Effects** - Pre-configured combinations

All effects simulate communication devices, environmental spaces, character types, and psychological states for film sound design.

---

## Documentation Structure

### 1. START HERE: TODO.md
**Purpose**: Task tracker - what needs to be built  
**When to use**: At the start of every session to see what's pending  
**Update**: Mark tasks `[~]` (in progress) or `[x]` (complete)

**Contents**:
- Checklist of all 35 effects (not started / in progress / complete)
- Implementation priority order
- Testing checklist for each effect
- File naming conventions
- Workflow instructions

### 2. DURING WORK: SESSION_TRACKING.md  
**Purpose**: Project journal - what happened, decisions made  
**When to use**: When you encounter issues, make decisions, or complete work  
**Update**: Log technical discoveries, blockers, solutions

**Contents**:
- Change log (dated entries)
- Active work tracking (current session)
- Technical decisions and open questions
- Issues and blockers
- Resources and references

### 3. TECHNICAL REFERENCE: This File (INIT.md)
**Purpose**: Effect specifications and implementation guide  
**When to use**: When building an effect to understand requirements

**Contents**:
- Detailed specs for each effect (parameters, movie references, technical notes)
- Nyquist implementation patterns
- DSP function examples
- Usage guidelines

---

## Quick Start Workflow

```
1. Read TODO.md → See what's pending
2. Pick an effect → Mark it [~] in TODO.md
3. Read effect specs in INIT.md → Understand requirements
4. Build the effect → Create .ny file
5. Test → Use testing checklist in TODO.md
6. Update TODO.md → Mark [x] when complete
7. Log in SESSION_TRACKING.md → Note what you did
```

---

## Effect Categories

### Individual Effects (30 total)
- **Communication** (5): Walkie-Talkie, Intercom, PA System, Radio DJ, Old Telephone
- **Environment** (5): Underwater, Cave, Cathedral, Small Room, Outside/Distant
- **Size/Perspective** (5): Giant, Tiny, Distant, Through Wall, Whisper Close
- **Psychological** (5): Dream, Dizzy, Inner Monologue, Flashback, Possessed
- **Character** (6): Robot, Alien, Ghost, Monster, Computer, Villain
- **Vintage** (4): Old Radio, Vinyl, Film Noir, Tape Recording

### Recipe Effects (10 total)
Combinations like Ghost Voice (Whisper + Reverse Reverb + Low Rumble)

---

## Key Technical Standards

- **All effects have Intensity slider**: 0-100%
- **0%** = Dry signal (no effect)
- **50%** = Moderate/natural effect
- **100%** = Maximum strength without clipping
- **Platform**: Audacity Nyquist plugins (.ny files)
- **Naming**: `communication_walkie_talkie.ny`, `recipe_ghost_voice.ny`

---

---

## Detailed Effect Specifications

The following sections contain complete specifications for each effect. Use these when implementing.

## Installation

1. Copy the `.ny` files to your Audacity plugins folder:
   - **Windows**: `C:\Users\YourName\AppData\Roaming\audacity\Plug-Ins\`
   - **Mac**: `~/Library/Application Support/audacity/Plug-Ins/`
   - **Linux**: `~/.audacity-files/plug-ins/`

2. Restart Audacity

3. Enable the plugins:
   - Go to **Effect → Add / Remove Plug-ins...**
   - Select the voice effects and click **Enable**

## Quick Reference

### Individual Effects (30)
- **Communication**: Walkie-Talkie, Intercom, PA System, Radio DJ, Old Telephone
- **Environment**: Underwater, Cave, Cathedral, Small Room, Outside/Distant
- **Size/Perspective**: Giant, Tiny, Distant, Through Wall, Whisper Close
- **Psychological**: Dream, Dizzy, Inner Monologue, Flashback, Possessed
- **Character**: Robot, Alien, Ghost, Monster, Computer, Villain
- **Vintage**: Old Radio, Vinyl, Film Noir, Tape Recording

### Recipe Effects (10)
Pre-configured combinations for common movie scenarios:
- Ghost Voice, Possessed Voice, Dream Narrator, Villain Monologue, etc.

## Individual Effects

All individual effects include an **Intensity slider (0-100%)** to control the strength of the effect.

### 1. Communication Devices

#### Walkie-Talkie
Makes voice sound like it's coming through a military or police radio.

**Movie References**: 
- Military radio chatter (Saving Private Ryan, Black Hawk Down)
- Police dispatch (any crime drama)
- Security guard communications

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Bandpass Low** (Hz): Low frequency cutoff (default: 300)
- **Bandpass High** (Hz): High frequency cutoff (default: 3000)
- **Static Amount** (0-1): Radio static noise level (default: 0.05)
- **Compression** (ratio): Dynamic range compression (default: 4:1)

**Technical Notes**:
- Use bandpass filter to simulate radio frequency limitations
- Add white noise for static effect
- Apply heavy compression to simulate radio transmitter limiting

---

#### Intercom
Voice through an intercom or building announcement system.

**Movie References**:
- School announcements (The Breakfast Club, Ferris Bueller)
- Apartment building buzzer (Seinfeld, Friends)
- Office building PA system

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Room Size** (small/medium/large): Acoustic space simulation (default: small)
- **Feedback Warning** (0-1): Slight feedback before speaking (default: 0.1)
- **Bandwidth** (Hz): Frequency range (default: 400-3500)

---

#### PA System
Stadium, airport, or concert hall announcement voice.

**Movie References**:
- Stadium announcer (any sports movie)
- Airport announcements (Home Alone, Terminal)
- Concert "Please return to your seats"

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Stadium Size** (small/medium/large/arena): Reverb characteristics (default: large)
- **Distance** (0-1): Perceived distance from microphone (default: 0.3)
- **Bandwidth** (Hz): Frequency range (default: 200-5000)

---

#### Radio DJ
Classic radio host voice with compression and bass boost.

**Movie References**:
- Morning show host (Private Parts, Talk Radio)
- Late-night DJ (Pump Up the Volume)
- Classic rock DJ voice

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Compression** (ratio): Dynamic range compression (default: 6:1)
- **Bass Boost** (dB): Low frequency enhancement (default: +6dB)
- **De-esser** (0-1): Sibilance reduction (default: 0.3)

---

#### Old Telephone
Vintage telephone from 1940s-1960s with carbon microphone characteristics.

**Movie References**:
- Film noir phone calls (The Maltese Falcon, Casablanca)
- 1950s-60s period pieces (Mad Men)
- Vintage detective stories

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Carbon Mic Distortion** (0-1): Characteristic distortion (default: 0.4)
- **Line Noise** (0-1): 60Hz hum and line static (default: 0.05)
- **Bandwidth** (Hz): Frequency range (default: 400-2500)

---

### 2. Environmental Spaces

#### Underwater Voice
Voice submerged or speaking underwater.

**Movie References**:
- Aquaman underwater dialogue
- Drowning or submerged scenes (Titanic, The Abyss)
- Underwater creature speech

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Low-pass Cutoff** (Hz): High frequency cutoff (default: 800)
- **Slowdown Ratio** (0.5-1.0): Playback speed reduction (default: 0.8)
- **Bubble Resonance** (0-1): Underwater bubble sound overlay (default: 0.1)

**Technical Notes**:
- Heavy low-pass filtering simulates water muffling
- Slow down audio to simulate underwater sound propagation
- Optional bubble noise layer for realism

---

#### Cave Voice
Voice echoing in a large cave or cavern.

**Movie References**:
- Moria mines (Lord of the Rings: Fellowship)
- Cave exploration scenes (The Descent, Sanctum)
- Underground hideouts

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Reverb Decay** (sec): Echo tail length (default: 3.5)
- **Pre-delay** (ms): Time before first reflection (default: 80)
- **Dampening** (0-1): High frequency absorption (default: 0.4)

---

#### Cathedral Voice
Massive reverberant space like a cathedral or temple.

**Movie References**:
- Dumbledore's voice (Harry Potter series)
- Church scenes (The Godfather wedding)
- Temple or palace scenes (Gladiator)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Reverb Type** (cathedral/church/temple): Room model (default: cathedral)
- **Harmonics** (0-1): Choral/angelic harmonic enhancement (default: 0.2)
- **Decay Time** (sec): Reverb tail length (default: 5.0)

---

#### Small Room
Intimate voice recorded in a small enclosed space.

**Movie References**:
- Closet scenes (horror movies)
- Bathroom singing (Risky Business)
- Confessional booth scenes

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Room Size** (tiny/small/medium): Acoustic space (default: small)
- **Early Reflections** (0-1): First echo intensity (default: 0.3)
- **Intimacy** (0-1): Close-mic proximity effect (default: 0.6)

---

#### Outside/Distant
Voice from across the street or far away outdoors.

**Movie References**:
- Balcony scenes (Romeo and Juliet)
- Across the battlefield (Braveheart)
- Calling from a distance (any drama)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Distance** (0-1): Perceived distance (default: 0.5)
- **Outdoor EQ** (preset): Frequency curve for outdoor acoustics
- **Volume Attenuation** (dB): Volume reduction (default: -6)

---

### 3. Size & Perspective

#### Giant Voice
Massive creature or giant character voice.

**Movie References**:
- Godzilla roar/voice
- King Kong (Peter Jackson version)
- BFG (Big Friendly Giant)
- Clifford the Big Red Dog

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Pitch Shift** (semitones): Downward pitch shift (default: -12, range: -24 to -6)
- **Slow Attack** (ms): Envelope attack time (default: 50)
- **Massive Reverb** (0-1): Large space simulation (default: 0.7)

---

#### Tiny Voice
Shrunken or miniature character voice.

**Movie References**:
- Alice in Wonderland (shrinking scenes)
- Ant-Man when tiny
- Honey I Shrunk the Kids
- Chipmunks (though usually not human)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Pitch Shift** (semitones): Upward pitch shift (default: +12, range: +6 to +18)
- **Room Size** (tiny/small): Small space acoustics (default: tiny)
- **Formant Shift** (0-1): Vocal tract size simulation (default: 0.5)

---

#### Distant Voice
Voice from far away with atmospheric attenuation.

**Movie References**:
- "Luke, I am your father" (Star Wars - though that's close)
- Calling across canyons
- Distant battlefield commands

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Low-pass Cutoff** (Hz): High frequency rolloff (default: 1000)
- **Reverb Amount** (0-1): Atmospheric reverb (default: 0.6)
- **Volume Drop** (dB): Distance attenuation (default: -12)

---

#### Through Wall
Voice heard through a wall or closed door.

**Movie References**:
- Eavesdropping scenes ( Rear Window)
- Next room conversations
- Hotel wall scenes

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Bandpass** (Hz): Wall filtering (default: 200-2500)
- **Muffle Amount** (0-1): Low-mid emphasis (default: 0.6)
- **Structural Thump** (0-1): Bass transmission through wall (default: 0.2)

---

#### Whisper Close
Intimate whisper right next to the ear.

**Movie References**:
- ASMR-style intimacy
- Secret sharing scenes
- Horror movie whispers

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Proximity Effect** (dB): Bass boost from close mic (default: +8)
- **Breath Noise** (0-1): Breath sound overlay (default: 0.3)
- **Compression** (ratio): Evening out whispers (default: 3:1)

---

### 4. Psychological States

#### Dream Voice
Voice in a dream or dreamlike state.

**Movie References**:
- Inception dream sequences
- Dream dialogue (Eternal Sunshine)
- Nightmare on Elm Street

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Slowdown** (0.5-1.0): Playback speed (default: 0.8)
- **Underwater Filter** (0-1): Muffled quality (default: 0.4)
- **Reverse Reverb** (0-1): Pre-echo effect (default: 0.3)

---

#### Dizzy/Disoriented
Voice of someone dizzy, drunk, or disoriented.

**Movie References**:
- Drunk dialogue (The Hangover, any bar scene)
- Spinning camera scenes (Vertigo)
- Concussion or head injury

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Pitch Wobble** (cents): Pitch instability (default: ±30, range: ±10 to ±100)
- **Pan Rotation** (speed): Stereo spinning effect (default: 0.2 Hz)
- **Blur Filter** (0-1): High frequency reduction (default: 0.4)

---

#### Inner Monologue
Voiceover representing internal thoughts.

**Movie References**:
- Narration (Fight Club, American Beauty)
- Internal conflict scenes
- Stream of consciousness

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Close-mic Proximity** (dB): Intimate recording (default: +4)
- **Room Tone** (0-1): Subtle space ambience (default: 0.2)
- **Compression** (ratio): Consistent level (default: 2:1)

---

#### Flashback Voice
Voice representing a memory or past event.

**Movie References**:
- PTSD flashbacks (any war movie)
- Memory sequences (The Notebook)
- Childhood memories

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Telephone Filter** (0-1): Distant phone quality (default: 0.5)
- **Heavy Reverb** (0-1): Memory haze (default: 0.6)
- **Distant Quality** (0-1): Far away feel (default: 0.4)

---

#### Possessed Voice
Demonic or supernatural possession voice.

**Movie References**:
- The Exorcist (classic possessed voice)
- Demon voices (The Conjuring, Insidious)
- Supernatural possession scenes

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Dual Voice** (0-1): Layer original + detuned copy (default: 0.7)
- **Detune Amount** (cents): Pitch offset for layer (default: -20)
- **Stereo Spread** (0-1): Wide stereo image (default: 0.8)

---

### 5. Creature/Character Voices

#### Robot Voice
Mechanical or artificial voice.

**Movie References**:
- C-3PO (Star Wars)
- Transformers
- RoboCop
- HAL 9000 (though more subtle)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Ring Modulator** (Hz): Carrier frequency (default: 60, range: 30-100)
- **Metallic Resonance** (0-1): Metal pipe quality (default: 0.5)
- **Formant Shift** (0-1): Mechanical vocal tract (default: 0.3)

---

#### Alien Voice
Non-human extraterrestrial voice.

**Movie References**:
- Various Star Trek aliens
- District 9 prawns
- Alien (though mostly non-verbal)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Formant Shift** (semitones): Vocal tract modification (default: +5)
- **Strange Harmonics** (0-1): Unusual overtone series (default: 0.4)
- **Pitch Shift** (semitones): Overall pitch change (default: -3)

---

#### Ghost Voice
Ethereal, otherworldly spirit voice.

**Movie References**:
- The Ring (Samara's voice)
- Paranormal Activity
- The Sixth Sense
- Ghost (Patrick Swayze)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Whisper Base** (0-1): Start with whisper effect (default: 0.6)
- **Reverse Reverb** (0-1): Pre-echo tail (default: 0.5)
- **Low Rumble** (0-1): Sub-bass undertone (default: 0.3)

---

#### Monster Voice
Creature or beast voice.

**Movie References**:
- Darth Vader (Star Wars)
- Bane (The Dark Knight Rises)
- Predator
- Godzilla (when vocalizing)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Pitch Down** (semitones): Lower pitch (default: -8, range: -4 to -16)
- **Distortion** (0-1): Grit and aggression (default: 0.4)
- **Growl Layer** (0-1): Animalistic undertone (default: 0.3)

---

#### Computer Voice
AI or synthesized voice.

**Movie References**:
- HAL 9000 (2001: A Space Odyssey)
- Samantha (Her)
- Siri/Alexa-style assistants
- Mother (Alien)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Perfect Pitch** (0-1): No pitch variation (default: 0.8)
- **No Breath** (0-1): Remove breathing sounds (default: 0.9)
- **Slight Chorus** (0-1): Subtle doubling (default: 0.2)

---

#### Villain Voice
Menacing antagonist voice.

**Movie References**:
- Emperor Palpatine (Star Wars)
- Voldemort (Harry Potter)
- Sauron's voice (Lord of the Rings)
- Hans Gruber (Die Hard)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Dark EQ** (preset): Low-mid emphasis curve
- **Reverb** (0-1): Authority space (default: 0.4)
- **Menacing Compression** (ratio): Controlled aggression (default: 5:1)

---

### 6. Vintage/Retro

#### Old Radio
Vintage radio broadcast from early-to-mid 20th century.

**Movie References**:
- War of the Worlds broadcast
- FDR Fireside Chats
- 1940s news broadcasts

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **AM Crackle** (0-1): Amplitude modulation noise (default: 0.1)
- **Bandwidth** (Hz): Frequency range (default: 400-3000)
- **Distortion** (0-1): Tube/saturation (default: 0.3)

---

#### Vinyl Recording
Voice recorded on vinyl record with surface noise.

**Movie References**:
- 78 RPM records
- Vintage music recordings
- Period piece authenticity

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Crackle** (0-1): Surface noise (default: 0.15)
- **Wow/Flutter** (0-1): Speed variation (default: 0.1)
- **Saturation** (0-1): Warm distortion (default: 0.3)

---

#### Film Noir
1940s-50s detective/noir style voice.

**Movie References**:
- Casablanca
- The Maltese Falcon
- Double Indemnity
- Sin City (modern noir)

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Telephone Quality** (0-1): Band-limited sound (default: 0.6)
- **Room Reverb** (0-1): Office/bar ambience (default: 0.3)
- **1940s EQ** (preset): Period-accurate frequency curve

---

#### Tape Recording
Home or professional tape recording from 70s-90s.

**Movie References**:
- 80s home video narration
- Cassette tape recordings
- Answering machine messages

**Parameters**:
- **Intensity** (0-100%): Overall effect strength
- **Tape Hiss** (0-1): High frequency noise (default: 0.1)
- **Saturation** (0-1): Tape compression (default: 0.4)
- **Pitch Wobble** (0-1): Capstan variation (default: 0.15)

---

## Recipe Effects

Recipe effects combine multiple individual effects into a single plugin. Each recipe has a master **Intensity slider (0-100%)** that proportionally scales all component effects.

### Ghost Voice Recipe
**Components**: Whisper Close + Reverse Reverb + Low Rumble

**Movie References**:
- The Ring (Samara)
- Paranormal Activity
- The Sixth Sense

**Use Case**: Ethereal spirit voices, supernatural communication

**Parameters**:
- **Intensity** (0-100%): Overall ghost effect strength
- **Whisper Amount** (0-1): Base whisper level (default: 0.6)
- **Ethereal Tail** (0-1): Reverse reverb amount (default: 0.5)
- **Ominous Undertone** (0-1): Low rumble level (default: 0.3)

---

### Possessed Voice Recipe
**Components**: Monster Voice + Dizzy/Disoriented + Through Wall

**Movie References**:
- The Exorcist
- The Conjuring
- Insidious

**Use Case**: Demonic possession, supernatural takeover

**Parameters**:
- **Intensity** (0-100%): Overall possession strength
- **Demonic Quality** (0-1): Monster voice amount (default: 0.7)
- **Disorientation** (0-1): Dizzy effect level (default: 0.4)
- **Otherworldly Distance** (0-1): Through wall amount (default: 0.3)

---

### Dream Narrator Recipe
**Components**: Dream Voice + Inner Monologue + Cathedral Reverb

**Movie References**:
- Inception
- Eternal Sunshine
- Dream sequences

**Use Case**: Dream voiceovers, subconscious narration

**Parameters**:
- **Intensity** (0-100%): Overall dream quality
- **Dream State** (0-1): Dream voice amount (default: 0.6)
- **Intimacy** (0-1): Inner monologue level (default: 0.5)
- **Mystical Space** (0-1): Cathedral reverb amount (default: 0.4)

---

### Villain Monologue Recipe
**Components**: Villain Voice + Computer Voice + Cathedral Reverb

**Movie References**:
- Emperor Palpatine (Star Wars)
- Voldemort (Harry Potter)
- Sauron (Lord of the Rings)

**Use Case**: Powerful villain speeches, evil proclamations

**Parameters**:
- **Intensity** (0-100%): Overall villain presence
- **Menace** (0-1): Villain voice amount (default: 0.7)
- **Authority** (0-1): Computer precision (default: 0.3)
- **Power Space** (0-1): Cathedral reverb (default: 0.5)

---

### Robot Overlord Recipe
**Components**: Robot Voice + Giant Voice + PA System

**Movie References**:
- Transformers (Megatron)
- Matrix (machine voice)
- Terminator (Skynet)

**Use Case**: AI antagonists, machine uprising

**Parameters**:
- **Intensity** (0-100%): Overall machine presence
- **Mechanical** (0-1): Robot voice amount (default: 0.6)
- **Size** (0-1): Giant voice scale (default: 0.5)
- **Broadcast** (0-1): PA system spread (default: 0.4)

---

### Underwater Communication Recipe
**Components**: Underwater Voice + Walkie-Talkie + Distant

**Movie References**:
- The Abyss
- Underwater diving scenes
- Submarine communications

**Use Case**: Divers talking, submerged radio contact

**Parameters**:
- **Intensity** (0-100%): Overall underwater comm strength
- **Submersion** (0-1): Underwater effect (default: 0.7)
- **Radio Quality** (0-1): Walkie-talkie amount (default: 0.6)
- **Distance** (0-1): Far away feel (default: 0.3)

---

### Time Traveler Recipe
**Components**: Old Radio + Tape Recording + Dizzy/Disoriented

**Movie References**:
- Time travel arrival scenes
- Displaced characters
- Temporal displacement

**Use Case**: Characters out of time, temporal confusion

**Parameters**:
- **Intensity** (0-100%): Overall time displacement
- **Era** (0-1): Old radio amount (default: 0.5)
- **Recording Quality** (0-1): Tape effect (default: 0.4)
- **Disorientation** (0-1): Dizzy amount (default: 0.3)

---

### Haunted Recording Recipe
**Components**: Vinyl Recording + Ghost Voice + Through Wall

**Movie References**:
- Found footage horror
- EVP recordings
- Haunted media

**Use Case**: Ghost voices on old recordings, supernatural media

**Parameters**:
- **Intensity** (0-100%): Overall haunted quality
- **Vintage** (0-1): Vinyl amount (default: 0.6)
- **Spirit Voice** (0-1): Ghost effect (default: 0.5)
- **Mystery** (0-1): Through wall amount (default: 0.4)

---

### Interdimensional Being Recipe
**Components**: Alien Voice + Dream Voice + Cathedral Reverb

**Movie References**:
- Interstellar (tesseract scene)
- Arrival
- 2001: A Space Odyssey

**Use Case**: Higher dimensional entities, cosmic beings

**Parameters**:
- **Intensity** (0-100%): Overall otherworldly presence
- **Alien Quality** (0-1): Alien voice amount (default: 0.5)
- **Dream State** (0-1): Dream effect (default: 0.4)
- **Cosmic Space** (0-1): Cathedral reverb (default: 0.6)

---

### Secret Agent Recipe
**Components**: Radio DJ + Inner Monologue + Small Room

**Movie References**:
- James Bond voiceover
- Spy movie narration
- Mission briefings

**Use Case**: Espionage narration, secret agent voiceovers

**Parameters**:
- **Intensity** (0-100%): Overall agent presence
- **Broadcast Quality** (0-1): Radio DJ amount (default: 0.4)
- **Intimacy** (0-1): Inner monologue (default: 0.6)
- **Secrecy** (0-1): Small room amount (default: 0.5)

---

## Technical Implementation Guide for Other Agents

### Nyquist Plugin Structure

All plugins follow this standard header format:

```
;nyquist plug-in
;version 4
;type process
;name "[Effect Name]"
;action "Applying [effect]..."
;info "[Brief description]"

;control intensity "Effect Intensity" real "%" 50 0 100
;control param1 "Parameter 1 Name" real "Unit" default min max
;control param2 "Parameter 2 Name" real "Unit" default min max
```

### Intensity Scaling

The intensity slider (0-100%) should scale all effect parameters proportionally:

- **0%**: No effect (dry signal)
- **50%**: Default/moderate effect
- **100%**: Maximum effect strength

Implementation approach:
```lisp
(let ((scaled-param (linear-interpolate intensity 0 100 min-value max-value)))
  ; Apply effect with scaled parameter
  )
```

### Common DSP Functions

**Bandpass Filtering**:
```lisp
(lowpass2 (highpass2 signal low-freq) high-freq)
```

**Reverb**:
Use Audacity's built-in reverb or implement simple algorithmic reverb with comb filters and all-pass filters.

**Pitch Shifting**:
Use `resample` function for time-domain pitch shifting.

**Ring Modulation**:
```lisp
(mult signal (osc (hz-to-step carrier-freq)))
```

**Noise Generation**:
```lisp
(noise duration)  ; White noise
```

**Compression**:
Implement using `gate` or envelope followers.

### Recipe Implementation

Recipe effects chain multiple individual effects:

```lisp
(defun recipe-effect (s intensity)
  (let* (
    ; Scale component amounts by master intensity
    (comp1-amount (scale-intensity intensity default-comp1))
    (comp2-amount (scale-intensity intensity default-comp2))
    
    ; Apply effects in sequence
    (step1 (effect1 s comp1-amount))
    (step2 (effect2 step1 comp2-amount))
    )
    step2))
```

### Parameter Ranges

**Frequency (Hz)**: 
- Low cutoffs: 20-500 Hz
- High cutoffs: 2000-20000 Hz
- Band centers: 200-8000 Hz

**Time (seconds)**:
- Reverb decay: 0.5-10.0 sec
- Pre-delay: 0-200 ms
- Attack times: 1-100 ms

**Ratios/Amounts (0-1)**:
- Distortion: 0-1
- Noise: 0-0.5 (keep subtle)
- Reverb amount: 0-1
- Modulation depth: 0-1

**Pitch (semitones)**:
- Down: -24 to -4
- Up: +4 to +24

## Usage Tips

### General Guidelines

1. **Start with Intensity at 50%** and adjust to taste
2. **Apply EQ before effects** for better frequency control
3. **Use compression after effects** to even out levels
4. **Layer multiple effects** for complex characters
5. **Save presets** for frequently used settings

### Voice Preparation

- Record clean, dry voice
- Remove background noise before applying effects
- Consistent recording level helps effects work predictably
- Leave headroom for effect processing

### Effect Combinations

**Common Pairings**:
- Communication + Environment (walkie-talkie in a cave)
- Character + Size (tiny robot voice)
- Psychological + Vintage (dream flashback to 1940s)

**Avoid Overprocessing**:
- Too many effects can make voice unintelligible
- Test dialogue clarity with effects applied
- Consider subtitles if effect is extreme

### Movie Genre Guidelines

**Sci-Fi**: Robot, Alien, Computer, PA System, Giant
**Horror**: Ghost, Monster, Possessed, Whisper, Through Wall
**Fantasy**: Giant, Tiny, Cathedral, Dream
**Period Drama**: Old Telephone, Old Radio, Film Noir, Tape
**Thriller**: Inner Monologue, Distant, Secret Agent
**Comedy**: Tiny, Dizzy, Robot (for contrast)

---

## Effect Selection Guide

### By Scenario

**Phone/Communication**: Walkie-Talkie, Intercom, PA System, Radio DJ, Old Telephone
**Outdoor/Environment**: Outside/Distant, Underwater, Cave, Small Room
**Supernatural**: Ghost, Monster, Possessed, Alien, Dream
**Technology**: Robot, Computer, Walkie-Talkie, Tape
**Size Changes**: Giant, Tiny, Distant
**Mental States**: Dream, Dizzy, Inner Monologue, Flashback

### By Character Type

**Hero**: Inner Monologue, Radio DJ (for confidence)
**Villain**: Villain, Monster, Computer, Cathedral
**Comic Relief**: Tiny, Dizzy, Robot
**Mysterious**: Ghost, Whisper, Through Wall
**Authority**: PA System, Computer, Radio DJ
**Creature**: Monster, Giant, Tiny, Alien

### By Emotional Tone

**Intimate**: Whisper Close, Inner Monologue, Small Room
**Ominous**: Ghost, Monster, Villain, Low Rumble
**Confused**: Dizzy, Dream, Flashback
**Powerful**: Giant, PA System, Cathedral, Villain
**Distant**: Distant, Through Wall, Outside
**Nostalgic**: Old Radio, Film Noir, Tape, Vinyl

---

## Parameter Quick Reference

### Filter-Based Effects
- **Low-pass cutoff**: Higher = brighter, Lower = more muffled
- **High-pass cutoff**: Lower = more bass, Higher = thinner
- **Bandwidth**: Narrow = more telephone-like, Wide = more natural

### Reverb-Based Effects
- **Decay time**: Longer = bigger space
- **Pre-delay**: Longer = more separation from dry signal
- **Dampening**: Higher = darker/warmer reverb

### Modulation Effects
- **Pitch shift**: Negative = deeper voice, Positive = higher voice
- **Ring modulator**: Lower frequencies = more subtle, Higher = more robotic
- **Wobble speed**: Faster = more disoriented/dreamlike

### Distortion Effects
- **Amount**: More = more aggressive/gritty
- **Type**: Tube = warm, Digital = harsh, Tape = compressed

---

## Troubleshooting

### Voice is Unintelligible
- Reduce intensity
- Widen bandwidth filters
- Reduce distortion amount
- Add less reverb

### Effect is Too Subtle
- Increase intensity
- Check if dry/wet mix is balanced
- Verify parameters are at default (50%) or higher

### Clipping/Distortion
- Reduce input gain before effect
- Lower intensity slider
- Check if multiple effects are compounding

### Unnatural Sound
- Adjust formant shifting (if available)
- Reduce pitch shift amount
- Add subtle room tone
- Use parallel processing (blend dry signal)

---

## Version History

**v1.0** - Initial phone effects (existing)
**v2.0** - Expanded to comprehensive movie voice effects library
- Added 30 individual effects
- Added 10 recipe effects
- Included movie reference examples
- Added technical implementation guide

---

## Credits

These plugins are designed for Audacity using the Nyquist programming language.

Movie references are for educational and creative purposes.

---

## License

Public Domain - Free to use and modify for any project.
