variable "aws_acct_number" {
  type = string
}

variable "apps_prefix" {
  type    = string
  default = "app"
}

variable "tf_state_bucket" {
  type = string
}

variable "tf_dynamo_state_table" {
  type = string
}
