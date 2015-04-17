#!/bin/bash

function cleanup {
  local image_out=$(docker images)
  local image_hash=$(echo "${image_out}")
  local image_id=$(echo $image_hash | sed -e "s/.*loftili\/browser_build\s\w\{6,20\}\s\(\w\{12\}\).*/\1/g")
  docker rmi $image_id
  return 0
}

cleanup
