# define keyboard layout
class profile::keyboard {
  exec { 'xkeyboardlayout':
      command => "/usr/bin/setxkbmap -layout ${lookup('keyboard', String)}",
  }
}
