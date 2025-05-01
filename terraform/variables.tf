variable "cluster_name" {
    type    = string
    default = "jobfitchecker-blue-green"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
    type    = string
    default = "vpc-01c73a4c2de6c0fbb"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the VPC"
  type        = list(string)
  default     = [
    "subnet-0f6a4aa1c308011c8",
    "subnet-06c8f772d7241db81",
  ]
}

variable "public_subnet_ids" {
  default = [
    "subnet-035a0c26808ba5691",
    "subnet-0ce670b04e8215f6a",
    # "subnet-01fa37a3382fa2f65",
    # "subnet-02f077e30f62225be"
  ]
}

variable "service_account_name" {
  type = string
  default = "jfc-sa"
}
