* Terraform is an immutable and declarative language

# How to remove lock from state 
* `terraform force-unlock`

# How to switch between workspace
* `terraform workspace selects <WorkSpace Name>`

# To list workspace
* `terraform workspace list`

# To create a new workspace
* terraform workspace new <WorkSpace Name>

# To see the current workspace
* `terraform workspace show`

* Terraform recommends 2 spaces between each nesting level.

# How to launch Terraform interactive console to evaluate and experiment with expressions?
* `terraform console`

* TF_LOG environment variable can be set to enable detailed logging for Terraform.
* Terraform can be "written/support another syntax" in HCL or JASON, terraform does not support YAML or XML

# When multiple arguments with single-line values appear on consecutive lines at the same nesting level, HashiCorp recommends aligning the equals sign.

# Which Terraform command will check and report errors within modules, attribute names, and value types to ensure they are syntactically valid and internally consistent?
* `terraform validate`

# A user runs terraform init on their RHEL-based server, and per the output, two provider plugins are downloaded:
* .terraform/plugins

# Which VCS terraform supports
Git, Guthub, Gitlab, Bitbucket,  GitHub.com

# Which VCS does not terraform support?
* CVS Version control System

* dependes_on create explicit dependecy on resoureces 

* We can publish the value from any module using output block and retrive the values using module.subnet.subnet_id

# How to change the local name of any resources without delete the object
* terraform state mv aws_instance.oldname aws_instance.newname

* The provider plugins are downloaded and stored in the `.terraform/providers` directory within

*  default parallelism value for terraform apply is "10".

* float is not correct data types in terraform
* terraform start indexing from 0 in count and for_each
* Terraform is not supported in AIX.
* Terraform Community (Free) stores the local state for workspaces in a directory called `terraform.tfstate.d/`. This directory structure allows for separate state files for each workspace, making it easier to manage and maintain the state data.
* The correct prefix string for setting input variables using environment variables in Terraform is TF_VAR. This prefix is recognized by Terraform to assign values to variables.
* The "github" backend type is not a supported backend type in Terraform. Terraform does not have built-in support for storing state in a GitHub repository.
* Running `terraform init` is necessary when a new provider is introduced to download the required plugin. This ensures that Terraform has access to the Infoblox provider and can properly manage the DNS record resource.
* After approving a merge request, Terraform Cloud will run a speculative plan to show the potential changes that will be applied to the managed environment. This allows users to review and validate the changes against any applicable Sentinel policies before applying them.
* The statement is true because the `terraform plan -refresh-only` command is specifically designed to only refresh the Terraform state to match any changes made to remote objects outside of Terraform. It does not apply those changes to the state.
* Using `terraform apply -replace=aws_instance.web` allows Emma to mark the specific virtual machine resource for replacement without affecting other resources that were created. This command is useful for quickly recreating a single resource.
* Each Terraform workspace uses its own state file to manage the infrastructure associated with that particular workspace.
* The `terraform get` command is used to download modules from the module registry or a version control system, making them available for use in the configuration.
* The `terraform init` command is used to initialize a working directory containing Terraform configuration files. It downloads any modules specified in the configuration.
* The private registry feature in Terraform Cloud allows users to publish and maintain custom modules within their organization, providing a secure and controlled environment for sharing infrastructure configurations.
* The correct additional parameter required to use multiple provider blocks of the same type with distinct configurations is the "alias" parameter. This allows you to differentiate between the different configurations of the same provider type.