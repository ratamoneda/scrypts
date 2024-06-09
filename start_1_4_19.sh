cd /home/quilibrium/ceremonyclient/
# Set the primary and mirror remote URLs
PRIMARY_URL="https://source.quilibrium.com/quilibrium/ceremonyclient.git"
MIRROR_URL="https://git.quilibrium-mirror.ch/agostbiro/ceremonyclient.git"

# Function to set the remote URL and fetch
fetch_from_remote() {
  local url=$1
  git remote set-url origin "$url"
  if git fetch origin; then
    echo "Successfully fetched from $url"
    return 0
  else
    echo "Failed to fetch from $url"
    return 1
  fi
}

# Try fetching from the primary URL
if fetch_from_remote "$PRIMARY_URL"; then
  echo "Fetching from primary source succeeded."
else
  echo "Fetching from primary source failed. Attempting to fetch from mirror."
  # Try fetching from the mirror URL
  if fetch_from_remote "$MIRROR_URL"; then
    echo "Fetching from mirror succeeded."
  else
    echo "Fetching from both primary and mirror sources failed."
    exit 1
  fi
fi

# Checkout and track the release-cdn branch
git checkout -b release-cdn --track origin/release-cdn
git fetch origin && git checkout -b release-cdn --track origin/release-cdn
cd node
./release_autorun.sh
