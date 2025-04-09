
# =============== Bài 1 ====================
# a. Nhập số liệu trên vào R.
# Tạo dữ liệu
data <- data.frame(
  year = 1970:1979,
  snow_cover = c(6.5, 12.0, 14.9, 10.0, 10.7, 7.9, 21.9, 12.5, 14.5, 9.2)
)

# Hiển thị dữ liệu
print(data)


# b. Vẽ snow.cover theo year.

# Vẽ biểu đồ snow.cover theo year
plot(data$year, data$snow_cover, pch = 16, col = "blue",
     main = "Biểu đồ snow.cover theo year",
     xlab = "Năm", ylab = "Độ phủ tuyết (snow.cover)")



# c. Lặp lại câu b. sau khi lấy logarit của biến snow.cover
str(data)

# Tạo biến mới với giá trị logarit
data$log_snow_cover <- log(data$snow_cover)

# Vẽ lại biểu đồ với giá trị logarit
plot(data$year, data$log_snow_cover, pch = 16, col = "red",
     main = "Biểu đồ log(snow.cover) theo year",
     xlab = "Năm", ylab = "log(Độ phủ tuyết)")


# =============== Bài 2 ====================

# a. Nhập số liệu vào R
lamphat1 <- data.frame(
  Nam = 1960:1980,
  US = c(1.5, 1.1, 1.1, 1.2, 1.4, 1.6, 2.8, 2.8, 4.2, 5.0, 5.9, 4.3, 3.6, 6.2, 10.9, 9.2, 5.8, 6.4, 7.6, 11.4, 13.6),
  Anh = c(1.0, 3.4, 4.5, 2.5, 3.9, 4.6, 3.7, 2.4, 4.8, 5.2, 6.5, 9.5, 6.8, 8.4, 16.0, 24.2, 16.5, 15.9, 8.3, 13.4, 18.0)
)

lamphat2 <- data.frame(
  Nam = 1960:1980,
  Nhat = c(3.6, 5.4, 6.7, 7.7, 3.9, 6.5, 6.0, 4.0, 5.5, 5.1, 7.6, 6.3, 4.9, 12.0, 24.6, 11.7, 9.3, 8.1, 3.8, 3.6, 8.0),
  Duc = c(1.5, 2.3, 4.5, 3.0, 2.3, 3.4, 3.5, 1.5, 18.0, 2.6, 3.7, 5.3, 5.4, 7.0, 7.0, 5.9, 4.5, 3.7, 2.7, 4.1, 5.5)
)

# b. Trộn 2 data.frame trên vào 1 data.frame duy nhất là lamphat theo Nam.
lamphat <- merge(lamphat1, lamphat2, by = "Nam")
print(lamphat)

# c. Đếm số năm các nước US, Anh, Nhật, Đức có tỉ lệ lạm phát trên 5%.
# Đếm số năm lạm phát ở US trên 5%
sum(lamphat$US > 5)

# Đếm số năm lạm phát ở Anh trên 5%
sum(lamphat$Anh > 5)

# Đếm số năm lạm phát ở Nhật trên 5%
sum(lamphat$Nhat > 5)

# Đếm số năm lạm phát ở Đức trên 5%
sum(lamphat$Duc > 5)

# d. Vẽ đồ thị phân tán về tỉ lệ lạm phát cho mỗi quốc gia theo thời gian. Cho nhận xét tổng quát về lạm phát của 4 nước?
par(mfrow = c(2, 2)) # Chia màn hình thành 2x2 để vẽ 4 đồ thị

plot(lamphat$Nam, lamphat$US, type = "l", xlab = "Năm", ylab = "Lạm phát US (%)", main = "Lạm phát US theo thời gian")
plot(lamphat$Nam, lamphat$Anh, type = "l", xlab = "Năm", ylab = "Lạm phát Anh (%)", main = "Lạm phát Anh theo thời gian")
plot(lamphat$Nam, lamphat$Nhat, type = "l", xlab = "Năm", ylab = "Lạm phát Nhật (%)", main = "Lạm phát Nhật theo thời gian")
plot(lamphat$Nam, lamphat$Duc, type = "l", xlab = "Năm", ylab = "Lạm phát Đức (%)", main = "Lạm phát Đức theo thời gian")

