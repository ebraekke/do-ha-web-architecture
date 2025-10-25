
# variables for readbility in complex statements
locals {
    user_data_standard = file("${path.module}/templates/standard.tpl")

    user_data_bastion = data.template_file.bastion.rendered
}
