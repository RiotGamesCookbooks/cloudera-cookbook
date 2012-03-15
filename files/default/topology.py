#!/usr/bin/env python 

''' 
This script used by hadoop to determine network/rack topology.  It 
should be specified in hadoop-site.xml via topology.script.file.name 
Property. 

<property> 
 <name>topology.script.file.name</name> 
 <value>/home/hadoop/topology.py</value> 
</property> 
''' 

import sys 
from string import join 

DEFAULT_RACK = '/default/rack0'; 

RACK_MAP = { }

if len(sys.argv)==1: 
    print DEFAULT_RACK 
else: 
    print join([RACK_MAP.get(i, DEFAULT_RACK) for i in sys.argv[1:]]," ") 
