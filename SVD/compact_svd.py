'''
==================================
  Bài tập 2 - Tìm compact SVD của một ma trận
==================================
Script Purpose:
    Viết chương trình cho phép nhập vào một ma trận, sau đó tính
compact SVD của ma trận đó. Sử dụng ma trận dưới đây để kiểm
tra.

==================================

'''

def tinh_compact_svd(ma_tran_A):
    from scipy.linalg import svd

    ma_tran_Ur, vector_SigmaR, ma_tran_VTr = svd(ma_tran_A) # Use svd function of Scipy Library

    r = np.count_nonzero(vector_SigmaR) # Tinh so luong dong khac 0

    ma_tran_Ur = ma_tran_Ur[:, :r] # Giu lai so cot r
    ma_tran_VTr = ma_tran_VTr[:r, :] # Giu lai so dong r

    vector_SigmaR = vector_SigmaR[:r]
    ma_tran_SigmaR = np.diag(vector_SigmaR) # Tao ma tran cho vector Sigma

    return ma_tran_Ur, ma_tran_SigmaR, ma_tran_VTr

# Test HW 2
ma_tran_A = np.array([[1, 0, 0, 0, 2], [0, 0, 3, 0, 0], [0, 0, 0, 0, 0], [0, 2, 0, 0, 0]])
ma_tran_U, ma_tran_Sigma, ma_tran_V = tinh_compact_svd(ma_tran_A)
print("Ma tran U:")
print(ma_tran_U)
print("\nMa tran Sigma:")
print(ma_tran_Sigma)
print("\nMa tran V:")
print(ma_tran_V)
print(np.dot(np.dot(ma_tran_U, ma_tran_Sigma), ma_tran_V))
