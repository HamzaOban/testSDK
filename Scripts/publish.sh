#!/usr/bin/env bash


LOG_TAG="MSDK_BUILD_LOG"



function publishSDKToGitHubRepo(){
	echo "Publishing target ${1} to Github"

    export GITHUB_TOKEN=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
    export GITHUB_USER=HamzaOban
    git config user.name "HamzaOban"
    git config user.email "hamzaoban3@gmail.com"
	# Github will be clone as https in build.sh. Using https every developer can clone github repo with its cridentials.
	# But pushing on jenkins requires ssh otherwise it will ask password. To solve this change remote url to ssh.
    git remote set-url origin https://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@github.com/HamzaOban/TestRelease.git
    echo "remote set-url origin log"
	git checkout main
    echo "checkout main log"

	git status
    echo "status log"

	git branch -a
    echo "branch log"

	git fetch
    git reset --hard origin/main
    echo "pull log"

	git add .
	git commit -m "Version ${SDK_VERSION} release."

	echo "Publishing target ${1} to Github completed"
	
	git push --set-upstream origin main
	
	#parsing changelog for get release note of version
	RELEASE_NOTE="$(/usr/local/bin/changelog-parser CHANGELOG.md | /usr/local/bin/jq -r --arg a_version ${SDK_VERSION} '.versions[] | select(.version == $a_version) | .body')"

	#create release on github
	/usr/local/bin/hub release create ${SDK_VERSION} -m "${SDK_VERSION}" -m "$RELEASE_NOTE"
	
    # Go to root directory of the project
	cd "$CURRENT_PWD"
    echo "${LOG_TAG} Current dir after publish ends: $PWD"
}






publishSDKToGitHubRepo MobileSDK

echo "${LOG_TAG} PUBLISHING TO GITHUB COMPLETED"

