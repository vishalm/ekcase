# Print the jenkins url
output "masterhosturl" {
  value = aws_route53_record.jmaster.name
}


output "aws_efs_file_system" {
  value = aws_efs_file_system.jmaster.dns_name
}