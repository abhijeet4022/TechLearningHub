# Security Group Resource allow all traffic
resource "aws_security_group" "allow_all" {
  name        = "allow-all-traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.default_vpc.id
  tags        = { Name = "Allow-All-Security-Group" }
}

# Inbound Rule (Allow All Traffic)
resource "aws_security_group_rule" "inbound_allow_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # -1 means all protocols
  cidr_blocks       = ["0.0.0.0/0"] # Allow from anywhere
  security_group_id = aws_security_group.allow_all.id
}

# Outbound Rule (Allow All Traffic)
resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # -1 means all protocols
  cidr_blocks       = ["0.0.0.0/0"] # Allow to anywhere
  security_group_id = aws_security_group.allow_all.id
}

