#!/bin/bash

conf="\"tst\""

jq --argjson value "$conf" '.conf_path += [$value]' .wgbconf.json
