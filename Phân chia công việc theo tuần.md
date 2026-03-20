# Phân chia công việc theo tuần

## 1. Lộ trình thực hiện 8 Tuần (Roadmap)

Thầy chia công việc dựa trên nguyên tắc song song: một bạn lo phần App & CI/CD cơ bản, một bạn lo phần Hạ tầng (IaC) và các tool Security.

- [**Tuần 1: Khởi tạo nền tảng & Baseline CI.**](https://www.notion.so/Task_week_1-3295ea7bd0d8808fbedce9c4fecd9a15?pvs=21)
    - **Khôi:** Tìm/viết sample web app (Node/Python/Go) và Dockerfile. Tạo repo GitHub.
    - **Trung:** Viết mã IaC cơ bản (Terraform) để giả lập hạ tầng.
    - **Chung:** Dựng GitHub Actions cơ bản (chỉ build và test đơn giản).
- **Tuần 2: Pre-commit & Kiểm thử tĩnh (SAST/SCA).**
    - **Khôi:** Tích hợp Pre-commit hooks (gitleaks, linters) tại local.
    - **Trung:** Tích hợp SAST (Semgrep/Sonar) và Dependency scan (Dependabot/Snyk) vào CI.
- **Tuần 3: Build, Quét Container Image & IaC Scanning.**
    - **Khôi:** Setup build Docker image, xuất SBOM (Syft). Tích hợp Trivy/Anchore để quét image.
    - **Trung:** Tích hợp Checkov hoặc tfsec vào pipeline để quét Terraform code.
- **Tuần 4: Ký Image & Triển khai môi trường Staging.**
    - **Khôi:** Cấu hình ký image bằng Cosign và đẩy lên Container Registry (GHCR).
    - **Trung:** Hoàn thiện Terraform để deploy app tự động lên môi trường Staging (có thể dùng namespace K8s cục bộ hoặc Minikube).
- **Tuần 5: Kiểm thử động (DAST) & Policy Gating.**
    - **Khôi:** Tích hợp OWASP ZAP vào pipeline để bắn tự động vào URL của Staging.
    - **Trung:** Cấu hình Policy Gate (ví dụ: OPA Gatekeeper) để chặn các image không có chữ ký.
- **Tuần 6: Tự động hóa Triage & Auto-fix.**
    - **Khôi:** Cấu hình tự động tạo Issue trên GitHub/Jira khi ZAP hoặc Trivy phát hiện lỗi Critical.
    - **Trung:** Nghiên cứu tính năng auto-fix PR của Checkov cho IaC.
- **Tuần 7: End-to-End Testing & Thu thập Metrics.**
    - **Chung:** Chạy toàn bộ luồng. Cố tình đưa code lỗi (hardcode secret, dependency dính CVE) để quay video demo pipeline chặn lỗi thành công. Thu thập số liệu thời gian chạy (latency) và tỷ lệ false positive.
- **Tuần 8: Hoàn thiện Báo cáo & Video Demo.**
    - **Chung:** Viết báo cáo kỹ thuật (15-25 trang), chốt slide và render video demo (5-10 phút).

[Task_week_1](https://www.notion.so/Task_week_1-3295ea7bd0d8808fbedce9c4fecd9a15?pvs=21)