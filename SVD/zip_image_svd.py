'''
==================================
  Bài tập 5 - Tìm truncated SVD khi biết số λ cần giữ lại
==================================
Script Purpose:
  Nén ảnh với hai hàm
    - Hàm nén ảnh
    - Hàm vẽ ảnh

Parametter:
  - Đầu vào: Hình ảnh chùa một cột
  - Đầu ra: Hình ảnh bị nén lần lượt với số giá trị lambda được giữ lại theo đề bài và phần trăm lượng thông tin giữ lại tương ứng.
==================================
Step:
  - Khai báo thư viện
  - Hàm đọc ảnh A =  np.array(Image.open)
  - Nhân A với mảng (0.299, 0.587, 0.114)
  - Tìm truncated SVD của A với 50 số lambda lớn nhất được giữ
  - Tạo lại ma trận A từ 3 ma trận
  - Tính phần trăm thông tin giữ lại
  - Vẽ ảnh sau khi đã nén và trước khi nén

'''

def nen_anh(ten_file_anh, so_lambda):
    import numpy as np
    from scipy.linalg import svd
    from PIL import Image
    import requests
    from PIL import Image
    import numpy as np
    from io import BytesIO
    import numpy as np
    import matplotlib.pyplot as plt

    # Đọc ảnh
    response = requests.get(ten_file_anh)
    if response.status_code == 200:
        # Đọc ảnh từ dữ liệu tải về
        img = Image.open(BytesIO(response.content))
        
        # Chuyển ảnh thành ma trận NumPy
        A = np.array(img)

    # Chuyển ảnh về một chiều màu xám
    A_gray = np.dot(A, [0.299, 0.587, 0.114])

    # Truncate SVD với 50 số lambda
    ma_tran_Uk, vector_Sigmak, ma_tran_VTk = svd(A_gray) # Use svd function of Scipy Library

    
    ma_tran_Uk = ma_tran_Uk[:, :so_lambda] # Dữ lại số cột cần cho ma trận U
    ma_tran_VTk = ma_tran_VTk[:so_lambda, :] # Dữ lại số lượng dòng vo ma trận VT

    vector_Sk_truncate = vector_Sigmak[:so_lambda] # Này là vector, chỉ giữ lại số lượng phần tử cần
    ma_tran_Sk = np.diag(vector_Sk_truncate) # Chuyển vector này thành ma trận

    # Tạo lại ma trận A
    gray_scale_array = np.dot(ma_tran_Uk, np.dot(ma_tran_Sk, ma_tran_VTk))

    # Phần trăm lượng thông tin giữ lại
    luong_thong_tin = sum(np.square(vector_Sk_truncate))/sum(np.square(vector_Sigmak)) * 100

    print("Số lambda dữ lại: ", so_lambda)
    print("Phần trăm lượng thông tin giữ lại: ", luong_thong_tin)
    # Vẽ ảnh trước và sau khi nén
    # Hiển thị ảnh gốc và ảnh sau khi nén
    plt.figure(figsize=(10, 5))

    # Ảnh gốc
    plt.subplot(1, 2, 1)
    plt.imshow(A, cmap="gray")
    plt.title("Ảnh Gốc")
    plt.axis("off")

    # Ảnh sau khi nén
    plt.subplot(1, 2, 2)
    plt.imshow(gray_scale_array, cmap="gray")
    plt.title("Ảnh Sau Khi Nén")
    plt.axis("off")

    return gray_scale_array, luong_thong_tin

# Test HW5
gray_scale_array, luong_thong_tin = nen_anh("https://drive.usercontent.google.com/u/0/uc?id=1sSqWQxG9UTZupoBgmiyLIoYXoN7vrRu6&export=download", 101)
