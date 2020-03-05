#!/bin/bash


## HOW TO USE:
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
##   1. Goto https://github.com/settings/tokens   (only need REPO)
##   2. Create token and copy it to clipboard
##   3. Only need to edit these two fields.  (not the extra GITHUB_PAT below, thats for the acceptar output)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`



## GITUB PAT (PERSONAL ACCESS TOKEN) 
## To create a PAT, go to:
##   https://github.com/settings/tokens
## You only need to grant 'repo' rights
export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX

# ## WHOM TO ADD
export USER_TO_ADD=XXXXXXXXXXX_____THEIR_USER_NAME____XXXXXXXXXX

# ## MY Github USER NAME
export REPO_OWNER=rsaporta


## CREATE A FILE TO EXPORT OUTPUT
export GITHUB_API_RESPONSE_FILE="/tmp/github_api_invitation_accept_for_${USER_TO_ADD}_$(date -u +'%Y%m%dT%H%M%SZ').sh"











## REMINDER TO RICKY:  Dont edit this lower one.  It is for the file for the ACCEPTER
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##
cat << EOF > $GITHUB_API_RESPONSE_FILE
#!/bin/bash


## GITUB PAT (PERSONAL ACCESS TOKEN) 
## To create a PAT, go to:
##   https://github.com/settings/tokens
## You only need to grant 'repo' rights
export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX


EOF
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##






## ------------------------------------- ##

{
## THIS IS THE FRAMEWORK FOR THE API CALL TO *accept* THE INVITATION
## (this is missing just the invitation_id, which is added by the curl responses below)
## NOTE that in CMD_INVITATION_ACCEPT, the GITHUB_PAT should be changed by the user
export CMD_INVITATION_ACCEPT="curl -X PATCH -H \"Authorization: token \${GITHUB_PAT}\" https://api.github.com/user/repository_invitations/"

echo -e "\033[1;35m"Beginning curl calls to add user to github repos"\033[m"

curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/collectArgs/collaborators/${USER_TO_ADD}     | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rcreds/collaborators/${USER_TO_ADD}          | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/R_init/collaborators/${USER_TO_ADD}          | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaspath/collaborators/${USER_TO_ADD}       | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsubitly/collaborators/${USER_TO_ADD}        | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuconsoleutils/collaborators/${USER_TO_ADD} | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsucurl/collaborators/${USER_TO_ADD}         | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsudb/collaborators/${USER_TO_ADD}           | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaws/collaborators/${USER_TO_ADD}          | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsujesus/collaborators/${USER_TO_ADD}        | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsunotify/collaborators/${USER_TO_ADD}       | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuplotting/collaborators/${USER_TO_ADD}     | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuprophesize/collaborators/${USER_TO_ADD}   | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuscrubbers/collaborators/${USER_TO_ADD}    | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsushiny/collaborators/${USER_TO_ADD}        | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuvydia/collaborators/${USER_TO_ADD}        | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuworkspace/collaborators/${USER_TO_ADD}    | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuxls/collaborators/${USER_TO_ADD}          | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsugeneral/collaborators/${USER_TO_ADD}      | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
echo -e "\033[1;97m"================================================================="\033[m"

## OUTPUT FOR USER
echo -e "\033[1;97m"================================================================="\033[m"
echo -e "\033[1;97m""      (dont copy the lines, dummy :}~      )                   ""\033[m"
echo -e "\033[1;97m"–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"\033[m"

echo -e "\033[1;35m"To Accept the invitations, the receiver should run the following"\033[m"
cat "$GITHUB_API_RESPONSE_FILE"
echo ""
echo -e "\033[1;97m"–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"\033[m"
echo -e "\033[1;35m"'The tmp file is located here:'"\033[m"  \"${GITHUB_API_RESPONSE_FILE}\"
echo -e "\033[1;97m"================================================================="\033[m"
}
