#!/usr/bin/env bash
#
# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant as the primary
# provisioning script whenever the commands `vagrant up`, `vagrant provision`,
# or `vagrant reload` are used.

# By storing the date now, we can calculate the duration of provisioning at the
# end of this script.
start_seconds="$(date +%s)"

# PACKAGE INSTALLATION
#
# Build a bash array to pass all of the packages we want to install to a single
# yum command. This avoids doing all the leg work each time a package is
# set to install. It also allows us to easily comment out or add single
# packages. We set the array as empty to begin with so that we can append
# individual packages to it as required.
yum_package_install_list=()

# Start with a bash array containing all packages we want to install in the
# virtual machine. We'll then loop through each of these and check individual
# status before adding them to the yum_package_install_list array.
yum_package_check_list=(
  # other packages that come in handy
  git
  curl
  make
  vim
  nano

  # ntp service to keep clock current
  ntp

  # Req'd for i18n tools
  gettext

  #haskell
  haskell-platform
  #prolog
  autoconf


  # to build e.g. node modules
  gcc-c++
  #to build newest guest additions
  kernel-devel
)

### FUNCTIONS

network_detection() {
  # Network Detection
  #
  # Make an HTTP request to google.com to determine if outside access is available
  # to us. If 3 attempts with a timeout of 5 seconds are not successful, then we'll
  # skip a few things further in provisioning rather than create a bunch of errors.
  if [[ "$(wget --tries=3 --timeout=5 --spider --recursive --level=2 http://google.com 2>&1 | grep 'connected')" ]]; then
    echo "Network connection detected..."
    ping_result="Connected"
  else
    echo "Network connection not detected. Unable to reach google.com..."
    ping_result="Not Connected"
  fi
}

network_check() {
  network_detection
  if [[ ! "$ping_result" == "Connected" ]]; then
    echo -e "\nNo network connection available, skipping package installation"
    exit 0
  fi
}

repo_install() {
  yum -y install epel-release
}

noroot() {
  sudo -EH -u "vagrant" "$@";
}

not_installed() {
  rpm -q "$1" 2>&1 | grep -q 'not installed'
  # returns 0 if string 'not installed' is found, truthy value otherwise
  return "$?"
}

package_check() {
  # Loop through each of our packages that should be installed on the system. If
  # not yet installed, it should be added to the array of packages to install.
  local pkg

  for pkg in "${yum_package_check_list[@]}"; do
    if not_installed "${pkg}"; then
      echo " *" "$pkg" [not installed]
      yum_package_install_list+=($pkg)
    else
      rpm -q "${pkg}"
    fi
  done
}

package_install() {
  package_check

  if [[ ${#yum_package_install_list[@]} = 0 ]]; then
    echo -e "No yum packages to install.\n"
  else
    # Update all of the package references before installing anything
    echo "Running yum update..."
    yum -y update

    # Install required packages
    echo "Installing yum packages..."
    yum -y install ${yum_package_install_list[@]}

    # Remove unnecessary packages
    echo "Removing unnecessary packages..."
    yum autoremove -y
  fi
}

prolog_install() {
  echo "installing prolog.."

  git clone https://github.com/SWI-Prolog/swipl-devel.git
  cd swipl-devel
  ./prepare --yes
  cp -p build.templ build
  ./build
}



###############
# Setup Order #
###############

network_check
# Package and Tools Install
echo " "
echo "Main packages check and install."
repo_install
package_install
prolog_install

network_check
echo " "

#set +xv
# And it's done
end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$(( end_seconds - start_seconds ))" seconds"
