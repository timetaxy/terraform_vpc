resource "aws_vpc" "vpc" {
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    tags =  { Name = "vpc"}
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id #어느 VPC와 연결할 것인지 지정
    tags = { Name = "IGW"}  #태그 설정
}

# Subnet Public
resource "aws_subnet" "public-a" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "192.168.0.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2a" #가용영역 지정
    map_public_ip_on_launch = true #퍼블릭 IP 자동 부여 설정
    tags = { Name = "public-a"} #태그 설정

}

resource "aws_subnet" "public-c" {
    vpc_id = aws_vpc.vpc.id
    cidr_block  = "192.168.10.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true
    tags = { Name = "public-c"}
}

# Subnet Private
resource "aws_subnet" "private-a" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "192.168.20.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2a" #가용영역 지정
    map_public_ip_on_launch = false #외부에서 통신이 되면 안되기 때문에 퍼블릭 IP 부여를 하지 않습니다.
    tags = { Name = "private-a"} #태그 설정
}

resource "aws_subnet" "private-c" {
    vpc_id = aws_vpc.vpc.id
    cidr_block  = "192.168.30.0/24"
    availability_zone = "ap-northeast-2c"
    tags = { Name = "private-c"}
}

# public routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id #Internet Gateway 별칭 입력
  }
  tags = { Name = "public" } #태그 설정
}

resource "aws_route_table" "private-a" {
  vpc_id = aws_vpc.vpc.id #VPC 별칭 입력
  tags = { Name = "private-a" }
}

resource "aws_route_table" "private-c" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "private-c" }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id #연결할 서브넷 별칭 입력
  route_table_id = aws_route_table.public.id #서브넷과 연결할 라우팅 테이블 별칭 입력
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.private-c.id
  route_table_id = aws_route_table.private-c.id
}
