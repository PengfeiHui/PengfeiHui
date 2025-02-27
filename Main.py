import pandas as pd
from efficient_apriori import apriori

"""
惠鹏飞
22009200063
"""

def read_voting_data(file_path):
    raw_data = pd.read_table(file_path, sep=",", header=None, na_values="?")
    print(raw_data)
    column_names = [
        "party",
        "handicapped-infants",
        "water-project-cost-sharing",
        "adoption-of-the-budget-resolution",
        "physician-fee-freeze",
        "el-salvador-aid",
        "religious-groups-in-schools",
        "anti-satellite-test-ban",
        "aid-to-nicaraguan-contras",
        "mx-missile",
        "immigration",
        "synfuels-corporation-cutback",
        "education-spending",
        "superfund-right-to-sue",
        "crime",
        "duty-free-exports",
        "export-administration-act-south-africa",
    ]
    raw_data = raw_data.fillna(0)
    raw_data.columns = column_names
    processed_data = raw_data.replace({"y": 1, "n": -1})
    return processed_data


voting_data = read_voting_data(r"./data/house-votes-84.data")
transactions = []
for i in range(voting_data.shape[0]):
    transactions.append(tuple([str(voting_data.values[i][j]) for j in range(voting_data.shape[1])]))
item_sets, association_rules = apriori(transactions, min_support=0.3, min_confidence=0.9)
for rule in association_rules:
    print(rule)
