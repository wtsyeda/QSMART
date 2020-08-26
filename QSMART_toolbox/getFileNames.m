function file_names = getFileNames(dir_path)

file_names = dir(dir_path);
file_names=file_names(~ismember({file_names.name},{'.','..'}));
file_names={file_names.name};