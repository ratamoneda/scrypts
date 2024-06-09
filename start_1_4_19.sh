cd /home/quilibrium/ceremonyclient/
git remote set-url origin https://source.quilibrium.com/quilibrium/ceremonyclient
git fetch origin && git checkout -b release-cdn --track origin/release-cdn
cd node
./release_autorun.sh
