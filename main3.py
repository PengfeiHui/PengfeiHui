import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans, DBSCAN, AgglomerativeClustering
from sklearn.metrics.cluster import normalized_mutual_info_score, adjusted_mutual_info_score

# --------------------- 数据读取与预处理 ---------------------
# 读取基因表达数据和真实标签
data = pd.read_csv(r'D:\idea_python\pythontests\DATAproject3\data\klein.rds', sep='\t')  # 数据文件
label = pd.read_csv(r'D:\idea_python\pythontests\DATAproject3\data\klein.rds_label', sep='\t')  # 标签文件

# 数据转置：行对应样本，列对应特征
data_T = data.T

# 真实标签
label_1 = label.to_numpy()
label_true = label_1[:, 0]  # 提取标签列

# --------------------- PCA 降维 ---------------------
# PCA降维，保留95%的累计方差
pca = PCA(0.95)
pca.fit(data_T)
X = pca.transform(data_T)  # 降维后的数据矩阵
print(f"Data transformed by PCA. Shape: {X.shape}")  # 查看降维后维度

# --------------------- 聚类方法 1：KMeans ---------------------
n_clusters = len(np.unique(label_true))  # 聚类数与真实类别数一致
km = KMeans(n_clusters=n_clusters, random_state=1)
km.fit(X)
y_predict_kmeans = km.predict(X)

# --------------------- 聚类方法 2：层次聚类 ---------------------
# 使用 AgglomerativeClustering
hierarchical = AgglomerativeClustering(n_clusters=n_clusters, linkage='ward')
y_predict_hierarchical = hierarchical.fit_predict(X)

# --------------------- 聚类方法 3：DBSCAN ---------------------
# DBSCAN 聚类（需调整参数以适应不同数据集）
dbscan = DBSCAN(eps=2, min_samples=10)  # 可调整eps（邻域半径）和min_samples（最小样本数）
y_predict_dbscan = dbscan.fit_predict(X)

# --------------------- 聚类结果可视化 ---------------------
# 可视化 KMeans 聚类结果
plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.scatter(X[:, 0], X[:, 1], c=y_predict_kmeans, cmap='viridis', s=10)
plt.title("KMeans Clustering")
plt.xlabel("PC1")
plt.ylabel("PC2")

# 可视化层次聚类结果
plt.subplot(1, 3, 2)
plt.scatter(X[:, 0], X[:, 1], c=y_predict_hierarchical, cmap='viridis', s=10)
plt.title("Hierarchical Clustering")
plt.xlabel("PC1")
plt.ylabel("PC2")

# 可视化 DBSCAN 聚类结果
plt.subplot(1, 3, 3)
plt.scatter(X[:, 0], X[:, 1], c=y_predict_dbscan, cmap='viridis', s=10)
plt.title("DBSCAN Clustering")
plt.xlabel("PC1")
plt.ylabel("PC2")

plt.tight_layout()
plt.show()

# --------------------- 聚类效果评估 ---------------------
# 定义 NMI 和 AMI 指标
NMI = lambda x, y: normalized_mutual_info_score(x, y, average_method='arithmetic')
AMI = lambda x, y: adjusted_mutual_info_score(x, y, average_method='arithmetic')

# 计算评估指标
nmi_kmeans = NMI(label_true, y_predict_kmeans)
ami_kmeans = AMI(label_true, y_predict_kmeans)

# 注意：层次聚类和 DBSCAN 的聚类结果可能无法完全匹配真实标签
# 若 DBSCAN 识别出噪声点（标签为 -1），需剔除噪声点计算评估指标
valid_idx_dbscan = y_predict_dbscan != -1
nmi_dbscan = NMI(label_true[valid_idx_dbscan], y_predict_dbscan[valid_idx_dbscan])
ami_dbscan = AMI(label_true[valid_idx_dbscan], y_predict_dbscan[valid_idx_dbscan])

nmi_hierarchical = NMI(label_true, y_predict_hierarchical)
ami_hierarchical = AMI(label_true, y_predict_hierarchical)

# 输出评估指标
print(f"KMeans: NMI = {nmi_kmeans:.4f}, AMI = {ami_kmeans:.4f}")
print(f"Hierarchical: NMI = {nmi_hierarchical:.4f}, AMI = {ami_hierarchical:.4f}")
print(f"DBSCAN: NMI = {nmi_dbscan:.4f}, AMI = {ami_dbscan:.4f}")
