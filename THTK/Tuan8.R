

# Bai 1. Viết hàm mean.test(x, y, alternative=c("two-sided, "less", "greater"), conf.level=0.95)
# kiểm định (so sánh) kỳ vọng của hai tổng thể độc lập trong trường hợp phương sai của hai tổng thể là khác nhau. I
# In ra kết quả gồm p_value, T_0 và kết luận liên quan.

mean.test <- function(x, y, alternative = c("two-sided", "less", "greater"), conf.level = 0.95) {
  
  # Validate 'alternative' argument
  alternative <- match.arg(alternative)

  # Tính trung bình, phương sai mẫu và số lượng mẫu X và Y
  mean_x <- mean(x)
  mean_y <- mean(y)
  n_x <- length(x)
  n_y <- length(y)
  var_x <- var(x) # Sample variance (Sx^2)
  var_y <- var(y) # Sample variance (Sy^2)
  
  # Tính SE dựa theo công thức 
  se_diff <- sqrt((var_x / n_x) + (var_y / n_y))
  
  # Tính thống kê kiểm định T0
  T_0 <- (mean_x - mean_y) / se_diff
  
  # Tính bậc tự do df
  numerator_df <- se_diff^4
  denominator_df <- (var_x / n_x)^2 / (n_x - 1) + (var_y / n_y)^2 / (n_y - 1)
  df <- numerator_df / denominator_df
  
  # Tính toán p value dựa theo giả thuyết và đối thuyết , đầu vào là alternative 
  
  # Ở đây ta xem là chưa biết từng giá trị phương sai tổng thể, ta dùng  công thức theo  phương sai mẫu 
  if (alternative == "two-sided") {
    # H1: mu_x != mu_y
    p_value <- 2 * pt(abs(T_0), df, lower.tail = FALSE)
  } else if (alternative == "greater") {
    # H1: mu_x > mu_y
    p_value <- pt(T_0, df, lower.tail = FALSE)
  } else if (alternative == "less") {
    # H1: mu_x < mu_y
    p_value <- pt(T_0, df, lower.tail = TRUE)
  }
  
  # Tính alpha 
  alpha <- 1 - conf.level
  
  # Đưa ra kết luận dựa trên việc so sánh p_value và alpha
  conclusion <- if (p_value <= alpha) {
    paste0("Có đủ cơ sở để bác bỏ giả thuyết H0 tại mức ý nghĩa ", alpha, ".")
  } else {
    paste0("Chưa có đủ cơ sở để bác bỏ giả thuyết H0 tại mức ý nghĩa ", alpha, ".")
  }
  
  # In ra kết quả
  cat("Kết quả kiểm định T cho hai mẫu độc lập (giả định phương sai tổng thể không bằng nhau):\n")
  cat("Loại đối thuyết:  ", alternative, "\n")
  cat("Test Statistic T_0:", T_0, "\n")
  cat("Degrees of Freedom :", df, "\n") 
  cat("P-value:", p_value, "\n")
  cat("Kết luận:", conclusion, "\n")
  
  # Return results as a list (invisibly)
  invisible(list(
    T_0 = T_0,
    p_value = p_value,
    df = df,
    conclusion = conclusion,
    alternative = alternative,
    conf.level = conf.level,
    sample.means = c("mean_x" = mean_x, "mean_y" = mean_y),
    sample.variances = c("var_x" = var_x, "var_y" = var_y),
    sample.sizes = c("n_x" = n_x, "n_y" = n_y)
  ))
}

# Test hàm tự viết
x <- c(23, 25, 27, 22, 24)
y <- c(20, 19, 21, 18, 20)
result <- mean.test(x, y, alternative = "two-sided", conf.level = 0.95)

# T test Trong R
result_R <- t.test(x,y, alternative = "two.sided", var.equal = FALSE,conf.level = 0.95)


# ===================== Bai Tap File Li thuyet ======================================

# Bai so 2
# Cau a 
diameter_data <- read.csv("diameter.csv")

