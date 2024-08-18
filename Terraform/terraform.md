* Terraform is an immutable, declarative, Infrastructure as Code provisioning language based on Hashicorp Configuration Language, or optionally JSON.

* How to remove lock from state 
* `terraform force-unlock`

* How to switch between workspace
* `terraform workspace selects <WorkSpace Name>`

* To list workspace
* `terraform workspace list`

* To create a new workspace
* `terraform workspace new <WorkSpace Name>`

* To see the current workspace
* `terraform workspace show`

* Terraform recommends 2 spaces between each nesting level.

* How to launch Terraform interactive console to evaluate and experiment with expressions?
* `terraform console`

* TF_LOG environment variable can be set to enable detailed logging for Terraform.
* Terraform can be "written/support" another syntax in HCL or JASON, terraform does not support YAML or XML

* When multiple arguments with single-line values appear on consecutive lines at the same nesting level, HashiCorp recommends aligning the equals sign.

* Which Terraform command will check and report errors within modules, attribute names, and value types to ensure they are syntactically valid and internally consistent?
* `terraform validate`

* A user runs terraform init on their RHEL-based server, and per the output, two provider plugins are downloaded:
* `.terraform/plugins`

* Which VCS terraform supports
Git, Github, Gitlab, Bitbucket,  GitHub.com

* Which VCS does not terraform support?
* CVS Version control System

* `depends_on` create explicit dependency on resources.

* We can publish the value from any module using output block and retrieve the values using module.subnet.subnet_id

* How to change the local name of any resources without deleting the object.
* terraform state mv aws_instance.<old name> aws_instance.<new name>

* The provider plugins are downloaded and stored in the `.terraform/providers` directory. 

*  default parallelism value for terraform apply is "10".

* float is not correct data types in terraform.

* terraform starts indexing from 0 in count and for_each.

* Terraform does not not support AIX OS.

* Terraform Community (Free) stores the local state for workspaces in a directory called `terraform.tfstate.d/`. This directory structure allows for separate state files for each workspace, making it easier to manage and maintain the state data.

* The correct prefix string for setting input variables using environment variables in Terraform is TF_VAR. Terraform recognizes this prefix to assign values to variables.

* The "GitHub" is not a supported backend type in Terraform. Terraform does not have built-in support for storing state in a GitHub repository.

* Running `terraform init` is necessary when a new provider is introduced to download the required plugin. This ensures that Terraform has access to the Infobox provider and can properly manage the DNS record resource.
* `terraform init -upgrade` is use to update the provider.
* `.terraform.lock.hcl` will keep the info about Provider Name and Version. 

* After approving a merge request, Terraform Cloud will run a speculative plan to show the potential changes that will be applied to the managed environment. This allows users to review and validate the changes against any applicable Sentinel policies before applying them.

* The statement is true because the `terraform plan -refresh-only` command is specifically designed to only refresh the Terraform state to match any changes made to remote objects outside Terraform. It does not apply those changes to the state.

* Using `terraform apply -replace=aws_instance.web` allows Emma to mark the specific virtual machine resource for replacement without affecting other resources that were created. This command is useful for quickly recreating a single resource.

* Each Terraform workspace uses its own state file to manage the infrastructure associated with that particular workspace.

* The `terraform get` command is used to download modules from the module registry or a version control system, making them available for use in the configuration.

* The `terraform init` command is used to initialize a working directory containing Terraform configuration files. It downloads any modules specified in the configuration.

* The private registry feature in Terraform Cloud allows users to publish and maintain custom modules within their organization, providing a secure and controlled environment for sharing infrastructure configurations.

* The correct additional parameter required to use multiple provider blocks of the same type with distinct configurations is the "alias" parameter. This allows you to differentiate between the different configurations of the same provider type.

Q. In Terraform, most resource dependencies are handled automatically. Which of the following statements best describes how Terraform resource dependencies are handled? 
A. Terraform analyzes any expressions within a resource block to find references to other objects and treats those references as implicit ordering requirements when creating, updating, or destroying resources.

Q.When using the Terraform provider for Vault, the tight integration between these HashiCorp tools provides the ability to mask secrets in the state file.
A. False

Q. What do the declarations, such as name, cidr, and azs, in the following Terraform code represent and what purpose they serve ?
```
module "vpc" {
source  = "terraform-aws-modules/vpc/aws"
version = "5.7.0"

name = var.vpc_name
cidr = var.vpc_cidr

azs             = var.vpc_azs
private_subnets = var.vpc_private_subnets
public_subnets  = var.vpc_public_subnets

enable_nat_gateway = var.vpc_enable_nat_gateway

tags = var.vpc_tags
}
```
A. these are variables that are passed into the child module likely used for resource creation

Q. In the following code snippet, the type of Terraform block is identified by which string?

```
resource "aws_instance" "db" {
ami           = "ami-123456"
instance_type = "t2.micro"
}
```
A. Resource

Q. Using the latest versions of Terraform, terraform init cannot automatically download community providers.
A. False

Q. From the code below, identify the implicit dependency:

