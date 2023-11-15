import sys

class File:
    def __init__(self, name, size):
        self.__name = name
        self.__size = size
    def get_name(self):
        return self.__name
    def get_size(self):
        return self.__size

class Directory:
    def __init__(self, name, files, dirs):
        self.__name = name
        self.__files = files
        self.__dirs = dirs
    def __str__(self):
        return f"dir{{ name:'{self.__name}', files:{self.__files}, dirs:{self.__dirs} }}"
    def __repr__(self):
        return str(self)
    def get_name(self):
        return self.__name
    def get_size(self):
        pass

class Command:
    def __init__(self, name, argv, output):
        self.__name = name
        self.__argv = argv
        self.__output = output
    def __str__(self):
        return f"{{name: {self.__name}, argv: {self.__argv}, output: {self.__output}}}"
    def __repr__(self):
        return str(self)
    def get_name(self):
        return self.__name
    def get_argv(self):
        return self.__argv
    def get_output(self):
        return self.__output
    def exec(self, fs):
        if self.__name == "cd":
            fs.cd(self.__argv[0])
        if self.__name == "ls":
            fs.ls(self.__output)
    @staticmethod
    def __is_command(line):
        return line.startswith("$")
    @staticmethod
    def get_command_list(file_path):
        command_list = []
        with open(file_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
            while len(lines) > 0:
                line = lines.pop(0).strip()
                if Command.__is_command(line):
                    splited = line.split(" ")[1:]
                    name = splited.pop(0)
                    argv = [splited.pop(0)] if name == "cd" else []
                    output = []
                    if name == "ls":
                        next_line = lines.pop(0).strip()
                        while not Command.__is_command(next_line):
                            output.append(next_line)
                            if len(lines) > 0:
                                next_line = lines.pop(0).strip()
                            else:
                                next_line = None
                                break
                        if next_line != None:
                            lines.insert(0, next_line)
                    command_list.append(Command(name, argv, output))
        return command_list

class FileSystem:
    def __init__(self):
        self.__files = []
        self.__dirs = []
        self.__dirs.append(Directory("/", [], []))
        self.__dirs.append(Directory("a", [], []))
        self.__dirs.append(Directory("d", [], []))
        self.__current_dir = None
    def cd(self, dir_name):
        print(f"before cd '{dir_name}': '{self.__current_dir}'")
        if dir_name == ".." and self.__current_dir != None and self.__current_dir != "/":
            splited = self.__current_dir.split("/")[:-1]
            self.__current_dir = "/".join(splited) if len(splited) > 2 else "/"
        if dir_name in [dir.get_name() for dir in self.__dirs]:
            if self.__current_dir == None:
                self.__current_dir = dir_name
            else:
                self.__current_dir += dir_name if self.__current_dir == "/" else f"/{dir_name}"
        print(f"after  cd '{dir_name}': '{self.__current_dir}'")
    def ls(self, output_list):
        for output in output_list:
            first, second = output.split(" ")
            if first == "dir":
                self.__dirs.append(Directory(second, [], []))
            else:
                self.__files.append(File(second, int(first)))
    def get_dir_list(self, max_size):
        self.__current_dir = None
        return FileSystem.__get_dir_list_recursive(self.__dirs, max_size, [])
    @staticmethod
    def __get_dir_list_recursive(dirs, max_size, current_list):
        for dir in self.__dirs

def main(argc, argv):
    if(argc < 2):
        print("[ERROR] Input file not provided")
        print(f"[INFO] Usage: {argv[0]} <input_file>")
        return
    file_path = argv[1]
    commands = Command.get_command_list(file_path)
    fs = FileSystem()
    for command in commands:
        command.exec(fs)
    dir_list = fs.get_dir_list(100000)
    #sum = 0
    #for dir in dir_list:
    #    sum += dir.get_size()
    #print(f"sum = {sum}")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)