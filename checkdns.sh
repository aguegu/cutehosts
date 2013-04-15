#!/bin/bash

cat dns.txt | grep "^[^#]." | fping -a

