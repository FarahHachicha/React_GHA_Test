#!/bin/bash

# Get the last commit log
OUTPUT=$(git log -1 --oneline)
# Get the version from commit log
VERSION=$(echo "${OUTPUT}" | cut -c1-8)

printf "Deploy version ${VERSION} from commit: \n\t -> ${OUTPUT}\n"

echo 1. Build react-template:${VERSION}
echo  - docker build -t react-template:${VERSION} .
docker build -t react-template:${VERSION} .

echo 2. Remove latest prev container
echo  - docker rm -f react-template
docker rm -f react-template

echo 3. Run new container from build image
echo  - docker run -itd --name react-app -p 8080:80 react-template:${VERSION}
docker run -itd --name react-template --restart=always -p 8080:80 react-template:${VERSION}

echo Finish APP Deployment!!
exit 0