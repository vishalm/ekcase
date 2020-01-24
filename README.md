# Case Study

### Work break down
* [x] Jenkins Infra 
  * [x] Create Jenkins and monitoring AMI's
    * [x] Three ami's created jenkins, slave, grafana prometheus
  * [x] Create jenkins instance with monitoring
    * [x] create s3 vpc
    * [x] create jenkins, slave, monitoring.   
* [x] Create Terraform for Jenkins Provisioing
* [ ] Create dev test env with terraform for 2 automated env.
* [ ] Automate the Deployment to test and stage env


* Automate Dev and Test Env provisioning
* Automate Application Service deployment using CI/CD pipelines from Dev to Test 
* Need to write code of IaaC to provision jenkins infra
* Need to write code for Env Dev and Test provisioning
* Tagging Security groups and ACL to restrict accesses
* Deployemnt
* Pipeline with quality gates and on merge auto trigger the deployment
* Monitoring of jenkins jobs
* Architectural diagram
