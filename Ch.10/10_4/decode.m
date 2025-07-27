% Function for Decoding, first set the root and initialize node N to empty Array
function Output  = decode(Mc) 
%   DECODE takes a Morse code string and decodes it into its corresponding 
%    English text. It uses a binary tree (Morse Tree) to navigate through 
%    the Morse code and find the matching letter for each dot (.) and dash (-).
%   Returns output :A decoded English message based on the Morse code
%   input.
%   
  M = morse_tree;
  N = [];
  % For each character of string detect which child to proceede. If it be
  % Dot, left child and if dash, right child. Space show that we have found
  % the node and append it to N, and dash just add dash for each word.
  for k = 1:length(Mc)
      if Mc(k) == '.'
          M = M{2};
      elseif Mc(k) == '-'
          M = M{3};
      elseif Mc(k) == ' ' && (Mc(k-1) ~= '/' && Mc(k-1) ~= '*')
          N =[N M{1}];
          M = morse_tree;
          continue;
      elseif Mc(k) == '/'
          N = [N ' '];
          M = morse_tree;
          continue;
      end
      % If the code is not given quiet right, decode it to the nearest
      % Letter
      if isempty(M)
          continue;
      end
  end
  % Retrun the founded node N
  N = [N M{1}];
  Output = N;
            
end
