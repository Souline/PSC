function ENTRE_bits = Gene_bits( N, p0 )
% generate N random bits

% - p0 is the probability of 0
data_ini = sign( rand( 1, N ) - p0 * ones( 1, N ) );
% we get -1/0/1

%change 0 to 1
for i = 1:N
  if data_ini(i) == 0
    data_ini(i) = 1;
  end
end

% change -1/1 to 0/1
ENTRE_bits = 0.5 * ( data_ini + 1 );
