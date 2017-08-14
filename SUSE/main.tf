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

resource "aws_instance" "suse12" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name          = "admin"
  security_groups   = ["launch-wizard-1", "default"]

  tags {
    Name           = "${count.index}-${var.name}"
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

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("/root/admin.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "${file("userdata.sh")}",
    ]
  }

  provisioner "chef" {
    server_url              = "https://chef-v2.keytree.io/organizations/zombie"
    node_name               = "${var.name}"
    environment             = "Infrastructure"
    run_list                = ["role[suse]", "recipe[hanasnapshot-backup]", "recipe[motd::keytree]", "recipe[terraform-ebs-mkfs]"]
    user_name               = "zombie"
    recreate_client         = true
    version                 = "13.2.20"
    user_key                = "${file("/root/chef/.chef/zombie.pem")}"
    ssl_verify_mode         = "false"
    fetch_chef_certificates = true
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
  depends_on   = ["aws_ebs_volume.ebs-volume-1"]
  volume_id    = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-2-attachment" {
  device_name  = "/dev/sdc"
  depends_on   = ["aws_ebs_volume.ebs-volume-2"]
  volume_id    = "${aws_ebs_volume.ebs-volume-2.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-3-attachment" {
  device_name  = "/dev/sdd"
  depends_on   = ["aws_ebs_volume.ebs-volume-3"]
  volume_id    = "${aws_ebs_volume.ebs-volume-3.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-4-attachment" {
  device_name  = "/dev/sde"
  depends_on   = ["aws_ebs_volume.ebs-volume-4"]
  volume_id    = "${aws_ebs_volume.ebs-volume-4.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-5-attachment" {
  device_name  = "/dev/sdf"
  depends_on   = ["aws_ebs_volume.ebs-volume-5"]
  volume_id    = "${aws_ebs_volume.ebs-volume-5.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

resource "aws_volume_attachment" "ebs-volume-6-attachment" {
  device_name  = "/dev/sdg"
  depends_on   = ["aws_ebs_volume.ebs-volume-6"]
  volume_id    = "${aws_ebs_volume.ebs-volume-6.id}"
  instance_id  = "${aws_instance.suse12.id}"
  skip_destroy = "true"                              # Added due to https://github.com/hashicorp/terraform/issues/2957 #
}

output "public_ip" {
  value = "${aws_instance.suse12.public_ip}"
}

##################################################################################################
# End of Script
##################################################################################################

