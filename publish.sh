#!/usr/bin/env bash

#--------------------------------------------------------------------------
#
# Copyright 2014 Cumulus Networks, inc  all rights reserved
#
#--------------------------------------------------------------------------

# current branch
BRANCH=`git rev-parse --abbrev-ref HEAD`
BRANCHREPO="br_$BRANCH"
DESTOK=0
DESTERR=""

# check params
while getopts "r:n" opt; do
    case "$opt" in
        r) repo=$OPTARG ;;
        n) DESTOK=1 ;;
    esac
done
shift $(( OPTIND - 1))

# confirm repo specified and known
if [[ -z "$repo" ]]; then
    echo "ERROR: Repo not specified"
    exit 1
fi

echo ""
echo "Publish from branch '$BRANCH' to repo '$repo'"

if [ "$BRANCH" == "master" ] && [ "$repo" == "stable" ]; then
    DESTOK=1
fi
if [ "$BRANCH" == "master" ] && [ "$repo" == "testing" ]; then
    DESTOK=1
fi
if [ "$BRANCH" == "HEAD" ] && [ "$repo" == "stable" ]; then
    DESTOK=1
fi

if [ "$repo" == "$BRANCHREPO" ]; then
    DESTOK=1
fi

if [ $DESTOK == 1 ]; then
    echo "OK"
else
    echo "Should not publish from branch $BRANCH to REPO $repo, should go to $BRANCHREPO"
    exit 1
fi

echo ""

# upload
ssh cldemo@repo-publish "mkdir -p /opt/cldemo/$repo/dists/cldemo"
# ssh repo-publish "sudo chown -R cldemo.cldemo /opt/cldemo/br_ipv6ospf"
scp -r repo-build/* cldemo@repo-publish:/opt/cldemo/$repo/dists/cldemo

echo ""
echo "Published packages!"
echo ""
echo "deb http://cldemo.cumulusnetworks.com/$repo cldemo workbench"
echo ""

exit 0
