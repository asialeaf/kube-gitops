#!/bin/sh

# GITSOURCE="https://github.com/asialeaf/gitops.git"
# GITPATH="deploy/"
# CALLBACK="http://10.96.221.127:8060/dingtalk/webhook1/send"

TEMP_DIR=/tmp/git_storage
echo "Hello..."
# Create temp dir
mkdir -p $TEMP_DIR
# Get the Git repository
SUFF=${GITSOURCE##*/}
GITREPONAME=${SUFF%%.*}
git clone $GITSOURCE $TEMP_DIR/$GITREPONAME

echo "Git Repo "$GITREPONAME" "

# kubectl apply
cd $TEMP_DIR/$GITREPONAME/$GITPATH
kubectl apply -f .

# Send msg
DATA='{"status": "success"}'

if [[ $? == 0 ]]; then
    http_code=$(curl -m 10 -o /dev/null -s -w %{http_code} -H 'Content-Type: application/json' -d "$DATA" -X POST $CALLBACK)
    if [[ $http_code == 200 ]]; then 
        echo "msg send success!"
    else 
        echo "msg send failed!, http_code: "$http_code
    fi
fi
echo "End..."