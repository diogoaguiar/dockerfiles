#!/bin/bash

trap "exit" SIGTERM SIGINT
tail -f /dev/null