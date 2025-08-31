echo 'Build enviroment'
docker build . --target intellij_idea --tag intellij_idea
echo 'Build'
docker run --rm --user "$(id -u)" --volume "${PWD}:/community" intellij_idea -Dintellij.build.target.os=linux
