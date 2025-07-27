% Function for Encoding
function char4 = encode(char2)
%   ENCODE takes an English text input and converts it into Morse code. 
%    It traverses a binary tree structure (MORSE Tree) to encode each 
%    letter or space in the input string into its corresponding Morse code.
%   Returns char4: A string representing the encoded Morse code 
%    corresponding to the input characters.
%
% char4 is initialized to include the morse code encoded
  char4 = [];
  % For all the letters in the input string char2, flag k is set to zero
  % which shows that letters hasn't found yet. S and D are two stacks to
  % Save the history of path(D) and nodes(S)
  for i = 1:length(char2)
      k = 0;
      S = {morse_tree};
      D = {' '};
      % If we reach to the end of the tree we stop.
     while ~isempty(S)
      % Get top of the S and D and delete them from their stacks
      N = S{1};
      Mcode = D{1};
      S = S(2:end);
      D = D(2:end);
      % If node N is found, set the flag to 1. If there is space code it to
      % Slash and countinue.
      if ~isempty(N)
          if N{1} == char2(i)
              k = 1;
             if char2(i) == ' '
                 char4 = [char4 ' /'];
                 continue;
             end
               char4 = [char4 Mcode];
               % Return to the root of the tree for the coding the next
               % Letter
               S = {};
               N = {};
          else
              % If nodes is not found, check the children of current node
              % And update both S and D stacks
             S = { N{2} N{3} S{:}}; %DFS
             D = { [Mcode '.'] [Mcode '-'] D{:}}; 
          end
      end
     end
     % If letter is not in the tree, put "*" instead
       if k == 0
        char4 = [char4 ' *'];
        continue;
      end
  end
  % First element was root and we don't need its content
  char4(1) = [];
  return;
end