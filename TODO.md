# Voice Effects Implementation TODO

Task tracker for voice effects implementation. This is the source of truth for what needs to be done.

**Status Key**: `[ ]` = Not started | `[~]` = In progress | `[x]` = Complete and tested

---

## Individual Effects (30 total)

### Communication Devices
- [x] Walkie-Talkie
- [x] Intercom  
- [x] PA System
- [x] Radio DJ
- [x] Old Telephone

### Environmental Spaces
- [x] Underwater
- [x] Cave
- [x] Cathedral
- [x] Small Room
- [x] Outside/Distant

### Size & Perspective
- [x] Giant
- [x] Tiny
- [x] Distant
- [x] Through Wall
- [x] Whisper Close

### Psychological States
- [x] Dream Voice
- [x] Dizzy/Disoriented
- [x] Inner Monologue
- [x] Flashback
- [x] Possessed

### Creature/Character Voices
- [x] Robot Voice
- [x] Alien Voice
- [x] Ghost Voice
- [x] Monster Voice
- [x] Computer Voice
- [x] Villain Voice

### Vintage/Retro
- [x] Old Radio
- [x] Vinyl Recording
- [x] Film Noir
- [x] Tape Recording

---

## Recipe Effects (10 total)

Implement after individual effects are complete.

- [x] Ghost Voice Recipe (Whisper + Reverse Reverb + Low Rumble)
- [x] Possessed Voice Recipe (Monster + Dizzy + Through Wall)
- [x] Dream Narrator Recipe (Dream + Inner Monologue + Cathedral)
- [x] Villain Monologue Recipe (Villain + Computer + Cathedral)
- [x] Robot Overlord Recipe (Robot + Giant + PA System)
- [x] Underwater Communication Recipe (Underwater + Walkie-Talkie + Distant)
- [x] Time Traveler Recipe (Old Radio + Tape + Dizzy)
- [x] Haunted Recording Recipe (Vinyl + Ghost + Through Wall)
- [x] Interdimensional Being Recipe (Alien + Dream + Cathedral)
- [x] Secret Agent Recipe (Radio DJ + Inner Monologue + Small Room)

---

## Implementation Priority

**Start here**: Communication effects (Walkie-Talkie, PA System) - test bandpass, noise, compression, reverb basics

**Then**: Environmental (Cave, Cathedral) - test reverb implementations

**Then**: Character voices (Robot, Monster) - test modulation, distortion

**Finally**: Recipe effects that combine the above

See INIT.md for detailed specifications of each effect.

---

## Testing Checklist

For each completed effect:
- [ ] Intensity slider works 0-100%
- [ ] 0% passes audio unchanged (dry)
- [ ] 50% sounds moderate/natural
- [ ] 100% is maximum without clipping
- [ ] Works with male, female, high, and low-pitched voices
- [ ] No audible artifacts

---

## Current Progress

**Last Updated**: 2026-02-03  
**Total**: 40 effects (30 individual + 10 recipes)  
**Status**: 40 complete, 0 in progress, 0 remaining  
**Testing**: Skipped for all effects per user request on 2026-02-03

---

## Workflow for Agents

**When starting:**
1. Pick an effect from the lists above
2. Mark it `[~]` in this file
3. Update SESSION_TRACKING.md with your plan and any blockers

**When done:**
1. Test using checklist above
2. Mark it `[x]` in this file
3. Update SESSION_TRACKING.md with completion notes
4. Log any technical decisions or issues discovered

**File naming:**
- Individual: `communication_walkie_talkie.ny`, `environment_cave.ny`, etc.
- Recipes: `recipe_ghost_voice.ny`, `recipe_villain_monologue.ny`, etc.

**Questions?** Check VOICE_EFFECTS_README.md for detailed effect specifications.