```
resource "aws_eip" "public_ip" {
vpc      = true
instance = aws_instance.web_server.id
}

resource "aws_instance" "web_server" {
ami           = "ami-2757f631"
instance_type = "t2.micro"
depends_on    = [aws_s3_bucket.company_data]
}
```
A. The EC2 instance labeled `web_server`

Q. When you add a new module to a configuration, Terraform must download it before it can be used. What two commands can be used to download and update modules? 
A. `terraform get` & `terraform init`

Q. Environment variables can be used to set the value of input variables. The environment variables must be in the format "____"_<variablename>.

Select the correct prefix string from the following list.
A. `TF_VAR`

Q. What environment variable can be set to enable detailed logging for Terraform?
A. `TF_LOG`

Q. Rather than use a state file, Terraform can inspect cloud resources on every run to validate that the real-world resources match the desired state.
A. False

Q. Which Terraform command will check and report errors within modules, attribute names, and value types to ensure they are syntactically valid and internally consistent?
A. `terraform validate`

Q. Freddy and his co-worker Jason are deploying resources in GCP using Terraform for their team. After resources have been deployed, they must destroy the cloud-based resources to save on costs. However, two other team members, Michael and Chucky, are using a Cloud SQL instance for testing and request to keep it running.

How can Freddy and Jason destroy all other resources without negatively impacting the database?
A. run a `terraform state` rm command to remove the Cloud SQL instance from Terraform management before running the `terraform destroy` command.

Q. The terraform plan -refresh-only command is used to create a plan whose goal is only to update the Terraform state to match any changes made to remote objects outside of Terraform.
A. The statement is true because the terraform plan -refresh-only command is specifically designed to only refresh the Terraform state to match any changes made to remote objects outside of Terraform. It does not apply those changes to the state.

Q. Which of the following is a valid variable name in Terraform?
A. invalid — Because this is not reserve word in terraform.

Q. What tasks can the terraform state command be used for in Terraform?
A. modify the current state, such as removing items.
Explanation:
The `terraform state` command can indeed be used to modify the current state by removing items. This is useful for managing the state of resources in Terraform.

Q. You are performing a code review of a colleague's Terraform code and see the following code. Where is this module stored?

```
module "vault-aws-tgw" {
source  = "terraform-vault-aws-tgw/hcp"
version = "1.0.0"

client_id      = "4djlsn29sdnjk2btk"
hvn_id         = "a4c9357ead4de"
route_table_id = "rtb-a221958bc5892eade331"
}
```
A. The code specifies a source from "terraform-vault-aws-tgw/hcp", which is a typical format for modules stored in the Terraform public registry. 

Q. Which are some of the benefits of using Infrastructure as Code in an organization?
A. 
* IaC uses a human-readable configuration language to help you write infrastructure code quickly.
* IaC code can be used to manage infrastructure on multiple cloud platforms
* IaC allows you to commit your configurations to version control to safely collaborate on infrastructure

Q. Why might a user opt to include the following snippet in their configuration file?
```
terraform {
required_version = ">= 1.9.2"
}
```
A. The user wants to specify the minimum version of Terraform that is required to run the configuration.

Q. After many years of using Terraform Community (Free), you decide to migrate to Terraform Cloud. After the initial configuration, you create a workspace and migrate your existing state and configuration. What Terraform version would the new workspace be configured to use after the migration?
A. The new workspace in Terraform Cloud will be configured to use the same Terraform version that was used to perform the migration. This ensures compatibility and consistency with the existing state and configuration.

Q. Why might users want to utilize Sentinel or OPA with Terraform Cloud in their infrastructure workflow?
A. 
* Sentinel and OPA can enhance security by preventing unauthorized changes to your managed infrastructure.
* Organizations can enforce resource naming conventions or approved machine images for improved consistency and clarity
* Sentinel and OPA enable automated policy checks to enforce compliance standards before applying changes to production environments
* To provide real-time feedback on potential security risks in Terraform configurations during the development process

Q. Emma is a Terraform expert, and she has automated all the things with Terraform. A virtual machine was provisioned during a recent deployment, but a local script did not work correctly. As a result, the virtual machine needs to be destroyed and recreated.

How can Emma quickly have Terraform recreate the one resource without having to destroy everything that was created?

A. use `terraform apply -replace=aws_instance.web` to mark the virtual machine for replacement.

Q. You are using a Terraform Cloud workspace linked to a GitHub repo to manage production workloads in your environment. After approving a merge request, what default action can you expect to be triggered on the workspace?
A. A speculative plan will be run to show the potential changes to the managed environment and validate the changes against any applicable Sentinel policies.

Q. Where does Terraform Community (Free) store the local state for workspaces?
A. directory called `terraform.tfstate.d/<workspace name>`


# Practice Set 2
Q. Given the definition below, what Terraform feature is being described?
"helps you share Terraform providers and Terraform modules across your organization. It includes support for versioning, a searchable list of available providers and modules, and a configuration designer to help you build new workspaces faster."

A. Private Registry

