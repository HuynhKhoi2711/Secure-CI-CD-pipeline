variable "ghcr_pat" {
  description = ""
  type        = string
  sensitive   = true # Thuộc tính này sẽ ẩn giá trị token trong log của Terraform
}