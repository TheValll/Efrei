import multiprocessing
import time
import os

def transform(lines, output, process_number):
    """
    From lower to upper case and write the result in file
    """
    result = []
    for line in lines:
        # lower to upper conversion
        result.append(line.strip().upper())
    write_file(output + "_" + str(process_number), result)


def read_file(file_name):
    """
    Read file and returns lines
    :param nom_fichier:
    :return: lines as list
    """
    with open(file_name, "r", encoding="utf-8") as f:
        return f.readlines()


def write_file(file_name, content):
    """
    Write a file
    """
    with open(file_name, "w", encoding="utf-8") as f:
        for line in content:
            f.write(line + "\n")


def main():
    print("Start transforming a file\n")

    start_time = time.time()
    input_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/input.txt"
    output_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/process_no_sync/output.txt"
    # Number of processes to create
    nb_process = 4

    lines = read_file(input_file)

    # divide the lines in nb_process blocks
    size = len(lines)
    block_size = (size + nb_process - 1) // nb_process 
    blocs = [lines[i*block_size:(i+1)*block_size] for i in range(nb_process)]

    processes = []

    # Create and launch the processes
    for i, bloc in enumerate(blocs):
        if i < nb_process:
            # create and start processes
            p = multiprocessing.Process(
                target=transform,
                args=(bloc, output_file, i)
            )
            processes.append(p)
            p.start()

    # time spent to create a process
    process_creation_time = time.time() - start_time
    print(f"--Process creation time: {process_creation_time:.6f} seconds")

    # wait the end of all processes
    for p in processes:
        p.join()

    # compute execution time
    execution_time = time.time() - start_time

    print(f"--Execution time: {execution_time:.6f} seconds")
    print(f"--Core execution time: {execution_time - process_creation_time:.6f} seconds")


if __name__ == "__main__":
    main()
