# manage services
class profile::services {
  lookup('services', Hash, 'hash').each | String $servicename, Hash $attributes | {
    service { $servicename:
      ensure => if $attributes['ensure'] { $attributes['ensure'] },
      enable => if $attributes['enable'] { $attributes['enable'] },
      notify => if $attributes['reboottype'] { Reboot[$attributes['reboottype']] }
    }
  }
}
