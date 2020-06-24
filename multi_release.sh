#!/bin/bash

# Original Author Joe Asercion
# Additional Author Alex Reustle
#
# Usage:
# $ multi_release TAG_VERSION TAG_MESSAGE

generate_post_data()
{
    cat <<EOF
{
  "tag_name": "$version",
  "target_commitish": "$branch",
  "name": "$version",
  "body": "$text",
  "draft": false,
  "prerelease": false
}
EOF
}

EXIT_VALUE=0

for f in *; do
    echo "Tagging $f..."
    cd $f
    version=$1
    text=$2
    branch=$(git rev-parse --abbrev-ref HEAD)
    repo_full_name=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')
    token=$(git config --global github.token)

    echo "Create release $version for repo: $repo_full_name branch: $branch"
    curl --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token"
    ((EXIT_VALUE+=$?))
    cd ../
done

exit $(exit_value)
