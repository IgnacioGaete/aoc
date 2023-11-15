import sys

def main(argv):
    program_name = argv.pop(0)
    if len(argv) != 1:
        print(f"[ERROR] Usage: {program_name} <input file>")
        exit(1)
    file_path = argv.pop(0)
    sh = Shell(file_path)
    sh.ls_all()
    max_size = 100_000
    result = sh.find("d", "/", lambda x: x.get_size() < max_size)
    print(f"sum = {sum([dir.get_size() for dir in result])}")

class Shell:
    def __init__(self, file_path):
        self.__tab = "  "
        self.__current_dir = ""
        self.__root = Directory("/", [], [])
        cmds = Shell.__get_cmds(file_path)
        for cmd in cmds:
            if cmd.get_name() == "cd":
                self.cd(cmd.get_argv()[0])
            if cmd.get_name() == "ls":
                lines = cmd.get_output().copy()
                while len(lines) > 0:
                    splited = lines.pop(0).split(" ")
                    if splited[0] == "dir":
                        self.mkdir(splited[1])
                    else:
                        self.mkfile(splited[1], int(splited[0]))

    def cd(self, dir_name):
        new_cd = None
        if dir_name == "..":
            if self.__current_dir == "/":
                print(f"[ERROR] in Shell.cd(dir_name='{dir_name}'): Can't go back from root dir")
                exit(1)
            new_cd = "/".join(self.__current_dir.split("/")[:-1])
            if new_cd == "":
                new_cd = "/"
        else:
            if dir_name == "/":
                new_cd = "/"
            else:
                if dir_name not in [dir.get_name() for dir in self.__get_cd().get_dirs()]:
                    print(f"[ERROR] in Shell.cd(dir_name='{dir_name}'): Directory not found")
                    print(f"        dirs: {self.__get_cd().get_dirs()}")
                    exit(1)
                if self.__current_dir == "/":
                    new_cd = self.__current_dir + dir_name
                else:
                    new_cd = self.__current_dir + "/" + dir_name
        print(f"[INFO] in Shell.cd(dir_name={dir_name}): '{self.__current_dir}' (old) -> '{new_cd}' (new)")
        self.__current_dir = new_cd


    def mkdir(self, dir_name):
        self.__get_cd().mkdir(dir_name)

    def mkfile(self, name, size):
        self.__get_cd().mkfile(name, size)

    def find(self, search_type, path, predicate):
        result = []
        old_cd = self.__current_dir
        self.cd(path)
        print(f"[INFO] find starts <-----------------")
        if search_type == "d":
            if predicate(self.__get_cd()):
                result.append(self.__get_cd())
            for dir in self.__get_cd().get_dirs():
                result.extend(self.__find_recursive(search_type, dir, predicate))
        self.__current_dir = old_cd
        print(f"[INFO] find ends   <-----------------")
        print(f"[INFO] results: {result}")
        return result

    def ls_all(self):
        print(f"- {self.__root.get_name()} (dir, size={self.__root.get_size()})")
        for dir in self.__root.get_dirs():
            self.__ls_all_recursive(dir, 1)
        for file in self.__root.get_files():
            print(f"{self.__tab}- {file.get_name()} (file, size={file.get_size()})")

    def __get_cd(self):
        if self.__current_dir == "":
            return Directory("", [], [self.__root])
        if self.__current_dir == "/":
            return self.__root
        splited_cd_fullpath = self.__current_dir[1:].split("/")
        next_dir = self.__root
        while len(splited_cd_fullpath) > 0:
            next_dir_name = splited_cd_fullpath.pop(0)
            dir_found = False
            for dir in next_dir.get_dirs():
                if next_dir_name == dir.get_name():
                    dir_found = True
                    next_dir = dir
                    break
            if not dir_found:
                print(f"[ERROR] in Shell.__get_cd(): Couldn't find dir")
                print(f"        looking for: '{next_dir_name}'")
                print(f"        in: {[dir.get_name() for dir in next_dir.get_dirs()]}")
                print(f"        current dir: {self.__current_dir}")
                exit(1)
        return next_dir

    def __ls_all_recursive(self, dir, level):
        print(level * self.__tab + f"- {dir.get_name()} (dir, size={dir.get_size()})")
        for sub_dir in dir.get_dirs():
            Shell.__ls_all_recursive(self, sub_dir, level + 1)
        for file in dir.get_files():
            print((level + 1) * self.__tab + f"- {file.get_name()} (file, size={file.get_size()})")
        
    def __find_recursive(self, search_type, dir, predicate):
        result = []
        if search_type == "d":
            if predicate(dir):
                result.append(dir)
            for sub_dir in dir.get_dirs():
                result.extend(self.__find_recursive(search_type, sub_dir, predicate))
        return result

    @staticmethod
    def __get_cmds(file_path):
        result = []
        with open(file_path, "r") as f:
            lines = f.readlines()
            while len(lines) > 0:
                line_splited = lines.pop(0).strip().split(" ")
                first_symbol = line_splited.pop(0)
                if first_symbol == "$":
                    cmd_name = line_splited.pop(0)
                    cmd_argv = line_splited
                    cmd_output = []
                    if cmd_name == "ls":
                        next_line = lines.pop(0)
                        while not next_line.startswith("$"):
                            cmd_output.append(next_line.strip())
                            if len(lines) == 0:
                                break
                            next_line = lines.pop(0)
                        if len(lines) > 0:
                            lines.insert(0, next_line)
                    result.append(Command(cmd_name, cmd_argv, cmd_output))
        return result
    

class Command:
    def __init__(self, name, argv, output):
        self.__name = name
        self.__argv = argv
        self.__output = output
    def get_name(self):
        return self.__name
    def get_argv(self):
        return self.__argv
    def get_output(self):
        return self.__output

class Directory:
    def __init__(self, name, files, dirs):
        self.__name = name
        self.__files = files
        self.__dirs = dirs
    def __str__(self):
        return f"'{self.__name}' (dir, size={self.get_size()})"
    def __repr__(self):
        return str(self)
    def mkdir(self, name):
        self.__dirs.append(Directory(name, [], []))
    def mkfile(self, name, size):
        self.__files.append(File(name, size))
    def get_dirs(self):
        return self.__dirs
    def get_files(self):
        return self.__files
    def get_name(self):
        return self.__name
    def get_size(self):
        size = sum([file.get_size() for file in self.__files])
        for sub_dir in self.__dirs:
            size += sub_dir.get_size()
        return size

class File:
    def __init__(self, name, size):
        self.__name = name
        self.__size = size
    def get_name(self):
        return self.__name
    def get_size(self):
        return self.__size

if __name__ == "__main__":
    main(sys.argv)