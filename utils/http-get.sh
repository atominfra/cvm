#!/bin/bash

function http_get() {
    local url="$1"
    local response
    local status_code

    # Make the curl request
    response=$(curl -s -w "%{http_code}" -o /tmp/curl_response "$url")

    # Extract the HTTP status code
    status_code="${response: -3}"
    # Extract the HTTP response body
    http_body=$(< /tmp/curl_response)

    # Check if the response is not in the 2xx range
    if [[ $status_code -lt 200 || $status_code -ge 300 ]]; then
        return 1  # Return non-zero for error
    fi

    echo "$http_body"
    return 0  # Return zero for success
}