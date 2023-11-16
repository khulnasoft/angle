#!/usr/bin/env bash
set -euo pipefail

# verify-install.sh <package>
#
# SUMMARY
#
#   Verifies angle packages have been installed correctly

package="${1:?must pass package as argument}"

install_package () {
  case "$1" in
    *.deb)
        dpkg -i "$1"
      ;;
    *.rpm)
        rpm -i --replacepkgs "$1"
      ;;
  esac
}

install_package "$package"

getent passwd angle || (echo "angle user missing" && exit 1)
getent group angle || (echo "angle group  missing" && exit 1)
angle --version || (echo "angle --version failed" && exit 1)
test -f /etc/default/angle || (echo "/etc/default/angle doesn't exist" && exit 1)
test -f /etc/angle/angle.yaml || (echo "/etc/angle/angle.yaml doesn't exist" && exit 1)

echo "FOO=bar" > /etc/default/angle
echo "foo: bar" > /etc/angle/angle.yaml

install_package "$package"

getent passwd angle || (echo "angle user missing" && exit 1)
getent group angle || (echo "angle group  missing" && exit 1)
angle --version || (echo "angle --version failed" && exit 1)
grep -q "FOO=bar" "/etc/default/angle" || (echo "/etc/default/angle has incorrect contents" && exit 1)
grep -q "foo: bar" "/etc/angle/angle.yaml" || (echo "/etc/angle/angle.yaml has incorrect contents" && exit 1)
