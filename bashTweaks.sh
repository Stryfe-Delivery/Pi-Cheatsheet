# ================================
# Pi NAS + XRDP Development Starter
# ================================
# nano ~/.bashrc
# add these to bulk implement or use the readme / parse this for select commands 

# --- 1. System & Dev Helpers ---
# Quick system update & cleanup
alias piupdate='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean && echo "System updated"'

# Quick CPU/Memory info
alias pisys="echo 'CPU:' $(top -bn1 | grep load | awk '{printf \"%.2f%%\\n\", $(NF-2)*100/4}') && free -h | awk '/Mem:/ {print \"RAM: \"$3\" / \"$2}'"

# Quick temperature & throttling info
alias pitemp="vcgencmd measure_temp && vcgencmd get_throttled"

# Quick list directory helpers
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'

# ================================
# --- 2. Python Project Helpers ---
# Auto-activate Python venv when entering a directory
function cd() {
    builtin cd "$@" || return
    if [ -f "venv/bin/activate" ]; then
        if [ -n "$VIRTUAL_ENV" ]; then
            deactivate
        fi
        source venv/bin/activate
        echo "(auto) activated virtual environment in $(pwd)"
    elif [ -n "$VIRTUAL_ENV" ]; then
        deactivate
        echo "(auto) deactivated virtual environment"
    fi
}

# Auto-activate venv if opening terminal directly inside project
if [ -f "venv/bin/activate" ] && [ -z "$VIRTUAL_ENV" ]; then
    source venv/bin/activate
    echo "(auto) activated virtual environment in $(pwd)"
fi

# Quick run project function
function runproj() {
    cd ~/projects/$1 || return
    source venv/bin/activate
    clear
    echo "🚀 Running project: $1"
    python3 main.py
}

# Rebuild venv safely (keeps dependencies)
alias rebuildvenv='pip freeze > requirements.txt && rm -rf venv && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt'

# ================================
# --- 3. NAS Access & Sync ---
# Change these to match your NAS
NAS_IP="192.168.1.100"
NAS_SHARE="ShareName"
NAS_MOUNT="/mnt/nas"
NAS_USER="pi"
NAS_PASS="YourPassword"

# Mount NAS
alias mountnas="sudo mount -t cifs //$NAS_IP/$NAS_SHARE $NAS_MOUNT -o username=$NAS_USER,password=$NAS_PASS,uid=pi,gid=pi"

# Unmount NAS
alias unmountnas="sudo umount $NAS_MOUNT"

# Sync local projects to NAS
alias syncnas="rsync -avh --progress ~/projects/ $NAS_MOUNT/projects_backup/"

# Ping NAS quickly
alias pingnas="ping -c 3 $NAS_IP"

# ================================
# --- 4. XRDP / Remote Desktop ---
# Start / Stop XRDP
alias rdpstart="sudo systemctl start xrdp"
alias rdpstop="sudo systemctl stop xrdp"
alias rdpstatus="sudo systemctl status xrdp"

# Remote desktop to another Pi / machine (change IP & user as needed)
alias rempi="xfreerdp /v:192.168.1.51 /u:pi /p:YourPassword"

# ================================
# --- 5. Optional Power & Backup ---
# Disable HDMI to save power (headless)
alias hdmi-off='sudo /usr/bin/tvservice -o'
alias hdmi-on='sudo /usr/bin/tvservice -p'

# Quick backup projects to NAS
alias pibackup='rsync -avh --progress ~/projects/ $NAS_MOUNT/projects_$(date +%Y%m%d)/'

# Show uptime and temp on terminal open
echo "Uptime: $(uptime -p)"
echo "Temp: $(vcgencmd measure_temp | cut -d= -f2)"
