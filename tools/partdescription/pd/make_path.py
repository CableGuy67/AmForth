
import os
import errno

def make_path(base):
  try: 
    os.makedirs(base+"/blocks")
    os.makedirs(base+"/words")
  except OSError as exception:
    if exception.errno != errno.EEXIST:
      raise
