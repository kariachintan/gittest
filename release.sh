#!/bin/bash

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# establish branch and tag name variables
masterBranch=master
releaseBranch=$1

# checkout master branch
git checkout $masterBranch

echo "Doing git pull origin master."

# git pull origin master
git pull origin $masterBranch

# create the release branch from the -develop branch
git checkout -b $releaseBranch $masterBranch

# create the release branch from the -develop branch
git push --set-upstream origin $releaseBranch 

echo -e "Do you have a previous release branch to merge into the new one? \c "
read confirm

if([ $confirm == "y" ]) then

    # enter previous release branch number
    echo -e "Enter the previous release branch number e.g. (release.0.0.50) \c "
    read previousReleaseBranch

    if[ -z "$previousReleaseBranch"]
        echo "Created new local and remote release branch i.e. $releaseBranch \c"
        exit 1;
    else
        # checkout previous release branch
        git checkout $previousReleaseBranch

        # git pull origin previous releae branch
        git pull origin $previousReleaseBranch

        # checkout new release branch
        git checkout $releaseBranch 

        echo "Merging $previousReleaseBranch into $releaseBranch "

        result=`git merge --no-ff $previousReleaseBranch`

        if([ "$result" == "`echo $result | grep "^Already up-to-date\."`" ]) then
            echo "The branch is already up to date.";
            exit 1;
        else
            git push origin $releaseBranch
            echo "Finished merging."
            exit 1;
        fi
    fi
else
    echo "Created new local and remote release branch i.e. $releaseBranch \c"
    exit 1;
fi  