#
# Description: <Method description here>
#

status = $evm.inputs['status']
vm = $evm.root['vm']

description = status.gsub("_"," ")

description = description.gsub(/\w+/) { $&.capitalize }

#If the category doesn't exist, create it
if $evm.execute('category_exists?', "export_status")
  $evm.log("info", "Category export_status exists")
else
  $evm.log("info", "Category export_status doesn't exist, creating category")
  $evm.execute('category_create', :name => "export_status", :single_value => true, :description => "Export Status")
end

#If the particular status doesn't exist, create it
if $evm.execute('tag_exists?', "export_status",status)
  $evm.log("info","Tag #{status} exists for category export_status")
else
  $evm.log("info", "Adding new tag in export_status Category")
  $evm.execute("tag_create", "export_status", :name => status, :description => description)
end

#Unassign any existing tags in the export_status category.
vm.tags("export_status").each do |tag|
  vm.tag_unassign(tag)
end

#Assign this particular status tag
vm.tag_assign("export_status/#{status}")
