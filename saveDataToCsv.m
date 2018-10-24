function saveDataToCsv(src,evt, filename)
          hTask = src;
          data = evt.data;
          errorMessage = evt.errorMessage;
          outputFilename = filename;
          %dlmwrite(outputFilename, , 'newline',...
          %    'pc','-append');
          fid = fopen(outputFilename, 'at');
          fprintf (fid, char(datetime('now', 'Format', 'HH:mm:ss.SSS;')));
          fclose(fid);
          dlmwrite(outputFilename, data, 'newline', 'pc','-append');
end