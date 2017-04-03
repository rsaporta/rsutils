To install direclty from github, you will need to have a Personal Access Token from github ([instructions here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/))

1. setup your GITHUB_PAT   (make sure to quote it)   
Ideally, write this into your  ~/.Rprofile  file  (create the file if it doesnt exist)

     ```R
     ## Personal Access Token for github --- edit the xxxx's
     Sys.setenv(GITHUB_PAT="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")`
     ```
     
2. If you don't have the devtools packages yet, install that

     ```R
     if (!require(devtools)) {
        install.packages("devtools", dependencies=TRUE)
     }
     ```

3. Install from github

     ```R
     require(devtools)
     install_github("rsaporta/rsutils_pkg")
     ```

4. Calling  
For now, you have to call these functions right after loading the package


     ```R
     library(rsutils)
     .create_axis_functions()
     .create_dir.p_functions()
     ```
