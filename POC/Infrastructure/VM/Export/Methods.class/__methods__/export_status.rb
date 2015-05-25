#
# Description: This method determines the status of a job
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>

require 'rest-client'
require 'nokogiri'

@method = 'export_status'
$evm.log("info", "----Entering method #{@method}----")

def process_job_tags(vm)
  
  zero = vm.tags("job_id_0")[0]
  one = vm.tags("job_id_1")[0]
  two = vm.tags("job_id_2")[0]
  three = vm.tags("job_id_3")[0]
  four = vm.tags("job_id_4")[0]
  
  job_id = "#{zero}-#{one}-#{two}-#{three}-#{four}"
  
  return job_id
  
end


vm = $evm.root['vm']
mgmt_sys=vm.ext_management_system

job_id = process_job_tags(vm)
$evm.log("info", "Job ID = #{job_id}")

url = "https://"+mgmt_sys.hostname+":443/api/jobs/#{job_id}"
user = mgmt_sys.authentication_userid
password = mgmt_sys.authentication_password

response = RestClient::Request.new(
  	      :method => :get,
          :url => url,
  		  :user => user,
          :password => password,
  		  :verify_ssl => false,
          :headers => { :accept => :xml,
          :content_type => :xml }
      ).execute

$evm.log("debug","Job Response - #{response}")

xml_response  = Nokogiri::XML(response)

job_status = nil

job_status = xml_response.xpath('//status/state')[0].content
  
$evm.log("info", "Job Status = #{job_status}")

if ((job_status.eql? "FINISHED") && (!job_id.nil?))
  $evm.log("info",'---- FINISHED ----')
  $evm.root['ae_result'] = 'ok'
elsif !job_id.nil?
  $evm.log('info',"Job #{job_id} not complete yet")
  $evm.root['ae_result']         = 'retry'
  $evm.root['ae_retry_interval'] = '1.minute'
end

$evm.log("info", "----Exiting method #{@method}----")
