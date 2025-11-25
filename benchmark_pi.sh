#!/bin/bash
# save as benchmark_pi.sh
# collection of speed/performance tests
# objective is to strip down PiOS and see where gains can be made

echo "=== Raspberry Pi OS Benchmark ==="
echo "Running on: $(date)"
echo ""

# 1. Boot time analysis
echo "1. BOOT TIME ANALYSIS:"
systemd-analyze | tee -a benchmark_results.txt
echo ""

# 2. Memory usage
echo "2. MEMORY USAGE:"
free -h | tee -a benchmark_results.txt
echo ""

# 3. Storage performance
echo "3. STORAGE PERFORMANCE:"
echo "Write speed test:"
dd if=/dev/zero of=./testfile bs=1M count=100 oflag=direct 2>&1 | tail -1
echo "Read speed test:"
dd if=./testfile of=/dev/null bs=1M 2>&1 | tail -1
rm -f testfile
echo ""

# 4. CPU performance
echo "4. CPU PERFORMANCE:"
echo "Calculating 5000 primes with sysbench (if installed):"
if command -v sysbench &> /dev/null; then
    sysbench cpu --cpu-max-prime=5000 run | grep "events per second"
else
    echo "Install sysbench: sudo apt install sysbench"
fi
echo ""

# 5. Application launch times
echo "5. APPLICATION LAUNCH TIMES:"
echo "Testing terminal app launch..."
time (lxterminal -e "exit" 2>/dev/null)
echo ""

# 6. Package count comparison
echo "6. SYSTEM SIZE:"
dpkg-query -f '${binary:Package}\n' -W | wc -l | tee -a benchmark_results.txt
echo "Total packages installed"
echo ""

echo "Benchmark complete. Full results saved to benchmark_results.txt"
