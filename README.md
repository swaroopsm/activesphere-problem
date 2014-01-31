### ActiveSphere Problem
-
	$ ruby app.rb -m 10

	-m: Memory to allocate in MegaBytes

#### Operations Supported:

**Set:**

	Set a key/value.
	Eg.: set name swaroop

**Get:**

	Get value by key
	Eg.: get name

**Flush:**
	
	Flushes/Clears all data
	Eg.: flush

**All:**
	
	Get All Data
	Eg.: all

Note:
This also implements a LRU, when memory allocated is not sufficient.
