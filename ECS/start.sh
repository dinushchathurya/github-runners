#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure the required environment variables are set
if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN is not set. Please set it to a GitHub personal access token."
  exit 1
fi

if [ -z "$RUNNER_NAME" ]; then
  echo "RUNNER_NAME is not set. Please set it to a name for this runner."
  exit 1
fi

if [ -z "$RUNNER_SCOPE" ]; then
  echo "RUNNER_SCOPE is not set. Please set it to either 'user' or 'repository'."
  exit 1
fi

if [ -z "$GITHUB_OWNER" ]; then
  echo "GITHUB_OWNER is not set. Please set it to the owner of the repository or your GitHub username."
  exit 1
fi

if [ "$RUNNER_SCOPE" = "repository" ] && [ -z "$GITHUB_REPOSITORY" ]; then
  echo "GITHUB_REPOSITORY is not set. Please set it to the repository name in 'owner/repo' format."
  exit 1
fi

# Determine the URL based on the scope
if [ "$RUNNER_SCOPE" = "user" ]; then
  RUNNER_URL="https://github.com/$GITHUB_OWNER"
elif [ "$RUNNER_SCOPE" = "repository" ]; then
  RUNNER_URL="https://github.com/$GITHUB_REPOSITORY"
else
  echo "Invalid RUNNER_SCOPE value. It should be either 'user' or 'repository'."
  exit 1
fi

# Configure the GitHub Actions runner
./config.sh --url "${RUNNER_URL}" --token "${GITHUB_TOKEN}" --name "${RUNNER_NAME}" --work "_work" --replace

# Run the GitHub Actions runner
./run.sh
