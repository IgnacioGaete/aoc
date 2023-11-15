import sys

def main():
    argv = sys.argv
    argc = len(argv)
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    calories = []
    with open(file_path, "r", encoding="utf-8") as f:
        c = 0
        for line in f.readlines():
            if line == "\n": calories.append(c)
            c = 0 if line == "\n" else c + int(line)
        calories.append(c)
    print(calories)
    print(max(calories))

if __name__ == "__main__":
    main()