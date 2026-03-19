import polars as pl
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Loading the dataset with polars
df: pl.DataFrame = pl.read_csv("titanic.csv")

# Show the 10 first rows
print(df.head(10))

# Print the stat of the dataframe
print(df.describe())

# Print the structure of the dataframe
print(df.schema)

# Count the missing values
print(df.null_count())

# Show the count of duplicates values
print(f"Duplicates: {df.is_duplicated().sum()}")
df = df.unique()

# Type correction
df = df.with_columns(
    pl.col("Pclass").cast(pl.Utf8),
    pl.col("Sex").cast(pl.Utf8),
    pl.col("Embarked").cast(pl.Utf8),
)

# Outlier detection (IQR)
# Define mumeric columns where I want to detect aberrant values
num_cols: list[str] = ["Age", "Fare", "SibSp", "Parch"]

# Calculate quantile and the IRQ
Q1: dict[str, float] = {c: float(df[c].quantile(0.25)) for c in num_cols}
Q3: dict[str, float] = {c: float(df[c].quantile(0.75)) for c in num_cols}
IQR: dict[str, float] = {c: Q3[c] - Q1[c] for c in num_cols}

# Create a boolean mask indicating outliers for each column
outlier_mask: pl.DataFrame = df.select(
    [
        (pl.col(c) < (Q1[c] - 1.5 * IQR[c])) | (pl.col(c) > (Q3[c] + 1.5 * IQR[c]))
        for c in num_cols
    ]
)

# Calculate outliers by columns
print(outlier_mask.sum())

# Remove outliers with false values
df = df.filter(~outlier_mask.select(pl.any_horizontal(pl.all())).to_series())

# Skewness calculation for numeric columns
skewness = df.select([pl.col(c).skew().alias(c) for c in num_cols])
print(f"Skewness: {skewness}")

# Visualization
# Convert the polars dataframe into a pandas dataframe
df_pd: pd.DataFrame = df.to_pandas()

# Create a grid of 2x2
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Histograme for the age
sns.histplot(df_pd["Age"].dropna(), bins=30, kde=True, ax=axes[0, 0], color="steelblue")
axes[0, 0].set_title("Age distribution")

# Histograme for the fare
sns.histplot(df_pd["Fare"].dropna(), bins=30, kde=True, ax=axes[0, 1], color="coral")
axes[0, 1].set_title("Fare distribution")

# Countplot for the Pclass (count people for each class)
sns.countplot(
    x="Pclass", data=df_pd, ax=axes[1, 0], hue="Pclass", palette="Set2", legend=False
)
axes[1, 0].set_title("Class distribution")

# Countplot Survived (count people who survive)
sns.countplot(
    x="Survived",
    data=df_pd,
    ax=axes[1, 1],
    hue="Survived",
    palette="Set1",
    legend=False,
)
axes[1, 1].set_title("Survival distribution")

# Save the plot into a png file
plt.tight_layout()
plt.savefig("viz_01_distributions.png", dpi=150)
plt.close()

# Boxplot for compare age vs class
fig, axes = plt.subplots(1, 3, figsize=(15, 5))
sns.boxplot(
    x="Pclass",
    y="Age",
    data=df_pd,
    ax=axes[0],
    hue="Pclass",
    palette="Set2",
    legend=False,
)
axes[0].set_title("Age by Class")

# Boxplot for compare age vs survived
sns.boxplot(
    x="Survived",
    y="Age",
    data=df_pd,
    ax=axes[1],
    hue="Survived",
    palette="Set1",
    legend=False,
)
axes[1].set_title("Age by Survival")

# Boxplot for compare age vs age
sns.boxplot(
    x="Sex", y="Age", data=df_pd, ax=axes[2], hue="Sex", palette="muted", legend=False
)
axes[2].set_title("Age by Sex")

# Save the plot into a png file
plt.tight_layout()
plt.savefig("viz_02_boxplots.png", dpi=150)
plt.close()

# Correlation matrix to get a correlation bewteen all numerics values
fig, ax = plt.subplots(figsize=(8, 6))
corr_matrix: pd.DataFrame = df_pd[["Survived", "Age", "SibSp", "Parch", "Fare"]].corr()
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", center=0, fmt=".2f", ax=ax)
ax.set_title("Correlation Matrix")

# Save the plot into a png file
plt.tight_layout()
plt.savefig("viz_03_correlation.png", dpi=150)
plt.close()

# Fare is positively correlated with survival → richer passengers survived more
# Pclass is negatively correlated with survival → lower class = lower survival
# SibSp and Parch have weak correlation with survival

# Null handling, replace age and fare by the median due of the > skewnees
df = df.with_columns(
    pl.col("Age").fill_null(pl.col("Age").median()),
    pl.col("Fare").fill_null(pl.col("Fare").median()),
    # Replace the value by the first popular value
    pl.col("Embarked").fill_null(pl.col("Embarked").mode().first()),
)

# Remove the coloums cuz the dataset isn't complete
df = df.drop("Cabin")

# Survival analysis
print(f"Survival rate: {df['Survived'].mean():.2%}")
print(df.group_by("Pclass").agg(pl.col("Survived").mean()))
print(df.group_by("Sex").agg(pl.col("Survived").mean()))

df = df.with_columns(
    pl.col("Age")
    .cut(
        [12, 18, 30, 50, 80],
        labels=["enfant", "ado", "jeune", "adulte", "senior", "80+"],
    )
    .alias("Age_group")
)
print(df.group_by("Age_group").agg(pl.col("Survived").mean()))


# Analyse métier :
# La plupart des passagers ont entre 20 et 35ans, il y a un petit groupe d'enfants de 10ans et de personnes agées.
# La distribution de Fare est asymétrique à droite, la majorité des personnes ont payées moins de 15livres.
# La plupart des passagers sont en 3ème classe.
# Environ 65% des passagers sont morts
# La moyenne par classe est de 42, 27 et 23 ans pour les classes 1,2 et 3.
# L'age moyen des survivants est de 22ans.
# Permis les passagers les hommes sont légèrement plus agés.

# Pipeline processing
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

raw_df = pd.read_csv("titanic.csv")

# Define the X et Y variables
X = raw_df[["Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked"]]
y = raw_df["Survived"]

# Define type colomuns
numeric_features = ["Age", "Fare", "SibSp", "Parch", "Pclass"]
categorical_features = ["Sex", "Embarked"]

# Pipeline for the numerics values, replace null values by the median and put values a the same scale
numeric_transformer = Pipeline(steps=[
    ("imputer", SimpleImputer(strategy="median")),
    ("scaler", StandardScaler())
])

# Pipeline for the categorical values, replace null values by the most common values
categorical_transformer = Pipeline(steps=[
    ("imputer", SimpleImputer(strategy="most_frequent")),
    ("onehot", OneHotEncoder(handle_unknown="ignore"))
])

# Applu the correct transformations
preprocessor = ColumnTransformer(
    transformers=[
        ("num", numeric_transformer, numeric_features),
        ("cat", categorical_transformer, categorical_features)
    ]
)

X_prepared = preprocessor.fit_transform(X)

# Create a dataframe to see the result
prepared_feature_names = preprocessor.get_feature_names_out()
X_prepared_df = pd.DataFrame(X_prepared, columns=prepared_feature_names)

# Show the first 5 lines
print(X_prepared_df.head())