Q. Both you and a colleague are responsible for maintaining resources that host multiple applications using Terraform CLI. What feature of Terraform helps ensure only a single person can update or make changes to the resources Terraform is managing?
A. state locking

Q. Which of the following Terraform versions would be permitted to run the Terraform configuration based on the following code snippet?
```
terraform {
required_version = "~> 1.0.0"
required_providers {
aws = {
source  = "hashicorp/aws"
version = "~> 3.0"
}
random = {
source  = "hashicorp/random"
version = "3.1.0"
}
}}
```
A. Terraform v1.0.5

Q. Your colleague provided you with a Terraform configuration file and you're having trouble reading it because parameters and blocks are not properly aligned. What command can you run to quickly update the file configuration file to make it easier to consume?
A. terraform fmt

Q. A coworker provided you with Terraform configuration file that includes the code snippet below. Where will Terraform download the referenced module from?
```
terraform {
required_providers {
kubernetes = {
source = "hashicorp/kubernetes"
version = "2.6.1"
}
}
}

provider "kubernetes" {
# Configuration below
...
```
A. the official Terraform public registry

Q. Which of the following is an advantage of using Infrastructure as Code?
A. standardize your deployment workflow

Q. which of the following are true statements regarding Terraform? (select three)
A. 1. A single configuration file can use multiple providers
2. Terraform is cloud-agnostic
3. Terraform can orchestrate large-scale, multi-cloud infrastructure deployments

Q. You need to enable logging for Terraform and persist the logs to a specific file. What two environment variables can be set to enable logs and write them to a file? (select two)
A. 1.TF_LOG_PATH="<file_path>"
2. TF_LOG=TRACE

Q. Infrastructure as Code (IaC) provides many benefits to help organizations deploy application infrastructure much faster than manually clicking in the console. Which is NOT an additional benefit to IaC?
A. eliminates API communication to the target platform
Eliminating API communication to the target platform is NOT a benefit of IaC. In fact, Terraform likely increases communication with the backend platform since Terraform uses the platform's API to build and manage infrastructure.

Q. After hours of development, you've created a new Terraform configuration from scratch and now you want to test it. Before you can provision the resources, what is the first command that you should run?
A. terraform init

Q. You have a number of different variables in a parent module that calls multiple child modules. Can the child modules refer to any of the variables declared in the parent module?
A. Not the variable, but it can only refer to values that are passed to the child module

Q. As you are developing new Terraform code, you are finding that you are constantly repeating the same expression over and over throughout your code, and you are worried about the effort that will be needed if this expression needs to be changed. What feature of Terraform can you use to avoid repetition and make your code easier to maintain?
A. Locals

Q. A Terraform module (usually the root module of a configuration) can call other modules to include their resources into the configuration. A module that has been called by another module is often referred to as _______________.
A. Child Module.

Q. Based on the code snippet below, where is the module that the code is referencing?
```
module "server_subnet_1" {
source          = "./modules/web_server"
ami             = data.aws_ami.ubuntu.id
key_name        = aws_key_pair.generated.key_name
user            = "ubuntu"
private_key     = tls_private_key.generated.private_key_pem
subnet_id       = aws_subnet.public_subnets["public_subnet_1"].id
security_groups = [aws_security_group.vpc-ping.id, aws_security_group.vpc-web.id]
}
```
A. in the modules subdirectory in the current working directory where Terraform is being executed

Q. Where is the most secure place to store credentials when using a remote backend?
A. defined outside of Terraform

Q. In order to use the terraform console command, the CLI must be able to lock state to prevent changes.
A. True

Q. What is terrafrom state lock file name.
A. .terraform.tfstate.lock.info

Q. Under special circumstances, Terraform can be used without state.
A. False

Q.  In Terraform OSS, workspaces generally use the same code repository while workspaces in Terraform Enterprise/Cloud are often mapped to different code repositories.
A. True, Workspaces in OSS are often used within the same working directory while workspaces in Enterprise/Cloud are often (but not required) mapped to unique repos.

Q. You are managing multiple resources using Terraform running in AWS. You want to destroy all the resources except for a single web server. How can you accomplish this?
A. run a terraform state rm to remove it from state and then destroy the remaining resources by running terraform destroy

Q. You are having trouble with executing Terraform and want to enable the most verbose logs. What log level should you set for the TF_LOG environment variable?
A. TRACE


Q. You are using Terraform to manage some of your AWS infrastructure. You notice that a new version of the provider now includes additional functionality you want to take advantage of. What command do you need to run to upgrade the provider?
A. terraform init -upgrade

Q. Which of the following are tasks that terraform apply can perform? (select three)
A. 1. destroy infrastructure previously deployed with Terraform
2. provision new infrastructure
3. update existing infrastructure with new configurations

Q. Which of the following code snippets will ensure you're using a specific version of the AWS provider?
A.
```
terraform { 
  required_providers {
    aws = ">= 3.0"
  }
} 
```

Q. What is NOT a benefit of using Infrastructure as Code?
A. reducing vulnerabilities in your publicly-facing applications