# Perform the two-sample t-test assuming equal variances
# H0: mu_machine1 = mu_machine2
# H1: mu_machine1 != mu_machine2 
# alpha = 0.05
machine1_diameter <- diameter_data$extru.ma.1
machine2_diameter <- diameter_data$extru.ma.2
test_result <- t.test(machine1_diameter, machine2_diameter,
                      var.equal = TRUE,
                      alternative = "two.sided",
                      conf.level = 0.95)
# Print the results
print(test_result)
# Vì p_value << 0.05 -> Bác bỏ giả thuyết H0

# Cau b.
p_value <- test_result$p.value
print(p_value)
# p_value la 1.35 * 10^-3

# Câu c
# KHoang tin cay su khac biet trung binh
print(test_result$conf.int)
# (0.499, 0.509)

# Cau d
test.leq.oneside <- function(x, y, mu0, alpha = 0.05) {
  x <- na.omit(x)
  y <- na.omit(y)
  n <- length(x)
  m <- length(y)
  
  mean_x <- mean(x)
  mean_y <- mean(y)
  
  var_x <- var(x)
  var_y <- var(y)
  
  pooled_sd <- sqrt(((n - 1) * var_x + (m - 1) * var_y) / (n + m - 2))
  
  t_0 <- ((mean_x - mean_y) - mu0) / (pooled_sd * sqrt(1/n + 1/m))
  
  df <- n + m - 2
  
  p_value <- pt(t_0, df, lower.tail = TRUE)
  
  if (p_value <= alpha) {
    conclusion <- "Reject H0"
  } else {
    conclusion <- "Accept H0" 
  }
  
  cat("Test Statistic T_0:", t_0, "\n")
  cat("Degrees of Freedom :", df, "\n") 
  cat("P-value:", p_value, "\n")
  cat("Kết luận:", conclusion, "\n")
}

# Use R
test_d <- t.test(machine1_diameter, machine2_diameter,
                      var.equal = TRUE,
                      alternative = "less",
                      conf.level = 0.95)
# Print the results
print(test_d)

# Use scratch
test.leq.oneside(machine1_diameter, machine2_diameter, mu0 = 0, alpha = 0.05)


# Cau e
test.geq.oneside <- function(x, y, mu0, alpha) {
  # So luong mau
  n <- length(x)
  m <- length(y)
  
  mean_x <- mean(x)
  mean_y <- mean(y)
  
  var_x <- var(x)
  var_y <- var(y)
  
  pooled_sd <- sqrt(((n - 1) * var_x + (m - 1) * var_y) / (n + m - 2))
  
  t_0 <- ((mean_x - mean_y) - mu0) / (pooled_sd * sqrt(1/n + 1/m))
  
  df <- n + m - 2
  
  p_value <- pt(t_0, df, lower.tail = FALSE)
  
  if (p_value <= alpha) {
    conclusion <- "Reject H0"
  } else {
    conclusion <- "Accept H0" 
  }
  
  cat("Test Statistic T_0:", t_0, "\n")
  cat("Degrees of Freedom :", df, "\n") 
  cat("P-value:", p_value, "\n")
  cat("Kết luận:", conclusion, "\n")
}

# Bai 4 

# Perform the paired t-test
# H0: mu_Before <= mu_After (or mu_Before - mu_After <= 0)
# H1: mu_Before > mu_After (or mu_Before - mu_After > 0)
# alpha = 0.05
cholesterol_data <- data.frame(
  Subject = 1:15,
  Before = c(265, 240, 258, 295, 251, 245, 287, 314, 260, 279, 283, 240, 238, 225, 247),
  After = c(229, 231, 227, 240, 238, 241, 234, 256, 247, 239, 246, 218, 219, 226, 233)
)
test_result_a <- t.test(cholesterol_data$Before, cholesterol_data$After,
                        paired = TRUE,        # Specify paired test [4]
                        alternative = "greater", # Specify right-sided test
                        conf.level = 0.95)    # Default 95% CI included

# Print the results
print(test_result_a)

# p_value < 0.05 -> Bac bo gia thuyet H0. Cho thấy việc tập thể dục ko giảm mỡ 

