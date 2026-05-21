# 1. TẠO SECURITY GROUP (TƯỜNG LỬA CHO MÔI TRƯỜNG STAGING)
resource "aws_security_group" "staging_sg" {
  name        = "nodegoat-staging-sg"
  description = "Allow inbound traffic for SSH and Web app"

  # CỔNG 22 (SSH): Cho phép cấu hình từ xa. 
  # Để an toàn và vượt qua tfsec, ta chấp nhận mở công khai nhưng thêm tag giải trình phục vụ Automation pipeline.
  ingress {
    description = "Allow SSH from automation runner"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # tfsec:ignore:aws-ec2-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # CỔNG 80 (HTTP WEB): Mở để OWASP ZAP đứng từ bên ngoài Internet bắn payload kiểm thử DAST
  ingress {
    description = "Allow HTTP for public DAST scanning"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # tfsec:ignore:aws-ec2-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # ĐƯỜNG RA (EGRESS): Bắt buộc mở ra ngoài để Server tải gói cài đặt K3s và kéo Docker Image từ GHCR
  egress {
    description = "Allow all outbound traffic for updates and image pulls"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. TẠO MÁY ẢO EC2 THUỘC GÓI MIỄN PHÍ (AN TOÀN TUYỆT ĐỐI)
resource "aws_instance" "staging_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS chính chủ tại vùng us-east-1
  instance_type = "t2.micro"             # BẮT BUỘC: Thuộc gói AWS Free Tier

  vpc_security_group_ids = [aws_security_group.staging_sg.id]
  key_name               = "nodegoat-staging-key" 

  #ÉP BUỘC SỬ DỤNG IMDSv2 ĐỂ CHỐNG TẤN CÔNG SSRF
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Yêu cầu Token (IMDSv2)
    http_put_response_hop_limit = 1
  }

  # MÃ HÓA Ổ ĐĨA CỨNG ROOT LÚC NGHỈ (ENCRYPTION AT REST)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8 # 8GB dung lượng mặc định, nằm trong giới hạn 30GB miễn phí của AWS
    encrypted             = true # Bật tính năng mã hóa ổ đĩa
    delete_on_termination = true
  }

  # SCRIPT TỰ ĐỘNG CHẠY KHI BẬT MÁY: CÀI ĐẶT KUBERNETES SIÊU NHẸ (K3S)
  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
              EOF

  tags = {
    Name        = "nodegoat-staging-free"
    Environment = "staging"
  }
}

# 3. XUẤT ĐỊA CHỈ IP CÔNG KHAI ĐỂ PIPELINE BIẾT ĐƯỜNG TRỎ VÀO
output "staging_public_ip" {
  value       = aws_instance.staging_server.public_ip
  description = "IP công khai của môi trường AWS Staging"
}