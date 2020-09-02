function file_name = searchFile(dir_path,fstring)

file_name = dir(fullfile(dir_path,fstring));
file_name=sprintf('%s/%s',file_name.folder,file_name.name);