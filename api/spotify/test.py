import sys, os
print('sys.argv[0] =', sys.argv[0])             
print('path =', os.path.dirname(sys.argv[0]))
print('full path =', os.path.abspath(os.path.dirname(sys.argv[0])))
