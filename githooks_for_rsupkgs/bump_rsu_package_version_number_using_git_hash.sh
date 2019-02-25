function bump_rsu_package_version_number_using_git_hash() {
  if [   -z "$1" ];               then
      errcho "ERROR:  No argument passed to bump_version_with_git_hash"
  else 
    local PWD_BAK=$(pwd)
    local FOLDER=$(echo "$1" | sed s/'\/\/'/'\/'/g) # /Users/rsaporta/Development/rsutils_packages/rsutils
    local FILE_NAME="DESCRIPTION" # "DESCRIPTION_sample.txt" | sed s/'\/\/'/'\/'/g
    local FILE=$(echo "$FOLDER/$FILE_NAME" | sed s/'\/\/'/'\/'/g)

    ## PULL CHANGES BEFORE; Wrap in a quick validator. More robust error-handling is downstream.
    if [ -d "$FOLDER" ];          then
      cd "$FOLDER" && git pull
    fi

    local patch_hash_part=$(cd "$FOLDER" && echo $(git_hash_to_decimal_3))

      if [   -z "$1" ];               then
        errcho "ERROR:  No argument passed"
    elif [ ! -d "$FOLDER" ];          then
        errcho "ERROR:  Could not find folder (or it is not a directory): '$FOLDER'"
    elif [ ! -f $FILE ];              then
        errcho "ERROR:  Could not find file (or it is not a regular file): '$FILE'"
    elif [   -z "$patch_hash_part" ];  then
        errcho "ERROR:  Could not get git hash octal -- are you sure git is initialized in the folder?"
    else 
        echo "Bumping version in file '"$FILE"'"
        {
          local VER_CURRENT=$(cat $FILE | grep "^Version" | sed -e 's/Version: \([0-9].*\)/\1/' )
          ## TODO: Check if blank
          # echo $VER_CURRENT

          local PATCH_CURRENT=$(echo $VER_CURRENT | sed -e s/'[0-9]\{1,\}\.[0-9]\{1,\}\.'//)
          ## TODO: Check if blank
          # echo $PATCH_CURRENT

          local MAJMIN_CURRENT=$(echo $VER_CURRENT | sed -e s/'.[0-9]\{1,\}$'//)
          ## TODO: Check if blank
          # echo $MAJMIN_CURRENT

          local MAJOR_CURRENT=$(echo $MAJMIN_CURRENT | sed -e s/'.[0-9]\{1,\}$'//)
          ## TODO: Check if blank
          # echo $MAJOR_CURRENT

          local MINOR_CURRENT=$(echo $MAJMIN_CURRENT | sed -e s/'^[0-9]\{1,\}\.'// | xargs printf '%02s')
          ## TODO: Check if blank
          # echo $MINOR_CURRENT

          local PATCH_FIRST_THREE=$(echo $PATCH_CURRENT | head -c 3 | xargs printf '%03s')
          # local tmp_first_three="$(echo $PATCH_CURRENT | head -c 3)"
          # local PATCH_FIRST_THREE=$(printf '%03d' "${tmp_first_three#0}")
          ## TODO: Check if blank
          # echo $PATCH_FIRST_THREE

          local patch_hash_part=$(cd "$FOLDER" && echo $(git_hash_to_decimal_3))
      

          local VER_NEW=$(printf '%s.%s.%s%s' $MAJOR_CURRENT $MINOR_CURRENT $PATCH_FIRST_THREE $patch_hash_part)
          ## TODO: Check if blank
          # echo $VER_NEW
        }

        echo " from version:  $VER_CURRENT"
        echo " to   version:  $VER_NEW"
      
        ## UPDATE THE VERSION NUMBER IN THE DESCRIPTION FILE
        local CONFIRMED=$(echo $VER_NEW | grep -E "^\d+\.\d+\.\d+$")
        if [ -z "$CONFIRMED" ]; then 
          errcho "ERROR:  \$VER_NEW did not format correctly. Its value is: '$VER_NEW'"
        else
          sed -i '' s/"\(Version. \{0,\}[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\)"/"Version: "$VER_NEW/ $FILE
          ## See this stackoverflow for why the empty string after -i 
          ##   https://stackoverflow.com/a/21243111
        fi
      
        ## UPDATE THE "last committed" LINE
        local DEV_LINE_NEW=$(printf "    Unstable development version ( last committed on %s)." "$(date +'%b %d, %Y')")
        local CONFIRMED=$(echo $DEV_LINE_NEW | grep -E "\( last committed on [A-Z][a-z][a-z] \d\d, \d\d\d\d\)\.$")
        if [ -z "$CONFIRMED" ]; then 
          errcho "ERROR:  \$DEV_LINE_NEW did not format correctly. Its value is: '$DEV_LINE_NEW'"
        else
          sed -i '' -E s/"^.*development version .\s*(next|last) committed.*"/"$DEV_LINE_NEW"/ $FILE
        fi
    fi
    cd $PWD_BAK
  fi
}

# ------------------------------------------------------------------------- #
## #| EXAMPLES:
# ------------------------------------------------------------------------- #
# cp /Users/rsaporta/Development/rsutils_packages/rsutils/DESCRIPTION /Users/rsaporta/Development/rsutils_packages/rsutils/DESCRIPTION_sample.txt
# source /Users/rsaporta/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/bump_rsu_package_version_number_using_git_hash.sh
# bump_rsu_package_version_number_using_git_hash ~/Development/rsutils_packages/rsutils/
# git_patch_bump /Users/rsaporta/Development/rsutils_packages/rsutils/
# ------------------------------------------------------------------------- #
# UPDATE 2019-02-15:  Use this file instead:
#  /Users/rsaporta/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/BUMP-ALL.sh
# ------------------------------------------------------------------------- #
function git_patch_bump() {
   if [   -z "$1" ];               then
      errcho "ERROR:  No argument passed to bump_version_with_git_hash"
  else 
    local PWD_BAK=$(pwd)
    local FOLDER=$(echo "$1" | sed s/'\/\/'/'\/'/g) # /Users/rsaporta/Development/rsutils_packages/rsutils
    local FILE_NAME="DESCRIPTION" # "DESCRIPTION_sample.txt" | sed s/'\/\/'/'\/'/g
    local FILE=$(echo "$FOLDER/$FILE_NAME" | sed s/'\/\/'/'\/'/g)
    local patch_hash_part=$(cd "$FOLDER" && echo $(git_hash_to_decimal_3))

      if [   -z "$1" ];               then
        errcho "ERROR:  No argument passed"
    elif [ ! -d "$FOLDER" ];          then
        errcho "ERROR:  Could not find folder (or it is not a directory): '$FOLDER'"
    elif [ ! -f $FILE ];              then
        errcho "ERROR:  Could not find file (or it is not a regular file): '$FILE'"
    elif [   -z "$patch_hash_part" ];  then
        errcho "ERROR:  Could not get git hash octal -- are you sure git is initialized in the folder?"
    else 
        local VER_CURRENT=$(cat $FILE | grep "^Version" | sed -e 's/Version: \([0-9].*\)/\1/' )
        cmd="cd \""$FOLDER"\" && git add \""$FILE_NAME"\" && git commit -m \"PATCH BUMP: $VER_CURRENT\""
        echo EXECUTING THE FOLLOWING COMMAND:
        echo ------------------------------------------------------------
        echo $cmd
        echo ------------------------------------------------------------
        eval $cmd
    fi
    cd $PWD_BAK
  fi 
}

function bump_and_commit_rsu_package_version_number_using_git_hash() {
   if [   -z "$1" ];               then
      errcho "ERROR:  No argument passed to bump_version_with_git_hash"
  elif [ ! -d "$1" ];          then
      errcho "ERROR:  Argument passed is not a folder (or it does not exist): '$1'"
  else 
    local PWD_BAK=$(pwd)
    echo
    bump_rsu_package_version_number_using_git_hash "$1"
    git_patch_bump "$1"
    echo 
    echo "================= HERE ARE THE LAST 7 COMMITS ================="
    local cmd_gitlog="cd \"$1\" && git log -7 --graph --pretty=format:'%C(auto)%h%C(auto)%d %s %C(dim white)(%aN, %ar)'"
    eval $cmd_gitlog
    echo "==============================================================="
    # eval $(cd "$1" && git log -7 --graph --pretty=format:'%C(auto)%h%C(auto)%d %s %C(dim white)(%aN, %ar)')
    cd $PWD_BAK
  fi
}

#| function test() {
#|   bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsutils/
#| }
#| 
#| test


## #| EXAMPLES:
# git status
# source /Users/rsaporta/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/bump_rsu_package_version_number_using_git_hash.sh
# bump_and_commit_rsu_package_version_number_using_git_hash /Users/rsaporta/Development/rsutils_packages/rsutils/
# git status
# gitlog -5




# echo ------------------------ === SOURCED $(date) === --------------------------------
