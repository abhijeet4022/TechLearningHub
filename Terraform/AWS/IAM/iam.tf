# group definition
resource "aws_iam_group" "admin-grp" {
  name = "admin"
}

resource "aws_iam_policy_attachment" "administrators-attach" {
  name       = "administrators-attach"
  groups     = [aws_iam_group.admin-grp.name]
  policy_arn = "arn:aws:iam::017186918596:policy/custom-policy"
}

# user
resource "aws_iam_user" "user-1" {
  name = "admin1"
}

resource "aws_iam_user" "user-2" {
  name = "admin2"
}

resource "aws_iam_group_membership" "administrators-users" {
  name = "administrators-users"
  users = [
    aws_iam_user.user-1.name,
    aws_iam_user.user-2.name,
  ]
  group = aws_iam_group.admin-grp.name
}

output "warning" {
  value = "WARNING: make sure you're not using the AdministratorAccess policy for other users/groups/roles. If this is the case, don't run terraform destroy, but manually unlink the created resources"
}

