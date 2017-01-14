function suite_bits = gene_bits( N, p0 )
% generate N random bits

% - p0 is the probability of 0
suite_ini = sign( rand( 1, N ) - p0 * ones( 1, N ) );
% we get -1/0/1

%change 0 to 1
for i = 1:N
  if suite_ini(i) == 0
    suite_ini(i) = 1;
  end
end

% change -1/1 to 0/1
suite_bits = 0.5 * ( suite_ini + 1 );
end

