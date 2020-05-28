#!/bin/bash

source /opt/codechecker/venv/bin/activate
exec /opt/codechecker/build/CodeChecker/bin/CodeChecker "$@"
