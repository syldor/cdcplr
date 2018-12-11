#!/bin/bash
set -e

# Run this in your Hugo blog repo directory

DISTRIBUTION_ID=EVBI55VXT2Y4M
BUCKET_NAME=creerdescartespourlarecherche.fr
PROFILE=default # or `default` if you don't use profiles

snap run hugo -v 

# Copy over pages - not static js/img/css/downloads
aws s3 sync --profile ${PROFILE} --acl "public-read" --sse "AES256" public/ s3://${BUCKET_NAME}/ 

# Ensure static files are set to cache forever - cache for a month --cache-control "max-age=2592000"
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/img/ s3://${BUCKET_NAME}/img/ 
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/css/ s3://${BUCKET_NAME}/css/ 
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/js/ s3://${BUCKET_NAME}/js/ 

# Invalidate landing page so everything sees new post - warning, first 1K/mo free, then 1/2 cent each
aws cloudfront create-invalidation --profile ${PROFILE} --distribution-id ${DISTRIBUTION_ID} --paths /index.html /



aws cloudfront create-invalidation --profile default --distribution-id EVBI55VXT2Y4M --paths "/*"

