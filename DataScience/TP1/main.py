import polars as pl
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
df: pl.DataFrame = pl.read_csv("titanic.csv")

# Sample
print(df.head(10))

# Stats
print(df.describe())

# Missing values
print(df.null_count())

# Duplicates
print(f"Duplicates: {df.is_duplicated().sum()}")
df = df.unique()

# Type correction
df = df.with_columns(
    pl.col("Pclass").cast(pl.Utf8),
    pl.col("Sex").cast(pl.Utf8),
    pl.col("Embarked").cast(pl.Utf8),
)

# Outlier detection (IQR)
num_cols: list[str] = ["Age", "Fare", "SibSp", "Parch"]
Q1: dict[str, float] = {c: float(df[c].quantile(0.25)) for c in num_cols}
Q3: dict[str, float] = {c: float(df[c].quantile(0.75)) for c in num_cols}
IQR: dict[str, float] = {c: Q3[c] - Q1[c] for c in num_cols}

outlier_mask: pl.DataFrame = df.select(
    [
        (pl.col(c) < (Q1[c] - 1.5 * IQR[c])) | (pl.col(c) > (Q3[c] + 1.5 * IQR[c]))
        for c in num_cols
    ]
)
print(outlier_mask.sum())

# Remove outliers
df = df.filter(~outlier_mask.select(pl.any_horizontal(pl.all())).to_series())

# Visualization
df_pd: pd.DataFrame = df.to_pandas()

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
sns.histplot(df_pd["Age"].dropna(), bins=30, kde=True, ax=axes[0, 0], color="steelblue")
axes[0, 0].set_title("Age distribution")
sns.histplot(df_pd["Fare"].dropna(), bins=30, kde=True, ax=axes[0, 1], color="coral")
axes[0, 1].set_title("Fare distribution")
sns.countplot(
    x="Pclass", data=df_pd, ax=axes[1, 0], hue="Pclass", palette="Set2", legend=False
)
axes[1, 0].set_title("Class distribution")
sns.countplot(
    x="Survived",
    data=df_pd,
    ax=axes[1, 1],
    hue="Survived",
    palette="Set1",
    legend=False,
)
axes[1, 1].set_title("Survival distribution")
plt.tight_layout()
plt.savefig("viz_01_distributions.png", dpi=150)
plt.close()

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
sns.boxplot(
    x="Sex", y="Age", data=df_pd, ax=axes[2], hue="Sex", palette="muted", legend=False
)
axes[2].set_title("Age by Sex")
plt.tight_layout()
plt.savefig("viz_02_boxplots.png", dpi=150)
plt.close()

fig, ax = plt.subplots(figsize=(8, 6))
corr_matrix: pd.DataFrame = df_pd[["Survived", "Age", "SibSp", "Parch", "Fare"]].corr()
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", center=0, fmt=".2f", ax=ax)
ax.set_title("Correlation Matrix")
plt.tight_layout()
plt.savefig("viz_03_correlation.png", dpi=150)
plt.close()

# Null handling
df = df.with_columns(pl.col("Age").fill_null(pl.col("Age").median()))
df = df.with_columns(pl.col("Fare").fill_null(pl.col("Fare").median()))
df = df.with_columns(pl.col("Embarked").fill_null(pl.col("Embarked").mode().first()))
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
