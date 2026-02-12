# Steps to install a single node AVI cluster to beta 9.0.1 vPOD in EPC





## Initial vPOD Prep:
* Deploy vPOD 
* Start JUST the console VM
* connect to the console-VMs  "console"
    * Edit the ~/hol/vPOD.txt file
    * Change settings to 
        * vPOD_SKU=ATE-27XX
        * labtype=ATE
* Save vPOD.txt file
* Poweroff console VM from inside OS
* Once the consoleVMC is "PoweredOoff" in vCD 
    * "stop" vPOD - It will be "partially running"
* Once the vPOD is "Powered off"
    * Start POD
    * This will cause the startup scripts to grab all the github content properly and run the labstartup properly
* connect to the console-VMs  "console"

## Once the vPOD is in "Ready" state
* Try to connect to google.com
* If this fails, open a terminal
* ssh to manager
    * ssh root@manager
    * su to holuser
        * Run commands
            * cd ~/hol/Tools
            * ./proxyfilteroff.sh 
* Install curl
* Instill git
* Install anything else you need from an apt install
* MAKE SURE THE SUPERVISOR IS NOT RUNNING
## Once you can connect to the interwebs
* Download files
    * Avi ova - for beta 9.0.1 I was advised to use "controller-31.1.2-9193.ova
    * Files from git hub repo
        * Files from - https://github.com/avinetworks/devops/tree/master/tools/vcf
            * pvc.json
            * pvc.sig
            * vcf_tools.sh
                * make this file executable
* Run command ./vcf_tools.sh
    * Choose menu option 1
    * Do yourself a favor and create a text file with all the entries you will need when running this shell script
        * i.e.
            * Controller-31.1.2-9193.ova
            * 31.1.2-24923866 - this can be found in the pvc.json file
            * VMware123!VMware123!
            * sddc manager fqdn
    * When the script goes clean - open sddc manager ui

## ONCE the bundle upload is done in sddc manager

* In new terminal ssh into sddc manager as vcf 
* run su - to su to root 
* run command "vi /home/vcf/feature.properties"
* Paste "feature.vcf.vgl-41078.alb.single.node.cluster=true" - this allows for a single node avi cluster to be deployed via the sddcmanager
* run /opt/vmware/vcf/operationsmanager/scripts/cli/sddcmanager_restart_services.sh
    * Wait for sddc manager to restart
## Goto SDDC Manager → Developer center → Bundles
* Click GET
* Click Execute
* Scroll to response
* Expand the response
* Expand elements: → Bundle {big guid}
* Go to block that starts with description and copy "id"
    * Edit the "bundleID" value in the avi.single.node json file with this id
* Close Bundles
    * Scroll to NSX-T Clusters
    * Execute GET under Clusters
* Expand Response
    * Expand and grab id for the wld you are deploying to
    * Edit avi.single.json nsxIds with this id
    * Edit avi.single.json change clustername to something .i.e. Alb-a-wld01
    * Save the file in VSCode and then vi it to make sure there are no crazy characters
    * Save → cat → and copy the avi.single.json file
* Copy avi.sing.json file contents
    * In SDDC manager Developer Center . Scroll to ALBClusters
        * Expand POST /va/alb-clusters
        * Paste into body for "Try it out"
        * Hit execute
        * Click CONTINUE
        * You Should see the AVI Controller task being deployed in SDDC Manager
            * In 9 and 9.1 it will take quite a while. It is supposed to be much faster in 9.2
## Once the AVI Controller is deployed.
* Open the AVI UI at alb-a.site-a.vcf.lab
    * Username: admin
    * Password: VMware1!VMware1! - whatever is in the avi.single.json file
    * Configure AVI
        * Passphrase: VMware123!VMware123!
        * Confirm Passphrase: VMware123!VMware123!
            * These are up to you. Thety are used to encrypt backups
    * DNS Resolver: 10.1.1.1
    * Search Domain: site-a.vcf.lab
    * Uncheck Join
    * Click NEXT
    * Check NONE
    * Click NEXT
    * Leave Multi-Tenant As Default
    * Click SAVE
