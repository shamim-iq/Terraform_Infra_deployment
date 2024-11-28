#The 'terraform.tfvars' file often contains sensitive data, such as access keys and secrets. To prevent uploading it to a remote repository, add the file to .gitignore.
instance_type  = "t3.micro"
sg_cidr_blocks = ["0.0.0.0/0"]
