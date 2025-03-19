'''
==================================
  Bài tập 4 - 
==================================
Script Purpose:
    - Tìm truncated SVD khi biết phần trăm lượng
thông tin muốn giữ
    -Viết chương trình cho phép nhập vào ma trận A dưới đây. Tìm
truncated SVD của ma trận A khi muốn giữ lại ít nhất 90% lượng
thông tin ban đầu.
==================================


'''

def tinh_luong_ky_di_can(ma_tran_A, phan_tram_thong_tin_luu_giu):
    from scipy.linalg import svd

    ma_tran_Uk, vector_Sigmak, ma_tran_VTk = svd(ma_tran_A) # Use svd function of Scipy Library

    total_square_sum = np.sum(np.square(vector_Sigmak) )  # Total square cho vector ban đầu

    sp_ky_di_can = 1

    for i in range(1, len(vector_Sigmak)): # Ta su lan luot so luong ky di 

        vector_Sk_truncate = vector_Sigmak[:i] # Truncate lần lượt
        total_square_truncate_sum = np.sum( np.square(vector_Sk_truncate)) # Tổng square sau khi truncate

        # Tính phần trăm lượng thông tin dữ lại
        I = (total_square_truncate_sum / total_square_sum) * 100

        if I >= phan_tram_thong_tin_luu_giu:
            so_ky_di_can = i
            break

    ma_tran_Uk = ma_tran_Uk[:, :so_ky_di_can]
    ma_tran_VTk = ma_tran_VTk[:so_ky_di_can, :]
    ma_tran_Sk = np.diag(vector_Sk_truncate)

    return so_ky_di_can, ma_tran_Uk, ma_tran_Sk, ma_tran_VTk

# Test HW 4
ma_tran_A = np.array([[1.01, 0.9, 0.2, 1.001, 0.3],
              [0.2, 1.01, 0.3, 0.8, 0.4],
              [1, 1.002, 2, 0.98, 2],
              [0.3, 2, 0.4, 1.01, 0.9],
              [1.1, 0.2, 0.03, 2, 0.87]])
so_ky_di_can, ma_tran_U, ma_tran_Sigma, ma_tran_V =  tinh_luong_ky_di_can(ma_tran_A, 90)
print("Ma tran U:")
print(ma_tran_U)
print("\nMa tran Sigma:")
print(ma_tran_Sigma)
print("\nMa tran V:")
print(ma_tran_V)
print(np.dot(np.dot(ma_tran_U, ma_tran_Sigma), ma_tran_V))
print("\n So ki di can:")
print(so_ky_di_can)
