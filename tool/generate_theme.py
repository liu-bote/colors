"""Generates assets/audio/color_spot_theme.wav — the looping background music.

Pure-stdlib synthesis (no numpy/ffmpeg needed): a calm 84 BPM, 16-bar
C-major loop with three melody-only layers (music-box arpeggio, soft chord
pad, lead melody) and no percussion. Every note tail, echo and filter is
rendered onto a circular buffer, so the end of the loop flows back into the
start with no audible seam by construction.

Usage: python3 tool/generate_theme.py
"""
import array
import math
import wave

SR = 22050
BPM = 84
BEAT = 60.0 / BPM
BARS = 16
N = int(round(BARS * 4 * BEAT * SR))  # loop length in samples

OUT_PATH = "assets/audio/color_spot_theme.wav"

buf = [0.0] * N


def midi_hz(m):
    return 440.0 * 2.0 ** ((m - 69) / 12.0)


def add_pluck(start_beat, midi, vol, decay, partials):
    """Music-box style note: fast attack, exponential decay, wraps at N."""
    f = 2.0 * math.pi * midi_hz(midi) / SR
    start = int(start_beat * BEAT * SR)
    attack = int(0.006 * SR)
    sin = math.sin
    exp = math.exp
    i = 0
    while True:
        env = exp(-i / (decay * SR))
        if i > attack and env < 0.0008:
            break
        if i <= attack:
            env *= i / attack
        s = 0.0
        for mult, amp in partials:
            s += amp * sin(f * mult * i)
        buf[(start + i) % N] += vol * env * s
        i += 1


def add_pad(start_beat, midi, dur_beats, vol):
    """Soft sustained chord tone: slow attack, sustain, gentle release."""
    f = 2.0 * math.pi * midi_hz(midi) / SR
    start = int(start_beat * BEAT * SR)
    sustain = int(dur_beats * BEAT * SR)
    attack = int(0.5 * SR)
    release = int(0.6 * SR)
    sin = math.sin
    for i in range(sustain + release):
        if i < attack:
            env = i / attack
        elif i < sustain:
            env = 1.0
        else:
            env = 1.0 - (i - sustain) / release
        s = sin(f * i) + 0.12 * sin(2 * f * i) + 0.05 * sin(3 * f * i)
        buf[(start + i) % N] += vol * env * s


PLUCK_PARTIALS = [(1, 1.0), (2, 0.30), (4, 0.10)]

# One chord per bar: C  G  Am  F, repeated. Voicings chosen for smooth
# voice leading; arpeggio cycles chord tones in eighth notes.
PADS = {
    "C": [48, 55, 64],
    "G": [47, 55, 62],
    "Am": [45, 52, 60],
    "F": [45, 53, 60],
}
ARPS = {
    "C": [60, 67, 64, 67, 72, 67, 64, 67],
    "G": [59, 67, 62, 67, 71, 67, 62, 67],
    "Am": [57, 64, 60, 64, 69, 64, 60, 64],
    "F": [57, 65, 60, 65, 69, 65, 60, 65],
}
PROGRESSION = ["C", "G", "Am", "F"] * 4

# Lead melody as (start beat, duration beats, midi note). Two 8-bar phrases;
# chord tones plus gentle passing notes, ending so bar 16 resolves back into
# the loop start.
MELODY = [
    (0, 2, 76), (2, 1, 79), (3, 1, 76),
    (4, 3, 74), (7, 1, 71),
    (8, 2, 72), (10, 2, 76),
    (12, 2, 69), (14, 2, 72),
    (16, 2, 67), (18, 1, 72), (19, 1, 76),
    (20, 2, 74), (22, 2, 79),
    (24, 3, 76), (27, 1, 72),
    (28, 2, 74), (30, 2, 72),
    (32, 1, 76), (33, 1, 77), (34, 2, 79),
    (36, 2, 81), (38, 2, 79),
    (40, 2, 76), (42, 2, 72),
    (44, 2, 69), (46, 2, 77),
    (48, 2, 76), (50, 2, 74),
    (52, 2, 71), (54, 2, 74),
    (56, 4, 72),
    (60, 2, 72), (62, 2, 69),
]


def render():
    for bar, chord in enumerate(PROGRESSION):
        bar_beat = bar * 4
        for note in PADS[chord]:
            add_pad(bar_beat, note, 4, 0.14)
        for k, note in enumerate(ARPS[chord]):
            vol = 0.13 if k % 2 == 0 else 0.10
            add_pluck(bar_beat + k * 0.5, note, vol, 0.45, PLUCK_PARTIALS)
    for start, dur, note in MELODY:
        add_pluck(start, note, 0.30, 0.35 + 0.28 * dur, PLUCK_PARTIALS)


def echo():
    """Dotted-eighth feedback delay, run circularly so the tail wraps."""
    d = int(0.75 * BEAT * SR)
    fb = 0.32
    wet = [0.0] * N
    for _ in range(3):  # extra passes let the feedback wrap and converge
        for i in range(N):
            wet[i] = buf[i] + fb * wet[i - d]  # negative index wraps in a list
    for i in range(N):
        buf[i] += 0.22 * (wet[i] - buf[i])


def lowpass(cutoff_hz):
    """One-pole lowpass, run twice around the loop so its state wraps too."""
    rc = 1.0 / (2.0 * math.pi * cutoff_hz)
    dt = 1.0 / SR
    alpha = dt / (rc + dt)
    y = 0.0
    for _ in range(2):
        for i in range(N):
            y += alpha * (buf[i] - y)
            buf[i] = y


def write():
    peak = max(abs(s) for s in buf)
    scale = 0.85 * 32767 / peak
    pcm = array.array("h", (int(s * scale) for s in buf))
    with wave.open(OUT_PATH, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())
    print(f"wrote {OUT_PATH}: {N / SR:.2f}s loop @ {SR} Hz, peak {peak:.3f}")


if __name__ == "__main__":
    render()
    echo()
    lowpass(3800)
    write()
