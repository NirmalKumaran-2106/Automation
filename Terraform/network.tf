resource "aws_vpc" "terraform_vpc" {
    tags = {
        Name = "Terraform_VPC"
    }
    cidr_block = "173.0.0.0/16"
    instance_tenancy = "default"
}
resource "aws_internet_gateway" "terraform_ig" {
    tags = {
        Name = "terraform_internet_gateway"
    }
    vpc_id = aws_vpc.terraform_vpc.id
}
resource "aws_subnet" "terraform_public_subnet" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "173.0.1.0/20"
    availability_zone = "ap-south-1a"
}
resource "aws_route_table" "public_routetable" {
    vpc_id = aws_vpc.terraform_vpc.id
}
resource "aws_route_table_association" "public_routeattach" {
    subnet_id = aws_subnet.terraform_public_subnet.id
    route_table_id = aws_route_table.public_routetable.id
}
resource "aws_security_group" "terraform-securitygroup" {
    vpc_id = aws_vpc.terraform_vpc.id
    tags = {
      Name = "terraform-securitygroup"
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
