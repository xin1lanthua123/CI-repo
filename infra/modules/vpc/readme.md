resource "aws_subnet" "public" {
  for_each                = toset(slice(data.aws_availability_zones.available.names,0,2)) 
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 8, index(data.aws_availability_zones.available.names,each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-public-${each.key}"
    "kubernetes.io/role/elb"  = "1"
  }
}
# 1. Cấu trúc aws_subnet.private trong case của bạn
for_each = toset(slice(data.aws_availability_zones.available.names, 0, 2))

Giả sử:

names = [
  "ap-southeast-1a",
  "ap-southeast-1b",
  "ap-southeast-1c"
]

Sau slice(0,2):

[
  "ap-southeast-1a",
  "ap-southeast-1b"
]

Sau toset(...):

{
  "ap-southeast-1a",
  "ap-southeast-1b"
}
2. Quan trọng: key của resource lúc này là gì?

Với for_each = toset(...)

👉 Terraform sẽ tự tạo map:

aws_subnet.private = {
  "ap-southeast-1a" = aws_subnet object
  "ap-southeast-1b" = aws_subnet object
}
👉 KEY CHÍNH LÀ:
each.key = availability_zone string

Ví dụ:

key	value
ap-southeast-1a	subnet object
ap-southeast-1b	subnet object
3. Value là gì?

Mỗi value là resource object AWS subnet thật

Ví dụ:

aws_subnet.private["ap-southeast-1a"] = {
  id = "subnet-0a1b2c3d"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  vpc_id = "vpc-123"
}
4. Vậy cấu trúc chính xác là gì?
aws_subnet.private = map(string => aws_subnet)

Cụ thể:

{
  "ap-southeast-1a" = aws_subnet_object
  "ap-southeast-1b" = aws_subnet_object
}
5. each.key và each.value trong case của bạn

Trong resource khác:

for_each = aws_subnet.private
Biến	Giá trị
each.key	ap-southeast-1a
each.value	subnet object
each.value.id	subnet-xxxx
6. Điểm quan trọng bạn đang bị lệch ở chỗ này

Bạn nghĩ:

key là AWS subnet ID ❌

Không đúng.

✔ Thực tế:
Thành phần	Nguồn
key	từ for_each input (AZ name)
value	AWS subnet resource object