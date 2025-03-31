#!/usr/bin/env nu

def anim [frames, rate, infinite?: bool = false] {
  loop {
    $frames | each {|frame|
      print -n $"  ($frame)\r"
      sleep (($rate | into duration) * 1_000_000)
    }

    if not $infinite {
      break
    }
  }
}

def main [
  name: string
  --frames (-f)
  --infinite (-i)
] {
  let spinner = open spinners.json
  | get $name

  if $frames {
    $spinner.frames
  } else {
    # listen for input
    job spawn {
      loop {
        input listen --types [key]
        exit
      }
    }
    
    # animate spinner
    anim $spinner.frames $spinner.interval $infinite
    exit
  }
}