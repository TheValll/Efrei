import polars as pl
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

sns.set_theme(style="whitegrid")

df: pl.DataFrame = pl.read_csv("credit_risk_dataset.csv")
print(df.head(10))
print(df.describe())

# Missing values
print(df.null_count())

# Duplicates
print(f"Duplicates: {df.is_duplicated().sum()}")
df = df.unique()

# Type correction
# On corrige le type pour les colonnes string
df = df.with_columns(
    pl.col("loan_status").cast(pl.Utf8),
    pl.col("loan_grade").cast(pl.Utf8),
    pl.col("person_home_ownership").cast(pl.Utf8),
    pl.col("loan_intent").cast(pl.Utf8),
    pl.col("cb_person_default_on_file").cast(pl.Utf8),
)

# IQR
# On sélecte les colonnes numériques
num_cols: list[str] = [
    "person_age",
    "person_income",
    "person_emp_length",
    "loan_amnt",
    "loan_int_rate",
]
# On prends le quantile correspondant en droppant par avance les nulls values
Q1: dict[str, float] = {c: float(df[c].drop_nulls().quantile(0.25)) for c in num_cols}
Q3: dict[str, float] = {c: float(df[c].drop_nulls().quantile(0.75)) for c in num_cols}
IQR: dict[str, float] = {c: Q3[c] - Q1[c] for c in num_cols}

# Masque permettant de sélectionner les valeurs entre Q1 et Q3 permettant de supprimer les valeurs abérantes
outlier_mask: pl.DataFrame = df.select(
    [
        (
            (pl.col(c) < (Q1[c] - 1.5 * IQR[c])) | (pl.col(c) > (Q3[c] + 1.5 * IQR[c]))
        ).fill_null(False)
        for c in num_cols
    ]
)

# On applique le filtre sur le tableau
print(outlier_mask.sum())
df = df.filter(~outlier_mask.select(pl.any_horizontal(pl.all())).to_series())

# Visualization
df_pd: pd.DataFrame = df.to_pandas()

# On crée un subplots 2x2 avec les distributions des variables numériques (age, revenu, montant du prêt, taux d'intérêt)
fig, axes = plt.subplots(2, 2, figsize=(14, 10))
sns.histplot(
    df_pd["person_age"].dropna(), bins=30, kde=True, ax=axes[0, 0], color="steelblue"
)
axes[0, 0].set_title("Age distribution")
sns.histplot(
    df_pd["person_income"].dropna(), bins=30, kde=True, ax=axes[0, 1], color="coral"
)
axes[0, 1].set_title("Income distribution")
sns.histplot(
    df_pd["loan_amnt"].dropna(),
    bins=30,
    kde=True,
    ax=axes[1, 0],
    color="mediumseagreen",
)
axes[1, 0].set_title("Loan amount distribution")
sns.histplot(
    df_pd["loan_int_rate"].dropna(), bins=30, kde=True, ax=axes[1, 1], color="orchid"
)
axes[1, 1].set_title("Interest rate distribution")
plt.tight_layout()
plt.savefig("viz_01_distributions_num.png", dpi=150)
plt.close()

# Skewness des variables numériques
# Proche de 0 = distribution quasi normale, > 0 = asymétrique à droite, < 0 = à gauche
skew_cols: list[str] = ["person_age", "person_income", "loan_amnt", "loan_int_rate"]
for col in skew_cols:
    skew_val: float = df_pd[col].dropna().skew()
    print(f"{col}: {skew_val:.3f}")

# Si p-value < 0.05 on rejette l'hypothèse que la distribution est normale
for col in skew_cols:
    sample = (
        df_pd[col]
        .dropna()
        .sample(n=min(5000, len(df_pd[col].dropna())), random_state=42)
    )
    stat, p_value = stats.shapiro(sample)
    normal: str = "Oui" if p_value > 0.05 else "Non"
    print(f"{col}: stat={stat:.4f}, p={p_value:.4e} -> Normale: {normal}")

# Répartition de la colonne à prédire (loan_status)
status_counts = df_pd["loan_status"].value_counts().sort_index()
status_pct = df_pd["loan_status"].value_counts(normalize=True).sort_index() * 100
for val in status_counts.index:
    print(f"Classe {val}: {status_counts[val]} ({status_pct[val]:.1f}%)")

