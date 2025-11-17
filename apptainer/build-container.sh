#!/bin/bash

# Record start time
start_time=$(date +%s)

echo "Starting apptainer build at $(date)"

# Run the build
make gcc
status=$?  # Capture exit status

# Record end time
end_time=$(date +%s)
elapsed=$((end_time - start_time))

# Report result
if [ $status -eq 0 ]; then
    echo "✅ Build succeeded in ${elapsed} seconds."
else
    echo "❌ Build failed after ${elapsed} seconds (exit code: $status)."
fi
