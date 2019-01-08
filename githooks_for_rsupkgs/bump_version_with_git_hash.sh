function bump_rsu_version_with_git_hash() {
  if [   -z "$1" ];               then
      errcho "ERROR:  No argument passed to bump_version_with_git_hash"
  else 

    local FOLDER="$1" # /Users/rsaporta/Development/rsutils_packages/rsutils
    local FILE_NAME="DESCRIPTION" # "DESCRIPTION_sample.txt"
    local FILE=$FOLDER/$FILE_NAME
    local expected_patch=$(cd $FOLDER && echo $(git_hash_to_octal))

      if [   -z "$1" ];               then
        errcho "ERROR:  No argument passed"
    elif [ ! -d "$FOLDER" ];          then
        errcho "ERROR:  Could not find folder (or it is not a directory): '$FOLDER'"
    elif [ ! -f $FILE ];              then
        errcho "ERROR:  Could not find file (or it is not a regular file): '$FILE'"
    elif [   -z "$expected_patch" ];  then
        errcho "ERROR:  Could not get git hash octal -- are you sure git is initialized in the folder?"
    else 
        echo -n "Bumping version in file '"$FILE"'"
        {
          VER_CURRENT=$(cat $FILE | grep "^Version" | sed -e 's/Version: \([0-9].*\)/\1/' )
          ## TODO: Check if blank
          # echo $VER_CURRENT

          PATCH_CURRENT=$(echo $VER_CURRENT | sed -e s/'[0-9]\{1,\}\.[0-9]\{1,\}\.'//)
          ## TODO: Check if blank
          # echo $PATCH_CURRENT

          MAJMIN_CURRENT=$(echo $VER_CURRENT | sed -e s/'.[0-9]\{1,\}$'//)
          ## TODO: Check if blank
          # echo $MAJMIN_CURRENT

          MAJOR_CURRENT=$(echo $MAJMIN_CURRENT | sed -e s/'.[0-9]\{1,\}$'//)
          ## TODO: Check if blank
          # echo $MAJOR_CURRENT

          MINOR_CURRENT=$(echo $MAJMIN_CURRENT | sed -e s/'^[0-9]\{1,\}\.'// | xargs printf '%02s')
          ## TODO: Check if blank
          # echo $MINOR_CURRENT

          PATCH_FIRST_THREE=$(echo $PATCH_CURRENT | head -c 3 | xargs printf '%03s')
          # tmp_first_three="$(echo $PATCH_CURRENT | head -c 3)"
          # PATCH_FIRST_THREE=$(printf '%03d' "${tmp_first_three#0}")
          ## TODO: Check if blank
          # echo $PATCH_FIRST_THREE

          APPEND_NEW=$(cd $FOLDER && echo $(git_hash_to_octal))
      

          VER_NEW=$(printf '%s.%s.%s%s' $MAJOR_CURRENT $MINOR_CURRENT $PATCH_FIRST_THREE $APPEND_NEW)
          ## TODO: Check if blank
          # echo $VER_NEW
        }
        echo " to version $VER_NEW"

      
        ## UPDATE THE VERSION NUMBER IN THE DESCRIPTION FILE
        CONFIRMED=$(echo $VER_NEW | grep -E "^\d+\.\d+\.\d+$")
        if [ -z "$CONFIRMED" ]; then 
          errcho "ERROR:  \$VER_NEW did not format correctly. Its value is: '$VER_NEW'"
        else
          sed -i '' s/"\(Version. \{0,\}[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\)"/"Version: "$VER_NEW/ $FILE
          ## See this stackoverflow for why the empty string after -i 
          ##   https://stackoverflow.com/a/21243111
        fi
      
        ## UPDATE THE "last committed" LINE
        DEV_LINE_NEW=$(printf "    Unstable development version ( last committed on %s)." "$(date +'%b %d, %Y')")
        CONFIRMED=$(echo $DEV_LINE_NEW | grep -E "\( last committed on [A-Z][a-z][a-z] \d\d, \d\d\d\d\)\.$")
        if [ -z "$CONFIRMED" ]; then 
          errcho "ERROR:  \$DEV_LINE_NEW did not format correctly. Its value is: '$DEV_LINE_NEW'"
        else
          sed -i '' -E s/"^.*development version .\s*(next|last) committed.*"/"$DEV_LINE_NEW"/ $FILE
        fi
    fi
  fi
}

## IF (FALSE) {
# echo ------------------------ === SOURCED $(date) === --------------------------------
# cp /Users/rsaporta/Development/rsutils_packages/rsutils/DESCRIPTION /Users/rsaporta/Development/rsutils_packages/rsutils/DESCRIPTION_sample.txt
# source /Users/rsaporta/Development/rsutils_packages/rsutils/githooks_for_rsupkgs/bump_version_with_git_hash.sh
# bump_rsu_version_with_git_hash ~/Development/rsutils_packages/rsutils/
## }