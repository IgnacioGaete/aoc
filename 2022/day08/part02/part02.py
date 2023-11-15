import sys

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    tv = TopView(file_path)
    #print(tv)
    print(f"max scenic score: {tv.get_max_scenic_score()}")

class TopView:
    def __init__(self, file_path):
        self.__data = []
        with open(file_path, "r") as f:
            lines = f.readlines()
            self.__rows = len(lines)
            while len(lines) > 0:
                self.__data.append([int(char) for char in lines.pop(0).strip()])
            self.__cols = len(self.__data[0])
    def __repr__(self):
        return "\n".join([" ".join([str(data) for data in row]) for row in self.__data])
    def get_visible_count(self):
        count = 0
        for row in range(self.__rows):
            for col in range(self.__cols):
                count += 1 if self.is_visible(row, col) else 0
        return count
    def is_visible(self, row, col):
        if row not in range(self.__rows) or col not in range(self.__cols):
            print(f"[ERROR] in TopView.is_visible(row={row}, col={col}): Out of range: range=({self.__rows},{self.__cols})")
            exit(1)
        result = True
        blocks = 0
        for neighbors in [self.__get_neighbors(row, col, pos) for pos in ["top", "bottom", "left", "right"]]:
            if len(neighbors) == 0:
                break
            if self.__data[row][col] <= max(neighbors):
                blocks += 1
        result = blocks < 4
        #print(f"[INFO] in TopView.is_visible(row={row}, col={col}): {result}")
        return result
    def __get_neighbors(self, row, col, pos):
        result = []
        for r in range(self.__rows):
            for c in range(self.__cols):
                if r == row and c == col:
                    continue
                if r == row or c == col:
                    if pos == "top" and r < row:
                        result.insert(0, self.__data[r][c])
                    if pos == "bottom" and r > row:
                        result.append(self.__data[r][c])
                    if pos == "left" and c < col:
                        result.insert(0, self.__data[r][c])
                    if pos == "right" and c > col:
                        result.append(self.__data[r][c])
        #print(f"[INFO] in TopView.__get_neightbors(row={row}, col={col}, pos={pos}): neighbors={result}")
        return result
    def get_max_scenic_score(self):
        scenic_scores = []
        for row in range(self.__rows):
            scenic_scores.append([])
            for col in range(self.__cols):
                scenic_scores[row].append(1)
                for neighbor_type in ["top", "bottom", "left", "right"]:
                    neighbors = self.__get_neighbors(row, col, neighbor_type)
                    scenic_score = 0
                    for neighbor in neighbors:
                        scenic_score += 1
                        if self.__data[row][col] <= neighbor:
                            break
                    #print(f"[DEBUG] (row={row}, col={col}, neighbor_type='{neighbor_type}'): scenic_score={scenic_score}, neighbors={neighbors}")
                    scenic_scores[row][col] *= scenic_score
                #print(f"[DEBUG] final scenic score at ({row}, {col}): {scenic_scores[row][col]}")
        #print(f"[DEBUG] in TopView.get_max_scenic_score(): scenic_scores: {scenic_scores}")
        return max([max(row) for row in scenic_scores])

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)