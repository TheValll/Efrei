import multiprocessing
import time
import os
from multiprocessing import Process, Queue


def transform(lines, queue):
    """
    From lower to upper case and send the result in the queue
    """
    result = []
    for line in lines:
        words = line.strip().split(",")
        mots_majuscules = [word.strip().upper() for word in words]
        result.append(",".join(mots_majuscules))
    # Send result in the queue
    queue.put(result)


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
    print("--Start transforming a file")

    start_time = start_time = time.time()
    input_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/input.txt"
    output_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/process_sync/output.txt"
    # Number of processes to create
    nb_process = 4

    lines = read_file(input_file)

    # divide the lines in nb_process blocks
    size = len(lines)
    block_size = (size + nb_process - 1) // nb_process 
    blocs = [lines[i*block_size:(i+1)*block_size] for i in range(nb_process)]

    # Create a queue/pipe for synch
    queue = Queue()
    processes = []

    # Create and launch the processes
    for i, bloc in enumerate(blocs):
        if i < nb_process:
            # create and start processes
            p = multiprocessing.Process(
                target=transform,
                args=(bloc, queue)
            )
            processes.append(p)
            p.start()

    # process creation time
    process_creation_time = time.time() - start_time
    print(f"--Process creation time: {process_creation_time:.6f} seconds")

    # Retrieve results from the queue (one per process)
    final_results = []
    for _ in range(len(processes)):
        result = queue.get()
        final_results.extend(result)

    # wait the end of processes
    for p in processes:
        p.join()

    # Write the result in a file
    write_file(output_file, final_results)

    # COmpute the execution time
    execution_time = time.time() - start_time

    print(f"--Execution time: {execution_time:.6f} seconds")
    print(f"--Core execution time: {execution_time - process_creation_time:.6f} seconds")



if __name__ == "__main__":
    main()
