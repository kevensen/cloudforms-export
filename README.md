# cloudforms-export
This code enables the export of a VM from RHEV to another format.  In this scenario, you might not have your entire hybrid cloud managed by CloudForms and you need to move your VM from RHEV to another virtual infrastructure or cloud.  This automate code…

1. Exports the virtual machine
2. Converts it to an OVA for RHEV, vmdk for VMware, or Qcow2 for OpenStack.
3. Creates a folder in the export storage domain share based on the user name logged into CloudForms
4. Places the exported VM in that folder
5. Deletes the VM from the export storage domain

Note: This requires CFME 5.3 or better.

###Integration
1. Install and configure CloudForms
2. Login
3. Navigate to “Automate” —> Import/Export
4. 