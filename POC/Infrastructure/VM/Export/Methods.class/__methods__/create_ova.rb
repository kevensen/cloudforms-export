#
# Description: Create the OVA file
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>
#


require 'open3'
require 'nokogiri'

@method = 'create_ova'
$evm.log("info", "----Entering method #{@method}----")


#The first step will be to get the *.ovf file and add it to the tar archive.
def create_initial_tar(user_name, store_id, vm_name, vm_id, vdisk_location)
  
  cmd = "cd /mnt/exports/#{store_id}; tar -czf /mnt/exports/#{user_name}/#{vm_name}.tar.gz master/vms/#{vm_id} images/#{vdisk_location} images/#{vdisk_location}.meta"

  Open3.popen3(cmd) do |stdin, stdout, stderr, wthr|
	
      error = false

      stdout.each_line { |line| $evm.log("info","#{line}") }  

      stderr.each_line { |line| $evm.log("error","#{line}") 
        error = true
        }    
  
      if error
        $evm.log("error","Unable to create tar file /mnt/exports/#{user_name}/#{vm_name}.tar.gz")
        exit MIQ_ABORT
      end
    end
  
end

def make_ova(user_name, vm_name)
   cmd = "mv /mnt/exports/#{user_name}/#{vm_name}.tar.gz /mnt/exports/#{user_name}/#{vm_name}.ova"

  Open3.popen3(cmd) do |stdin, stdout, stderr, wthr|
	
      error = false

      stdout.each_line { |line| $evm.log("info","#{line}") }  

      stderr.each_line { |line| $evm.log("error","#{line}") 
        error = true
        }    
  
      if error
        $evm.log("error","Unable to make OVA file /mnt/exports/#{user_name}/#{vm_name}.ova")
        exit MIQ_ABORT
      end
    end
  
end

def extract_vdisk_location(ovf_path)
  
  xml_response  = Nokogiri::XML(File.open(ovf_path))
  vdisk_location = xml_response.xpath('//References/File/@ovf:href').first.value
  
end



time = Time.new

export_domain = nil

user = $evm.root['user']
vm = $evm.root['vm']
mgmt_sys=vm.ext_management_system

stores = mgmt_sys.storages

stores.each { |store| 
  if store.name.eql? $evm.object['export_domain']
    export_domain = store
  end
    
  }
store_id = export_domain.ems_ref.sub("/api/storagedomains/","")

my_time = time.strftime("%Y-%m-%d-%H-%M-%S")

my_vm_name = "#{vm.name}_#{my_time}"

vdisk_location = extract_vdisk_location("/mnt/exports/#{store_id}/master/vms/#{vm.uid_ems}/#{vm.uid_ems}.ovf")

create_initial_tar(user.name, store_id, my_vm_name, vm.uid_ems, vdisk_location)

make_ova(user.name, my_vm_name)


$evm.log("info", "----Exiting method #{@method}----")

