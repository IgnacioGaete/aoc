import sys

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    rope = Rope()
    actions = []
    with open(file_path, "r") as f:
        actions.extend([Action(line.strip()) for line in f.readlines()])
    rope.perform_actions(actions)
    print(f"positions count = {len(rope.get_tail_visited_positions())}")

class Rope:
    def __init__(self):
        self.__head = SmartPoint(0,0)
        self.__tail = SmartPoint(0,0)
    def perform_actions(self, actions):
        for action in actions:
            count = 0
            while count < action.get_count():
                count += 1
                old_head_pos = self.__head.copy()
                self.__head.add_and_record(action.get_dir_vector())
                if len(self.__head - self.__tail) > 2:
                    self.__tail.replace_and_record(old_head_pos)
    def get_tail_visited_positions(self):
        return self.__tail.get_visited_positions()

class SmartPoint:
    def __init__(self, x, y):
        self.__x = x
        self.__y = y
        self.__visited_positions = set([(x, y)])
    def copy(self):
        result = SmartPoint(self.get_x(), self.get_y())
        result.record_points(self.get_visited_positions())
        return result
    def __add__(self, other):
        return SmartPoint(self.get_x() + other.get_x(), self.get_y() + other.get_y())
    def __sub__(self, other):
        return SmartPoint(self.get_x() - other.get_x(), self.get_y() - other.get_y())
    def __len__(self):
        return self.get_x()**2 + self.get_y()**2
    def get_x(self):
        return self.__x
    def get_y(self):
        return self.__y
    def add_and_record(self, point):
        self.__x += point.get_x()
        self.__y += point.get_y()
        self.__visited_positions.add((self.get_x(), self.get_y()))
    def replace_and_record(self, point):
        self.__x = point.get_x()
        self.__y = point.get_y()
        self.__visited_positions.add((self.get_x(), self.get_y()))
    def get_visited_positions(self):
        return self.__visited_positions
    def record_points(self, point_set):
        self.__visited_positions |= point_set

class Action:
    def __init__(self, line):
        splited = line.split(" ")
        self.__direction = splited.pop(0)
        self.__count = int(splited.pop(0))
    def get_count(self):
        return self.__count
    def get_dir_vector(self):
        result = None
        if self.__direction == "R":
            result = SmartPoint(1, 0)
        elif self.__direction == "L":
            result = SmartPoint(-1, 0)
        elif self.__direction == "U":
            result = SmartPoint(0, 1)
        elif self.__direction == "D":
            result = SmartPoint(0, -1)
        return result

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)