Q. You have declared the variable as shown below. How should you reference this variable throughout your configuration?
A. var.aws_region

Q. Beyond storing state, what capability can an enhanced storage backend, such as the remote backend, provide your organization?
A. execute your Terraform on infrastructure either locally or in Terraform Cloud

Q. When working with Terraform CLI/OSS workspaces, what command can you use to display the current workspace you are working in?
A. terraform workspace show

Q. A child module created a new subnet for some new workloads. What Terraform block type would allow you to pass the subnet ID back to the parent module?
A. output block

Q. What feature does Terraform use to map configuration to resources in the real world?
A. state

Q. You want to restrict your team members to specific modules that are approved by the organization's security team when using Terraform Cloud. What feature should you use?
A. Terraform Cloud Private Registry

Q. Using multi-cloud and provider-agnostic tools like Terraform provides which of the following benefit?
A. can be used across major cloud providers and VM hypervisors

Q. Given the code snippet below, how would you identify the arn to be used in the output block that was retrieved by the data block?

```
data "aws_s3_bucket" "data-bucket" {
bucket = "my-data-lookup-bucket-btk"
}
...

output "s3_bucket_arn" {
value = ????
}
```

A. data.aws_s3_bucket.data-bucket.arn

Q. What of the following are benefits of using Infrastructure as Code? (select three)
A.
1. your infrastructure configurations can be version controlled and stored in a code repository alongside the application code
2. the reduction of misconfigurations that could lead to security vulnerabilities and unplanned downtime
3. the ability to programmatically deploy infrastructure

Q. Your organization has multiple engineers that have permission to manage Terraform as well as administrative access to the public cloud where these resources are provisioned. If an engineer makes a change outside of Terraform, what command can you run to detect drift and update the state file?
A. terraform apply -refresh-only

Q. Which statement below is true regarding using Sentinel in Terraform Enterprise?
A. Sentinel runs before a configuration is applied, therefore potentially reducing cost for public cloud resources
When using Sentinel policies to define and enforce policies, it (Sentinel) runs after a terraform plan, but before a terraform apply. Therefore, you can potentially reduce costs on public cloud resources by NOT deploying resources that do NOT conform to policies enforced by Sentinel.


Q. You've included two different modules from the official Terraform registry in a new configuration file. When you run a terraform init, where does Terraform OSS download and store the modules locally?
A. in the .terraform/modules folder in the working directory

Q. What command can be used to display the resources that are being managed by Terraform?
A. terraform show

Q. You have infrastructure deployed with Terraform. A developer recently submitted a support ticket to update a security group to permit a new port. To satisfy the ticket, you update the Terraform configuration to reflect the changes and run a terraform plan. However, a co-worker has since logged into the console and manually updated the security group to the same configuration.
What will happen when you run a terraform apply?

A. Nothing will happen. Terraform will validate the infrastructure matches the desired state.
A terraform apply will run its own state refresh and see the configuration matches the deployed infrastructure, so no changes will be made to the infrastructure.

Q. The command terraform destroy is actually just an alias to which command?
A. terraform apply -destroy

Q. As part of a Terraform configuration, you are deploying a Linux-based server using a default image that needs to be customized based on input variables. What feature of Terraform can execute a script on the server once is has been provisioned?
A. remote-exec provisioner

Q. You need to input variables that follow a key/value type structure. What type of variable would be used for this use case?
A. Map

Q. hen referencing a module, you must specify the version of the module in the calling module block.
A. False 

Q. You can use a combination of Terraform Cloud's cost estimation feature and Sentinel policies to ensure your organization doesn't apply changes to your environment that would result in exceeding your monthly operating budget.
A. True

Q. You need to define a single input variable to support the IP address of a subnet, which is defined as a string, and the subnet mask, which is defined as a number. What type of variable variable should you use?
A. type = object ()
Explanation: Using an object type variable allows you to define a single input variable that can hold multiple values, such as the IP address (string) and subnet mask (number). This type of variable is suitable for grouping related data together and maintaining the structure of the input data.

Q. What actions does a terraform init perform for you?
A. downloads plugins and retrieves the source code for referenced modules

Q.  Input variables that are marked as sensitive are NOT written to Terraform state.
A. False

Q. You have a configuration file that you've deployed to one AWS region already but you want to deploy the same configuration file to a second AWS region without making changes to the configuration file. What feature of Terraform can you use to accomplish this?
A. terraform workspace

Q. By default, where does Terraform CLI store its state?
A. in the terraform.tfstate file on the local backend

Q. Rather than having to scan and inspect every resource on every run, Terraform relies on what feature to help manage resources?
A. State

Q. Which of the following are collection or structural types that can be used when declaring a variable in order to group values together? (select four)
A. map, object, tuple, list

Q. Given the following code snippet, what is the managed resource name for this particular resource?
```
resource "aws_vpc" "prod-vpc" {
cidr_block = var.vpc_cidr

tags = {
Name        = var.vpc_name
Environment = "demo_environment"
Terraform   = "true"
}

enable_dns_hostnames = true
}
```
A. prod-vpc

