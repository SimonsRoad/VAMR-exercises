%% color print
clc
for i = -10:100
    try
        fprintf(num2str(i));
        fprintf(i,'Hello \n');
    catch
        disp(['i=',num2str(i),'does not work']);
    end
end

%%
clc
fprintf('This is a ') ; cprintf('_blue', 'colorful ') ; fprintf('example!\n') ;
%%
fprintf('_red','Hello\n')

%%
clc
fprintf('This is [\borange]\b \n')
fprintf('This is [\gorange]\g \n')

%% URL
url = 'http://www.mathworks.com';
sitename = 'The MathWorks Web Site';





