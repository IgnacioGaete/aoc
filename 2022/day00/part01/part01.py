import sys

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f.readlines():
            line = line.rstrip()
            print(line)

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)