# On fait pareil mais avec les variables catégorielles en utilisant des countplots
fig, axes = plt.subplots(2, 2, figsize=(14, 10))
sns.countplot(
    x="loan_status",
    data=df_pd,
    ax=axes[0, 0],
    hue="loan_status",
    palette="Set1",
    legend=False,
)
axes[0, 0].set_title("Loan status (0=OK, 1=Default)")
sns.countplot(
    x="loan_grade",
    data=df_pd,
    ax=axes[0, 1],
    hue="loan_grade",
    palette="Set2",
    legend=False,
    order=sorted(df_pd["loan_grade"].dropna().unique()),
)
axes[0, 1].set_title("Loan grade distribution")
sns.countplot(
    x="loan_intent",
    data=df_pd,
    ax=axes[1, 0],
    hue="loan_intent",
    palette="Set3",
    legend=False,
)
axes[1, 0].set_title("Loan intent distribution")
axes[1, 0].tick_params(axis="x", rotation=30)
sns.countplot(
    x="person_home_ownership",
    data=df_pd,
    ax=axes[1, 1],
    hue="person_home_ownership",
    palette="pastel",
    legend=False,
)
axes[1, 1].set_title("Home ownership distribution")
plt.tight_layout()
plt.savefig("viz_02_distributions_cat.png", dpi=150)
plt.close()

# Boxplots pour comparer les variables numériques selon les catégories
fig, axes = plt.subplots(1, 3, figsize=(18, 5))
sns.boxplot(
    x="loan_status",
    y="person_income",
    data=df_pd,
    ax=axes[0],
    hue="loan_status",
    palette="Set1",
    legend=False,
)
axes[0].set_title("Income by Loan Status")
sns.boxplot(
    x="loan_grade",
    y="loan_int_rate",
    data=df_pd,
    ax=axes[1],
    hue="loan_grade",
    palette="Set2",
    legend=False,
    order=sorted(df_pd["loan_grade"].dropna().unique()),
)
axes[1].set_title("Interest Rate by Grade")
sns.boxplot(
    x="loan_status",
    y="person_age",
    data=df_pd,
    ax=axes[2],
    hue="loan_status",
    palette="Set1",
    legend=False,
)
axes[2].set_title("Age by Loan Status")
plt.tight_layout()
plt.savefig("viz_03_boxplots.png", dpi=150)
plt.close()

# Matrice de corrélation
# On sélectionne les colonnes numériques pour voir les relations entre elles
fig, ax = plt.subplots(figsize=(10, 7))
corr_cols: list[str] = [
    "person_age",
    "person_income",
    "person_emp_length",
    "loan_amnt",
    "loan_int_rate",
    "loan_percent_income",
    "cb_person_cred_hist_length",
]
corr_matrix: pd.DataFrame = df_pd[corr_cols].corr()
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", center=0, fmt=".2f", ax=ax)
ax.set_title("Correlation Matrix")
plt.tight_layout()
plt.savefig("viz_04_correlation.png", dpi=150)
plt.close()

# Null handling
# On fill les valeurs nulles de emp_length et loan_int_rate par la médiane car il y a une axymétrie dans la distribution
df = df.with_columns(
    pl.col("person_emp_length").fill_null(pl.col("person_emp_length").median())
)
df = df.with_columns(
    pl.col("loan_int_rate").fill_null(pl.col("loan_int_rate").median())
)


 # Analyse :

# histogramme1 = voir la répartition des variables numériques et la forme des distributions
# histogramme2 = voir le nombre de personnes par catégorie
# boxplot = voir la différence de revenu, age et taux entre les groupes
# heatmap = voir la corrélation entre les variables numériques

# Null values : emp_length et loan_int_rate avaient des valeurs nulles, on les remplace par la médiane
# 330 doublons supprimés

# Skewness : aucune variable est normalement distribuée (confirmé par Shapiro-Wilk)
# Les distributions sont asymétriques à droite, surtout person_age (skew=1.03)

# Il y a une forte corrélation entre loan_percent_income et loan_amnt ce qui montre que plus le montant du prêt est élevé, plus la part du prêt par rapport au revenu est grande
# Il y a une forte corrélation entre person_age et cb_person_cred_hist_length ce qui montre que plus une personne est âgée, plus son historique de crédit est long

# Le dataset est déséquilibré : 78% non-défaut vs 22% défaut
# Le modèle risque d'être biaisé vers la classe majoritaire, il faut compenser avec du SMOTE ou class_weight


