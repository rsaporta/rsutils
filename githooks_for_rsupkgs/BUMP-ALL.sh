# source /Users/rsaporta/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/BUMP-ALL.sh
# bump_and_commit_rsu_package_version_number_using_git_hash

{

export PWD_BACK=$(PWD)

## PULL THE MORE COMMONLY UPDATED PACKAGES
{
  cd /Users/rsaporta/Development/rsutils_packages/rsudb           && git pull
  cd /Users/rsaporta/Development/rsutils_packages/rsugeneral      && git pull
  cd /Users/rsaporta/Development/rsutils_packages/rsuplotting     && git pull
  cd /Users/rsaporta/Development/rsutils_packages/rsuworkspace    && git pull
}

{
source $HOME/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/bump_rsu_package_version_number_using_git_hash.sh
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuaspath
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuaws
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsubitly
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuconsoleutils
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsucurl
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsudb
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsugeneral
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsujesus
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsunotify
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuplotting
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuprophesize
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuscrubbers
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsushiny
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuvydia
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuworkspace
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsuxls
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsutils

## -- DSI PACKAGES
bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rpkgs/dsiutils
}

RSU_UPDATE_nogit

{
  cd /Users/rsaporta/Development/rsutils_packages/rsuaspath       && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuaws          && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsubitly        && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuconsoleutils && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsucurl         && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsudb           && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsugeneral      && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsujesus        && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsunotify       && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuplotting     && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuprophesize   && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuscrubbers    && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsushiny        && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuvydia        && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuworkspace    && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsuxls          && git push
  cd /Users/rsaporta/Development/rsutils_packages/rsutils         && git push


  #| -- DSI PACKAGES
  #| cd /Users/rsaporta/Development/rpkgs/dsiutils                   && git push
}

cd "$PWD_BACK"
unset PWD_BACK
}

