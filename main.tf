data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.17"
  subnets         = ["subnet-9d1be6e0", "subnet-61b2350a", "subnet-ea6440a6"]
  vpc_id          = "vpc-b4900fdf"

  worker_groups = [
    {
      instance_type        = "t3.small"
      asg_max_size         = 5
      asg_desired_capacity = 2
      ec2_ssh_key          = "jipara-test.pem"
    }
  ]
}
