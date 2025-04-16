/*
===============================================
     MY RAW APRIORI SCRATCH
===============================================
Purpose:
  - Code này chỉ là raw, tự code và còn lỗi rất nhiều, chưa tối ưu
  - Nên sử dụng Chat GPT fix lại cho hợp lí hơn

Usage: Từ Apriori, xây dựng các luật liên hệ, khám phá các mối liên hệ,
giúp đưa ra được các phân tích trong các lĩnh vực như thương mại, .......
===============================================
*/


# Thuat toan Apriori

def Apriori(Transaction : pd.DataFrame, minsup: float) -> pd.DataFrame:
    """
        T: Transaction (This is a dataframe)
        minsup: 60% ()
    """
    # Lay ten tat ca cac cot cua Transaction
    columns = Transaction.columns.to_list()
    columns = [[x] for x in columns]
    # So itemset
    number_itemset = Transaction.shape[0]

    # All frequent itemsets
    F = []

    flag = True


    while flag:
        columns_k = []
        C = []
        flag = False
        for col in columns:
            
            count_fre = Transaction[Transaction[col].eq(1).all(axis=1)].shape[0]
            count_sup = round(count_fre/number_itemset, 4)

            if count_sup >= minsup:
                item = {
                    "Item" : col
                    , "frequency": count_fre
                    , "support" : count_sup
                }  
                flag = True
                F.append(item)
                # Khoi tao C_k+1
                columns_k.append(col)
            else:
                flag = False
                
        if flag:
            C = [list(set(columns_k[i] + columns_k[j])) for i in range(len(columns_k)) for j in range(i+1, len(columns_k))]
            print(C)

        columns = []
        columns = C.copy()

    return F
