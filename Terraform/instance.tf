resource "aws_instance" "terraform_slave" {
    count = 1
    ami = "ami-03d294e37a4820c21"
    instance_type = "t2.micro"
    key_name = "terraformkey"
    ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 29
    volume_type           = "gp2"
    delete_on_termination = true
  }
    tags = {
        Name = "Terraform Slave"
    }
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "ec2-user"
            host = self.public_ip
            private_key = "/home/ec2-user/Terraform/terraformkey.pem"
        }
        inline = [ 
            "sudo yum update -y",
            "sudo yum install git -y",
            "sudo git --version",
            "sudo wget https://releases.hashicorp.com/terraform/1.6.3/terraform_1.6.3_linux_amd64.zip",
            "sudo unzip terraform_1.6.3_linux_amd64.zip",
            "sudo mv terraform /usr/local/bin/",
            "sudo terraform --version"
            ]
    }
}
output "terraform_ec2" {
    value = {
       public_ip = aws_instance.terraform_slave.public_ip
       private_ip = aws_instance.terraform_slave.private_ip
    }
}
resource "aws_s3_bucket" "terraform_bucket" {
    bucket = "s3bucketfornirmalbackend"
    tags = {
      Name = "s3bucketfornirmalbackend"
    }
}
resource "aws_s3_bucket_acl" "terraform_bucket_acl" {
    bucket = aws_s3_bucket.terraform_bucket.id
    acl = "private"
}
resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
    bucket = aws_s3_bucket.terraform_bucket.id
    versioning_configuration {
      status = "enabled"
    }
}