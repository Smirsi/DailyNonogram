#!/usr/bin/env python3
"""
Nonogram Puzzle Generator
Generates B&W and color nonogram puzzles from embedded pixel art patterns.
Patterns inspired by CC0 assets from OpenGameArt.org (opengameart.org).

Outputs:
  - B&W: easy/medium/hard → .nonogram XML (FreeNono format)
  - Color: color-easy/color-medium/color-hard → .cnonogram XML

Usage: python3 generate_puzzles.py [--output-dir PATH]
"""

import os
import sys
import xml.etree.ElementTree as ET
from xml.dom import minidom
from copy import deepcopy
import numpy as np
from typing import List, Tuple, Optional, Dict, Any

OUTPUT_DIR = os.path.join(os.path.dirname(__file__),
                          "../DailyNonogram/Resources/Puzzles")

# ============================================================
# PIXEL ART PATTERNS — B&W (0=empty, 1=filled)
# CC0 / public domain, inspired by OpenGameArt.org assets
# ============================================================

BW_EASY: List[Dict[str, Any]] = [
    {"name": "heart", "grid": [
        [0,1,0,1,0],
        [1,1,1,1,1],
        [1,1,1,1,1],
        [0,1,1,1,0],
        [0,0,1,0,0],
    ]},
    {"name": "star", "grid": [
        [0,0,1,0,0],
        [0,1,1,1,0],
        [1,1,1,1,1],
        [0,1,1,1,0],
        [1,0,1,0,1],
    ]},
    {"name": "diamond", "grid": [
        [0,0,1,0,0],
        [0,1,1,1,0],
        [1,1,0,1,1],
        [0,1,1,1,0],
        [0,0,1,0,0],
    ]},
    {"name": "arrow", "grid": [
        [0,0,1,0,0,0],
        [0,1,1,0,0,0],
        [1,1,1,1,1,1],
        [0,1,1,0,0,0],
        [0,0,1,0,0,0],
    ]},
    {"name": "moon", "grid": [
        [0,1,1,0,0],
        [1,0,0,1,0],
        [1,0,0,0,1],
        [1,0,0,1,0],
        [0,1,1,0,0],
    ]},
    {"name": "cross", "grid": [
        [0,0,1,0,0],
        [0,0,1,0,0],
        [1,1,1,1,1],
        [0,0,1,0,0],
        [0,0,1,0,0],
    ]},
    {"name": "house", "grid": [
        [0,0,1,1,0,0],
        [0,1,1,1,1,0],
        [1,1,1,1,1,1],
        [1,1,0,0,1,1],
        [1,1,0,0,1,1],
        [1,1,1,1,1,1],
    ]},
    {"name": "fish", "grid": [
        [1,0,0,0,1,0],
        [0,1,0,1,1,1],
        [0,0,1,1,1,1],
        [0,1,0,1,1,1],
        [1,0,0,0,1,0],
    ]},
    {"name": "mushroom", "grid": [
        [0,1,1,1,1,0],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [0,0,1,1,0,0],
        [0,0,1,1,0,0],
        [0,1,1,1,1,0],
    ]},
    {"name": "lightning", "grid": [
        [0,0,1,1,0],
        [0,1,1,0,0],
        [1,1,1,1,0],
        [0,0,1,1,0],
        [0,0,0,1,1],
    ]},
    {"name": "face", "grid": [
        [0,1,1,1,0],
        [1,0,0,0,1],
        [1,0,1,0,1],
        [1,0,0,0,1],
        [1,0,1,1,1],
        [0,1,0,0,0],
    ]},
    {"name": "flag", "grid": [
        [1,1,1,1,0],
        [1,1,1,0,0],
        [1,1,0,0,0],
        [1,0,0,0,0],
        [1,0,0,0,0],
        [1,0,0,0,0],
    ]},
    {"name": "crown", "grid": [
        [1,0,0,0,1,0,1],
        [1,0,1,0,1,0,1],
        [1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1],
        [0,1,1,1,1,1,0],
    ]},
    {"name": "key", "grid": [
        [0,1,1,0,0],
        [1,0,0,1,0],
        [0,1,1,0,0],
        [0,0,1,0,0],
        [0,1,1,1,0],
        [0,0,1,0,0],
        [0,0,1,0,0],
    ]},
]

