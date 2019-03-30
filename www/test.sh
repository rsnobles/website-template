#!/bin/bash

export suite_name="${1:-*}"
export test_name="${2:-*}"

if [[ "${suite_name}" == "cypress"* ]]; then
  npm run cypress:run
else
  echo "ERROR: Uknown test suite: ${suite_name}"
  exit 1
fi
