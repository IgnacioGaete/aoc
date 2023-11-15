import sys

def find_repreated_item(line):
    first_half = line[:len(line)//2]
    second_half = line[len(line)//2:]
    for c in first_half:
        if c in second_half:
            return c
    return ""

def priority(c):
    if len(c) != 1:
        exit(1)
    offset = 1 - ord("a") if c.islower() else 27 - ord("A")
    return ord(c) + offset


def main():
    argv = sys.argv
    argc = len(argv)
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    sum  = 0
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f.readlines():
            c = find_repreated_item(line)
            p = priority(c)
            print(f"c = {c}, p = {p}")
            sum += p
    print(f"sum = {sum}")


if __name__ == "__main__":
    main()