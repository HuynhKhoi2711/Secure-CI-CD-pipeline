# Task_week_1

Mục tiêu của tuần này là phải có **code chạy được** và **pipeline xanh** (chưa cần có bảo mật)

**Nhiệm vụ cụ thể:**

1. **Chốt công nghệ (Tech Stack):** Dùng **GitHub + GitHub Actions** vì tài liệu cực kỳ nhiều và dễ làm quen.
    - App stack: Nên chọn **Python (Flask/FastAPI)** vì dễ tìm code mẫu có sẵn lỗ hổng.
2. **Công việc của Khôi:**
    - Tạo một tổ chức (Organization) trên GitHub và cấp quyền cho cả hai.
    - Tìm một mã nguồn ứng dụng web đơn giản (hoặc tự viết 2-3 API).
    - Viết một file `Dockerfile` cơ bản để đóng gói ứng dụng đó. Hãy đảm bảo build thành công trên máy local.
    - **Viết file trình bày các bước đã thực hiện**
3. **Công việc của Trung (Thành viên B):**
    - Khởi tạo cấu trúc thư mục chứa IaC (ví dụ thư mục `terraform/`).
    - Viết file `main.tf` đơn giản (có thể chỉ cần deploy một instance cơ bản hoặc setup provider). Không cần chạy thật ngay, chỉ cần `terraform init` và `terraform validate` không báo lỗi.
    - **Viết file trình bày các bước đã thực hiện**
4. **Chốt hạ (Ghép nối):**
    - Tạo file `.github/workflows/ci.yml`.
    - Cấu hình step: Checkout code -> Setup Python/Node -> Chạy unit test (nếu có) -> Build Docker (chưa cần push).
    - *Mục tiêu:* Khi push code, pipeline báo dấu **Tích xanh (Passed)**.