# Cau b

paired_ttest_leq_oneside <- function(x, y, mu0 = 0, alpha = 0.05) {
  # Loại bỏ NA
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  # Check equal length (paired data)
  if (length(x) != length(y)) {
    stop("Vectors x and y must be the same length for paired test.")
  }
  
  # Compute the difference vector
  d <- x - y
  
  # Compute sample statistics
  n <- length(d)
  mean_d <- mean(d)
  sd_d <- sd(d)
  
  # Compute test statistic
  t_stat <- (mean_d - mu0) / (sd_d / sqrt(n))
  
  # Degrees of freedom
  df <- n - 1
  
  # Left-sided p-value
  p_value <- pt(t_stat, df, lower.tail = TRUE)
  
  # Decision
  conclusion <- if (p_value <= alpha) "Reject H0" else "Accept H0"
  
  list(conclusion = conclusion, p_value = p_value)
}

# ---- Ap dung lai cau a
result_1 <- paired_ttest_leq_oneside(cholesterol_data$Before, cholesterol_data$After, mu0 = 0, alpha = 0.05)


# Cau c
paired_ttest_rightside <- function(x, y, mu0 = 0, alpha = 0.05) {
  # Loại bỏ NA
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  # Kiểm tra xem độ dài 2 vector có bằng nhau không (kiểm định cặp)
  if (length(x) != length(y)) {
    stop("Vectors x and y must be the same length for paired test.")
  }
  
  # Tính hiệu giữa các cặp
  d <- x - y
  
  # Thống kê mẫu
  n <- length(d)
  mean_d <- mean(d)
  sd_d <- sd(d)
  
  # Thống kê kiểm định
  t_stat <- (mean_d - mu0) / (sd_d / sqrt(n))
  
  # Bậc tự do
  df <- n - 1
  
  # Tính P-value (một phía bên phải)
  p_value <- pt(t_stat, df, lower.tail = FALSE)
  
  # Kết luận
  conclusion <- if (p_value <= alpha) "Reject H0" else "Accept H0"
  
  # Trả kết quả
  list(conclusion = conclusion, p_value = p_value)
}

result_2 <- paired_ttest_rightside(cholesterol_data$Before, cholesterol_data$After, mu0 = 0, alpha = 0.05)

# Bai 6

# Đọc dữ liệu
pro_time <- read.csv("prop.time.csv")

# Tính paired t-test để lấy khoảng tin cậy
ci_result <- t.test(pro_time$Des.Lang..1, pro_time$Des.Lang..2, 
                    paired = TRUE, 
                    conf.level = 0.95)

print(ci_result$conf.int)  # In khoảng tin cậy

# Dưa vào khoảng tin cậy, chưa thể  khẳng đinh  dược ngôn ngữ nào tốt hơn

# Cau b
# Kiem dinh cap ben trai
# H0: muy >= muy0
# H1: muy < muy0

test.leq.oneside <- function(x, y, mu0 = 0, alpha = 0.05) {
  # Loại bỏ NA
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  # Kiểm tra số phần tử giống nhau
  if (length(x) != length(y)) {
    stop("Vectors must be of the same length.")
  }
  
  # Hiệu giữa các cặp
  d <- x - y
  n <- length(d)
  mean_d <- mean(d)
  sd_d <- sd(d)
  
  # Tính t statistic
  t_stat <- (mean_d - mu0) / (sd_d / sqrt(n))
  
  # Bậc tự do
  df <- n - 1
  
  # P-value bên trái
  p_value <- pt(t_stat, df, lower.tail = TRUE)
  
  # Kết luận
  conclusion <- ifelse(p_value <= alpha, "Reject H0", "Accept H0")
  
  return(list(conclusion = conclusion, p_value = p_value))
}

result_left <- test.leq.oneside(pro_time$Des.Lang..1, pro_time$Des.Lang..2, mu0 = 0, alpha = 0.05)
print(result_left)


# -> p value = 0.38 -> Khong du bang chung de bac bo H0 

