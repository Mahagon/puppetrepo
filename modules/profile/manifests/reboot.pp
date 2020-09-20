# manage reboot
class profile::reboot {
  if $facts['uptime_seconds'] < 120 {
    $rebootforbidden = true
  } else  {
    $rebootforbidden = false
  }
  reboot { 'finished':
    message => 'puppet reboot - apply mode finished',
    apply   => 'finished',
    timeout => 0,
    unless  => $rebootforbidden
  }
  reboot { 'immediately':
    message => 'puppet reboot - apply mode immediately',
    apply   => 'immediately',
    timeout => 0,
    unless  => $rebootforbidden
  }
  reboot { 'immediately_ignorerebootallowed':
    message => 'puppet reboot - apply mode immediately_ignorerebootallowed',
    apply   => 'immediately',
    timeout => 0,
  }
}
