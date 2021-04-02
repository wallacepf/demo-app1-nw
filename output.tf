output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "db_security_group_id" {
  value = module.security_group_db.this_security_group_id
}

output "backend_security_group_id" {
  value = module.security_group_backend.this_security_group_id
}

output "frontend_security_group_id" {
  value = module.security_group_frontend.this_security_group_id
}
