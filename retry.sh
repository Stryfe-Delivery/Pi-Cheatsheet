#retry loop for fault-ish code chunks

#Example call
retry curl -fsS http://example.com

#function loop
retry() {
  local n=1
  local max=5
  local delay=2
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        echo "Attempt $n failed, retrying in $delay seconds..."
        ((n++))
        sleep $delay
      else
        echo "Command failed after $n attempts."
        return 1
      fi
    }
  done
}
