# install/uninstall/update programs
class profile::packages {
  lookup('packages', Hash, 'hash').each | String $providername, Hash $providerattributes | {
    if $providername == 'yay' {
      $yaycodedir='/tmp/yay-bin'
      vcsrepo { $yaycodedir:
        ensure   => present,
        provider => git,
        notify   => [Exec['build yay'],File[$yaycodedir]],
        source   => 'https://aur.archlinux.org/yay-bin.git',
      }
      file { $yaycodedir:
        ensure  => directory,
        recurse => true,
        owner   => 'nobody',
        group   => 'nobody',
      }
      exec { 'build yay':
        command => '/usr/bin/sudo -u nobody /usr/bin/makepkg -sf --needed --noconfirm --noprogressbar',
        cwd     => $yaycodedir,
        notify  => Exec['install yay'],
        require => [Package['git'],Vcsrepo[$yaycodedir]],
      }
      exec { 'install yay':
        command => '/usr/bin/pacman -U ./yay-bin*.pkg.tar.zst --needed --noconfirm --noprogressbar',
        cwd     => $yaycodedir,
        creates => '/usr/bin/yay',
        require => [Package['git'],Vcsrepo[$yaycodedir]],
      }
    }
    $providerattributes.each | String $packagename, Hash $attributes | {
      case $providername {
        'yay': {
          exec { "yayinstall_${packagename}":
            command => "/usr/bin/sudo -u vagrant /usr/bin/yay -S --needed --noconfirm --noprogressbar ${packagename}",
            require => Exec['install yay'],
          }
        }
        default: {
          package { $packagename:
            ensure   => if $attributes['ensure'] { $attributes['ensure'] } else { 'latest' },
            provider => $providername,
          }
        }
      }
    }
  }
}