* Select Templates →Security →SS/TLS Certificates
* Click CREATE
    * Select Controller Certificate
    * Give Cert a name: i.e. avi-a.portal-cert
    * Set common name to: alb-a.site-a.vcf.lab
    * Scroll down to Subject Alternate name (SAN)
        * Click ADD
            * Enter: 10.1.1.90
        * Click ADD
            * Enter: 10.1.1.91
        * Click ADD
            * Enter: alb-01a.site-a.vcf.lab
        * Click ADD
            * Enter: alb-a.site-a.vcf.lab
* Click Administration → System Settings
    * Click EDIT
    * Under SSL/TLS Certificate
        * Click the X to remove the existing System Default Cert
        * Click the dropdown and choose the newly created avi-a.portal-cert
* Go back to the terminal
    * Run command cd ~/Downloads
    * Run command . ~/noproxy.sh
    * Run command ~/Downloads/vcf_tools.sh
    * Choose menu option 3
        * Enter: nsx-wld01-a.site-a.vcf.lab
        * Enter: VMware123!VMware123!
        * Enter: 10.1.1.90
        * Enter: AVI ADMIN PASSWORD - i.e. VMware1!VMware1!
* Log Into NSX Manager for wld01-a.site-a.vcf.lab
    * Click Networking → Tier-1 gateways
        * Click ADD TIER-1 GATEWAY
        * Select t0-wld-a: for Linked Tier-a gateway
        * Select edgecl-wld-a for edge cluster
        * Expand Route Advertisement
        * Select all SLIDERS
        * Click SAVE
        * Click NO for Do you want to continue configuring
* Click Segments
    * Click ADD SEGMENT
        * Name: avi-mgmt-segment
        * Subnets CIDR: 10.1.14.1/25
        * Click SAVE
        * Click NO
* Click Tier-1-Gateways
    * Click Edit for avi-mgmt-gw
    * Click DHCP Config : set
    * Click Dropdown and set to DHCP Server
    * Click three dots to create new
    * Name: avi-dhcp
        * Select edgecl-wld-a for Edge Cluster
        * Click SAVE
        * Click APPLY
        * Click SAVE
        * Click CLOSE EDITING
* Click Segments
    * Edit avi-mgmt-segment
    * Click SET DHCP CONFIG
    * Click Dropdown for DHCP Type, set to: Gateway DHCP Server
    * For DHCP ranges Set to: 10.1.14.20-10.1.14.100
        * HIT ENTER
    * Click APPLY
    * Click SAVE
    * Click CLOSE EDITING
* Log Into vCenter for wld01-a
    * Select Content Libraries
    * Click CREATE
    * Name: avi-content-lib
    * Click NEXT
    * Leave as LOCAL
    * Click NEXT
    * Click NEXT
    * Select vsan-wld01-o1a
    * Click NEXT
    * Click FINISH
* Back to the AVI UI
    * Click Infrastructure → Clouds
        * Click CREATE
        * Select NSX Cloud
            * Name: site-a-cloud
            * Object Name Prefix: site-a
        * Scroll to NSX
            * Click CHANGE CREDENTIALS
        * NSX Manager Address:  nsx-wld01-a.site-a.vcf.lab
            * Click Three Dots
            * Select CREATE
        * NSX Manager Credentials: 
            * Name: nsx-admin
            * Username: admin
            * Password: VMware123!VMware123!
            * Click SAVE
            * Click CONNECT
        * Transport Zone
            * Select overlay-vds01-wld01-01a (overlay)
        * Tier1 Logical Router
            * Select: avi-mgmt-gw
        * Overlay Segment
            * Select: avi-mgmt-segment
        * Check Enable VPC Mode
        * Data Networks
            * Select the same transport zone as above
        * vCenter Server
            * Click ADD
            * name : wld01-a-vcenter
            * Click CHANGE CREDENTIALS
            * vCenter Address
            * Select vc-wld01-a
            * vCenter Credentials
            * Select svc-alb-a-vc-wld01-a@wld.sso
            * Click CONNECT
            * Content Library
            * Select new content lib
            * Click DONE
            * Click SAVE
            * Wait for the STATUS to go GREEN
