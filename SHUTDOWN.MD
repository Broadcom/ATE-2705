## Shutdown procedure:

#### 1. Shutdown nested environment:
  1. ssh holuser@manager

  2. cd hol

  3. python3 Shutdown/Shutdown.py

Wait until complete. 

2) Shutdown router as follows:
On the router, login as root and run the /root/shutdown.sh script -This was written today to perform a graceful shutdown of the kubernetes stuff because the way the holorouter was given to us, it just killed things at shutdown instead of graceful.

3) Shutdown manager

4) Shutdown console
