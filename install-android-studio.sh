#!/bin/bash
function check_dl {
  openssl sha1 $1 2>&1 | grep $2 >/dev/null
}
app="Android Studio.app"
dldir="/tmp/missionbit-laptop-management"
dl_url="http://dl.google.com/android/studio/install/0.5.2/android-studio-bundle-135.1078000-mac.dmg"
dl="${dldir}/$(basename "${dl_url}")"
dl_sha="f3f8d67f8f2280a18dc971aa0890c6748602e1ce"
if [ ! -e "/Applications/${app}" ]; then
  echo "[laptop-management $$] ${app} not installed"
  mkdir -p "${dldir}"
  check_dl "${dl}" "${dl_sha}"
  if [ $? -ne 0 ]; then
    echo "[laptop-management $$] Downloading to ${dl}.$$"
    curl -s -L "${dl_url}" -o "${dl}.$$"
    check_dl "${dl}.$$" "${dl_sha}" && \
      mv "${dl}.$$" "${dl}" && \
      echo "[laptop-management $$] ${app} download successful"
  fi
  mountpoint=$(hdiutil attach "${dl}" | tail -n1 | cut -f3-)
  echo "[laptop-management $$] mounted app dmg at ${mountpoint}"
  rsync -a "${mountpoint}/${app}/" "/Applications/${app}/"
  echo "[laptop-management $$] unmounting app dmg from ${mountpoint}"
  hdiutil detach "${mountpoint}"
fi
