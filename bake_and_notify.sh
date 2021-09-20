#!/bin/bash
cd `dirname $0`

discord_token=

cd stationeers_resources/locales

git fetch

master_commit_id=`git show -s master --format=%H`
origin_commit_id=`git show -s origin/master --format=%H`

echo "master_commit_id:${master_commit_id}"
echo "origin_commit_id:${origin_commit_id}"

if [[ "${master_commit_id}" == "${origin_commit_id}" ]]; then
  echo "same commit"
else
  echo "new commit"

  echo "clear and update"
  cd ../
  git fetch
  git reset --hard origin/main
  git clean -d -f
  git submodule update --remote --merge
  echo "done(clear and update)"

  echo "bake and notify"
  martian bake

  git add *
  git commit -m "generate to ${origin_commit_id}"
  git push origin main

  sh release.sh
  martian notify --token ${discord_token} assets
  echo "done(bake and notify)"
fi
