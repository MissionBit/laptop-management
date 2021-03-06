#!/bin/bash
set -e
function check_dl {
  openssl sha1 $1 2>&1 | grep $2 >/dev/null
}
app="Racket v6.1"
dldir="/tmp/missionbit-laptop-management"
dl_url="http://mirror.racket-lang.org/installers/6.1/racket-6.1-x86_64-macosx.dmg"
dl="${dldir}/$(basename "${dl_url}")"
dl_sha="0428fcc057ec3bccb252dad8eab402d88888958c"
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
  check_dl "${dl}" "${dl_sha}"
  if [ $? -eq 0 ]; then
    mountpoint=$(hdiutil attach "${dl}" | tail -n1 | cut -f3-)
    echo "[laptop-management $$] mounted app dmg at ${mountpoint}"
    rsync -a "${mountpoint}/${app}/" "/Applications/.${app}.$$/"
    mv "/Applications/.${app}.$$" "/Applications/${app}"
    chown -R missionbit:admin "/Applications/${app}"
    chmod -R g+w "/Applications/${app}"
    echo "[laptop-management $$] unmounting app dmg from ${mountpoint}"
    hdiutil detach "${mountpoint}"
  fi
fi
