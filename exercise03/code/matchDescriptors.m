function matches = matchDescriptors(...
    query_descriptors, database_descriptors, lambda)
% Returns a 1xQ matrix where the i-th coefficient is the index of the
% database descriptor which matches to the i-th query descriptor.
% The descriptor vectors are MxQ and MxD where M is the descriptor
% dimension and Q and D the amount of query and database descriptors
% respectively. matches(i) will be zero if there is no database descriptor
% with an SSD < lambda * min(SSD). No two non-zero elements of matches will
% be equal.

%% calculations
% query_descriptors = current descriptors
% database_descriptors = past desctiptors

% bridge
try
    % lauched inside matchDescriptors
    lambda = match_lambda; 
    query_descriptors = descriptors_2;
    database_descriptors = descriptors;
    num = 1;
catch
    % launched from main   
    num = size(query_descriptors,2);
end

% init
Q = size(query_descriptors,2);
matches = zeros(1,Q);

% calculate distance
D = pdist2(query_descriptors',database_descriptors');
delta = min(min(D))*lambda;

for i = 1:num
   D_i = D(i,:);
   [dist, idx] = min(D_i);
   
   if dist < delta
       matches(i) = idx; 
   end
    
end


end