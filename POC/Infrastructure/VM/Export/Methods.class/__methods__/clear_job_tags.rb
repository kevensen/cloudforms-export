#
# Description: This method will remove any job tags.
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>

@method = 'clear_job_tags'
$evm.log("info", "----Entering method #{@method}----")

vm = $evm.root['vm']

for count in 0..4
  #Unassign any existing tags in the job_id_# category.
  $evm.log("info","Attempting to remove tags in category job_id_#{count}")
  vm.tags("job_id_#{count}").each do |tag|
    $evm.log("info","Attempting to remove tag job_id_#{count}/#{tag}")
    vm.tag_unassign("job_id_#{count}/#{tag}")
  end
end

$evm.log("info", "----Exiting method #{@method}----")

