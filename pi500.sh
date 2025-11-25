# Because pi500+ runs off SSD

# Ensure TRIM is enabled for SSD longevity
sudo fstrim -v /
# Enable weekly TRIM
sudo systemctl enable fstrim.timer
