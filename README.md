# cloudforms-export
This code enables the export of a VM from RHEV to another format.  In this scenario, you might not have your entire hybrid cloud managed by CloudForms and you need to move your VM from RHEV to another virtual infrastructure or cloud.  This automate code…

1. Exports the virtual machine
2. Converts it to an OVA for RHEV, vmdk for VMware, or Qcow2 for OpenStack.
3. Creates a folder in the export storage domain share based on the user name logged into CloudForms
4. Places the exported VM in that folder
5. Deletes the VM from the export storage domain

Note: This requires CFME 5.3 or better.

###Obtain Automate Code
1. Clone repository
2. Compress the POC folder as a ZIP archive

###Integration
1. Install and configure CloudForms
2. Login
3. Navigate to “Automate” —> Import/Export
4. Click browse
5. Navigate to the zipped archive
6. Upload the archive
7. Navigate to “Automate” —> “Explorer”
8. Ensure the POC domain is enabled

9. Navigate to “Automate” —> “Customization” and the “Buttons” accordionan on the left
10. Create a button group named “Export” under “VM and Instance”
11. Create three buttons
    a. “Export for RHEV”  —> System/Process/Request Request—>Export
    b. “Export for VMware” —> System/Process/Request Request—>ExportVmdk
    c. “Export for OpenStack” —> System/Process/Request Request—>ExportQcow2
