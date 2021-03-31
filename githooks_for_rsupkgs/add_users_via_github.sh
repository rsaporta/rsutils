#!/bin/bash


## HOW TO USE:
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
##   1. Goto https://github.com/settings/tokens   (only need REPO)
##   2. Create token and copy it to clipboard
##   3. Only need to edit these two fields.  (not the extra GITHUB_PAT below, thats for the acceptar output)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`


# open https://github.com/settings/tokens



## GITUB PAT (PERSONAL ACCESS TOKEN) 
## To create a PAT, go to:
##   https://github.com/settings/tokens/new
## You only need to grant 'repo' rights
if [ -z "${GITHUB_PAT}" ]; then
  export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX
fi  

# ## WHOM TO ADD
if [ -z "${USER_TO_ADD}" ]; then
  export USER_TO_ADD=XXXXXXXXXXX_____THEIR_USER_NAME____XXXXXXXXXX
fi
# ## MY Github USER NAME
if [ -z "${REPO_OWNER}" ]; then
  export REPO_OWNER=rsaporta
fi

## CREATE A FILE TO EXPORT OUTPUT
if [ -z "${GITHUB_API_RESPONSE_FILE}" ]; then
  export GITHUB_API_RESPONSE_FILE="/tmp/github_api_invitation_accept_for_${USER_TO_ADD}_$(date -u +'%Y%m%dT%H%M%SZ').sh"
fi

## THEN JUST SOURCE:
# source ~/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/add_users_via_github.sh
















# ONLY EDIT ABOVE ^^^^^^^^^^^^^^^^^
# ONLY EDIT ABOVE ^^^^^^^^^^^^^^^^^
# ONLY EDIT ABOVE ^^^^^^^^^^^^^^^^^
# ONLY EDIT ABOVE ^^^^^^^^^^^^^^^^^
#
#
# DO NOT EDIT BELOW -----------------------------------------------------
# DO NOT EDIT BELOW -----------------------------------------------------
# DO NOT EDIT BELOW -----------------------------------------------------
# DO NOT EDIT BELOW -----------------------------------------------------





FOLDER_GITHUB_API_RESPONSE_FILE=$(dirname "$GITHUB_API_RESPONSE_FILE")
mkdir -p "$FOLDER_GITHUB_API_RESPONSE_FILE"


## REMINDER TO RICKY:  Dont edit this lower one.  It is for the file for the ACCEPTER
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##
cat << EOF > "$GITHUB_API_RESPONSE_FILE"
#!/bin/bash


## GITUB PAT (PERSONAL ACCESS TOKEN) 
## To create a PAT, go to:
##   https://github.com/settings/tokens
## You only need to grant 'repo' rights
export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX


if ! [ -x "\$(command -v jq)" ]; then
  echo NOTE: JSON parsing tool \'jq\' is not installed. Will attempt to install it now with homebrew
  echo Running:  \'brew install jq\'
  brew install jq
fi


EOF
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##






## ------------------------------------- ##

{
## THIS IS THE FRAMEWORK FOR THE API CALL TO *accept* THE INVITATION
## (this is missing just the invitation_id, which is added by the curl responses below)
## NOTE that in CMD_INVITATION_ACCEPT, the GITHUB_PAT should be changed by the user
export CMD_INVITATION_ACCEPT="curl -X PATCH -H \"Authorization: token \${GITHUB_PAT}\" https://api.github.com/user/repository_invitations/"

echo -e "\033[1;35m"Beginning curl calls to add user to github repos"\033[m"

curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/bash_profile_pieces/collaborators/${USER_TO_ADD} | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
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
## TFD Specifically
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/tfd_misc/collaborators/${USER_TO_ADD}            | jq '.id' | sed -e "s|^|$CMD_INVITATION_ACCEPT|g" >> "$GITHUB_API_RESPONSE_FILE"
echo -e "\033[1;97m"================================================================="\033[m"

## OUTPUT FOR USER
echo -e "\033[1;97m"================================================================="\033[m"
echo -e "\033[1;97m""      (dont copy the lines, dummy :}~      )                   ""\033[m"
echo -e "\033[1;97m"–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"\033[m"
echo -e "\033[1;35m"To Accept the invitations, the receiver should run the following"\033[m"
cat "$GITHUB_API_RESPONSE_FILE"
subl "$GITHUB_API_RESPONSE_FILE" 
# cp "$GITHUB_API_RESPONSE_FILE" "$HOME/Development/DSI_Computer_Setup/to_send_to_candidates/$(basename "$GITHUB_API_RESPONSE_FILE")"
echo ""
echo -e "\033[1;97m"–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"\033[m"
echo -e "\033[1;35m"'The tmp file is located here:'"\033[m"  \"${GITHUB_API_RESPONSE_FILE}\"
echo -e "\033[1;35m"'The tmp file is located here:'"\033[m"  \"${GITHUB_API_RESPONSE_FILE}\"
echo -e "\033[1;35m"'The tmp file is located here:'"\033[m"  \"${GITHUB_API_RESPONSE_FILE}\"
echo ""
echo -e "\033[1;35m"'Send it to the receiver'"\033[m"
echo -e "\033[1;97m"================================================================="\033[m"

}
