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

# enter previous release branch number
echo -e "Enter the previous release branch number e.g. (release.0.0.50) \c "
read previousReleaseBranch

# checkout previous release branch
git checkout $previousReleaseBranch

# git pull origin previous releae branch
git pull origin $previousReleaseBranch

# checkout new release branch
git checkout $releaseBranch 

echo -e "Are you sure you want to merge the previous release branch $previousReleaseBranch into new $releaseBranch? (y|n): \c "
read confirm

if([ $confirm == "y" ]) then

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
else
	echo "Aborted the merging of old release branch into new release branch."
	echo "Deleting the new release branch $releaseBranch"
	git checkout $masterBranch
	git branch -d $releaseBranch
    exit 2;
fi	