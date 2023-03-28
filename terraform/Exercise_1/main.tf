# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "ASIAS2BBAJVXO2NLHOEL"
  secret_key = "kjDP1DkjM7hwe5rneQ53v+h0CKXFMNI+lL7tK9yB"
  token = "FwoGZXIvYXdzEIH//////////wEaDF6LCyxtC0L1jpXlFSLVAf+sh2fBc143y3EFd2AcLSJ9nEBvfyl30lEDmttQM4xy9+s4ZF+ULXoYIPVO4P2jE1UCbB66wiANNkVpVWMH0ojfahcxwGTUNjkTEj6AoJqGZpG6CHRse/56vJHHYC6aobCMdVFS9MaDlt8BetxDzXiEAqe+tKsfP2XHlmsyjJbAt5oN3qi0r4+xCFuS/p8N5gZgMAh43ggYOFJs2W3wroH4GAyVnFHGfNleUK9HmR3CXwgjQwQGSrTadtOpe9aXI1BF3YSByVJZS60fdn3fyF5sPaH9xyi+lIyhBjItJg3B1vn8yS00EwHBkOwNMFXNRGwwIBxsFriDBxv4SzHdsIJYIPG8El1yE4A2"
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacityt2" {
  count = "4"
  ami = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  tags = {
    name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacitym4" {
  count = "2"
  ami = "ami-00c39f71452c08778"
  instance_type = "m4.large"

  tags = {
    Name = "Udacity M4"
  }
}