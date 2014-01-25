import sys
import os
from os.path import dirname, abspath

# add our python package to the path
project_root = dirname(dirname(abspath(__file__)))  # our parent directory
server_root = os.path.join(project_root, "src/main/py")
sys.path.append(server_root)
