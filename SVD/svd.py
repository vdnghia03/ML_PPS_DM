'''
==================================
 Bài tập 1 - Tìm phân tích suy biến svd của một ma trận
==================================
Script Purpose:
    - Phan tich ma tran A theo phep bien doi SVD

==================================
'''

def tinh_svd(ma_tran_A):
    from scipy.linalg import svd

    ma_tran_U, vector_Sigma, ma_tran_Vt = svd(ma_tran_A) # Use svd function of Scipy Library

    ma_tran_zero = np.zeros((ma_tran_A.shape[0], ma_tran_A.shape[1]))
    np.fill_diagonal(ma_tran_zero, vector_Sigma)

    ma_tran_Sigma = np.array(ma_tran_zero)
    return ma_tran_U, ma_tran_Sigma, ma_tran_Vt

# Test HW 1
ma_tran_A = np.array([[1, 0, 0, 0, 2], [0, 0, 3, 0, 0], [0, 0, 0, 0, 0], [0, 2, 0, 0, 0]])
ma_tran_U, ma_tran_Sigma, ma_tran_V = tinh_svd(ma_tran_A)
print("Ma tran U:")
print(ma_tran_U)
print("\nMa tran Sigma:")
print(ma_tran_Sigma)
print("\nMa tran V:")
print(ma_tran_V)
print("\n Nhan ba ma tran UZV: ")
print(np.dot(np.dot(ma_tran_U, ma_tran_Sigma), ma_tran_V))