Q. A provider block is required in every configuration file so Terraform can download the proper plugin.
A. False , ou don't have to specify a provider block since Terraform is smart enough to download the right provider based on the specified resources. 

Q. You need to set the value for a Terraform input variable. Which of the following allows you to set the value using an environment variable?
A. export TF_VAR_user=dbadmin01 



# Practice set 2.1

Q. In Terraform Cloud, a workspace can be mapped to how many VCS repos?
A. 1

Q. Similar to Terraform OSS, you must use the CLI to switch between workspaces when using Terraform Cloud workspaces.
A. False

Q. Before installing and using Terraform, you must download and install Go as a prerequisite.
A. False

Q. In regards to Terraform state file, select all the statements below which are correct: (select four)
A. 1. storing state remotely can provide better security
2. when using local state, the state file is stored in plain-text
3. the Terraform state can contain sensitive data, therefore the state file should be protected from unauthorized access
4. Terraform Cloud always encrypts state at rest

Q. When configuring a remote backend in Terraform, it might be a good idea to purposely omit some of the required arguments to ensure secrets and other relevant data are not inadvertently shared with others. What alternatives are available to provide the remaining values to Terraform to initialize and communicate with the remote backend? (select three)
A. 1. interactively on the command line
2. command-line key/value pairs
3. use the -backend-config=PATH flag to specify a separate config file

Q. What are some of the features of Terraform state? (select three)
A 1. determining the correct order to destroy resources
2. mapping configuration to real-world resources
3. increased performance

Q. When using variables in Terraform Cloud, what level of scope can the variable be applied to? (select three)
A. 1. A specific Terraform run in a single workspace
2. All current and future workspaces in a project using a variable set
3. Multiple workspaces using a variable set

Q. What are the benefits of using Infrastructure as Code? (select five)
A. 1. Infrastructure as Code allows a user to turn a manual task into a simple, automated deployment
2. Infrastructure as Code provides configuration consistency and standardization among deployments
3. Infrastructure as Code gives the user the ability to recreate an application's infrastructure for disaster recovery scenarios
4. Infrastructure as Code is relatively simple to learn and write, regardless of a user's prior experience with developing code
5. Infrastructure as Code is easily repeatable, allowing the user to reuse code to deploy similar, yet different resources

Q. Which of the following describes the process of leveraging a local value within a Terraform module and exporting it for use by another module?
A. Exporting the local value as an output from the first module, then importing it into the second module's configuration.

Q. Workspaces provide similar functionality in the open-source and Terraform Cloud versions of Terraform.
A. False, 
Workspaces, managed with the terraform workspace command, isn't the same thing as Terraform Cloud's workspaces. Terraform Cloud workspaces act more like completely separate working directories.
CLI workspaces (OSS) are just alternate state files.

Q. In order to make a Terraform configuration file dynamic and/or reusable, static values should be converted to use what?
A. input variables

Q. Which of the following best describes a Terraform provider?
A. a plugin that Terraform uses to translate the API interactions with the service or provider

Q. Which of the following is considered a Terraform plugin?
A. Terraform provider

Q. Which of the following Terraform files should be ignored by Git when committing code to a repo? (select two)
A. 1. terraform.tfvars
2. terraform.tfstate

Q. What is the downside to using Terraform to interact with sensitive data, such as reading secrets from Vault?
A. secrets are persisted to the state file

Q. Multiple providers can be declared within a single Terraform configuration file.
A. True

Q. From the answers below, select the advantages of using Infrastructure as Code. (select four)
A. 1. Easily integrate with application workflows (GitHub Actions, Azure DevOps, CI/CD tools)
2. Provide reusable modules for easy sharing and collaboration
3. Easily change and update existing infrastructure
4. Safely test modifications using a "dry run" before applying any actual changes

Q. Published modules via the Terraform Registry provide which of the following benefits? (select four)
A. 1. allow browsing version histories
2. support versioning
3. automatically generated documentation
4. show examples and READMEs

Q. Using multi-cloud and provider-agnostic tools provides which of the following benefits? (select two)
A.
1. operations teams only need to learn and manage a single tool to manage infrastructure, regardless of where the infrastructure is deployed
2. can be used across major cloud providers and VM hypervisors

Q. Before a new provider can be used, it must be ______ and _______. (select two)
A.
1. declared or used in a configuration file
2. initialized

Q. You found a module on the Terraform Registry that will provision the resources you need. What information can you find on the Terraform Registry to help you quickly use this module? (select three)
A.
1. Dependencies to use the Module
2. Required Input Variables
3. A list of Outputs

Q. Kristen is using modules to provision an Azure environment for a new application. She is using the following code to specify the version of her virtual machine module. Which of the following Terraform features supports the versioning of a module? (select two)
```
module "compute" {
source  = "azure/compute/azurerm"
version = "5.1.0"

resource_group_name = "production_web"
vnet_subnet_id      = azurerm_subnet.aks-default.id
}
```

