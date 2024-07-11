# Node not ready issue
* Due to CPU, Disk, Ram utilization.
* kubelet is down.
* In our workstation, there is a bridge network that works as L2 Bridge, and it does not support routing. So kubernetes will make its own bridge network known as L3 bridge network, and it supports routing.
* 