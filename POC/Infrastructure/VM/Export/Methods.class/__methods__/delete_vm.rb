#
# Description: This method will delete the VM from the storage domain to save space
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>
#

require 'rest-client'
require 'nokogiri'

@method = 'delete_vm'
$evm.log("info", "----Entering method #{@method}----")

export_domain = nil

vm = $evm.root['vm']
mgmt_sys=vm.ext_management_system



stores = mgmt_sys.storages

stores.each { |store| 
  
  $evm.log("info"," Store Name - #{store.name}")
  if store.name.eql? $evm.object['export_domain']
    export_domain = store
  end
    
}

url = "https://"+mgmt_sys.hostname+":443#{export_domain.ems_ref}/vms/#{vm.ems_ref.sub("/api/vms/","")}"
user = mgmt_sys.authentication_userid
password = mgmt_sys.authentication_password

$evm.log("info", "URL is #{url}")

response = RestClient::Request.new(
  		:method => :delete,
          :url => url,
  		  :user => user,
          :password => password,
  		  :verify_ssl => false,
          :headers => { :accept => :xml,
          :content_type => :xml }
      ).execute

xml_response  = Nokogiri::XML(response)

$evm.log("info","Response - #{response}")

$evm.log("info", "----Exiting method #{@method}----")