A.
1. Terraform registry
2. private registry

Q. You can migrate the Terraform backend but only if there are no resources currently being managed.
A. False

Q. What are some problems with how infrastructure was traditionally managed before Infrastructure as Code? (select three)
1. Traditional deployment methods are not able to meet the demands of the modern business where resources tend to live days to weeks, rather than months to years
2. Requests for infrastructure or hardware often required a ticket, increasing the time required to deploy applications
3. Traditionally managed infrastructure can't keep up with cyclic or elastic applications


Q. What Terraform command can be used to inspect the current state file?
A. terraform show

Q. In the terraform block, which configuration would be used to identify the specific version of a provider required?
A. required_providers

Q. Which of the following best describes the default local backend?
A. The local backend stores state on the local filesystem, locks the state using system APIs, and performs operations locally

# Practice set 3

Q. Infrastructure as Code (IaC) makes infrastructure changes _______, ________, ________, and __________. (select four)
A.
1. repeatable
2. idempotent
3. predictable
4. consistent

Q. Both Terraform CLI and Terraform Cloud offer a feature called "workspaces". Which of the following statements are true regarding workspaces? (select three)
A.
1. CLI workspaces are alternative state files in the same working directory
2. Terraform Cloud maintains the state version and run history for each workspace
3. Terraform Cloud manages infrastructure collections with a workspace whereas CLI manages collections of infrastructure resources with a persistent working directory

Q. A provider alias is used for what purpose in a Terraform configuration file?
A. using the same provider with different configurations for different resources

Q. When using a Terraform provider, it's common that Terraform needs credentials to access the API for the underlying platform, such as VMware, AWS, or Google Cloud. While there are many ways to accomplish this, what are three options that you can provide these credentials? (select three)
A.
1. use environment variables
2. directly in the provider block by hardcoding or using a variable
3. integrated services, such as AWS IAM or Azure Managed Service Identity

Q. Aaron is new to Terraform and has a single configuration file ready for deployment. What can be true about this configuration file? (select three)
A.
1. the state file can be stored in Azure but provision applications in AWS
2. the configuration file can deploy both QA and Staging infrastructure for applications
3. Aaron's configuration file can deploy applications in both AWS and GCP

Q. Terraform Cloud provides organizations with many features not available to those running Terraform open-source to deploy infrastructure. Select the ADDITIONAL features that organizations can take advantage of by moving to Terraform Cloud. (select three)
A.
1. remote runs
2. VCS connection
3. private registry

Q. What function does the terraform init -upgrade command perform?
A. update all previously installed plugins and modules to the newest version that complies with the configuration’s version constraints

Q. Which of the following Terraform CLI commands are valid? (select five)
A.
1. terraform show, terraform apply -refresh-only, terraform login, terraform workspace select, terraform fmt

Q. What happens when you apply a Terraform configuration using terraform apply? (select two)
A.
1. Terraform makes infrastructure changes defined in your configuration.
2. Terraform updates the state file with configuration changes made during the execution

Q. Which of the following is not a benefit of Terraform state?
A. reduces the amount of outbound traffic by requiring that state is stored locally

Q. AutoPlants, Inc is a new startup that uses AI and robotics to grow sustainable and organic vegetables for California farmer's markets. The organization can quickly burst into the public cloud during the busy season using Terraform to provision additional resources to process AI computations and images. Since its compute stack is proprietary and critical to the organization, it needs a solution to create and publish Terraform modules that only its engineers and architects can use.
A. Private Registry

Q. Your organization requires that no security group in your public cloud environment includes "0.0.0.0/0" as a source of network traffic. How can you proactively enforce this control and prevent Terraform configurations from being executed if they contain this specific string?
A. Create a Sentinel or OPA policy that checks for the string and denies the Terraform apply if the string exists

Q. Which of the following best describes a "data source"?
A. enables Terraform to fetch data for use elsewhere in the Terraform configuration

Q. What is the primary function of Terraform Cloud agents?
A. execute Terraform plans and apply changes to infrastructure

Q. Margaret is calling a child module to deploy infrastructure for her organization. Just as a good architect does (and suggested by HashiCorp), she specifies the module version she wants to use even though there are newer versions available. During a terrafom init, Terraform downloads v0.0.5 just as expected.

What would happen if Margaret removed the version parameter in the module block and ran a terraform init again?
A.Terraform would use the existing module already downloaded

Q. When using Terraform Cloud, what is the easiest way to ensure the security and integrity of modules when used by multiple teams across different projects?
A. Use the TFC Private Registry to ensure only approved modules are consumed by your organization

Q. When using Terraform Cloud, what is the easiest way to ensure the security and integrity of modules when used by multiple teams across different projects?
A. Use the TFC Private Registry to ensure only approved modules are consumed by your organization

Q. Which of the following are the benefits of using modules in Terraform? (select three)
A.
1. supports versioning to maintain compatibility
2. supports modules stored locally or remotely
3. enables code reuse

