installation_reminder <- function() {

  message("

  ==============================================================
  ## RSU LOADING ON INSTALL, LOADS OTHER PACKAGES. 

  When installing new packages, R will load the .Rprofile file
  This generally is calling the rsupackages. 
  To avoid this, you can set a flag. 

  However, first you have to 
  start R in vanilla mode. 
  Therefor quit R. 
  

  ```
    ## In terminal, run:
    R --vanilla
  ```

  And once in R, before you begin installation, run:

  ```
    ## Let the system know you are in 'installation mode'
    Sys.setenv(RSU_INSTALLING = TRUE); 
  ```

  ==============================================================
  ## GITHUB ISSUES

  Bonus reminder.  If you are getting an error when
   you are installing from github, check the Personal Access Token

  If it is set to this placeholder, edit your personal profile using 
  
  ```
    Sys.getenv(\"GITHUB_PAT\")
    # [1] \"WHAT IS YOUR GITHUB PAT\"

    ## If it's set to this placeholder, edit your profile:
    sublprofile() ## -- pops open your personal profile

    ## Aleternatively, set it to blank:
    Sys.unsetenv(\"GITHUB_PAT\") ## -- removes the variable
  ```

  ")

}
