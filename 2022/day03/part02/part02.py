import sys

def find_common_char(group):
    first_rucksack = group[0]
    for item in first_rucksack:
        if item in group[1] and item in group[2]:
            return item
    print(f"[WARN] in find_common_char(group) could\'n find the item: group = {group}")
    return ""


def priority(c):
    if len(c) != 1:
        print(f"[WARN] in priority(c), len(c) = {len(c)}")
        return 0
    offset = 1 - ord("a") if c.islower() else 27 - ord("A")
    return ord(c) + offset

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    with open(file_path, "r", encoding="utf-8") as f:
        group = []
        sum = 0
        for line in f.readlines():
            line = line.rstrip()
            group.append(line)
            if len(group) == 3:
                c = find_common_char(group)
                p = priority(c)
                sum += p
                group.clear()
        print(f"sum = {sum}")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)