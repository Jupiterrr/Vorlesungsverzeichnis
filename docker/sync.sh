#!/bin/bash

set -u # prevent unbound variables
set -e # terminate on error

SSH_PORT=$(boot2docker config 2>&1 | awk '/SSHPort/ {print $3}')

# load rsync
boot2docker ssh tce-load -wi rsync

# ensure existance of .rsyncignore
touch .rsyncignore

function boot2docker_sync {
  # sync current directory to ~/share on the vm
  rsync \
      -rlz --force --delete \
      --exclude-from=.rsyncignore \
      -e "ssh \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -i $HOME/.ssh/id_boot2docker \
        -p $SSH_PORT" \
      ./ docker@localhost:/home/docker/share
  echo "sync: $(date)"
}
export -f boot2docker_sync

boot2docker_sync
fswatch -o . | xargs -n1 -I{} boot2docker_sync
