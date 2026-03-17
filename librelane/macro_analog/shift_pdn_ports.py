#!/usr/bin/env python3

import re

# =========================
# USER PARAMETERS
# =========================
INPUT_LEF = "line_driver.lef"
OUTPUT_TXT = "shifted_pins.txt"

DX = 179.84
DY = 2.47

TARGET_PINS = {"VPWR", "VGND"}

# =========================
# REGEX
# =========================
rect_re = re.compile(r"RECT\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s*;")

# =========================
# PROCESS
# =========================
with open(INPUT_LEF, "r") as f:
    lines = f.readlines()

inside_target_pin = False
current_pin = []
output_lines = []

for line in lines:
    stripped = line.strip()

    # Enter PIN
    if stripped.startswith("PIN"):
        pin_name = stripped.split()[1]
        if pin_name in TARGET_PINS:
            inside_target_pin = True
            current_pin = [line]
        else:
            inside_target_pin = False

        continue

    if inside_target_pin:
        # Modify RECT
        if "RECT" in line:
            def shift_rect(match):
                x1, y1, x2, y2 = map(float, match.groups())

                x1 += DX
                x2 += DX
                y1 += DY
                y2 += DY

                return f"RECT {x1:.3f} {y1:.3f} {x2:.3f} {y2:.3f} ;"

            line = rect_re.sub(shift_rect, line)

        current_pin.append(line)

        # Exit PIN
        if stripped.startswith("END"):
            tokens = stripped.split()
            if len(tokens) > 1 and tokens[1] in TARGET_PINS:
                inside_target_pin = False
                output_lines.extend(current_pin)

# =========================
# WRITE OUTPUT
# =========================
with open(OUTPUT_TXT, "w") as f:
    f.writelines(output_lines)

print(f"✅ Shifted PINs written to {OUTPUT_TXT}")

