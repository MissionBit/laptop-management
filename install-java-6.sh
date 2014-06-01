#!/bin/bash
function check_dmg {
  openssl sha1 $1 2>&1 | grep $2 >/dev/null
}
dldir="/tmp/missionbit-laptop-management"
jdk_url="http://support.apple.com/downloads/DL1572/en_US/JavaForOSX2014-001.dmg"
jdk="${dldir}/$(basename "${jdk_url}")"
jdk_sha="0dc67455ff90ae0d20001a018465d3929f0a5334"
jdk_pkg="JavaForOSX.pkg"
if [ ! -e /System/Library/Java/JavaVirtualMachines/1.6.0.jdk ]; then
  echo "[laptop-management $$] Java SE 6 not installed"
  mkdir -p "${dldir}"
  check_dmg "${jdk}" "${jdk_sha}"
  if [ $? -ne 0 ]; then
    echo "[laptop-management $$] Downloading to ${jdk}.$$"
    curl -s -L "${jdk_url}" -o "${jdk}.$$"
    check_dmg "${jdk}.$$" "${jdk_sha}" && \
      mv "${jdk}.$$" "${jdk}" && \
      echo "[laptop-management $$] jdk download successful"
  fi
  echo "[laptop-management $$] attempting Java install"
  mountpoint=$(hdiutil attach "${jdk}" | tail -n1 | cut -f3-)
  echo "[laptop-management $$] mounted at ${mountpoint}"
  echo "[laptop-management $$] installing ${mountpoint}/${jdk_pkg}"
  /usr/sbin/installer \
      -pkg "${mountpoint}/${jdk_pkg}" \
      -target "/"
  echo "[laptop-management $$] detaching ${mountpoint}"
  hdiutil detach "${mountpoint}"
fi
