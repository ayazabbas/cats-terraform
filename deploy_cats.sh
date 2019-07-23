#!/bin/bash
set -e
printf "Enter desired application version (git tag)...\n"
read VERSION
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "${DIR}"

# cleanup tmp folder
if [ -d "${DIR}/tmp" ]; then
    printf "Cleaning up tmp folder...\n"
    rm -rf "${DIR}/tmp"
fi
mkdir "${DIR}/tmp"

cd "${DIR}/tmp"
git clone https://github.com/Streetbees/cats.git
cd "${DIR}/tmp/cats"
git checkout "${VERSION}"
zip -r "${DIR}/tmp/cats.zip" *
cd "${DIR}/tmp"
rm -rf cats
cd "${DIR}"

terraform apply -var app_version="${VERSION}"

# Start a state machine execution to kick off the pipeline
state_machine_arn=$(cat "${DIR}/tmp/state-machine-arn.txt")
state_machine_input=$(cat "${DIR}/tmp/streetbees-cats-pipeline-input.json")
printf "Executing Step Functions state machine...\n"
response=$(aws stepfunctions start-execution --state-machine-arn "${state_machine_arn}" --input "${state_machine_input}")
printf "${response}\n"
execution_arn=$(echo "${response}" | jq -r '.executionArn')
status="RUNNING"
while [ "${status}" == "RUNNING" ]; do
    status=$(aws stepfunctions describe-execution --execution-arn "${execution_arn}" | jq -r '.status')
    echo "State Machine is: ${status}"
    if [ "${status}" == "RUNNING" ]; then
        sleep 20
    fi
done

printf "Cleaning up tmp folder...\n"
rm -rf "${DIR}/tmp"
