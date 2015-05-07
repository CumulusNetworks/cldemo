class base::users {

  base::sudo_user { 'cumulus':
    privileges => ['ALL = (root) NOPASSWD: ALL']
  }

}