BW_MEDIUM: List[Dict[str, Any]] = [
    {"name": "cat", "grid": [
        [1,0,0,0,0,0,0,0,0,1],
        [1,1,0,0,0,0,0,0,1,1],
        [0,1,1,0,0,0,0,1,1,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,0,1,0,1,1,0,1,0,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,0,0,1,0,0,1,0,0,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,1,1,0,0,0,0,1,1,0],
        [0,1,0,0,0,0,0,0,1,0],
    ]},
    {"name": "robot", "grid": [
        [0,1,1,1,1,1,1,0],
        [1,1,1,1,1,1,1,1],
        [1,0,1,0,0,1,0,1],
        [1,1,1,1,1,1,1,1],
        [0,1,1,0,0,1,1,0],
        [1,1,1,1,1,1,1,1],
        [1,0,1,0,0,1,0,1],
        [1,1,1,1,1,1,1,1],
        [0,1,0,0,0,0,1,0],
        [0,1,0,0,0,0,1,0],
    ]},
    {"name": "penguin", "grid": [
        [0,0,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,0],
        [1,1,0,1,1,0,1,1],
        [1,1,1,1,1,1,1,1],
        [0,1,1,0,0,1,1,0],
        [0,1,1,1,1,1,1,0],
        [0,1,1,1,1,1,1,0],
        [0,0,1,0,0,1,0,0],
        [0,1,1,0,0,1,1,0],
        [0,1,1,0,0,1,1,0],
    ]},
    {"name": "tree", "grid": [
        [0,0,0,1,0,0,0],
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,1,1,1,1,1,1],
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,1,1,1,1,1,1],
        [0,0,0,1,0,0,0],
        [0,0,0,1,0,0,0],
        [0,0,1,1,1,0,0],
    ]},
    {"name": "ship", "grid": [
        [0,0,0,0,1,0,0,0,0,0],
        [0,0,0,1,1,0,0,0,0,0],
        [0,0,0,1,1,1,1,0,0,0],
        [0,1,1,1,1,1,1,1,1,0],
        [1,1,1,1,1,1,1,1,1,1],
        [0,1,1,1,1,1,1,1,1,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,0,0,1,1,1,1,0,0,0],
        [0,0,0,0,1,1,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],  # will be rejected — fixed below
    ]},
    {"name": "butterfly", "grid": [
        [1,1,0,0,0,0,0,1,1,0],
        [1,1,1,0,0,0,1,1,1,0],
        [0,1,1,1,0,1,1,1,0,0],
        [0,0,1,1,1,1,1,0,0,0],
        [0,0,0,1,1,1,0,0,0,0],
        [0,0,1,1,1,1,1,0,0,0],
        [0,1,1,1,0,1,1,1,0,0],
        [1,1,1,0,0,0,1,1,1,0],
        [1,1,0,0,0,0,0,1,1,0],
        [0,0,0,0,1,0,0,0,0,0],
    ]},
    {"name": "fox", "grid": [
        [1,0,0,0,0,0,0,0,0,1],
        [1,1,0,0,0,0,0,0,1,1],
        [1,1,1,0,0,0,0,1,1,1],
        [0,1,1,1,1,1,1,1,1,0],
        [0,0,1,0,1,1,0,1,0,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,0,0,1,0,0,1,0,0,0],
        [0,0,1,1,0,0,1,1,0,0],
        [0,1,1,0,0,0,0,1,1,0],
        [1,1,0,0,0,0,0,0,1,1],
    ]},
    {"name": "guitar", "grid": [
        [0,0,1,1,0,0,0,0],
        [0,1,0,0,1,0,0,0],
        [0,1,0,0,1,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,1,1,1,0,0,0],
        [0,1,1,0,1,1,0,0],
        [1,1,0,0,0,1,1,0],
        [1,1,0,1,0,1,1,0],
        [1,1,0,0,0,1,1,0],
        [0,1,1,0,1,1,0,0],
        [0,0,1,1,1,0,0,0],
    ]},
    {"name": "elephant", "grid": [
        [0,1,1,1,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1,0,0],
        [1,1,1,1,1,1,1,1,1,0],
        [1,0,1,0,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1,1,0],
        [0,1,1,1,1,1,1,1,0,0],
        [0,0,1,1,0,0,1,1,0,0],
        [0,0,1,1,0,0,1,1,0,0],
        [0,1,1,1,0,0,1,1,1,0],
        [0,1,0,0,0,0,0,0,1,0],
    ]},
    {"name": "spaceship", "grid": [
        [0,0,0,1,1,0,0,0],
        [0,0,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,0],
        [1,1,0,1,1,0,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,1,0,1,1,0,1,0],
        [1,0,0,1,1,0,0,1],
        [1,0,0,0,0,0,0,1],
        [0,0,0,0,0,0,0,0],  # will be removed
    ]},
    {"name": "duck", "grid": [
        [0,0,1,1,0,0,0,0,0,0],
        [0,1,0,0,1,0,0,0,0,0],
        [0,1,0,0,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,1,1,0],
        [1,1,1,1,1,1,1,1,1,1],
        [0,1,1,1,1,1,1,1,1,0],
        [0,0,1,1,1,1,1,1,0,0],
        [0,0,0,1,0,0,1,0,0,0],
        [0,0,0,1,0,0,1,0,0,0],
    ]},
    {"name": "anchor", "grid": [
        [0,0,1,1,1,0,0],
        [0,1,0,0,0,1,0],
        [0,0,0,1,0,0,0],
        [0,0,0,1,0,0,0],
        [1,0,0,1,0,0,1],
        [1,1,0,1,0,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,1,1,0,0],
        [0,1,0,1,0,1,0],
        [1,1,0,1,0,1,1],
    ]},
]

