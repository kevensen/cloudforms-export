#
# Description: Because we can't pass the job_id with the evm.root object on a retry, we have to get a little creative.
# We could try to make a tag out of the whole job UUID, but a tag can be no more than 30 characters.  Therefore we need
# to create multiple tags.
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>

@method = 'tag_with_job'
$evm.log("info", "----Entering method #{@method}----")

def tag_job_part(count, uuid)
  
  vm = $evm.root['vm']
  
  #If the category doesn't exist, create it
  if $evm.execute('category_exists?', "job_id_#{count}")
    $evm.log("info", "Category job_id_#{count} exists")
  else
    $evm.log("info", "Category job_id_#{count} doesn't exist, creating category")
    $evm.execute('category_create', :name => "job_id_#{count}", :single_value => true, :description => "Export Job ID #{count}")
  end
  
  #If the particular uuid tag doesn't exist, create it
  if $evm.execute('tag_exists?', "job_id_#{count}",uuid)
    $evm.log("info","Tag #{uuid} exists for category job_id_#{count}")
  else
    $evm.log("info", "Adding new tag in job_id Category with uuid #{uuid}")
    $evm.execute("tag_create", "job_id_#{count}", :name => uuid, :description => uuid)
  end

  #Unassign any existing tags in the export_status category.
  vm.tags("job_id_#{count}").each do |tag|
    vm.tag_unassign(tag)
  end
  
  #Assign this particular status tag
  vm.tag_assign("job_id_#{count}/#{uuid}")
  
end


job_id = $evm.root['job_id']

split_id = job_id.split("-")

split_id.each_with_index do |uuid, index|
  
  tag_job_part(index, uuid.sub("/api/jobs/",""))
  
end

$evm.log("info", "----Exiting method #{@method}----")