# Cau c: Viet ham ben kiem dinh cap ben phai
# H0: muy <= muy0
# H1: muy > muy0

test.geq.oneside <- function(x, y, mu0 = 0, alpha = 0.05) {
  # Loại bỏ NA
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  
  if (length(x) != length(y)) {
    stop("Vectors must be of the same length.")
  }
  
  d <- x - y
  n <- length(d)
  mean_d <- mean(d)
  sd_d <- sd(d)
  
  t_stat <- (mean_d - mu0) / (sd_d / sqrt(n))
  df <- n - 1
  
  p_value <- pt(t_stat, df, lower.tail = FALSE)
  
  conclusion <- ifelse(p_value <= alpha, "Reject H0", "Accept H0")
  
  return(list(conclusion = conclusion, p_value = p_value))
}

result_right <- test.geq.oneside(pro_time$Des.Lang..1, pro_time$Des.Lang..2, mu0 = 0, alpha = 0.05)
print(result_right)

# -> p value = 0.61 -> Khong du bang chung de bac bo H0 


# Bai 11

data_sal <- read.csv("Inf.Sal.csv")

hcm <- data_sal$HCM
hanoi <- data_sal$HaNoi

# Cau a. 
# Kiểm định t độc lập (2 mẫu,igả định phương sai không bằng nhau)
a <- t.test(hcm, hanoi, var.equal = FALSE, conf.level = 0.95)
print(a$conf.int) 
# ket qua la (-0.13, 0.74)

# Cau b.
# Tạo vector nhị phân
hcm_high <- ifelse(hcm > 11.5, 1, 0)
hanoi_high <- ifelse(hanoi > 11.5, 1, 0)

# Loại bỏ NA (nếu có)
hcm_high <- hcm_high[!is.na(hcm_high)]
hanoi_high <- hanoi_high[!is.na(hanoi_high)]

# Tính số người > 11.5 triệu
x_success <- sum(hcm_high)
y_success <- sum(hanoi_high)

n_x <- length(hcm)
n_y <- length(hanoi)

# Kiểm định prop.test đúng cú pháp
prop_test <- prop.test(
  x = c(x_success, y_success),
  n = c(n_x, n_y),
  alternative = "greater",  # H1: p_HCM > p_HN
  conf.level = 0.95  ,       # 95% confidence level
  correct = TRUE
)

print(prop_test)


# Câu c
prop.test.geq <- function(x, y, alpha = 0.05) {
  # Loại bỏ NA
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  
  # Nhị phân hóa: 1 nếu > 11.5 triệu
  x_high <- ifelse(x > 11.5, 1, 0)
  y_high <- ifelse(y > 11.5, 1, 0)
  
  # Tổng số thành công
  Y1 <- sum(x_high)
  Y2 <- sum(y_high)
  
  n1 <- length(x_high)
  n2 <- length(y_high)
  
  # Tỉ lệ mẫu
  p1_hat <- Y1 / n1
  p2_hat <- Y2 / n2
  p_hat <- (Y1 + Y2) / (n1 + n2)
  
  # Thống kê kiểm định Z
  Z <- (p1_hat - p2_hat) / sqrt(p_hat * (1 - p_hat) * (1/n1 + 1/n2))
  
  # P-value cho kiểm định một phía (lớn hơn)
  p_value <- pnorm(Z, lower.tail = FALSE)
  
  # Kết luận
  conclusion <- ifelse(p_value <= alpha, "Reject H0", "Accept H0")
  
  return(list(
    Z_stat = Z,
    p_value = p_value,
    conclusion = conclusion
  ))
}

# Câu d
# Tỉ lệ
p_hat_x <- x_success / n_x
p_hat_y <- y_success / n_y
diff <- p_hat_x - p_hat_y

# Sai số chuẩn
se <- sqrt((p_hat_x * (1 - p_hat_x)) / n_x + (p_hat_y * (1 - p_hat_y)) / n_y)

# Khoảng tin cậy 95%
z <- qnorm(0.975)
ci_lower <- diff - z * se
ci_upper <- diff + z * se
c(ci_lower, ci_upper)




