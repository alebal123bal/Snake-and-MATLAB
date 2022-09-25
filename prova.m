fileID  = fopen("handshake.txt", "w");
fprintf(fileID, "Hello");
fclose(fileID);

disp(fileread("handshake.txt"))
disp(fileread("handshake.txt") == "Hello")