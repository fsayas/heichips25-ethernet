import os
import glob

# Get the directory where launch.py is located
base_dir = os.path.dirname(os.path.abspath(__file__))
runs_dir = os.path.join(base_dir, "runs")

# Find all directories that start with "RUN_"
run_dirs = glob.glob(os.path.join(runs_dir, "RUN_*"))

# Sort alphabetically to find the latest one by timestamp
run_dirs.sort()

if run_dirs:
    latest_run = run_dirs[-1]
    print(latest_run)
else:
    print("No RUN folders found.")