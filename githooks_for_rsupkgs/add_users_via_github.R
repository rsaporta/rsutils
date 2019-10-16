## PAT -- To create, go to:
##   https://github.com/settings/tokens
##  needs just 'repo' rights
export GITHUB_PAT=XXXXXXXXXXX_____fill_me_in____XXXXXXXXXX

## WHOM TO ADD
export USER_TO_ADD=XXXXXXXXXXX_____THEIR_USER_NAME____XXXXXXXXXX

## MY Github USER NAME
export REPO_OWNER=rsaporta


{
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/collectArgs/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rcreds/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/R_init/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaspath/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsubitly/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuconsoleutils/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsucurl/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsudb/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuaws/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsujesus/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsunotify/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuplotting/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuprophesize/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuscrubbers/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsushiny/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuvydia/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuworkspace/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsuxls/collaborators/${USER_TO_ADD}
curl -X PUT -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${REPO_OWNER}/rsugeneral/collaborators/${USER_TO_ADD}
}
