#!/usr/bin/env python3
"""Deterministically format and validate Markdown tables outside fenced code blocks."""
from __future__ import annotations
import argparse, re, unicodedata
from pathlib import Path

def width(s: str) -> int:
    return sum(0 if unicodedata.combining(c) else 2 if unicodedata.east_asian_width(c) in 'WF' else 1 for c in s)
def cells(line: str) -> list[str]: return [x.strip() for x in line.strip()[1:-1].split('|')]
def is_sep(row: list[str]) -> bool: return bool(row) and all(re.fullmatch(r':?-{3,}:?', x) for x in row)
def format_text(text: str) -> tuple[str,int]:
    lines=text.splitlines(keepends=True); out=[]; i=0; fence=False; tables=0
    while i<len(lines):
        if lines[i].lstrip().startswith('```'): fence=not fence; out.append(lines[i]); i+=1; continue
        if not fence and i+1<len(lines) and lines[i].startswith('|') and lines[i+1].startswith('|'):
            end=i+2
            while end<len(lines) and lines[end].startswith('|'): end+=1
            rows=[cells(x) for x in lines[i:end]]
            if len(rows)>=2 and is_sep(rows[1]):
                n=len(rows[0]); assert all(len(r)==n for r in rows), 'inconsistent table columns'
                data=[rows[0]]+rows[2:]; widths=[max(3,max(width(r[j]) for r in data)) for j in range(n)]
                rendered=[]
                for k,row in enumerate(rows):
                    if k==1: row=['-'*widths[j] for j in range(n)]
                    rendered.append('| '+' | '.join(c+' '*(widths[j]-width(c)) for j,c in enumerate(row))+' |\n')
                out.extend(rendered); i=end; tables+=1; continue
        out.append(lines[i]); i+=1
    return ''.join(out),tables

def main() -> int:
    ap=argparse.ArgumentParser(); ap.add_argument('file',type=Path); ap.add_argument('--check',action='store_true'); args=ap.parse_args()
    original=args.file.read_text(); formatted,count=format_text(original)
    if count==0: raise SystemExit('no Markdown tables found')
    again,_=format_text(formatted)
    if again!=formatted: raise SystemExit('formatter is not idempotent')
    if args.check:
        if original!=formatted: print(f'{args.file}: {count} table(s) need formatting'); return 1
        print(f'{args.file}: {count} table(s) valid and stable')
    else:
        args.file.write_text(formatted); print(f'{args.file}: formatted {count} table(s)')
    return 0
if __name__=='__main__': raise SystemExit(main())
