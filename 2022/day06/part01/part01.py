import sys

def has_repeated_char(sub_str):
    for c in sub_str:
        if sub_str.count(c) > 1:
            return True
    return False

def find_mark(line):
    if line == "": return 0, None
    index = 0
    mark = None
    while index < len(line):
        if index > 3 and not has_repeated_char(line[index - 4 : index]):
            mark = line[index - 4 : index]
            break
        index += 1
    index %= len(line)
    return index, mark


def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f.readlines():
            line = line.strip()
            index, mark = find_mark(line)
            print(f"line: {line}")
            print(f"\tindex: {index}\tmark: {mark}")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)