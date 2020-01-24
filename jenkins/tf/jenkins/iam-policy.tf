# IAM policies for jenkins ec2 plugins and grafan to access cloud watch

 resource "aws_iam_policy" "ec2-policy" {
  name        = "Jenkins-EC2-Policy"
  path        = "/"
  description = "Policy for Jenkins EC2 plugin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1312295543082",
            "Action": [
                "ec2:DescribeSpotInstanceRequests",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetConsoleOutput",
                "ec2:RequestSpotInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "ec2:GetPasswordData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group" "grafana-cloudwatch" {
  name = "Grafana-Cloud-Watch-access"
}

resource "aws_iam_group_policy_attachment" "grafana-cloudwatch-policy-attach" {
  group      = aws_iam_group.jenkins-ec2-slave.name
  policy_arn = aws_iam_policy.ec2-policy.arn
}

resource "aws_iam_policy" "grafana-cloudwatch-policy" {
  name        = "Grafana-EC2-Policy"
  path        = "/"
  description = "Policy for Jenkins EC2 plugin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1312295543082",
            "Action": [
                "ec2:DescribeSpotInstanceRequests",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetConsoleOutput",
                "ec2:RequestSpotInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "ec2:GetPasswordData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group" "jenkins-ec2-slave" {
  name = "Jenkins-EC2-Slaves-Plugin"
}

resource "aws_iam_group_policy_attachment" "jenkins-policy-attach" {
  group      = aws_iam_group.jenkins-ec2-slave.name
  policy_arn = aws_iam_policy.ec2-policy.arn
}

