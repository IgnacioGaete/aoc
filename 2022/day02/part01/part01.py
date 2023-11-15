import sys

play_scores = {"X":1, "Y":2, "Z":3}
win_scores = {"A":{"X":3, "Y":6, "Z":0},
              "B":{"X":0, "Y":3, "Z":6},
              "C":{"X":6, "Y":0, "Z":3}}

def play_score(splited):
    return play_scores[splited[1]]
def win_score(splited):
    return win_scores[splited[0]][splited[1]]

def main():
    argv = sys.argv
    argc = len(argv)
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    score = 0
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f.readlines():
            splited = line[:-1].split(" ") if line.endswith("\n") else line.split(" ")
            score += play_score(splited) + win_score(splited)
    print(f"Final score: {score}")

if __name__ == "__main__":
    main()