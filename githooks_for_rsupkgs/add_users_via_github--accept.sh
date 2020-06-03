## PAT -- To create, go to:
##   https://github.com/settings/tokens
##  needs just 'repo' rights
export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX


if ! [ -x "$(command -v jq)" ]; then
  echo NOTE: JSON parsing tool \'jq\' is not installed. Will attempt to install it now with homebrew
  echo Running:  \'brew install jq\'
  brew install jq
fi



*** THIS IS NOT THE RIGHT FILE TO SEND ***
--- CHECK YOUR TMP FOLDER  ---------------


ls -la /tmp/github_api_*
ls -la /tmp/github_api_*
ls -la /tmp/github_api_*
ls -la /tmp/github_api_*
ls -la /tmp/github_api_*
















# PATCH /user/repository_invitations/:invitation_id
echo "https://api.github.com/user/repository_invitations/"

export CMD_INVITATION_ACCEPT="curl -X PUT -H \"Authorization: token \\\${GITHUB_PAT}\" https://api.github.com/user/repository_invitations/"
echo $CMD_INVITATION_ACCEPT

export CMD_INVITATION_ACCEPT="curl -X PUT -H \"Authorization: token \${GITHUB_PAT}\" https://api.github.com/user/repository_invitations/"
export z=$(curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/collectArgs/collaborators/${USER_TO_ADD}     | jq '.id' | echo ${CMD_INVITATION_ACCEPT})
echo $z



export CMD_INVITATION_ACCEPT="curl -X PUT -H \"Authorization: token \\\${GITHUB_PAT}\" https://api.github.com/user/repository_invitations/"
cat "/tmp/github_api_response_file_hilaryp_20191204T131432Z.txt" | sed -e "s|^|$CMD_INVITATION_ACCEPT|g"

{
## CREATE A FILE TO EXPORT TO
export GITHUB_API_RESPONSE_FILE="/tmp/github_api_response_file_${USER_TO_ADD}_$(date -u +'%Y%m%dT%H%M%SZ').txt"

curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/collectArgs/collaborators/${USER_TO_ADD}     | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rcreds/collaborators/${USER_TO_ADD}          | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/R_init/collaborators/${USER_TO_ADD}          | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaspath/collaborators/${USER_TO_ADD}       | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsubitly/collaborators/${USER_TO_ADD}        | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuconsoleutils/collaborators/${USER_TO_ADD} | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsucurl/collaborators/${USER_TO_ADD}         | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsudb/collaborators/${USER_TO_ADD}           | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaws/collaborators/${USER_TO_ADD}          | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsujesus/collaborators/${USER_TO_ADD}        | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsunotify/collaborators/${USER_TO_ADD}       | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuplotting/collaborators/${USER_TO_ADD}     | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuprophesize/collaborators/${USER_TO_ADD}   | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuscrubbers/collaborators/${USER_TO_ADD}    | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsushiny/collaborators/${USER_TO_ADD}        | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuvydia/collaborators/${USER_TO_ADD}        | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuworkspace/collaborators/${USER_TO_ADD}    | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuxls/collaborators/${USER_TO_ADD}          | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsugeneral/collaborators/${USER_TO_ADD}      | jq '.id' >> "$GITHUB_API_RESPONSE_FILE"

echo -e "\033[1;35m"The Following invitation IDs have been sent"\033[m"
cat "$GITHUB_API_RESPONSE_FILE"
echo ""
echo -e "\033[1;35m"'The tmp file is located here:'"\033[m"  \"${GITHUB_API_RESPONSE_FILE}\"
}
