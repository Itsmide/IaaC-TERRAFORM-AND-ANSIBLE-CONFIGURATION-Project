TERRAFORM AND ANSIBLE CONFIGURATION (IaaC)

Created by https://github.com/Itsmide

- Using Terraform, create 3 EC2 instances and put them behind an Elastic Load Balancer.

- Make sure the after applying your plan, Terraform exports the public IP addresses of the 3 instances to a file called host-inventory.

- Get a domain name and set it up with AWS Route53 within your terraform plan, then add an A record for subdomain terraform-test that points to your ELB IP address.

- Create an Ansible script that uses the host-inventory file Terraform created to install Apache, set timezone and displays a simple HTML page that displays content to clearly identify on all 3 EC2 instances.


        Perquisites

1. Install aws cli, for better access and user configuration.

2. Filename "Host-inventory" will be created for public_ip storage { For Further usage e.g ansible.}

3. RE-namable ".pem" file will also be created for ssh into virtual machine(s)

4. Provider Used = aws

5. The Terraform file will create 3 ec2 instances, load balancer, target group to instances, Route53 zone name and subdomain, VPC, Security Group, Subnets(Public and Private), Internet Gateway and Route table.

* Variables are available for configuration in variables.tf file.


 
                       Order of Running File(s)
. terraform init

. terraform plan

. terraform apply

     Once all is applied, all resources will be available.


For ansible configuration, {Tips Below}

. ansible-playbook terraform-ec2.yml -i host-inventory --check   {to check how code will work without installation.}

. ansible-playbook terraform-ec2.yml -i host-inventory           {To Install}


Tips
For easy ansible running. Use ssh-key to generate new private(id_rsa) and public keys(id_rsa.pub)
Go into virual machine and paste new id_rsa.pub in authorized_keys in all machines and run ansible file. 

Created by https://github.com/Itsmide
