'''
==================================
  Bài tập 3 - Tìm truncated SVD khi biết số λ cần giữ lại
==================================
Script Purpose:
    tính truncated SVD của ma trận A khi giữ lại 4 giá trị λ lớn
nhất và xuất ra lượng thông tin còn giữ lại lúc này của ma trận.
==================================

'''

def tinh_luong_thong_tin(ma_tran_A):
    from scipy.linalg import svd


    ma_tran_Uk, vector_Sigmak, ma_tran_VTk = svd(ma_tran_A) # Use svd function of Scipy Library

    r = 4 # Số lambda cần dữ lại
    ma_tran_Uk = ma_tran_Uk[:, :r] # Dữ lại số cột cần cho ma trận U
    ma_tran_VTk = ma_tran_VTk[:r, :] # Dữ lại số lượng dòng vo ma trận VT

    vector_Sk_truncate = vector_Sigmak[:r] # Này là vector, chỉ giữ lại số lượng phần tử lambda theo đề
    ma_tran_Sk = np.diag(vector_Sk_truncate) # Chuyển vector sau khi truncate thành ma trận

    # Tính phần trăm lượng thông tin dữ lại

    total_square_truncate_sum = np.sum(np.square(vector_Sk_truncate)) # Tổng bình phương sau khi truncate của ma trận Sigma
    total_square_sum = np.sum(np.square(vector_Sigmak)) # Tổng bình phương ban đầu của ma trận Sigma
    phan_tram_thong_tin_luu_giu = (total_square_truncate_sum / total_square_sum) * 100

    return phan_tram_thong_tin_luu_giu, ma_tran_Uk, ma_tran_Sk, ma_tran_VTk


# Test HW 3
ma_tran_A = np.array([[1.01, 0.9, 0.2, 1.001, 0.3],
              [0.2, 1.01, 0.3, 0.8, 0.4],
              [1, 1.002, 2, 0.98, 2],
              [0.3, 2, 0.4, 1.01, 0.9],
              [1.1, 0.2, 0.03, 2, 0.87]])
phan_tram_thong_tin_luu_giu, ma_tran_U, ma_tran_Sigma, ma_tran_V = tinh_luong_thong_tin(ma_tran_A)
print("Ma tran U:")
print(ma_tran_U)
print("\nMa tran Sigma:")
print(ma_tran_Sigma)
print("\nMa tran V:")
print(ma_tran_V)
print(np.dot(np.dot(ma_tran_U, ma_tran_Sigma), ma_tran_V))
print("\nPhan tram thong tin luu giu:")
print(phan_tram_thong_tin_luu_giu)
