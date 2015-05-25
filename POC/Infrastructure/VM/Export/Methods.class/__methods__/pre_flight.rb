#
# Description: This method will ensure qemu-img is installed for conversion to vmdk or qcow2.
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>

require 'open3'

@method = 'pre_flight'
$evm.log("info", "----Entering method #{@method}----")

cmd = "yum list installed | grep qemu-img"

Open3.popen3(cmd) do |stdin, stdout, stderr, wthr|
	
  error = true
  
  stdout.each_line { |line| $evm.log("info","#{line}")
    error = false
    } 
  
  stderr.each_line { |line| $evm.log("error","#{line}")
    error = true
    }    
  
  if error
    $evm.log("error","qemu-img not installed.  Cannot continue.")
    exit MIQ_ABORT
  end
  
end

$evm.log("info", "----Exiting method #{@method}----")
