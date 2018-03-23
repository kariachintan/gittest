#cat ~/.vimrc
#syntax on 

echo -e "Enter the previous release branch number e.g. (release.0.0.50) \c "
 read previousReleaseBranch

if ([ -z "$previousReleaseBranch" ]) then
	echo "I am in if"
    exit 1;
else
	echo "I am in else"
    exit 2;
fi
