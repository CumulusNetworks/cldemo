#!/bin/bash

# Should we ignore linter failures?
IGNORE_FAILURES=0
# Did all of the linters pass?
RET_SUCCESS=0

while getopts ":i" OPT; do
  case $OPT in
    i)
      IGNORE_FAILURES=1
      ;;
    \?)
      echo "Unknown option: -$OPTARG" >&2
      ;;
  esac
done

# Check and install dependencies
# Ruby dependencies (Puppet, Chef)
for GEM in puppet-lint foodcritic; do
  gem list | grep $GEM 2>&1 >/dev/null 
  if [ $? -ne 0 ]; then
    gem install $GEM
  fi
done

# Python dependencies (Ansible)
for EGG in ansible-lint; do
  pip list | grep $EGG 2>&1 >/dev/null
  if [ $? -ne 0 ]; then
    pip install $EGG
  fi
done

# Lint the Puppet manifests
printf "***\nChecking Puppet manifests...\n***\n"
puppet-lint pkgs/workbench/cldemo-wbench-*puppet*/debian/etc/puppet/**/*.pp
if [ $? -ne 0 ]; then
  printf "***\nPUPPET CHECKS FAILED\n***\n"
  RET_SUCCESS=1
fi

# Lint the Ansible playbooks
printf "***\nChecking  Ansible playbooks...\n***\n"
ansible-lint pkgs/workbench/cldemo-wbench-*ansible*/debian/home/cumulus/ansibledemos/roles/**/tasks/*
if [ $? -ne 0 ]; then
  printf "***\nANSIBLE CHECKS FAILED\n***\n"
  RET_SUCCESS=1
fi

# Lint the Chef cookbooks
printf "***\nChecking Chef cookbooks...\n***\n"
foodcritic --epic-fail any --tags ~FC003 --context pkgs/workbench/cldemo-wbench-*chef*/debian/usr/local/share/chef/cookbooks/
if [ $? -ne 0 ]; then
  printf "***\nCHEF CHECKS FAILED\n***\n"
  RET_SUCCESS=1
fi

# If the caller is ignoring failures, make sure we always return successfully
if [ $IGNORE_FAILURES -eq 1 ]; then
  printf "***\nIgnoring failures\n***\n"
  RET_SUCCESS=0
fi

exit $RET_SUCCESS
