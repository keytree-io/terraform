##################################################################################################
#
#	SCRIPT NAME:
#	EXECUTION INSTRUCTIONS:  
#	VARIABLES: variables.tf 
#	VERSION:  1.8
#	AUTHOR:  Keytree Ltd
#	REVISIONS: 
#
##################################################################################################
# Definition of AWS EC2 instance build parameters
##################################################################################################

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_instance" "rhel6" {
  count             = "1"
  ami               = "ami-af6faad8"
  instance_type     = "t2.small"
  availability_zone = "eu-west-1a"
  key_name          = "admin"
  user_data         = "${file("userdata.sh")}"

  tags {
    PROJECT        = "${var.project}"
    ENVIRONMENT    = "${var.environment}"
    LANDSCAPE      = "${var.landscape}"
    TIER           = "${var.tier}"
    TYPE           = "${var.type}"
    ESTIMATED_COST = "${var.estimated_cost}"
    CR_REF         = "${var.cr_ref}"
    COST_CODE      = "${var.cost_code}"
    REQUESTOR      = "${var.requestor}"
  }

  provisioner "chef" {
    server_url              = "https://chef-v2.keytree.io/organizations/zombie"
    node_name               = "hana02.keytree.io"
    environment             = "Infrastructure"
    run_list                = ["role[rhel]", "recipe[hanasnapshot-backup]", "recipe[motd::keytree]"]
    user_name               = "zombie"
    recreate_client         = true
    version                 = "13.2.20"
    user_key                = "${file("/root/chef/.chef/zombie.pem")}"
    ssl_verify_mode         = "false"
    fetch_chef_certificates = true
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("/root/admin.pem")}"
  }
}

##################################################################################################
# End of AWS EC2 instance build parameters
##################################################################################################
# Definition of EBS storage device and attachment
##################################################################################################

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "USRSAP Volume"
  }
}

resource "aws_ebs_volume" "ebs-volume-2" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "SAPMNT Volume"
  }
}

resource "aws_ebs_volume" "ebs-volume-3" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "BACKUP Volume"
  }
}

resource "aws_ebs_volume" "ebs-volume-4" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "HANA Volume"
  }
}

resource "aws_ebs_volume" "ebs-volume-5" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "HANADATA Volume"
  }
}

resource "aws_ebs_volume" "ebs-volume-6" {
  availability_zone = "eu-west-1a"
  size              = 2
  type              = "gp2"

  tags {
    Name = "HANALOG Volume"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name  = "/dev/sdb"
  volume_id    = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-2-attachment" {
  device_name  = "/dev/sdc"
  volume_id    = "${aws_ebs_volume.ebs-volume-2.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-3-attachment" {
  device_name  = "/dev/sdd"
  volume_id    = "${aws_ebs_volume.ebs-volume-3.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-4-attachment" {
  device_name  = "/dev/sde"
  volume_id    = "${aws_ebs_volume.ebs-volume-4.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-5-attachment" {
  device_name  = "/dev/sdf"
  volume_id    = "${aws_ebs_volume.ebs-volume-5.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-6-attachment" {
  device_name  = "/dev/sdg"
  volume_id    = "${aws_ebs_volume.ebs-volume-6.id}"
  instance_id  = "${aws_instance.rhel6.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

output "public_ip" {
  value = "${aws_instance.rhel6.public_ip}"
}

##################################################################################################
# End of Script
##################################################################################################

