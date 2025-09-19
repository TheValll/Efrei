"""
Le programme ci-dessous lit un fichier, transfome tous les mots en majuscule et écrit le résultat dans un fichier
en sortie.
Les mots dans le fichier en entrée sont séparés par une virgule et le fichier en sortie doit avoir le meme format
à la fin, le temps d'exécution de la fonction est affiché
"""
import time

def from_lower_case_to_upper_case(input_file, output_file):
    """
    Reads a file, make the words capital letters, and writes to a new file.
    """
    with open(input_file, "r", encoding="utf-8") as f_in, open(output_file, "w", encoding="utf-8") as f_out:

        for line in f_in:
            # TODO complétez la fonction
            upper_case_world = line.upper()
            f_out.write(",".join(upper_case_world) + "\n")


if __name__ == '__main__':
    print("Start transforming a file\n")

    start_time = time.time()
    input_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/input.txt"
    output_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/no_opti/output.txt"
    from_lower_case_to_upper_case(input_file, output_file)
    end_time = time.time()
    execution_time = end_time - start_time

    print("End of file transformation\n")
    print(f"Execution time: {execution_time:.6f} seconds")