# Nhận xét:

# - US: Lạm phát khá biến động, đa phần là tăng lên, từ năm 1970-1972 và 1974-1976 có phần giảm đôi chút 

# - Anh: Lạm phát có vẻ biến động mạnh, tăng khá nanh vào những năm 1970-1975

# - Nhật: Lạm phát ở Nhật trước 1972 có phần ổn định, tuy nhiên từ 1972 đến 1974 thì lại tăng rất cao, sau đó giảm xuống

# - Đức: Lạm phát ở Đức dường như ổn định hơn so với ba nước còn lại trong phần lớn giai đoạn, mặc dù có một đỉnh điểm là vào 1968-1969

# e. Tính trung bình, trung vị, Max, Min, độ lệch chuẩn, sai số chuẩn của từng nước?

thongke_lamphat <- data.frame(
  QuocGia = c("US", "Anh", "Nhat", "Duc"),
  TrungBinh = c(mean(lamphat$US), mean(lamphat$Anh), mean(lamphat$Nhat), mean(lamphat$Duc)),
  TrungVi = c(median(lamphat$US), median(lamphat$Anh), median(lamphat$Nhat), median(lamphat$Duc)),
  Max = c(max(lamphat$US), max(lamphat$Anh), max(lamphat$Nhat), max(lamphat$Duc)),
  Min = c(min(lamphat$US), min(lamphat$Anh), min(lamphat$Nhat), min(lamphat$Duc)),
  DoLechChuan = c(sd(lamphat$US), sd(lamphat$Anh), sd(lamphat$Nhat), sd(lamphat$Duc)),
  SaiSoChuan = c(sd(lamphat$US) / sqrt(nrow(lamphat)),
                 sd(lamphat$Anh) / sqrt(nrow(lamphat)),
                 sd(lamphat$Nhat) / sqrt(nrow(lamphat)),
                 sd(lamphat$Duc) / sqrt(nrow(lamphat)))
)

# f. Để xác định lạm phát nước nào biến thiên nhiều hơn, ta cần dựa vào tham số thống kê nào? Kết luận?
# Để xác định mức độ biến thiên của lạm phát giữa các nước, ta cần dựa vào độ lệch chuẩn (standard deviation). Độ lệch chuẩn đo lường sự phân tán của các giá trị xung quanh giá trị trung bình. Độ lệch chuẩn càng cao thì mức độ biến thiên càng lớn.
# Kết luận: Anh là nước có mức độ biến thiên lạm phát cao nhất

# g:
lamphat1 <- subset(lamphat, Nam < 1980)
print(lamphat1)

#h
# Tính các giá trị cần thiết
n1 <- nrow(lamphat1)
mean_nam1 <- mean(lamphat1$Nam)
mean_us1 <- mean(lamphat1$US)
sum_xy <- sum(lamphat1$Nam * lamphat1$US)
sum_x_squared <- sum(lamphat1$Nam^2)

# Tính beta2_hat
beta2_hat <- (sum_xy - n1 * mean_nam1 * mean_us1) / (sum_x_squared - n1 * mean_nam1^2)

# Tính beta1_hat
beta1_hat <- mean_us1 - beta2_hat * mean_nam1

cat("Hệ số hồi quy cho lạm phát US theo thời gian (sử dụng lamphat1):\nBeta0 (Intercept):", beta1_hat, "\nBeta1 (Slope):", beta2_hat, "\n\n")

# test bằng lm
model_us <- lm(US ~ Nam, data = lamphat1)
coefficients(model_us)

# Vẽ đồ thị
par(mfrow = c(1, 1))
plot(lamphat1$Nam, lamphat1$US,
     xlab = "Năm",
     ylab = "Lạm phát US (%)",
     main = "Hồi quy tuyến tính: Lạm phát US theo thời gian (1960-1979)")

# Thêm đường hồi quy
abline(a = beta1_hat, b = beta2_hat, col = "red", lwd = 2)

# i. Dự đoán lạm phát US năm 1980
predicted_1980 <- beta1_hat + beta2_hat * 1980
cat("Dự đoán lạm phát US năm 1980:", predicted_1980, "%\n")

# Lạm phát thực tế năm 1980 (từ data.frame lamphat)
actual_1980 <- lamphat$US[lamphat$Nam == 1980]
cat("Lạm phát US thực tế năm 1980:", actual_1980, "%\n")

