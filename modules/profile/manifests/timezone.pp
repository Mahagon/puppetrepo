# define timezone
class profile::timezone {
  class { 'timezone':
    timezone => lookup('timezone', String),
  }
}
