#!/bin/sh

# Log File location
logfile="~/Library/Logs/AutoPkg_Server.log"

# Define logged-in username
username=$(ls -l /dev/console | awk '{ print $3 }')

# Define apps to update
adobeReader="AdobeReader-pkg.jamf"
adobeCC="AdobeCC-pkg.jamf"
fireFox="Firefox-pkg.jamf"
googleChrome="GoogleChrome-pkg.jamf"
googleDrive="GoogleDrive-pkg.jamf"
microsoftAutoUpdate="MicrosoftAutoUpdate-pkg.jamf"
microsoftEdge="MicrosoftEdge-pkg.jamf"
microsoftExcel="MicrosoftExcel-pkg.jamf"
microsoftOutlook="MicrosoftOutlook-pkg.jamf"
microsoftPowerpoint="MicrosoftPowerpoint-pkg.jamf"
microsoftRemoteDesktop="MicrosoftRemoteDesktop-pkg.jamf"
microsoftTeams="MicrosoftTeams-pkg.jamf"
microsoftWord="MicrosoftWord-pkg.jamf"
mySQL="MySQL-pkg.jamf"
pyCharm="PyCharmCE-pkg.jamf"
rStudio="RStudio-pkg.jamf"
slack="Slack-pkg.jamf"
spotify="Spotify-pkg.jamf"
thunderbird="Thunderbird-pkg.jamf"
visualStudioCode="VisualStudioCode-pkg.jamf"
vmWareFusion="VMWareFusion-pkg.jamf"
vmWareTools="VMWareTools-pkg.jamf"
webex="WebEx-pkg.jamf"
zoom="zoom.us-pkg.jamf"


[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.dataJAR-recipes" ] && /usr/local/bin/autopkg repo-add dataJAR-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.gerardkok-recipes" ] && /usr/local/bin/autopkg repo-add gerardkok-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.grahampugh-recipes" ] && /usr/local/bin/autopkg repo-add grahampugh-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.hansen-m-recipes" ] && /usr/local/bin/autopkg repo-add hansen-m-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.homebysix-recipes" ] && /usr/local/bin/autopkg repo-add homebysix-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.killahquam-recipes" ] && /usr/local/bin/autopkg repo-add killahquam-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.nstrauss-recipes" ] && /usr/local/bin/autopkg repo-add nstrauss-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.precursorca-recipes" ] && /usr/local/bin/autopkg repo-add precursorca-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.recipes" ] && /usr/local/bin/autopkg repo-add recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.rtrouton-recipes" ] && /usr/local/bin/autopkg repo-add rtrouton-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/com.github.autopkg.smithjw-recipes" ] && /usr/local/bin/autopkg repo-add smithjw-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -d "/Users/$username/Library/AutoPkg/RecipeRepos/recipeFolder" ] && /usr/local/bin/autopkg repo-add https://github.com/recipeRepo;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";

# Update all recipe repos. This will clone the latest changes to your local drive.
/usr/local/bin/autopkg repo-update dataJAR-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update gerardkok-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update grahampugh-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update hansen-m-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update homebysix-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update killahquam-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update nstrauss-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update precursorca-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update rtrouton-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update smithjw-recipes;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg repo-update https://github.com/recipeRepo;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";


# Currently disabled repos.
#autopkg repo-delete scriptingosx-recipes
#autopkg repo-delete mosen-recipes
#autopkg repo-delete n8felton-recipes
#autopkg repo-delete nmcspadden-recipes
#autopkg repo-delete primalcurve-recipes
#autopkg repo-delete jazzace-recipes
#autopkg repo-delete jessepeterson-recipes
#autopkg repo-delete joshua-d-miller-recipes
#autopkg repo-delete jss-recipes
#autopkg repo-delete justinrummel-recipes
#autopkg repo-delete hjuutilainen-recipes
#autopkg repo-delete MLBZ521-recipes
#autopkg repo-delete ahousseini-recipes
#autopkg repo-delete bnpl-recipes

# Create Overrides for all recipes
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$adobeReader.recipe" ] && /usr/local/bin/autopkg make-override $adobeReader;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$adobeCC.recipe" ] && /usr/local/bin/autopkg make-override $adobeCC;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$fireFox.recipe" ] && /usr/local/bin/autopkg make-override $fireFox;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$googleChrome.recipe" ] && /usr/local/bin/autopkg make-override $googleChrome;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$googleDrive.recipe" ] && /usr/local/bin/autopkg make-override $googleDrive;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftAutoUpdate.recipe" ] && /usr/local/bin/autopkg make-override $microsoftAutoUpdate;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftEdge.recipe" ] && /usr/local/bin/autopkg make-override $microsoftEdge;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftExcel.recipe" ] && /usr/local/bin/autopkg make-override $microsoftExcel;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftOutlook.recipe" ] && /usr/local/bin/autopkg make-override $microsoftOutlook;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftPowerpoint.recipe" ] && /usr/local/bin/autopkg make-override $microsoftPowerpoint;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftRemoteDesktop.recipe" ] && /usr/local/bin/autopkg make-override $microsoftRemoteDesktop;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftTeams.recipe" ] && /usr/local/bin/autopkg make-override $microsoftTeams;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$microsoftWord.recipe" ] && /usr/local/bin/autopkg make-override $microsoftWord;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$mySQL.recipe" ] && /usr/local/bin/autopkg make-override $mySQL;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$pyCharm.recipe" ] && /usr/local/bin/autopkg make-override $pyCharm;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$rStudio.recipe" ] && /usr/local/bin/autopkg make-override $rStudio;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$slack.recipe" ] && /usr/local/bin/autopkg make-override $slack;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$spotify.recipe" ] && /usr/local/bin/autopkg make-override $spotify;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$thunderbird.recipe" ] && /usr/local/bin/autopkg make-override $thunderbird;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$visualStudioCode.recipe" ] && /usr/local/bin/autopkg make-override $visualStudioCode;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$vmWareFusion.recipe" ] && /usr/local/bin/autopkg make-override $vmWareFusion;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$vmWareTools.recipe" ] && /usr/local/bin/autopkg make-override $vmWareTools;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$webex.recipe" ] && /usr/local/bin/autopkg make-override $webex;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
[ ! -f "/Users/$username/Library/AutoPkg/RecipeOverrides/$zoom.recipe" ] && /usr/local/bin/autopkg make-override $zoom;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";

# Run AutoPkg recipes to check for latest updates.
/usr/local/bin/autopkg run -vvv $adobeReader;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $adobeCC;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $fireFox;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $googleChrome;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
#/usr/local/bin/autopkg run -vvv $googleDrive;
#DATE=$(date '+%Y-%m-%d %H:%M:%S')
#echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftAutoUpdate;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftEdge;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftExcel;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftOutlook;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftPowerpoint;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftRemoteDesktop;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftTeams;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $microsoftWord;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $mySQL;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $pyCharm;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $rStudio;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $slack;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $spotify;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $thunderbird;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $visualStudioCode;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $vmWareFusion;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $vmWareTools;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $webex;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
/usr/local/bin/autopkg run -vvv $zoom;
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";

exit 0
