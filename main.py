import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.impute import SimpleImputer
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt

# 1. 加载数据集
iris = load_iris()
X, y = iris.data, iris.target

# 2. 引入缺失值并填补
rng = np.random.default_rng(42)
missing_mask = rng.choice([1, 0], size=X.shape, p=[0.1, 0.9]).astype(bool)
X[missing_mask] = np.nan

imputer = SimpleImputer(strategy='mean')
X_imputed = imputer.fit_transform(X)

# 3. 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X_imputed, y, test_size=0.3, random_state=42)

# 4. 决策树分类
dt_model = DecisionTreeClassifier(random_state=42)
dt_model.fit(X_train, y_train)
y_pred_dt = dt_model.predict(X_test)
accuracy_dt = accuracy_score(y_test, y_pred_dt)
print(f"决策树准确率: {accuracy_dt:.2f}")

# 决策树可视化
plt.figure(figsize=(10, 6))
plot_tree(dt_model, feature_names=iris.feature_names, class_names=iris.target_names, filled=True)
plt.show()

# 输出特征重要性
print("特征重要性:", dt_model.feature_importances_)

# 5. KNN分类
knn_model = KNeighborsClassifier(n_neighbors=5)
knn_model.fit(X_train, y_train)
y_pred_knn = knn_model.predict(X_test)
accuracy_knn = accuracy_score(y_test, y_pred_knn)
print(f"KNN准确率: {accuracy_knn:.2f}")

# 6. 朴素贝叶斯分类
nb_model = GaussianNB()
nb_model.fit(X_train, y_train)
y_pred_nb = nb_model.predict(X_test)
accuracy_nb = accuracy_score(y_test, y_pred_nb)
print(f"朴素贝叶斯准确率: {accuracy_nb:.2f}")

# 7. 模型准确率比较
print(f"模型准确率比较：决策树={accuracy_dt:.2f}, KNN={accuracy_knn:.2f}, 朴素贝叶斯={accuracy_nb:.2f}")
