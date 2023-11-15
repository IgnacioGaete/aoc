import sys

def get_range_pair(line):
    l = line.split(",")[0]
    r = line.split(",")[1]
    return ((int(l.split("-")[0]), int(l.split("-")[1])), (int(r.split("-")[0]), int(r.split("-")[1])))

def is_overlaped(range_pair):
    l = range_pair[0]
    r = range_pair[1]
    return r[0] <= l[1] and r[1] >= l[0]

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    with open(file_path, "r", encoding="utf-8") as f:
        count = 0
        for line in f.readlines():
            line = line.rstrip()
            range_pair = get_range_pair(line)
            if is_overlaped(range_pair):
                count += 1
                print(f"pair found: {range_pair}")
        print(f"count = {count}")


if __name__ == "__main__":
    main(len(sys.argv), sys.argv)