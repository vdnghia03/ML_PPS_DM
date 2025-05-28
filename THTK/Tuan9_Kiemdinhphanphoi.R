

# Bai 1. Kiểm tra xem số vụ tai nạn xe máy hàng ngày có tuân theo luật phân phối poisson hay không?

kiem_dinh_poisson <- function(x, freq, alpha = 0.05) {
  # Bước 1: Cỡ mẫu
  N <- sum(freq)
  
  # Bước 2: Tính lambda (ước lượng trung bình)
  lambda <- sum(x * freq) / N
  
  # Bước 3: Tính tần số lý thuyết n’i = N * pi
  pi_theoretical <- dpois(x, lambda)
  freq_theoretical <- N * pi_theoretical
  print(freq_theoretical)
  
  # Bước 4: Tính giá trị Q^2 theo công thức
  Q2 <- sum((freq - freq_theoretical)^2 / freq_theoretical)
  
  # Bước 5: Bậc tự do df = k - r - 1
  k <- length(x)      
  r <- 1              
  df <- k - r - 1
  
  # Tính giá trị tới hạn
  q_crit <- qchisq(1 - alpha, df)
  
  # Kết luận
  ket_luan <- if (Q2 > q_crit) {
    "Bác bỏ H0: Dữ liệu không tuân theo phân phối Poisson"
  } else {
    "Không bác bỏ H0: Dữ liệu có thể tuân theo phân phối Poisson"
  }
  
  # Kết quả
  list(
    lambda_uoc_luong = lambda,
    freq_ly_thuyet = round(freq_theoretical, 2),
    Q2_thuc_nghiem = round(Q2, 4),
    chisq_crit = round(q_crit, 4),
    bac_tu_do = df,
    ket_luan = ket_luan
  )
}

# Dữ liệu bài toán
x <- 0:4
e <- c(34, 25, 11, 7, 3)

# Gọi hàm
ketqua <- kiem_dinh_poisson(x, e)
print(ketqua)


# Bai 2. 
exp_kiem_dinh <- function(gia_tri, khoang, mean_life, alpha = 0.05) {
  N <- sum(gia_tri)
  lambda <- 1 / mean_life
  
  # Tính xác suất p_i cho từng khoảng theo phân phối mũ
  probs <- numeric(length(gia_tri))
  for (i in seq_along(gia_tri)) {
    a <- khoang[i, 1]
    b <- khoang[i, 2]
    p <- pexp(b, rate = lambda) - pexp(a, rate = lambda)
    probs[i] <- p
  }
  
  # Tính tần số kỳ vọng
  expected <- N * probs
  
  # Tính thống kê Chi bình phương
  Q2 <- sum((gia_tri - expected)^2 / expected)
  
  # Bậc tự do: df = số khoảng - 1 - số tham số ước lượng (lambda)
  df <- length(gia_tri) - 1 - 1
  
  # Tính p-value và giá trị tới hạn
  p_val <- pchisq(Q2, df, lower.tail = FALSE)
  chi_critical <- qchisq(1 - alpha, df)
  
  # Kết luận
  conclusion <- if (Q2 > chi_critical) "Bác bỏ H0: không tuân theo phân phối mũ" else "Không bác bỏ H0: có thể tuân theo phân phối mũ"
  cat("p_value: ", p_val, "\n")
  cat("Chisq: ", chi_critical, "\n")
  cat("conclusion: ", conclusion, "\n")
}

# Dữ liệu đề bài
gia_tri <- c(63, 47, 55, 34, 29, 27, 24, 21)
khoang <- matrix(c(  0,  50,
                        50, 100,
                        100, 150,
                        150, 200,
                        200, 300,
                        300, 400,
                        400, 500,
                        500, Inf),
                    byrow = TRUE, ncol = 2)

# Tuổi thọ trung bình
mean_life <- 200

# Gọi hàm kiểm định
result <- exp_kiem_dinh(gia_tri, khoang, mean_life)


# Bai 8

kiem_dinh_su_phu_hop <- function(observed, prob, alpha = 0.05) {
  # B1. Tổng số quan sát
  n <- sum(observed)
  
  # B2. Tính tần số kỳ vọng
  expected <- prob * n
  
  # B3. Tính thống kê Chi-squared
  chi2 <- sum((observed - expected)^2 / expected)
  
  # B4. Tính bậc tự do và giá trị tới hạn
  df <- length(observed) - 1
  critical_value <- qchisq(1 - alpha, df)
  p_value <- 1 - pchisq(chi2, df)
  
  # In kết quả
  cat("Tần số quan sát:", observed, "\n")
  cat("Tần số kỳ vọng:", round(expected, 2), "\n")
  cat("\nThống kê Chi2 =", round(chi2, 4), "với bậc tự do =", df, "\n")
  cat("Giá trị tới hạn =", round(critical_value, 4), "tại mức ý nghĩa alpha =", alpha, "\n")
  cat("Giá trị p =", round(p_value, 4), "\n")
  
  # Kết luận
  if (chi2 > critical_value) {
    cat("\nKết luận: Có sự khác biệt (bác bỏ H0)\n")
  } else {
    cat("\nKết luận: Không có bằng chứng bác bỏ H0 (phân phối phù hợp)\n")
  }
}

observed <- c(30, 80, 40)         
prob <- c(0.10, 0.60, 0.30)
kiem_dinh_su_phu_hop(observed, prob, alpha = 0.01)

# Nguoi noi noi khong dung voi thuc te.

# Bai 12
# a. Chuyen gia tri thanh cac mo ta tuong ung
data <- read.table("data61.txt", header = TRUE, sep = "\t")

data$Nguoi_yeu <- factor(data$Nguoi_yeu, levels = c(0,1,2),
                         labels = c("Chua_co", "Da_co", "Dang_tim_hieu"))
data$Hoc_tap <- factor(data$Hoc_tap, levels = c(0,1,2),
                       labels = c("Gioi", "Kha", "Trung_binh"))
          

# b. Voi muc y nghia 5% hay kiem dinh xem viec co nguoi yeu co anh huong den ket qua hoc tap khong

# H0: Nguoi yeu va hoc tap khong co moi lien he
# H1: Co moi lien he giua viec hoc va co nguoi yeu
kiem_dinh_doc_lap <- function(x, y, alpha = 0.05) {
  # 1. Bảng tần số quan sát
  O <- table(x, y)
  
  # 2. Bảng kỳ vọng
  row_sums <- rowSums(O)
  col_sums <- colSums(O)
  total <- sum(O)
  E <- outer(row_sums, col_sums, FUN = function(r, c) r * c / total)
  
  # 3. Tính thống kê kiểm định
  chi2 <- sum((O - E)^2 / E)
  
  # 4. Bậc tự do, giá trị tới hạn, p-value
  df <- (nrow(O) - 1) * (ncol(O) - 1)
  critical_value <- qchisq(1 - alpha, df)
  p_value <- 1 - pchisq(chi2, df)
  
  # In kết quả
  cat("Chi2 =", round(chi2, 4), "\n")
  cat("df =", df, "\n")
  cat("p-value =", round(p_value, 4), "\n")
  
  if (chi2 > critical_value) {
    cat("Kết luận: Có mối liên hệ giữa hai biến (bác bỏ H0)\n")
  } else {
    cat("Kết luận: Không có bằng chứng bác bỏ H0 (không có mối liên hệ)\n")
  }
}

kiem_dinh_doc_lap(data$Nguoi_yeu, data$Hoc_tap)