# So sánh
cat("Sai số dự đoán:", predicted_1980 - actual_inflation_1980, "%\n")


# ==============================Bài 3 ========================
# a. Ve bieu do
# Dữ liệu số cây
y <- c(7, 8, 6, 4, 9, 11, 9, 9, 9, 10, 9, 8, 11, 5, 8, 5, 8, 8, 7, 8, 3, 5, 8, 7, 10, 7, 8, 9, 8, 11, 10, 8, 9, 8, 9, 9, 7, 8, 13, 8, 9, 6, 7, 9, 9, 7, 9, 5, 6, 5, 6, 9, 8, 8, 4, 4, 7, 7, 8, 9, 10, 2, 7, 10, 8, 10, 6, 7, 7, 8)

# Vẽ biểu đồ tần suất (histogram)
hist(y, main = "Biểu đồ tần suất số cây đường kính > 12cm", xlab = "Số cây", ylab = "Tần số", col = "lightblue")


# b. Tính trung bình mẫu y và độ lệch chuẩn mẫu s của Y

# Tính trung bình mẫu
mean_y <- mean(y)
cat("Trung bình mẫu (Ȳ):", mean_y, "\n")

# Tính độ lệch chuẩn mẫu
sd_cay <- sd(y)
cat("Độ lệch chuẩn mẫu (s):", sd_cay, "\n")

# c.

y <- c(7, 8, 6, 4, 9, 11, 9, 9, 9, 10, 9, 8, 11, 5, 8, 5, 8, 8, 7, 8, 3, 5, 8, 7, 10, 7, 8, 9, 8, 11, 10, 8, 9, 8, 9, 9, 7, 8, 13, 8, 9, 6, 7, 9, 9, 7, 9, 5, 6, 5, 6, 9, 8, 8, 4, 4, 7, 7, 8, 9, 10, 2, 7, 10, 8, 10, 6, 7, 7, 8)

# Xây dựng hàm khoang
khoang <- function(x, k) {
  m <- mean(x)
  s <- sd(x)
  lower <- m - k * s
  upper <- m + k * s
  return(c(lower = lower, upper = upper))
}

# Tính khoảng ước lượng cho k = 1, 2, 3
khoang_k1 <- khoang(y, 1)
khoang_k2 <- khoang(y, 2)
khoang_k3 <- khoang(y, 3)

cat("Khoảng ước lượng (k=1): [", khoang_k1["lower"], ",", khoang_k1["upper"], "]\n")
cat("Khoảng ước lượng (k=2): [", khoang_k2["lower"], ",", khoang_k2["upper"], "]\n")
cat("Khoảng ước lượng (k=3): [", khoang_k3["lower"], ",", khoang_k3["upper"], "]\n")

# Tính tỷ lệ các mảnh đất nằm trong mỗi khoảng
ty_le_k1 <- mean(y >= khoang_k1["lower"] & y <= khoang_k1["upper"])
ty_le_k2 <- mean(y >= khoang_k2["lower"] & y <= khoang_k2["upper"])
ty_le_k3 <- mean(y >= khoang_k3["lower"] & y <= khoang_k3["upper"])

cat("Tỷ lệ nằm trong khoảng k=1:", ty_le_k1 * 100, "%\n")
cat("Tỷ lệ nằm trong khoảng k=2:", ty_le_k2 * 100, "%\n")
cat("Tỷ lệ nằm trong khoảng k=3:", ty_le_k3 * 100, "%\n")

# So sánh với quy tắc thực nghiệm
cat("\nSo sánh với quy tắc thực nghiệm:\n")
cat("- Khoảng ± 1 độ lệch chuẩn (k=1): Quy tắc thực nghiệm ≈ 68%, Thực tế =", ty_le_k1 * 100, "%\n")
cat("- Khoảng ± 2 độ lệch chuẩn (k=2): Quy tắc thực nghiệm ≈ 95%, Thực tế =", ty_le_k2 * 100, "%\n")
cat("- Khoảng ± 3 độ lệch chuẩn (k=3): Quy tắc thực nghiệm ≈ 99.7%, Thực tế =", ty_le_k3 * 100, "%\n")
