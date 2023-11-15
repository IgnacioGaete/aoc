import sys

def has_repeated_char(sub_str):
    for c in sub_str:
        if sub_str.count(c) > 1:
            return True
    return False

def find_message(line):
    if line == "": return 0, None
    index = 0
    mark = None
    while index < len(line):
        if index > 13 and not has_repeated_char(line[index - 14 : index]):
            mark = line[index - 14 : index]
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
            index, message = find_message(line)
            print(f"line: {line}")
            print(f"\tindex: {index}\tmessage: {message}")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)