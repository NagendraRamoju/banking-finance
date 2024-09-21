resource "aws_instance" "test-server" {
  ami           = "ami-0e86e20dae9224db8" 
  instance_type = "t2.micro" 
  key_name = "slavekey"
  vpc_security_group_ids= ["sg-0135234a952876b5d"]
  connection {
    type     = "ssh"
    user     = "ubuntu" 
    private_key = file("./slavekey.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }
  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/project1/terraform-files/ansibleplaybook.yml"
         }
  }
