#
# Description: Make a directory for the user in the mounted exports.
# Author: Kenneth Evensen <kenneth.evensen@redhat.com>
#


require 'open3'

@method = 'mkdir_exports_user'
$evm.log("info", "----Entering method #{@method}----")

export_domain = nil

user = $evm.root['user']


cmd = "mkdir -p /mnt/exports/#{user.name}"

Open3.popen3(cmd) do |stdin, stdout, stderr, wthr|
	
  error = false
  stderr.each_line { |line| $evm.log("error","#{line}") 
    error = true
    }    
  
  if error
    $evm.log("error","Unable to make directory to /mnt/exports/#{user.name}")
    exit MIQ_ABORT
  end
  
end

$evm.log("info", "----Exiting method #{@method}----")