Q. Infrastructure as Code (IaC) provides many benefits to help organizations deploy application infrastructure much faster than clicking around in the console. What are the additional benefits of IaC? (select three)
A.
1. allows infrastructure to be versioned
2. code can easily be shared and reused
3. creates a blueprint of your data center

Q. What feature of Terraform provides an abstraction above the upstream API and is responsible for understanding API interactions and exposing resources?
A. Terraform provider



# Terraform practice set 4

Q. Steve is a developer who is deploying resources to AWS using Terraform. Steve needs to gather detailed information about an EC2 instance that he deployed earlier in the day. What command can Steve use to view this detailed information?
A. `terraform state show aws_instance.frontend`

Q. You have an existing resource in your public cloud that was deployed manually, but you want the ability to reference different attributes of that resource throughout your configuration without hardcoding any values. How can you accomplish this?
A. Add a `data` block to your configuration to query the existing resource. Use the available exported attributes of that resource type as needed throughout your configuration to get the values you need.

Q. What Terraform command can be used to evaluate and experiment with expressions in your configuration?
A. `terraform console`

Q. Which of the following Terraform offerings provides the ability to use a private registry?
A. Terraform Cloud

Q. Your co-worker has decided to migrate Terraform state to a remote backend. They configure Terraform with the backend configuration, including the type, location, and credentials. However, you want to secure this configuration better.
Rather than storing them in plaintext, where should you store the credentials for the remote backend? (select two)
A. 
1. credentials file
2. environment variables

Q. Which of the following tasks does terraform init perform? (select three)
A.
1. prepares the working directory for use with Terraform
2. caches the source code locally for referenced modules
3. downloads required providers used in your configuration file

Q. When developing Terraform code, you must include a provider block for each unique provider so Terraform knows which ones you want to download and use.
A. False

Q. You are worried about unauthorized access to the Terraform state file since it might contain sensitive information. What are some ways you can protect the state file? (select two)
A. 
1. use the S3 backend using the encrypt option to ensure state is encrypted
2. store in a remote backend that encrypts state at rest

Q.  Running a terraform fmt will modify Terraform configuration files in the current working directory and all subdirectories.
A. False, terraform fmt` command will only format the Terraform configuration files in the current working directory, not in all subdirectories. 
`terraform fmt -recursive` will include the sub directory as well.

Q. You are using Terraform Cloud to manage a new data analytics environment for your organization. You have decided to use Sentinel to enforce standardization and security controls. At what step are the Sentinel policies enforced during a run?
A. after the plan, run tasks, cost estimation phases but before the apply phase

Q. `terraform validate` will validate the syntax of your HCL files.
A. True

Q. You need to use multiple resources from different providers in Terraform to accomplish a task. Which of the following can be used to configure the settings for each of the providers?
A.
```
provider "consul" {
address = "https://consul.krausen.com:8500"  
namespace = "developer"
token = "45a3bd52-07c7-47a4-52fd-0745e0cfe967"
}

