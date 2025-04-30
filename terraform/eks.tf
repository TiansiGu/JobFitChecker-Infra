# No need to manually create the CloudFormation stack or an IAM role
# terraform-aws-modules/eks/aws module handles all of that automatically.

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "20.35.0" # module version

    cluster_name    = var.cluster_name
    cluster_version = "1.29" # kubernetes version

    # Make K8 API server publicly accessible - GitHub Actions needs it to deploy to EKS
    cluster_endpoint_public_access = true
    # The IAM user who creates the cluster will have admin-level Kubernetes permissions without needing extra manual setup
    enable_cluster_creator_admin_permissions = true
    # For IRSA setup
    enable_irsa = true

    # Network positions
    vpc_id     = var.vpc-id
    subnet_ids = var.public-subnet-ids

    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64" # Amazon Linux2, amd
    }

    eks_managed_node_groups = {
        default = {
            name           = "app-node-group"
            instance_types = ["t3.medium"]
            min_size       = 2
            max_size       = 6
            desired_size   = 4
        }
    }
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_name
}
