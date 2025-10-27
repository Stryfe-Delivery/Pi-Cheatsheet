This is a collection of **small “quality of life” code snippets, shell tweaks, and habits** that can make developing and experimenting on a Raspberry Pi dramatically smoother — especially when you’re juggling Python projects, GPIO work, and system tinkering.

---

## Development Environment Helpers

### **Auto-update & cleanup function**

Keeps your Pi’s system, Python packages, and cache tidy with one command.

Add to `~/.bashrc`:

```bash
alias piupdate='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean && echo && echo "System updated ✅"'
```

Usage:

```bash
piupdate
```

---

### **Quick project launcher**

If you often test Python projects:

```bash
function runproj() {
    cd ~/projects/$1 || return
    source venv/bin/activate
    clear
    echo "Running project: $1"
    python3 main.py
}
```

Usage:

```bash
runproj weather_station
```

---

### **Auto-activate Git branch in prompt**

Nice for tracking what branch you’re on without typing `git status`.

Add this in `~/.bashrc` **after** your prompt setup:

```bash
parse_git_branch() {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}

export PS1="\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[36m\]\$(parse_git_branch)\[\e[0m\]\n\$ "
```

Now your terminal prompt shows:

```
pi@raspberrypi ~/projects/led_controller main
$
```

---

### **Custom `ll` and `la`**

Helpful for quick inspection:

```bash
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
```

---

## Python / Project Efficiency

### **Check Pi’s CPU and memory in Python**

Add to your project utilities:

```python
import psutil

def system_info():
    cpu = psutil.cpu_percent(interval=1)
    mem = psutil.virtual_memory().percent
    print(f"CPU: {cpu:.1f}% | Memory: {mem:.1f}%")

if __name__ == "__main__":
    system_info()
```

Usage:

```bash
python utils.py
```

→ Outputs `CPU: 7.2% | Memory: 43.1%`

(Install `psutil` if needed: `pip install psutil`)

---

### **Auto-restart Python script on crash**

Handy for long-running scripts (e.g., sensors or web servers):

```bash
while true; do
    python3 main.py
    echo "Script crashed with exit code $? — restarting in 5s..."
    sleep 5
done
```

Save as `run.sh`, make executable:

```bash
chmod +x run.sh
./run.sh
```

---

## Performance / Monitoring

### **View Pi temperature and throttling**

Add an alias:

```bash
alias pitemp="vcgencmd measure_temp && vcgencmd get_throttled"
```

Example output:

```
temp=48.5'C
throttled=0x0
```

If `throttled` ≠ `0x0`, the Pi has been throttled due to temperature or voltage issues.

---

### **Quick CPU and RAM usage summary**

```bash
alias pisys="echo 'CPU:' $(top -bn1 | grep load | awk '{printf \"%.2f%%\\n\", $(NF-2)*100/4}') && free -h | awk '/Mem:/ {print \"RAM: \"$3\" / \"$2}'"
```

---

### **Disable HDMI to save power (headless Pi)**

If you run your Pi headless, this saves ~20–30 mA of power draw:

```bash
alias hdmi-off='sudo /usr/bin/tvservice -o'
alias hdmi-on='sudo /usr/bin/tvservice -p'
```

---

## GPIO / Hardware Convenience

### **Quick test for GPIO pin states**

If using RPi.GPIO or gpiozero, this script reads all pins:

```python
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
for pin in range(2, 28):
    try:
        GPIO.setup(pin, GPIO.IN)
        print(f"Pin {pin}: {'HIGH' if GPIO.input(pin) else 'LOW'}")
    except:
        pass
GPIO.cleanup()
```

---

### **I2C device scan**

Use this command to quickly check which I2C devices are detected:

```bash
sudo i2cdetect -y 1
```

---

## System Management Tricks

### **Show uptime and temperature on login**

Add to end of `~/.bashrc`:

```bash
echo "Uptime: $(uptime -p)"
echo "Temp: $(vcgencmd measure_temp | cut -d= -f2)"
```

You’ll see it each time you open a terminal:

```
Uptime: up 1 hour, 42 minutes
Temp: 47.8'C
```

---

### **Backup project folders**

Simple one-liner backup to USB or NAS:

```bash
alias pibackup='rsync -av --progress ~/projects/ /media/pi/BACKUP/projects_$(date +%Y%m%d)/'
```

---

## Useful tools to install

| Tool         | Command                     | Purpose                                  |
| ------------ | --------------------------- | ---------------------------------------- |
| **htop**     | `sudo apt install htop`     | Interactive CPU/memory monitor           |
| **ncdu**     | `sudo apt install ncdu`     | Disk usage visualizer (faster than `du`) |
| **neofetch** | `sudo apt install neofetch` | Pretty system info summary               |
| **tmux**     | `sudo apt install tmux`     | Run persistent terminal sessions         |
| **glances**  | `sudo apt install glances`  | Full system dashboard                    |

---

### Example: Daily workflow on an optimized Pi

```bash
piupdate                      # Keep system fresh
cd ~/projects/weather_station # Enter project folder
# auto venv activates
runproj weather_station       # Run and test your project
pitemp                        # Check Pi health
pibackup                      # Sync code to backup drive
```

---

Would you like me to group a handful of the **most useful 5–7 of these into a single ready-to-copy “Pi Dev Starter Pack” block** (like a tuned `.bashrc` segment for developers)?
