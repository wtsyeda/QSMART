function sequence=getBrukerSequence(datapath)

acqpfile=fopen([datapath,'/acqp']);
acqp=fread(acqpfile,'*char')';
fclose(acqpfile);
clear acqpfile;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                   Get Sequence                         %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seq1=strfind(acqp,'##$PULPROG=(');
seq2=seq1+12;
tt=acqp(seq2);
while (tt~='<')
   seq2=seq2+1;
   tt=acqp(seq2);
end
seq1=seq2+1;
tt=acqp(seq2);
while (tt~='>')
   seq2=seq2+1;
   tt=acqp(seq2);
end
sequence=convertCharsToStrings(acqp(seq1:seq2-5));
clear tt seq1 seq2;


