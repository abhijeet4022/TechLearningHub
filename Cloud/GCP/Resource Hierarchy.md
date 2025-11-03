There is a concept called resource hierarchy in GCP.
Organizations -> Folders -> Projects -> Resources

1. Organization
- Root Node in the Google Cloud resource hierarchy.
- Hierarchical ancestor of project, resources and Folders.
- Projects belong to your organization instead of the employee who created the project.
- Organization administrators have central control of all resources.
- An Organization ID, which is a unique identifier for an organization.

2. Folders
- They are used to represent sub-organizations within the Organization.
- They act as an Additional grouping mechanism and isolation boundaries between projects and the organization.
- Folders can be used to model different legal entities, departments, and teams within a company.
- Each team folder could contain additional sub-folders to represent different applications.
- Folders act as a policy inheritance point for Cloud IAM and Organization policies.

3. Projects (The Base Unit)
- The Project is the base-level organizing entity in the GCP hierarchy. All GCP resources you create (like VMs, buckets, databases) must belong to a project.
- Identifiers: Each project has two key identifiers: Project ID and Project number (read-only).
- Display Name: Projects have one mutable display name.
- Lifecycle State: The project has a lifecycle state, for example, ACTIVE or DELETE REQUESTED.

36.47