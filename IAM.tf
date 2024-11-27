#IAM service role for EC2 to access S3 bucket
resource "aws_iam_role" "proj_ec2_role" {
  name = "proj_ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

#S3 policy
resource "aws_iam_policy" "proj_policy" {
  name = "s3_access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:*"],
        "Resource" : "*"
      }
    ]
  })
}

#Attach the policy with the role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.proj_ec2_role.name
  policy_arn = aws_iam_policy.proj_policy.arn
}

#Attach the iam role to the instance profile, which will eventually be 
#associated with the instances to access S3 buckets
resource "aws_iam_instance_profile" "proj_instance_profile" {
  name = "proj_instance_profile"
  role = aws_iam_role.proj_ec2_role.name
}

