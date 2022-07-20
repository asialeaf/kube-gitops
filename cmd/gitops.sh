#!/bin/sh

###############DEBUG###############
# GITSOURCE="https://github.com/asialeaf/gitops.git"
# GITPATH="deploy/"
# CALLBACK="http://10.96.221.127:8060/dingtalk/webhook1/send"


# Define log format
function Color_Definition(){
    RC='\033[1;31m'
    GC='\033[1;32m'
    BC='\033[1;34m'
    YC='\033[1;33m'
    EC='\033[0m'
}
Color_Definition
function nowTime(){
	date1=`date '+%Y-%m-%d %H:%M:%S+%N'`
}

function errorlog() {
        nowTime
        echo -e "[$date1] ${RC} [ERROR]${EC} $@" 1>&2
}
function infolog() {
        nowTime
        echo -e "[$date1] ${GC} [INFO]${EC} $@" 1>&2
}
function warnlog() {
        nowTime
        echo -e "[$date1] ${YC} [WARN]${EC} $@" 1>&2
}

# Send msg
function sendmsg() {
    STATUS=$1
    DATA="{\"status\": \"$STATUS\",\"msg\": \"$MSG\"}"
    infolog "send msg: "$DATA
    http_code=$(curl -m 10 -o /dev/null -s -w %{http_code} -H 'Content-Type: application/json' -d "$DATA" -X POST $CALLBACK)
    if [[ $http_code == 200 ]]; then 
        infolog "msg send success!"
    else 
        errorlog "msg send failed!, http_code: "$http_code
    fi
}

# Create temp dir
infolog "Start..."
TEMP_DIR=/tmp/git_storage
mkdir -p $TEMP_DIR
infolog "Created temp dir "$TEMP_DIR

# Get the Git repository
infolog "Start clone repo..."
SUFF=${GITSOURCE##*/}
GITREPONAME=${SUFF%%.*}
MSG=$(git clone $GITSOURCE $TEMP_DIR/$GITREPONAME 2>&1)
if [[ $? == 0 ]];then
    infolog "Git Repo "$GITREPONAME" success!"
else
    errorlog "Git Repo "$GITREPONAME" failed!"
    sendmsg "failed"
    exit 1
fi

# kubectl apply
infolog "Start apply yamls..."
cd $TEMP_DIR/$GITREPONAME/$GITPATH
# MSG=$(kubectl apply -f . 2>&1)
# MSG=$(echo $MSG)
kubectl apply -f . > /tmp/msg.log
MSG=$(sed ':a;N;$!ba;s#\n#, #g' /tmp/msg.log)
if [[ $? == 0 ]];then
    infolog "kubectl apply "$GITREPONAME" success!"
    sendmsg "success"
else
    infolog "kubectl apply "$GITREPONAME" failed!"
    sendmsg "failed"
    exit 1
fi

infolog "End..."