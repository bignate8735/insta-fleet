module "vpc" {
  source               = "./modules/vpc"
  project              = "instafleet"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
}

module "security" {
  source  = "./modules/security"
  project = "instafleet"
  vpc_id  = module.vpc.vpc_id
}

module "iam" {
  source  = "./modules/iam"
  project = "instafleet"
}

module "cloudwatch" {
  source            = "./modules/cloudwatch"
  project           = "instafleet"
  ecs_cluster_name  = "instafleet-cluster"
}

module "ecs" {
  source                     = "./modules/ecs"
  project                    = "instafleet"
  env                        = "dev"
  aws_region                 = "us-east-1"

  execution_role_arn         = module.iam.ecs_execution_role_arn
  task_role_arn              = module.iam.ecs_task_role_arn

  private_subnet_ids         = module.vpc.private_subnet_ids
  ecs_sg_id                  = module.security.ecs_sg_id

  auth_image                 = "123456789012.dkr.ecr.us-east-1.amazonaws.com/auth:latest"
  booking_image              = "123456789012.dkr.ecr.us-east-1.amazonaws.com/booking:latest"
  driver_image               = "123456789012.dkr.ecr.us-east-1.amazonaws.com/driver:latest"
  dispatch_image             = "123456789012.dkr.ecr.us-east-1.amazonaws.com/dispatch:latest"
  notification_image         = "123456789012.dkr.ecr.us-east-1.amazonaws.com/notification:latest"

  auth_target_group_arn      = module.alb.auth_target_group_arn
  booking_target_group_arn   = module.alb.booking_target_group_arn
  driver_target_group_arn    = module.alb.driver_target_group_arn
  dispatch_target_group_arn  = module.alb.dispatch_target_group_arn
  notification_target_group_arn = module.alb.notification_target_group_arn
}

module "alb" {
  source            = "./modules/alb"
  project           = "instafleet"
  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.security.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "rds" {
  source              = "./modules/rds"
  project             = "instafleet"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  ecs_sg_id           = module.security.ecs_sg_id

  db_name             = "instafleetdb"
  db_username         = "admin"
  db_password         = var.rds_password # from secrets.tfvars or SSM
}


module "auth_service" {
  source            = "./ecs/auth"
  project           = var.project
  env               = var.env
  aws_region        = var.aws_region
  auth_image        = var.auth_image
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  db_secret_arn      = module.rds.db_secret_arn
}

module "networking" {
  source                = "./vpc"
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
}

module "sqs" {
  source = "../../modules/sqs"
  project = var.project
  env     = var.env
}

module "ecs_sqs_iam" {
  source                 = "../../modules/iam"
  project                = var.project
  ecs_task_role_name     = module.ecs.task_role_name  # or from output of ECS module
  dispatch_queue_arn     = module.sqs.dispatch_queue_arn
  notification_queue_arn = module.sqs.notification_queue_arn
}


# -------------------------------------------------
# ECR Modules
# -------------------------------------------------
module "auth_ecr" {
  source = "../../modules/ecr"
  name   = "${var.project}-auth"
}

module "booking_ecr" {
  source = "../../modules/ecr"
  name   = "${var.project}-booking"
}

module "driver_ecr" {
  source = "../../modules/ecr"
  name   = "${var.project}-driver"
}

module "dispatch_ecr" {
  source = "../../modules/ecr"
  name   = "${var.project}-dispatch"
}

module "notification_ecr" {
  source = "../../modules/ecr"
  name   = "${var.project}-notification"
}

# -------------------------------------------------
# Secrets Manager Module for DB credentials
# -------------------------------------------------
module "db_secret" {
  source        = "../../modules/secrets_manager"
  secret_name   = "${var.project}-${var.env}-db-credentials"
  description   = "Database credentials for ECS tasks"
  secret_values = {
    username = var.db_username
    password = var.db_password
  }
}