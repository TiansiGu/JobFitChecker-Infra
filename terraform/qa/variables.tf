variable "aws_region" {
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
    type    = string
    default = "vpc-01c73a4c2de6c0fbb"
}

variable "public_subnet_ids" {
  default = [
    "subnet-035a0c26808ba5691",
    "subnet-0ce670b04e8215f6a",
    # "subnet-01fa37a3382fa2f65",
    # "subnet-02f077e30f62225be"
  ]
}

variable "rds_sg_id" {
  type    = string
  default = "sg-037631e67ccb1dd64"
}
