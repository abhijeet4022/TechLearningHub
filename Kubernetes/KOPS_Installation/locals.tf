# Define a local variable with all resources
locals {
  resources_to_depend_on = [
	aws_s3_bucket.bucket,
	aws_security_group.allow_all,
	aws_security_group_rule.inbound_allow_all,
	aws_security_group_rule.outbound_allow_all,
	aws_iam_role_policy_attachment.admin_policy_attachment,
	aws_iam_instance_profile.admin_instance_profile
  ]
}