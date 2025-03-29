"""
==================================
 Bài tập 8 - Viết chương trình cho phép khôi phục ảnh nhòe
==================================
Script Purpose:
    - Khoi phuc anh nhoe theo phuong doc

Parametter:
  - Dau vao: Ảnh nhòe theo phương doc và l.
  - Dau ra: Ảnh đã được khôi phục.
==================================

"""

def khoi_phuc_anh_nhoe_doc(ten_file_anh, l):
  # Khai bao thu vien
  from matplotlib import pyplot as plt
  import numpy as np
  from scipy.linalg import svd
  from PIL import Image
  import requests
  from PIL import Image
  import numpy as np
  from io import BytesIO

  # Dung ham numpy.array de doc anh
  response = requests.get(ten_file_anh)
  if response.status_code == 200:
      # Đọc ảnh từ dữ liệu tải về
      img = Image.open(BytesIO(response.content))

      # Chuyển ảnh thành ma trận NumPy
      B = np.array(img)

  # Tao ma tran A giam cap Toepltiz
  r, m = B.shape[0], B.shape[1]
  n = r + l-1
  A = np.zeros((r, n))
  for i in range(r):
    for j in range(i, l +i):
      A[i,j] = 1/l

  # Tìm A+ = V Σ+ UT từ SVD của A.
  # Tim SVD cua A
  ma_tran_Uk, vector_Sigmak, ma_tran_VTk = svd(A) # Use svd function of Scipy Library

  # Vector Sigma +
  vector_Sigmak_plus = np.where(vector_Sigmak != 0, 1 / vector_Sigmak, 0)
  ma_tran_zero = np.zeros((A.shape[0], A.shape[1]))
  np.fill_diagonal(ma_tran_zero, vector_Sigmak_plus )

  # Ma trận Sigma +
  ma_tran_Sigma_plusT = np.array(ma_tran_zero).T

  # Tính ma trận X+ từ công thức
  A_plus = ma_tran_VTk.T @ ma_tran_Sigma_plusT @ ma_tran_Uk.T # Ma tran gia nghich dao

  # Anh khoi phuc
  anh_khoi_phuc = np.dot(A_plus, B)

# Ảnh nhoe
  plt.subplot(1, 2, 1)
  plt.imshow(B, cmap="gray")
  plt.title("Ảnh Gốc")
  plt.axis("off")

  # Ảnh sau khi khoi phuc
  plt.subplot(1, 2, 2)
  plt.imshow(anh_khoi_phuc,cmap="gray" )
  plt.title("Ảnh Sau Khi Khoi phuc")
  plt.axis("off")
  return anh_khoi_phuc
