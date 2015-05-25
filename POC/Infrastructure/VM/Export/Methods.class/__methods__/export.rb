#
# Description: This method will invoke an export of a template via the RHEV-M REST API
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>
#

require 'rest-client'
require 'nokogiri'

@method = 'export'
$evm.log("info", "----Entering method #{@method}----")

export_domain = nil

vm = $evm.root['vm']
mgmt_sys=vm.ext_management_system

url = "https://"+mgmt_sys.hostname+":443/"+vm.ems_ref+"/export"
user = mgmt_sys.authentication_userid
password = mgmt_sys.authentication_password

stores = mgmt_sys.storages

stores.each { |store| 
  
  $evm.log("info"," Store Name - #{store.name}")
  if store.name.eql? $evm.object['export_domain']
    export_domain = store
  end
    
}

export_store_id =  export_domain.ems_ref.sub("/api/storagedomains/","")

payload = "<action><storage_domain id=\"#{export_store_id}\"/><exclusive>true</exclusive></action>"

response = RestClient::Request.new(
          :method => :post,
          :url => url,
  		  :user => user,
          :password => password,
  		  :verify_ssl => false,
          :headers => { :accept => :xml,
          :content_type => :xml },
  		  :payload => payload
      ).execute

xml_response  = Nokogiri::XML(response)

$evm.log("info","Response - #{response}")

job_id = xml_response.xpath("//job/@href").first.value
$evm.root['job_id'] = job_id

$evm.log("info", "----Exiting method #{@method}----")
