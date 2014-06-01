#!/bin/bash
function check_dmg {
  openssl sha1 $1 2>&1 | grep $2 >/dev/null
}
if [ ! -e /System/Library/Java/JavaVirtualMachines ]; then
  echo "[laptop-management] Java not installed"
  dldir="/tmp/missionbit-laptop-management"
  jdk="${dldir}/jdk-8u5-macosx-x64.dmg"
  jdk_sha="dd91b51ff93f1089b9053cf7d7a8b3db568ed65e"
  mkdir -p "${dldir}"
  check_dmg "${jdk}" "${jdk_sha}"
  if [ $? -ne 0 ]; then
    echo "[laptop-management] Downloading to ${jdk}.$$"
    curl -s -b 'oraclelicense=accept-securebackup-cookie' -L http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-macosx-x64.dmg -o "${jdk}.$$"
    check_dmg "${jdk}.$$" "${jdk_sha}" && \
      mv "${jdk}.$$" "${jdk}" && \
      echo "[laptop-management] jdk download successful"
  fi
fi
