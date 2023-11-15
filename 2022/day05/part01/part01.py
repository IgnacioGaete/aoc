import sys

class Stack:
    def __init__(self):
        self.__data = []
    def __len__(self):
        return len(self.__data)
    def __str__(self):
        return str(self.__data)
    def push(self, item):
        self.__data.append(item)
    def pop(self):
        return self.__data.pop()
    def peak(self):
        return self.__data[-1]
    
def create_stacks(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        line = f.readline()
        data = Stack()
        while line != "\n":
            data.push(line)
            line = f.readline()
        raw_keys = data.pop()
        keys = []
        # " a  b"
        #["","a","","b"]
        for raw_key in raw_keys.split(" "):
            if len(raw_key) > 0 and raw_key != "\n":
                keys.append(raw_key)
        result = {}
        for key in keys:
            result[key] = Stack()
        while len(data) > 0:
            line = data.pop()
            for key in result.keys():
                item = line[raw_keys.index(key)]
                if item != " ":
                    result[key].push(item)
        return result

def get_secuence(stacks):
    secuence = ""
    for key in stacks.keys():
        secuence += stacks[key].peak()
    return secuence


def print_stacks(stacks):
    for key in stacks.keys():
        print(f"{key}: {stacks[key]}")

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    stacks = create_stacks(file_path)
    print("before:")
    print_stacks(stacks)
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f.readlines():
            line = line.strip()
            if line.startswith("move"):
                n = int(line.split(" ")[1])
                pop_key = line.split(" ")[3]
                push_key = line.split(" ")[5]
                while n > 0:
                    stacks[push_key].push(stacks[pop_key].pop())
                    n -= 1
    print("after:")
    print_stacks(stacks)
    secuence = get_secuence(stacks)
    print(f"secuence: {secuence}")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)