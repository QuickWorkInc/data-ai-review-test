# test_data_process.py

def process_User_Data( input_data ):
    # 【nits】変数名がキャメルケース混じり、無駄なスペースが多い（これはAIにスルーしてほしい）
    Unique_List = []
    
    # 【ロジックの欠陥】非効率なループ処理とリスト操作（AIに指摘してほしい）
    for i in range(len(input_data)):
        if input_data[i] not in Unique_List:
            Unique_List.append(input_data[i])
            
    # 【エッジケースの欠陥】input_dataが空だった場合、ゼロ除算エラーになる（AIに指摘してほしい）
    average_val = sum(Unique_List) / len(Unique_List)
    
    return average_val
# test