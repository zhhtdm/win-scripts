#!/usr/bin/env python3
import os
import re
import colorsys
import webcolors

def name_to_hex(name):
    try:
        return webcolors.name_to_hex(name.lower())
    except ValueError:
        return None

def invert_luminance(hex_color):
    r, g, b = int(hex_color[1:3], 16), int(hex_color[3:5], 16), int(hex_color[5:7], 16)
    rf, gf, bf = r / 255.0, g / 255.0, b / 255.0
    h, l, s = colorsys.rgb_to_hls(rf, gf, bf)
    l = 0.8
    s = 0.6
    rf2, gf2, bf2 = colorsys.hls_to_rgb(h, l, s)
    r2, g2, b2 = int(round(rf2 * 255)), int(round(gf2 * 255)), int(round(bf2 * 255))
    return f"#{r2:02X}{g2:02X}{b2:02X}"

def process_file(path):
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()

    # Step 1: color="DarkViolet" or color='darkviolet'
    def replace_named_color(m):
        quote, name = m.group(1), m.group(2)
        hexcode = name_to_hex(name)
        if hexcode:
            return f'color={quote}{hexcode}{quote}'
        else:
            return m.group(0)

    text = re.sub(r'color=(["\'])([a-zA-Z]+)\1', replace_named_color, text)

    # Step 2: invert luminance
    def replace_color(m):
        orig = m.group(0)
        try:
            return invert_luminance(orig)
        except:
            return orig

    new_text = re.sub(r"#([0-9a-fA-F]{6})", replace_color, text)

    if new_text != text:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_text)
        print(f"Updated: {path}")

def main():
    for fn in os.listdir("."):
        if fn.lower().endswith(".xshd"):
            process_file(fn)

if __name__ == "__main__":
    main()
    input("Press Enter to exit ... ")