provider "vault" {
address = "https://vault.krausen.com:8200"
namespace = "developer"
}
```

Q. If supported by your backend, Terraform will lock your state for all operations that could write state. What purpose does this serve?
A. This prevents others from acquiring the lock and potentially corrupting your state.

Q. Which of the following are true regarding Terraform variables? (select two)
A. 
1. variables marked as sensitive are still stored in the state file, even though the values are obfuscated from the CLI output
2. the default value will be found in the state file if no other value was set for the variable

Q. Which of the following are true about Terraform providers
A.
1. they allow anybody to write a provider and publish it to the registry
2. some providers are maintained by HashiCorp
3. some providers are community-supported
4. providers can be written and maintained by an outside organization, such as AWS, F5, or Microsoft

Q. You work for a retail organization that has multiple peak seasons throughout the year. During those peak seasons, your applications need to be scaled up quickly to handle the increased demand. However, the deployment of application servers is manual and new servers are only deployed when problems are reported by users.
How can you reduce the effort required to deploy new resources, increase the speed of deployments, and reduce or eliminate the negative experiences of your customers?
A. Develop code that provisions new application servers programmatically. Use monitoring software to trigger a pipeline that deploys additional servers during periods of increased demand.


Q. Which of the following is not true about the terraform.tfstate file used by Terraform?
A. it always matches the infrastructure deployed with Terraform.
The one thing that cannot be guaranteed is that the terraform.tfstate file ALWAYS matches the deployed infrastructure since changes can easily be made outside of Terraform. 


Q. When using Terraform Cloud, committing code to your version control system (VCS) can automatically trigger a speculative plan.
A. True

Q. You are using Terraform to manage resources in Azure. Due to unique requirements, you need to specify the version of the Azure provider so it remains the same until newer versions are thoroughly tested.
What block would properly configure Terraform to ensure it always installs the same Azure provider version?
A. 
```
terraform {
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = "2.90.0"
}
}
}
```

Q. Which of the following is the best description of a dynamic block?
A. produces nested configuration blocks instead of a complex typed value

Q. You can continue using your local Terraform CLI to execute terraform plan and terraform apply operations while using Terraform Cloud as the backend.
A. True


Q. min, max, format, join, trim, and length are examples of different expressions in Terraform.
A. False

Q. What are some of the benefits that Terraform providers offer to users? (select three)
A.
1. enables a plugin architecture that allows Terraform to be extensible without having to update Terraform core
2. abstracts the target platform's API from the end-user
3. enables the deployment of resources to multiple platforms, such as public cloud, private cloud, or other SaaS, PaaS, or IaaS services

Q. Terraform can only manage dependencies between resources if the depends_on argument is explicitly set for the dependent resources.
A. False

Q. In both Terraform OSS and Terraform Cloud, workspaces provide similar functionality of using a separate state file for each workspace.
A. True 

Q. Your organization uses IaC to provision and manage resources in a public cloud platform. A new employee has developed changes to existing code and wants to push it into production.
What best practice should the new employee follow to submit the new code?
A. Submit a merge/pull request of the proposed changes. Have a team member validate the changes and approve the request.

Q. Which of the following best describes the primary use of Infrastructure as Code (IaC)?
A. the ability to programmatically deploy and configure resources

Q. You are using Terraform OSS and need to spin up a copy of your GCP environment in a second region to test some new features. You create a new workspace. Which of the following is true about this new workspace? (select four)
A.
1. you can use a different variables file for this workspace if needed
2. it has its own state file
3. it uses the same Terraform code in the current directory
4. changes to this workspace won't impact other workspaces

Q. What CLI commands will completely tear down and delete all resources that Terraform is currently managing? (select two)
A.
1. terraform destroy
2. terraform apply -destroy

Q. After using Terraform locally to deploy cloud resources, you have decided to move your state file to an Amazon S3 remote backend. You configure Terraform with the proper configuration as shown below. What command should be run in order to complete the state migration while copying the existing state to the new backend?
```
terraform {
  backend "s3" {
    bucket = "tf-bucket"
    key = "terraform/krausen/"
    region = "us-east-1"
  }
}
```
A. terraform init -migrate-state

Q. You are using modules to deploy various resources in your environment. You want to provide a "friendly name" for the DNS of a new web server so you can simply click the CLI output and access the new website. Which of the following code snippets would satisfy these requirements?
A.
```
output "website" {
  description = "Outputs the URL of the provisioned website" 
  value       = "https://${module.web.public_dns}:8080/index.html"
}

``` 

Q. Thomas has recently developed a new Terraform configuration in a new working directory and is very cost-conscious. After running a terraform init, how can Thomas perform a dry run to ensure Terraform will create the right resources without deploying real-world resources?
A. `terraform plan -out=thomas`

Q. Which of the following is true about working with modules?
A. a single module can be called many times in a single configuration file

Q. Which of the following code snippets will properly configure a Terraform backend?
A.
```
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "btk"
 
  workspaces {
    name = "bryan-prod"
  }
 }
}
```

Q. Which of the following statements are true about using terraform import
A.
1. using terraform import will bring the imported resource under Terraform management and add the new resource to the state file
2. the resource address (example: aws_instance.web) and resource ID (example: i-abdcef12345) must be provided when importing a resource
3. you must update your Terraform configuration for the imported resource before attempting to import the resource

Q. Which of the following are advantages of using infrastructure as code (IaC) for your day-to-day operations?
A.
1. enables self-service for developers and operators alike
2. API-driven workflows
3. provides the ability to version control the infrastructure and application architecture

Q. You are working on updating your infrastructure managed by Terraform. Before lunch, you update your configuration file and run a terraform plan to validate the changes. While you are away, a colleague manually updates a tag on a managed resource directly in the console (UI).
What will happen when you run a terraform apply?

A. Before applying the new configuration, Terraform will refresh the state and recognize the manual change. It will update the resource based on the desired state as configured in the Terraform configuration. The manual change will no longer exist.

Q. If you have properly locked down access to your state file, it is safe to provide sensitive values inside of your Terraform configuration.
A. False

Q. You have deployed your network architecture in AWS using Terraform. A colleague recently logged in to the AWS console and made a change manually and now you need to be sure your Terraform state reflects the new change.

What command should you run to update your Terraform state?
A. `terraform apply -refresh-only`

Q. When using Terraform, where can you install providers from?
A.
1. Terraform plugin cache
2. official HashiCorp releases site
3. Terraform registry
4. plugins directory

Q. The terraform graph command can be used to generate a visual representation of a configuration or execution plan.
A. True

Q. Which common action does not cause Terraform to refresh its state?
A. `terraform state list`

Q. You have declared a variable named db_connection_string inside of the app module. However, when you run a terraform apply, you get the following error message:
A. since the variable was declared within the module, it cannot be referenced outside of the module

Q. Your organization has standardized on Microsoft Azure to run its applications on PaaS, SaaS, and IaaS offerings. The deployment quickly standardized on Azure ARM to provision these resources quickly and efficiently.
Which of the following is true about how the team currently deploys its infrastructure?
A. the adoption of another public cloud provider will prove to be more challenging since all of its codebase is based on ARM




