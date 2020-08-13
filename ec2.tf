resource "aws_instance" "ec2" {
    ami = "ami-0a1c2ec61571737db"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public_a.id
    root_block_device {
        volume_type = "gp2"
        volume_size = "30"
    }
    key_name = aws_key_pair.kubeec2.id
    tags = {
        Name = "${var.env}-${var.project}-ec2"
    }
}

output "ec2_public_ip" {
    value = aws_instance.ec2.public_ip
}

resource "aws_key_pair" "kubeec2" {
  key_name   = "kubeec2"
  public_key = file("./kubeec2.pub")
}