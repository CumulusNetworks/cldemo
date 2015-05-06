class base::role::switch {
  include stdlib

  class { 'base::license':
    stage => 'setup',
  }

  include base::interfaces,
    base::motd,
    base::ntpclient,
    base::users
}
