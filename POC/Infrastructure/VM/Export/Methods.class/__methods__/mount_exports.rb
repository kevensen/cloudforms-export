#
# Description: Mounts the exports storage domain to the appliance
# Author: Kenneth Evensen <kenneth.evensen@redhat.com>
#


require 'open3'

@method = 'mount_exports'
$evm.log("info", "----Entering method #{@method}----")

export_domain = nil

vm = $evm.root['vm']
mgmt_sys=vm.ext_management_system

stores = mgmt_sys.storages

stores.each { |store| 
  if store.name.eql? $evm.object['export_domain']
    export_domain = store
  end
    
}

cmd = "mkdir -p /mnt/exports; mount -o vers=3 #{export_domain.location} /mnt/exports"

Open3.popen3(cmd) do |stdin, stdout, stderr, wthr|
	
  error = false
  stderr.each_line { |line| $evm.log("error","#{line}")
    unless line.include? "already mounted"
    	error = true
    else
      error = false
    end
    }    
  
  if error
    $evm.log("error","Unable to mount #{export_domain.location} to /mnt/exports")
    exit MIQ_ABORT
  end
  
end

$evm.log("info", "----Exiting method #{@method}----")
