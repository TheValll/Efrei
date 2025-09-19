import threading
import time

def transform(lines, result, index):
    """
    Lower to upper case and store the result
    """
    result[index] = [line.upper() for line in lines]
    return result

def read_file(file_name):
    """
    read a file
    """
    with open(file_name, "r", encoding="utf-8") as f:
        return f.readlines()


def write_file(file_name, content):
    """
    Write file
    """
    with open(file_name, "w", encoding="utf-8") as f:
        f.writelines(content)


def main():
    print("--Start transforming a file")

    start_time = time.time()
    input_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/input.txt"
    output_file = "C:/Users/Valentin/Documents/Efrei/DataLakes-DataIntegration/tp/projets_cours copy/resources/thread_no_sync/output.txt"


    lines = read_file(input_file)
    nb_threads = 4

    threads = []
    results = [None] * nb_threads

    # divide the lines in nb_threads blocks
    size = len(lines)
    block_size = (size + nb_threads - 1) // nb_threads 
    blocs = [lines[i*block_size:(i+1)*block_size] for i in range(nb_threads)]

    # Create and start threads
    for i, bloc in enumerate(blocs):
        if i < nb_threads:
            # create and start processes
            p = threading.Thread(
                target=transform,
                args=(bloc, results, i)
            )
            threads.append(p)
            p.start()

    # Compute the thread creation time
    process_creation_time = time.time() - start_time
    print(f"--Threads creation time: {process_creation_time:.6f} seconds")

    # Wait the threads to finish
    for t in threads:
        t.join()

    # Merge results and write the output
    final_result = []
    for r in results:
        if r:
            final_result.extend(r)

    write_file(output_file, final_result)

    execution_time = time.time() - start_time

    print(f"--Execution time: {execution_time:.6f} seconds")
    print(f"--Core execution time: {execution_time - process_creation_time:.6f} seconds")

if __name__ == "__main__":
    main()
