function M =  morse_tree % The binary search tree for English letters
%   MORSE_TREE Returns a binary tree structure that represents Morse code 
%    for English letters (M).

% Each cell array has its char content and then two left and right children
% The cells in last level are end of the tree and have no child
% Some cells in the level 3 are the leaves as well and thus have no child
h = {'H' {} {}};
v = {'V' {} {}};
f = {'F' {} {}}; 
l = {'L' {} {}};
p = {'P' {} {}};
j = {'J' {} {}};
b = {'B' {} {}};  
x = {'X' {} {}};
c = {'C' {} {}};
y = {'Y' {} {}};
z = {'Z' {} {}};
q = {'Q' {} {}};

%level 3
s = {'S' h v};
u = {'U' f {}};
r = {'R' l {}};
w = {'W' p j};
d = {'D' b x};
k = {'K' c y};
g = {'G' z q};
o = {'O' {} {}};

%level 2
i = {'I' s u};
a = {'A' r w};
n = {'N' d k};
m = {'M' g o};

%level 1
e = {'E' i a};
t = {'T' n m};

%root contain no letter
M = {'  ' e t};

end