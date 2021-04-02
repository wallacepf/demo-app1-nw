output "private_subnets" {
  value = module.vpc.private_subnets
}

output "db_security_group_id" {
  value = module.security_group_db.this_security_group_id
}
