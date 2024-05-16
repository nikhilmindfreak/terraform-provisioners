resource "aws_instance" "db" {

    ami = "ami-090252cbe067a9e58"
    vpc_security_group_ids = ["sg-0d41e315f829ef112"]
    instance_type = "t2.micro"

     # provisioners will run when you are creating resources
    # They will not run once the resources are created , ex: to fetch ip and run ansible
    provisioner "local-exec" {
        command = "echo ${self.private_ip} > private_ips.txt" #self is aws_instance.web    # we can use any command here 
    }

    # provisioner "local-exec" {
    #     command = "ansible-playbook -i private_ips.txt web.yaml"   
    # }

    # if will fail in local so we give remote exc

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [                             # it will take connection and run the command and install and nginix install
            "sudo dnf install ansible -y",
            "sudo dnf install nginx -y",
            "sudo systemctl start nginx"
        ]
    } 
}