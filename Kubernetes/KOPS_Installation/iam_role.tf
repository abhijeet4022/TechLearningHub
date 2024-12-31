# Create the IAM Role
resource "aws_iam_role" "aws_admin_role" {
  name = "AdministratorRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "AdministratorRole"
  }
}

# Attach Administrator Access Policy
resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role       = aws_iam_role.aws_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create an Instance Profile
resource "aws_iam_instance_profile" "admin_instance_profile" {
  name = "AdministratorInstanceProfile"
  role = aws_iam_role.aws_admin_role.name
  tags = { Name = "AdministratorInstanceProfile" }
}
