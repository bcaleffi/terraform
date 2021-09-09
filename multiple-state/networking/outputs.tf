output "environment"{
    value = var.environment
}

output "vpc_id" {
    value = aws_vpc.mult_state_vpc.id
}

output "subnet_id" {
    value = aws_subnet.mult_state_sbn.id
}