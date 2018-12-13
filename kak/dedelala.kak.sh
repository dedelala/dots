#!/bin/bash

blu="rgb:74d7ec"
bbl="rgb:7490ee"
orn="rgb:ee925d"
pnk="rgb:ffafc7"
prp="rgb:d97dff"
wht="rgb:fbf9f5"
red="rgb:ff6666"

#dblu="rgb:00323d"
mblu="rgb:00218F"
dblu="rgb:000F40"

#mprp="rgb:5a0080"
dprp="rgb:2d0040"

while read -r f v; do [[ -n $f ]] && echo "face global $f $v"; done <<🐈
value       $orn
type        $prp
identifier  $prp
variable    $prp
function    $blu
module      $prp
string      $pnk
error       $red
keyword     $blu
operator    $blu
attribute   $blu
comment     $bbl+i
meta        $blu
builtin     $blu

title       $blu
header      $pnk
bold        $wht+b
italic      $wht+i
mono        $wht
block       $wht
link        $prp
bullet      $wht
list        $wht
Default     $wht

PrimarySelection    default,$mblu
PrimaryCursor       $dprp,$blu
PrimaryCursorEol    default,$orn
SecondarySelection  default,$mblu
SecondaryCursor     $dprp,$pnk
SecondaryCursorEol  default,$orn

MatchingChar      $blu+b
Search            default
CurrentWord       default
Whitespace        default
BufferPadding     default
LineNumbers       $pnk
LineNumberCursor  $blu

MenuForeground   $pnk,$dblu
MenuBackground   $blu,$dblu
MenuInfo         $pnk,$dblu
Information      $pnk,$dblu
Error            $red
StatusLine       $wht,$dprp
StatusLineMode   $blu
StatusLineInfo   $pnk
StatusLineValue  $orn
StatusCursor     $dprp,$pnk
Prompt           $wht
🐈
