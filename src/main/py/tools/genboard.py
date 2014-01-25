#
# aciv

import argparse
import os

import xml.etree.ElementTree as etree

import microtome.xml_support as xml_support

import aciv.game_desc as game_desc
from tools.board_generator import BoardGenerator

def genboard(csv_file, output_file, name, width, height):
    # generate our board
    board = BoardGenerator(os.path.abspath(csv_file), name, width, height).board

    # serialize to XML
    root = etree.Element("microtome")
    game_desc.create_ctx().write(board, xml_support.create_writer(root))
    xml_support.indent(root)

    # write to disk
    etree.ElementTree(root).write(output_file)

def main():
    ap = argparse.ArgumentParser()
    # optional args
    ap.add_argument("--width", help="board width")
    ap.add_argument("--height", help="board height")
    ap.add_argument("--name", help="board name")
    # required args
    ap.add_argument("csv_file")
    ap.add_argument("output_file")
    args = ap.parse_args()

    genboard(args.csv_file, args.output_file, args.name or "board", args.width or 0, args.height or 0)
