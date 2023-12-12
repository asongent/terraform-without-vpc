output "vpc_id" {
  value = aws_vpc.fred_vpc.id
}

output "gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}
