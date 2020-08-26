function [folder_names,nFolders] = getFolderNames(dir_path)

folder_names = dir(dir_path);
folder_names(~[folder_names.isdir]) = [];
folder_names=folder_names(~ismember({folder_names.name},{'.','..'}));
folder_names={folder_names.name};
nFolders=length(folder_names);