# DEPRECATED
## This repo is no longer maintained.<br>For a list of current demos, please visit:<br>https://gitlab.com/cumulus-consulting/goldenturtle/<br><br><br>

# Cumulus Linux Demo Packages (cldemo)


## Overview

This repo contains the source for the **cldemo** packages, these can be used by sales engineers, partners and customers to demonstrate:

* Automation tools (such as Ansible, CFEngine, Chef and Puppet)
* Configuration of routing protocols (BGP, OSPF)
* Zero touch provisioning (ZTP)
* Monitoring tools (like Ganglia)

Using dependencies the packages will automatically install any required
components, configure them as appropriate and ensure content such as recipes,
cookbooks, ZTP scripts and playbooks are in place and ready.

Currently, the primary target for these packages is within the hosted Cumulus
Workbench, though in the near future we will support installation on the customer
or partner site using a standalone Ubuntu install.

## Usage

The Cumulus Workbench consists of a single pre-provisioned Ubuntu
(currently 12.04) workbench/jump VM and multiple switches running Cumulus Linux.

From the workbench packages can be installed via APT:

	cumulus@wbench:~$ apt-cache search cldemo
	cldemo-wbench-ibgp-2s-ansible - 2 switch; Ansible, PTM and iBGP IPv4
	cldemo-wbench-ibgp-2s2l-ansible - 2 leaf 2 spine; Ansible, PTM and iBGP IPv4
	cldemo-wbench-ibgp-2s2l-puppet - 2 leaf 2 spine; Puppet, PTM and iBGP IPv4
	cldemo-wbench-ospfunnum-2s-ansible - 2 switch; Ansible, PTM and OSPF Unnumbered IPv4
	cldemo-wbench-ospfunnum-2s-puppet - 2 switch; Puppet, PTM and OSPF Unnumbered IPv4
	cldemo-wbench-ospfunnum-2s2l-ansible - 2 leaf 2 spine; Ansible, PTM and OSPF Unnumbered IPv4
	cldemo-wbench-ospfunnum-2s2l-puppet - 2 leaf 2 spine; Puppet, PTM and OSPF Unnumbered IPv4
	cldemo-wbench-sflow-2lt22s-puppet - Setup sflow and ganglia web frontend
	cumulus@wbench:~$ sudo apt-get install cldemo-wbench-ospfunnum-2s2l-puppet

Instructions for each demo are hosted on the [knowledge base](https://support.cumulusnetworks.com/hc/en-us/sections/200398866-Demos-and-Training).

## Development

### Requirements

Package content can be developed on either Debian or Ubuntu.

**Note:** The SecureAPT releases signing key is not stored in this repo.

### Preparing Your Environment

Install the git and dpkg tools:

	julia@devhost:~$ sudo apt-get install git apt-utils dpkg-dev
	julia@devhost:~$ git clone git@github.com:CumulusNetworks/cldemo.git

### Testing

The test script runs lint tools for Puppet, Ansible & Chef against the
manifests/playbooks/cookbooks and reports any issues.

  julia@devhost:~$ cd cldemo
	julia@devhost:~/cldemo$ ./test.sh

The test.sh script will check for the following dependencies:

* puppet-lint (Ruby)
* ansible-lint (Python)
* foodcritic (Ruby)

It will attempt to install them, and their dependencies, if they are not
found. You will require a working Ruby 2.x, with a working Rubygems,
installed, and a working version of Python and Python Pip.

### Building

The build script compiles packages from within pkgs/*; it also generates the
packages and signs the release file.

	julia@devhost:~$ cd cldemo
	julia@devhost:~/cldemo$ ./build.sh

The compiled debs will be written to repo-build/. From there they can be uploaded
to your development Web server.

/*

### Old Packages

You can find old packages in the [Archive repository](https://github.com/CumulusNetworks/cldemo-archive)

---
/*;

![Cumulus icon](http://cumulusnetworks.com/static/cumulus/img/logo_2014.png)

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard
networking hardware. It enables the latest Linux applications and automation
tools on networking gear while delivering new levels of innovation and
ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)
