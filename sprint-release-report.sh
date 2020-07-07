#!/bin/bash
showhelp() {
	echo "---------------------------------------------------------------------------------------"
	echo "setup: "
	echo "1. git clone the Bamboo, Mooncake or both serive projects in ths same folder			"
	echo "2. set the project_dir with your upscale service project location							"
	echo "---------------------------------------------------------------------------------------"
	echo "run: "
	echo "command: sprint-release-report [options]"
	echo "-m : only Mooncake"
	echo "-b : only Bamboo"
	echo "-a : both two teams (default is both)"
	echo "-h : help"
}

echo
echo "------------------------------------------------------------------------------------------"
echo "		This tool is used to generate the sprint release notes basd on github				"
echo "------------------------------------------------------------------------------------------"
echo

release_notes=$(pwd)/release_notes.txt
project_dir="/Users/i340818/workspace/github"
projcet_name_bamboo=("caas2-uaa-configuration" "approuter" "continuity-engine" "customer-service" "job-scheduler-service" "order-streaming" "standing-order-service" "caas2-idp-service" "payment-service")
project_name_mooncake=("order-broker" "order-export" "shipping-service" "tax-service" "configuration-service" "gbaas-service")


generateProjectReleaseNotes() {
	cd $project_dir/$project
	echo "----------------------------------------------------------------------------" >> $release_notes
	echo $project: >> $release_notes
	echo "start $project"
	echo "start $project fetch"
	git fetch --all
	echo "start $project master and develop branch compare"
	sha1=`git rev-parse --short origin/develop`
	 echo [$sha1]>> $release_notes
	git --no-pager log origin/master...origin/develop | grep \#[0-9] | sort -u >> $release_notes
	echo "----------------------------------------------------------------------------" >> $release_notes
	echo >> $release_notes
	echo "finish $project"
}

bambooReport() {
	echo 'start bamboo service report generation ---------------------------------------'
	for project in ${projcet_name_bamboo[*]}
	do
		generateProjectReleaseNotes
	done
}

mooncakeReport() {
	echo 'start mooncake service report generation ---------------------------------------'
	for project in ${project_name_mooncake[*]}
	do
		generateProjectReleaseNotes
	done
}



# clean the release notes file
echo "sprint release notes" > $release_notes
echo >> $release_notes

if test $# -eq 1
then
	if test $1 == "-h"
	then
		showhelp
		read
	 elif test $1 == "-b"
	 then
	 	bambooReport
	 elif test $1 == "-m"
	 then
	 	mooncakeReport
	 elif test $1 == "-a"
	 then
	 	bambooReport
		mooncakeReport
	 fi
else
	bambooReport
	mooncakeReport
fi