BW_HARD: List[Dict[str, Any]] = [
    {"name": "castle", "grid": [
        [1,1,0,1,1,0,1,1,0,1,1,0,1,1,0],
        [1,1,0,1,1,0,1,1,0,1,1,0,1,1,0],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        [1,1,1,0,0,1,1,1,1,1,0,0,1,1,1],
        [1,1,1,0,0,1,1,1,1,1,0,0,1,1,1],
        [1,1,1,1,0,1,1,1,1,1,0,1,1,1,1],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        [0,1,1,1,1,1,0,1,0,1,1,1,1,1,0],
        [0,1,1,0,0,1,0,1,0,1,0,0,1,1,0],
        [0,1,1,0,0,1,1,1,1,1,0,0,1,1,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
        [0,0,1,1,1,1,0,1,0,1,1,1,1,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
    ]},
    {"name": "lighthouse", "grid": [
        [0,0,0,0,0,1,1,0,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,0,1,0,1,1,0,1,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    ]},
    {"name": "dragon", "grid": [
        [0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0],
        [0,0,1,1,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],
        [1,1,1,0,1,1,1,1,1,0,1,1,1,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0],
        [0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0],
        [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
        [0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0],
        [0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0],
    ]},
    {"name": "knight", "grid": [
        [0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,1,1,1,0,0,1,1,1,0,0,0,0,0,0],
        [0,1,1,1,1,0,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,1,1,0,0,1,1,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],
        [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],
        [0,1,1,1,0,0,0,0,1,1,1,0,0,0,0],
    ]},
    {"name": "mermaid", "grid": [
        [0,0,1,1,1,0,0,0,0,0,0,0,0,0,0],
        [0,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
        [1,1,0,1,0,1,1,0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],
        [0,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
        [0,0,1,0,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,1,1,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0],
        [0,0,0,0,1,1,0,0,0,1,1,1,0,0,0],
        [0,0,0,1,1,0,0,0,0,0,1,1,1,0,0],
        [0,0,1,1,0,0,0,0,0,0,0,0,1,1,0],
    ]},
    {"name": "owl", "grid": [
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],
        [1,1,0,1,1,0,0,1,1,0,1,1,0,0,0],
        [1,1,0,1,0,1,1,0,1,0,1,1,0,0,0],
        [1,1,0,1,1,0,0,1,1,0,1,1,0,0,0],
        [0,1,1,0,0,1,1,0,0,1,1,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,0,0,1,1,1,0,0,0,0,0],
        [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],
        [1,1,0,0,0,0,0,0,0,0,1,1,0,0,0],
        [1,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
        [1,1,0,0,0,0,0,0,0,0,1,1,0,0,0],
        [0,1,1,1,0,0,0,0,1,1,1,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],
    ]},
    {"name": "skull", "grid": [
        [0,0,0,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [0,1,1,1,0,0,1,0,0,1,1,1,0,0,0],
        [0,1,1,0,1,0,1,0,1,0,1,1,0,0,0],
        [0,1,1,0,0,0,1,0,0,0,1,1,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,1,0,1,0,1,0,1,0,1,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,1,0,0,0,1,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0,1,1,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,0,0,0,0,0,0,0],
    ]},
    {"name": "wolf", "grid": [
        [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
        [1,1,0,0,0,0,0,0,0,0,0,0,0,1,1],
        [1,1,1,0,0,0,0,0,0,0,0,0,1,1,1],
        [0,1,1,1,0,0,0,0,0,0,0,1,1,1,0],
        [0,0,1,1,1,0,0,0,0,0,1,1,1,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,0,1,1,0,1,0,1,0,1,1,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,0,0,0,1,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,0,1,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,0,1,1,0,1,1,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,0,1,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,1,1,0,0,0,1,1,0,0,0,0],
    ]},
]

# ============================================================
# PIXEL ART PATTERNS — COLOR
# 0=empty, 1..N = color index (colors defined per pattern)
# ============================================================

# Color palette format: list of hex strings, index 1..N
COLOR_EASY: List[Dict[str, Any]] = [
    {"name": "apple", "palette": ["#C8414A", "#2E8B57"], "grid": [
        [0,2,2,2,0],
        [0,0,0,2,0],
        [1,1,1,1,0],
        [1,1,1,1,1],
        [1,1,1,1,1],
        [0,1,1,1,0],
    ]},
    {"name": "sun", "palette": ["#FFD700", "#FF8C00"], "grid": [
        [0,2,0,2,0],
        [2,1,1,1,2],
        [0,1,1,1,0],
        [2,1,1,1,2],
        [0,2,0,2,0],
    ]},
    {"name": "flower", "palette": ["#FF69B4", "#FFD700", "#228B22"], "grid": [
        [0,1,1,1,0],
        [1,1,2,1,1],
        [1,2,2,2,1],
        [1,1,2,1,1],
        [0,1,1,1,0],
        [0,0,3,0,0],
        [0,0,3,0,0],
    ]},
    {"name": "flag", "palette": ["#FF0000", "#0000FF"], "grid": [
        [1,1,1,2,2,2],
        [1,1,1,2,2,2],
        [1,1,1,2,2,2],
        [1,1,1,2,2,2],
        [1,1,1,2,2,2],
    ]},
    {"name": "bird", "palette": ["#1E90FF", "#FF8C00"], "grid": [
        [0,1,1,1,0,0],
        [1,1,1,1,1,0],
        [1,1,1,1,1,0],
        [0,2,1,1,0,0],
        [0,0,1,0,0,0],
        [0,0,2,2,0,0],
    ]},
    {"name": "candy", "palette": ["#FF4444", "#FFFFFF"], "grid": [
        [0,1,1,0],
        [1,2,2,1],
        [1,1,1,1],
        [1,2,2,1],
        [0,1,1,0],
        [0,1,0,0],
    ]},
    {"name": "leaf", "palette": ["#228B22", "#006400"], "grid": [
        [0,0,1,0,0],
        [0,1,1,2,0],
        [1,1,2,2,1],
        [1,2,2,1,1],
        [0,1,2,1,0],
        [0,0,2,0,0],
    ]},
    {"name": "icecream", "palette": ["#FFB6C1", "#A0522D", "#FFFFFF"], "grid": [
        [0,1,1,1,0],
        [1,3,1,1,1],
        [1,1,1,3,1],
        [0,1,1,1,0],
        [0,2,2,2,0],
        [0,2,2,2,0],
        [0,0,2,0,0],
    ]},
    {"name": "mushroom_color", "palette": ["#FF4444", "#FFFFFF", "#F5DEB3"], "grid": [
        [0,1,1,1,1,0],
        [1,1,2,1,2,1],
        [1,1,1,1,1,1],
        [0,0,3,3,0,0],
        [0,0,3,3,0,0],
        [0,1,3,3,1,0],
    ]},
    {"name": "rainbow", "palette": ["#FF0000", "#FF7F00", "#0000FF"], "grid": [
        [0,0,1,1,0,0],
        [0,1,1,1,1,0],
        [1,2,2,2,2,1],
        [3,3,0,0,3,3],
        [0,3,0,0,3,0],
    ]},
    {"name": "frog", "palette": ["#228B22", "#000000"], "grid": [
        [1,0,1,0,1,0],
        [1,1,1,1,1,0],
        [1,2,1,2,1,0],
        [1,1,1,1,1,0],
        [0,1,0,1,0,0],
    ]},
    {"name": "snake", "palette": ["#228B22", "#FF4444"], "grid": [
        [0,1,1,1,0],
        [1,1,0,1,1],
        [1,0,0,0,1],
        [1,1,0,1,1],
        [0,0,2,0,0],
    ]},
]

COLOR_MEDIUM: List[Dict[str, Any]] = [
    {"name": "parrot", "palette": ["#FF4444", "#228B22", "#FFD700", "#1E90FF"], "grid": [
        [0,0,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,0],
        [1,1,2,1,1,2,1,1],
        [1,1,1,1,1,1,1,1],
        [0,1,3,3,3,3,1,0],
        [0,1,4,4,4,4,1,0],
        [0,1,1,1,1,1,1,0],
        [0,0,1,0,0,1,0,0],
        [0,0,1,1,1,1,0,0],
        [0,0,3,0,0,3,0,0],
    ]},
    {"name": "sunset", "palette": ["#FF4500", "#FF8C00", "#FFD700", "#87CEEB"], "grid": [
        [4,4,4,4,4,4,4,4],
        [4,4,4,4,4,4,4,4],
        [4,4,3,4,4,3,4,4],
        [3,3,3,3,3,3,3,3],
        [3,2,2,3,3,2,2,3],
        [2,2,2,2,2,2,2,2],
        [1,2,1,2,2,1,2,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
    ]},
    {"name": "fish_color", "palette": ["#FF8C00", "#1E90FF", "#FFFFFF"], "grid": [
        [0,0,0,1,0,0,0,0],
        [0,0,1,1,1,0,0,0],
        [1,0,1,1,1,1,0,0],
        [1,1,1,3,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,2,1,2,1,1,0],
        [0,1,1,1,1,1,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,1,0,0,1,0,0],
        [0,1,0,0,0,0,1,0],
    ]},
    {"name": "robot_color", "palette": ["#B0C4DE", "#FF4444", "#00FF00", "#FFD700"], "grid": [
        [0,1,1,1,1,1,1,0],
        [1,1,4,1,1,4,1,1],
        [1,1,4,4,4,4,1,1],
        [1,1,1,1,1,1,1,1],
        [0,1,2,1,1,2,1,0],
        [0,1,3,3,3,3,1,0],
        [1,1,1,1,1,1,1,1],
        [1,0,1,0,0,1,0,1],
        [1,0,1,0,0,1,0,1],
        [0,0,1,1,1,1,0,0],
    ]},
    {"name": "turtle", "palette": ["#228B22", "#006400", "#8B4513"], "grid": [
        [0,0,2,2,2,0,0,0],
        [0,2,2,2,2,2,0,0],
        [1,1,2,2,2,1,1,0],
        [1,2,2,2,2,2,1,0],
        [0,1,1,1,1,1,0,0],
        [0,0,3,0,3,0,0,0],
        [0,0,3,0,3,0,0,0],
        [0,0,3,3,3,3,0,0],
        [0,0,0,3,3,0,0,0],
        [0,0,0,3,3,0,0,0],
    ]},
    {"name": "butterfly_color", "palette": ["#FF69B4", "#FF8C00", "#000000"], "grid": [
        [1,1,0,0,0,0,2,2],
        [1,1,1,0,0,2,2,2],
        [1,1,1,1,2,2,2,0],
        [0,1,1,1,2,2,0,0],
        [0,0,3,1,2,3,0,0],
        [0,1,1,1,2,2,0,0],
        [1,1,1,1,2,2,2,0],
        [1,1,1,0,0,2,2,2],
        [1,1,0,0,0,0,2,2],
        [0,0,0,3,3,0,0,0],
    ]},
    {"name": "house_color", "palette": ["#8B4513", "#FF4444", "#87CEEB", "#228B22"], "grid": [
        [0,0,0,2,0,0,0,0],
        [0,0,2,2,2,0,0,0],
        [0,2,2,2,2,2,0,0],
        [2,2,2,2,2,2,2,0],
        [1,1,1,1,1,1,1,0],
        [1,3,3,1,1,3,1,0],
        [1,3,3,1,1,3,1,0],
        [1,1,1,1,0,1,1,0],
        [1,1,1,1,0,1,1,0],
        [4,4,4,4,4,4,4,4],
    ]},
    {"name": "peacock", "palette": ["#008B8B", "#1E90FF", "#228B22", "#FFD700"], "grid": [
        [0,0,0,1,0,0,0,0],
        [0,0,1,1,1,0,0,0],
        [0,1,2,1,2,1,0,0],
        [1,1,1,1,1,1,1,0],
        [1,3,1,1,1,3,1,0],
        [0,1,1,4,1,1,0,0],
        [0,0,1,4,1,0,0,0],
        [0,0,3,4,3,0,0,0],
        [0,0,3,3,3,0,0,0],
        [0,0,3,0,3,0,0,0],
    ]},
    {"name": "fox_color", "palette": ["#FF8C00", "#FFFFFF", "#000000"], "grid": [
        [1,0,0,0,0,0,0,1],
        [1,1,0,0,0,0,1,1],
        [1,1,1,0,0,1,1,1],
        [0,1,1,1,1,1,1,0],
        [0,0,1,3,3,1,0,0],
        [0,0,1,1,1,1,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,2,2,2,2,0,0],
        [0,1,2,0,0,2,1,0],
        [1,1,0,0,0,0,1,1],
    ]},
    {"name": "clownfish", "palette": ["#FF8C00", "#FFFFFF", "#000000"], "grid": [
        [0,0,3,1,1,3,0,0],
        [0,3,1,2,2,1,3,0],
        [3,1,2,2,2,2,1,3],
        [1,2,2,1,1,2,2,1],
        [1,2,1,1,1,1,2,1],
        [1,2,2,1,1,2,2,1],
        [3,1,2,2,2,2,1,3],
        [0,3,1,2,2,1,3,0],
        [0,0,3,1,1,3,0,0],
        [0,0,0,3,3,0,0,0],
    ]},
    {"name": "cactus", "palette": ["#228B22", "#90EE90", "#FFD700"], "grid": [
        [0,0,1,1,0,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,1,1,1,1,0,0,0],
        [0,1,2,2,1,0,1,1],
        [1,1,2,2,1,1,1,1],
        [1,2,2,2,2,2,2,1],
        [0,1,1,1,1,1,1,0],
        [0,0,1,3,3,1,0,0],
        [0,0,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,0],
    ]},
    {"name": "panda", "palette": ["#000000", "#FFFFFF", "#FFB6C1"], "grid": [
        [0,1,1,1,1,1,1,0],
        [1,1,2,1,1,2,1,1],
        [1,2,2,2,2,2,2,1],
        [1,2,1,2,2,1,2,1],
        [1,2,2,2,2,2,2,1],
        [0,1,2,3,3,2,1,0],
        [0,1,2,2,2,2,1,0],
        [0,1,1,1,1,1,1,0],
        [0,1,0,0,0,0,1,0],
        [0,1,1,0,0,1,1,0],
    ]},
]

COLOR_HARD: List[Dict[str, Any]] = [
    {"name": "tropical_bird", "palette": ["#FF4444", "#FFD700", "#228B22", "#1E90FF", "#FF8C00"], "grid": [
        [0,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,1,1,1,1,0,0,0,0,0,0],
        [0,1,2,1,1,2,1,0,0,0,0,0],
        [1,1,1,1,1,1,1,1,0,0,0,0],
        [1,3,3,1,1,3,3,1,0,0,0,0],
        [1,1,4,4,4,4,1,1,0,0,0,0],
        [0,1,4,4,4,4,1,0,0,0,0,0],
        [0,1,5,5,5,5,1,0,0,0,0,0],
        [0,0,1,5,5,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,0,0,0,0,0,0],
        [0,0,5,0,0,5,0,0,0,0,0,0],
        [0,0,5,5,5,5,0,0,0,0,0,0],
    ]},
    {"name": "seahorse", "palette": ["#FF8C00", "#FFD700", "#228B22", "#87CEEB"], "grid": [
        [0,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,1,1,1,1,0,0,0,0,0,0],
        [0,1,2,1,1,2,1,0,0,0,0,0],
        [0,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,1,1,3,1,0,0,0,0,0,0],
        [0,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,0,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,0,0,0,0,0,0],
    ]},
    {"name": "forest", "palette": ["#006400", "#228B22", "#8B4513", "#87CEEB", "#FFD700"], "grid": [
        [4,4,4,4,4,4,4,4,4,4,4,4],
        [4,4,4,5,4,4,4,5,4,4,4,4],
        [4,4,2,2,2,4,2,2,2,4,4,4],
        [4,2,2,2,2,2,2,2,2,2,4,4],
        [2,2,2,2,2,2,1,2,2,2,2,4],
        [2,2,1,2,2,1,1,1,2,2,2,2],
        [2,1,1,1,1,1,1,1,1,2,2,2],
        [1,1,1,1,1,1,1,1,1,1,2,2],
        [3,3,1,1,1,1,1,1,1,3,3,2],
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
    ]},
    {"name": "coral_reef", "palette": ["#FF4444", "#FF8C00", "#1E90FF", "#228B22", "#FFD700"], "grid": [
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,3,3,3,1,3,3,1,3,3,3,3],
        [3,3,1,1,1,1,1,1,1,3,3,3],
        [3,1,1,2,1,1,2,1,1,1,3,3],
        [3,1,2,2,2,2,2,2,2,1,3,3],
        [3,1,2,5,2,2,5,2,2,1,3,3],
        [3,1,4,4,4,2,4,4,4,1,3,3],
        [4,4,4,4,4,4,4,4,4,4,4,3],
        [4,4,4,4,4,3,4,4,4,4,4,4],
        [4,4,4,3,4,4,4,3,4,4,4,4],
        [4,4,3,4,4,4,4,4,3,4,4,4],
        [4,3,4,4,4,4,4,4,4,3,4,4],
    ]},
    {"name": "astronaut", "palette": ["#FFFFFF", "#B0C4DE", "#1E90FF", "#FF8C00", "#000000"], "grid": [
        [0,0,1,1,1,1,1,1,0,0,0,0],
        [0,1,1,1,1,1,1,1,1,0,0,0],
        [1,1,2,1,1,1,1,2,1,1,0,0],
        [1,2,2,2,2,2,2,2,2,1,0,0],
        [1,2,5,2,3,3,2,5,2,1,0,0],
        [1,2,2,2,2,2,2,2,2,1,0,0],
        [1,1,2,2,2,2,2,2,1,1,0,0],
        [0,1,1,1,1,1,1,1,1,0,0,0],
        [0,1,4,1,1,1,1,4,1,0,0,0],
        [0,1,1,1,1,1,1,1,1,0,0,0],
        [0,0,1,1,0,0,1,1,0,0,0,0],
        [0,0,1,1,0,0,1,1,0,0,0,0],
    ]},
    {"name": "koi_fish", "palette": ["#FF4444", "#FFFFFF", "#000000", "#FF8C00"], "grid": [
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,1,1,1,3,3,3,3,3,3,3,3],
        [1,1,4,1,1,3,3,3,3,3,3,3],
        [1,4,4,4,1,1,3,3,3,3,3,3],
        [1,1,4,4,4,1,1,3,3,3,3,3],
        [3,1,1,4,4,4,1,1,3,3,3,3],
        [3,3,2,2,4,4,1,2,1,3,3,3],
        [3,3,2,2,2,1,1,2,2,3,3,3],
        [3,3,3,2,2,2,2,2,3,3,3,3],
        [3,3,3,3,2,2,2,3,3,3,3,3],
        [3,3,3,3,3,2,3,3,3,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
    ]},
    {"name": "wizard", "palette": ["#4B0082", "#FFD700", "#87CEEB", "#FFFFFF", "#FF4444"], "grid": [
        [0,0,0,1,0,0,0,0,0,0,0,0],
        [0,0,1,1,1,0,0,0,0,0,0,0],
        [0,1,1,2,1,1,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,0,0,0,0,0],
        [0,1,3,3,3,1,0,0,0,0,0,0],
        [0,1,3,4,3,1,0,0,0,0,0,0],
        [0,1,1,1,1,1,0,0,0,0,0,0],
        [0,1,1,1,1,1,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,0,0,0,0,0],
        [1,0,1,1,1,1,0,1,0,0,0,0],
        [1,0,0,1,1,0,0,1,0,0,0,0],
        [5,0,0,0,0,0,0,5,0,0,0,0],
    ]},
    {"name": "mountain_sunset", "palette": ["#FF4500", "#FF8C00", "#4B0082", "#87CEEB", "#FFFFFF"], "grid": [
        [4,4,4,4,4,4,4,4,4,4,4,4],
        [4,4,4,5,4,4,4,5,4,4,4,4],
        [4,4,4,5,5,4,4,5,5,4,4,4],
        [4,4,1,1,1,4,1,1,1,4,4,4],
        [4,1,1,1,1,1,1,1,1,1,4,4],
        [4,1,2,1,1,1,1,1,2,1,4,4],
        [1,2,2,2,1,1,1,2,2,2,1,4],
        [2,2,2,2,2,3,2,2,2,2,2,2],
        [3,3,2,2,3,3,3,2,2,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
        [3,3,3,3,3,3,3,3,3,3,3,3],
    ]},
    {"name": "peacock_full", "palette": ["#008B8B", "#1E90FF", "#228B22", "#FFD700", "#9370DB"], "grid": [
        [3,1,3,3,3,3,3,3,3,3,3,3],
        [3,1,1,3,3,3,3,3,3,3,3,3],
        [3,1,2,1,3,3,3,3,3,3,3,3],
        [3,1,2,2,1,3,3,3,3,3,3,3],
        [3,3,1,1,1,1,3,3,3,3,3,3],
        [3,4,5,1,1,5,4,3,3,3,3,3],
        [4,4,5,5,5,5,4,4,3,3,3,3],
        [3,4,2,2,2,2,4,3,3,3,3,3],
        [3,3,2,3,3,2,3,3,3,3,3,3],
        [3,3,2,3,3,2,3,3,3,3,3,3],
        [3,3,2,2,2,2,3,3,3,3,3,3],
        [3,3,3,2,2,3,3,3,3,3,3,3],
    ]},
    {"name": "dragon_color", "palette": ["#228B22", "#FF4444", "#FFD700", "#000000"], "grid": [
        [0,0,1,1,0,0,0,0,0,0,0,0],
        [0,1,1,1,1,0,0,0,0,0,0,0],
        [1,1,3,3,3,1,0,0,0,0,0,0],
        [1,3,3,3,3,3,1,0,0,0,0,0],
        [1,1,2,3,3,2,1,0,0,0,0,0],
        [0,1,3,3,3,3,1,0,0,0,0,0],
        [0,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,1,1,1,1,0,0,0,0,0,0],
        [0,1,1,0,0,1,1,0,0,0,0,0],
        [1,1,0,0,0,0,1,1,0,0,0,0],
        [1,0,0,0,0,0,0,1,0,0,0,0],
        [4,0,0,0,0,0,0,4,0,0,0,0],
    ]},
    {"name": "city_night", "palette": ["#1a1a2e", "#4B0082", "#FFD700", "#FF4444", "#87CEEB"], "grid": [
        [2,5,5,5,5,2,2,2,5,5,5,2],
        [2,5,3,5,5,2,2,2,5,3,5,2],
        [1,1,1,1,1,1,1,1,1,1,1,1],
        [1,3,1,3,1,1,1,3,1,3,1,1],
        [1,1,1,1,1,1,1,1,1,1,1,1],
        [1,3,1,3,1,1,1,3,1,3,1,1],
        [1,1,1,1,1,1,1,1,1,1,1,1],
        [4,4,4,4,4,4,4,4,4,4,4,4],
        [1,1,1,1,1,3,1,1,1,1,1,1],
        [1,3,1,1,1,3,1,3,1,1,3,1],
        [1,1,1,1,1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1,1,1,1,1],
    ]},
]

# ============================================================
# NONOGRAM SOLVER (Line-Solving + Backtracking)
# ============================================================

def compute_bw_clues(grid: List[List[int]]) -> Tuple[List[List[int]], List[List[int]]]:
    rows = len(grid)
    cols = len(grid[0])
    row_clues = []
    for r in range(rows):
        clue, count = [], 0
        for c in range(cols):
            if grid[r][c]: count += 1
            elif count > 0: clue.append(count); count = 0
        if count > 0: clue.append(count)
        row_clues.append(clue if clue else [0])
    col_clues = []
    for c in range(cols):
        clue, count = [], 0
        for r in range(rows):
            if grid[r][c]: count += 1
            elif count > 0: clue.append(count); count = 0
        if count > 0: clue.append(count)
        col_clues.append(clue if clue else [0])
    return row_clues, col_clues


def compute_color_clues(grid: List[List[int]]) -> Tuple[List[List[Tuple[int,int]]], List[List[Tuple[int,int]]]]:
    """Returns clues as list of (color, length) tuples. 0 means empty."""
    rows = len(grid)
    cols = len(grid[0])
    row_clues = []
    for r in range(rows):
        clue = []
        prev, count = 0, 0
        for c in range(cols):
            v = grid[r][c]
            if v == 0:
                if count > 0 and prev > 0: clue.append((prev, count))
                prev, count = 0, 0
            elif v == prev:
                count += 1
            else:
                if count > 0 and prev > 0: clue.append((prev, count))
                prev, count = v, 1
        if count > 0 and prev > 0: clue.append((prev, count))
        row_clues.append(clue)
    col_clues = []
    for c in range(cols):
        clue = []
        prev, count = 0, 0
        for r in range(rows):
            v = grid[r][c]
            if v == 0:
                if count > 0 and prev > 0: clue.append((prev, count))
                prev, count = 0, 0
            elif v == prev:
                count += 1
            else:
                if count > 0 and prev > 0: clue.append((prev, count))
                prev, count = v, 1
        if count > 0 and prev > 0: clue.append((prev, count))
        col_clues.append(clue)
    return row_clues, col_clues


def _line_possibilities(clue: List[int], length: int) -> List[List[int]]:
    """All valid placements for a B&W clue in a line of given length."""
    if not clue or clue == [0]:
        return [[0] * length]
    results = []
    def backtrack(idx, pos, line):
        if idx == len(clue):
            full = line + [0] * (length - pos)
            results.append(full)
            return
        block = clue[idx]
        min_remaining = sum(clue[idx+1:]) + len(clue[idx+1:])
        for start in range(pos, length - block - min_remaining + 1):
            new_line = line + [0] * (start - pos) + [1] * block
            gap = 0 if idx == len(clue) - 1 else 1
            backtrack(idx + 1, start + block + gap, new_line)
    backtrack(0, 0, [])
    return results


def _solve_line(clue: List[int], known: List[int]) -> Optional[List[int]]:
    """
    known: -1=unknown, 0=empty, 1=filled
    Returns updated line or None if contradiction.
    """
    length = len(known)
    possibilities = [p for p in _line_possibilities(clue, length)
                     if all(known[i] == -1 or known[i] == p[i] for i in range(length))]
    if not possibilities:
        return None
    result = []
    for i in range(length):
        vals = set(p[i] for p in possibilities)
        if len(vals) == 1:
            result.append(vals.pop())
        else:
            result.append(-1)
    return result


def _is_solved(grid: List[List[int]]) -> bool:
    return all(cell != -1 for row in grid for cell in row)


def _line_solve(row_clues: List[List[int]], col_clues: List[List[int]],
                rows: int, cols: int) -> Optional[List[List[int]]]:
    grid = [[-1] * cols for _ in range(rows)]
    changed = True
    while changed:
        changed = False
        for r in range(rows):
            updated = _solve_line(row_clues[r], grid[r])
            if updated is None: return None
            for c in range(cols):
                if grid[r][c] == -1 and updated[c] != -1:
                    grid[r][c] = updated[c]; changed = True
        for c in range(cols):
            col = [grid[r][c] for r in range(rows)]
            updated = _solve_line(col_clues[c], col)
            if updated is None: return None
            for r in range(rows):
                if grid[r][c] == -1 and updated[r] != -1:
                    grid[r][c] = updated[r]; changed = True
    return grid


def check_unique(row_clues: List[List[int]], col_clues: List[List[int]],
                 rows: int, cols: int) -> bool:
    """Returns True if puzzle has exactly one solution (via backtracking, limit=2)."""
    partial = _line_solve(row_clues, col_clues, rows, cols)
    if partial is None:
        return False
    if _is_solved(partial):
        return True
    solutions = []
    def backtrack(grid):
        if len(solutions) >= 2: return
        # find first unknown
        pos = None
        for r in range(rows):
            for c in range(cols):
                if grid[r][c] == -1:
                    pos = (r, c); break
            if pos: break
        if pos is None:
            solutions.append(1); return
        r, c = pos
        for val in [0, 1]:
            new_grid = [row[:] for row in grid]
            new_grid[r][c] = val
            # quick line check
            ok = True
            row_line = _solve_line(row_clues[r], new_grid[r])
            if row_line is None: ok = False
            else:
                for cc in range(cols):
                    if new_grid[r][cc] == -1 and row_line[cc] != -1:
                        new_grid[r][cc] = row_line[cc]
            if ok:
                col_line = _solve_line(col_clues[c], [new_grid[rr][c] for rr in range(rows)])
                if col_line is None: ok = False
                else:
                    for rr in range(rows):
                        if new_grid[rr][c] == -1 and col_line[rr] != -1:
                            new_grid[rr][c] = col_line[rr]
            if ok:
                further = _line_solve(row_clues, col_clues, rows, cols)
                if further is not None:
                    backtrack(further if further is not None else new_grid)
    backtrack(partial)
    return len(solutions) == 1


# ============================================================
# VALIDATION
# ============================================================

def has_empty_line(grid: List[List[int]]) -> bool:
    rows, cols = len(grid), len(grid[0])
    for r in range(rows):
        if all(grid[r][c] == 0 for c in range(cols)):
            return True
    for c in range(cols):
        if all(grid[r][c] == 0 for r in range(rows)):
            return True
    return False


def trim_empty_border(grid: List[List[int]]) -> Optional[List[List[int]]]:
    """Remove all-zero border rows/cols. Returns None if nothing left."""
    g = [row[:] for row in grid]
    while g and all(v == 0 for v in g[0]):   g.pop(0)
    while g and all(v == 0 for v in g[-1]):  g.pop()
    if not g: return None
    while g[0] and all(row[0] == 0 for row in g):
        g = [row[1:] for row in g]
    while g[0] and all(row[-1] == 0 for row in g):
        g = [row[:-1] for row in g]
    if not g or not g[0]: return None
    return g


# ============================================================
# XML OUTPUT
# ============================================================

def _pretty_xml(elem: ET.Element) -> str:
    rough = ET.tostring(elem, encoding="unicode")
    reparsed = minidom.parseString(rough)
    return reparsed.toprettyxml(indent="  ", encoding=None)


def save_bw_nonogram(grid: List[List[int]], name: str, path: str):
    root = ET.Element("FreeNono")
    nono_list = ET.SubElement(root, "Nonograms")
    rows, cols = len(grid), len(grid[0])
    nono = ET.SubElement(nono_list, "Nonogram",
                         name=name, height=str(rows), width=str(cols))
    for row in grid:
        line_el = ET.SubElement(nono, "line")
        line_el.text = " " + " ".join("x" if v else "_" for v in row) + " "
    xml_str = _pretty_xml(root)
    with open(path, "w", encoding="utf-8") as f:
        f.write(xml_str)


def save_color_nonogram(grid: List[List[int]], palette: List[str], name: str, path: str):
    root = ET.Element("FreeNono")
    nono_list = ET.SubElement(root, "Nonograms")
    rows, cols = len(grid), len(grid[0])
    nono = ET.SubElement(nono_list, "Nonogram",
                         name=name, height=str(rows), width=str(cols), type="color")
    pal_el = ET.SubElement(nono, "palette")
    for i, hex_color in enumerate(palette, start=1):
        ET.SubElement(pal_el, "color", index=str(i), hex=hex_color)
    for row in grid:
        line_el = ET.SubElement(nono, "line")
        line_el.text = " " + " ".join(str(v) for v in row) + " "
    xml_str = _pretty_xml(root)
    with open(path, "w", encoding="utf-8") as f:
        f.write(xml_str)


# ============================================================
# AUGMENTATION (flip/transpose for more variety)
# ============================================================

def augment(patterns: List[Dict]) -> List[Dict]:
    result = []
    seen_names = set()
    for p in patterns:
        g = p["grid"]
        variants = [
            (p["name"], g),
            (p["name"] + "_hflip", [row[::-1] for row in g]),
            (p["name"] + "_vflip", list(reversed(g))),
            (p["name"] + "_rot90", list(map(list, zip(*g[::-1])))),
        ]
        extra = p.copy()
        for vname, vg in variants:
            if vname not in seen_names:
                entry = dict(p)
                entry["name"] = vname
                entry["grid"] = vg
                result.append(entry)
                seen_names.add(vname)
    return result


# ============================================================
# MAIN GENERATION
# ============================================================

def process_bw(patterns: List[Dict], category: str, target_count: int = 10) -> int:
    out_dir = os.path.join(OUTPUT_DIR, category)
    os.makedirs(out_dir, exist_ok=True)
    # clear old files
    for f in os.listdir(out_dir):
        if f.endswith(".nonogram"):
            os.remove(os.path.join(out_dir, f))

    augmented = augment(patterns)
    saved = 0
    for p in augmented:
        if saved >= max(target_count, len(patterns)):
            break
        grid = p["grid"]
        trimmed = trim_empty_border(grid)
        if trimmed is None or has_empty_line(trimmed):
            trimmed = grid
        if has_empty_line(trimmed):
            print(f"  SKIP {p['name']}: has empty row/col")
            continue
        rows, cols = len(trimmed), len(trimmed[0])
        row_clues, col_clues = compute_bw_clues(trimmed)
        # skip trivially empty clues
        if any(c == [0] for c in row_clues) or any(c == [0] for c in col_clues):
            print(f"  SKIP {p['name']}: zero clue")
            continue
        fname = f"{saved+1:03d}_{p['name']}.nonogram"
        fpath = os.path.join(out_dir, fname)
        save_bw_nonogram(trimmed, p["name"], fpath)
        print(f"  SAVED [{category}] {fname} ({rows}x{cols})")
        saved += 1
    print(f"  → {saved} puzzles in '{category}'")
    return saved


def process_color(patterns: List[Dict], category: str, target_count: int = 10) -> int:
    out_dir = os.path.join(OUTPUT_DIR, category)
    os.makedirs(out_dir, exist_ok=True)
    for f in os.listdir(out_dir):
        if f.endswith(".cnonogram"):
            os.remove(os.path.join(out_dir, f))

    augmented = augment(patterns)
    saved = 0
    for p in augmented:
        if saved >= max(target_count, len(patterns)):
            break
        grid = p["grid"]
        trimmed = trim_empty_border(grid)
        if trimmed is None:
            trimmed = grid
        if has_empty_line(trimmed):
            print(f"  SKIP {p['name']}: has empty row/col")
            continue
        rows, cols = len(trimmed), len(trimmed[0])
        palette = p["palette"]
        fname = f"{saved+1:03d}_{p['name']}.cnonogram"
        fpath = os.path.join(out_dir, fname)
        save_color_nonogram(trimmed, palette, p["name"], fpath)
        print(f"  SAVED [{category}] {fname} ({rows}x{cols}, {len(palette)} colors)")
        saved += 1
    print(f"  → {saved} puzzles in '{category}'")
    return saved


def main():
    print("=== Nonogram Puzzle Generator ===")
    print(f"Output: {OUTPUT_DIR}\n")

    # Delete old B&W puzzles
    for cat in ["easy", "medium", "hard"]:
        d = os.path.join(OUTPUT_DIR, cat)
        if os.path.isdir(d):
            for f in os.listdir(d):
                if f.endswith(".nonogram"):
                    os.remove(os.path.join(d, f))
            print(f"Cleared {cat}/")

    print("\n--- B&W Easy ---")
    process_bw(BW_EASY, "easy", 10)

    print("\n--- B&W Medium ---")
    process_bw(BW_MEDIUM, "medium", 10)

    print("\n--- B&W Hard ---")
    process_bw(BW_HARD, "hard", 10)

    print("\n--- Color Easy ---")
    process_color(COLOR_EASY, "color-easy", 10)

    print("\n--- Color Medium ---")
    process_color(COLOR_MEDIUM, "color-medium", 10)

    print("\n--- Color Hard ---")
    process_color(COLOR_HARD, "color-hard", 10)

    print("\nDone!")


if __name__ == "__main__":
    main()
