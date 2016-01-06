function [C,D,f,Z,Gamma,Phi] = QPmatrices(N,H,alpha,G)
% C - constraint matrix on FM
% D - quadratic term in QP (actually it's 2D, this just outputs D)
% f - linear term in QP

[no,N]=size(H);
if(isempty(G))
    G = zeros(2^N-1,1);
end;

% Form the constraint matrix
nc = 2^N-1;
k = [0:N-2];
nr = sum(factorial(N)./(factorial(N-k-1).*factorial(k)));
C = zeros(nr,nc);

index = 1;
n = [0:N-1];
for i=1:N,
    A = combnk(n,i);
    ncom = size(A,1);
    B = cell2mat(cellfun(@(x)setdiff(n,x),num2cell(A,2),'UniformOutput',false));
    cA = sum(2.^A,2);
    for j=1:N-i,
        %[A B(:,j)]
        rc = sub2ind([nr nc],[index:index+ncom-1]',cA); C(rc)=1;
        rc = sub2ind([nr nc],[index:index+ncom-1]',sum(2.^[A B(:,j)],2)); C(rc)=-1;
        index = index + ncom;
    end;
end;

[SortVal, SortInd] = sort( H , 2, 'descend' );

%Append a 0 for the difference calculation below
SortVal = [SortVal zeros(no,1)];

% These are the A vectors (without all the zeros)
Hdiff = SortVal(:,1:end-1)-SortVal(:,2:end);

% Compute the index of the values to fill the D and f matrices
i = cumsum(2.^(SortInd-1),2);

D = zeros(nc,nc);
f = zeros(nc,1);
for j = 1:no,
    D(i(j,:),i(j,:)) = D(i(j,:),i(j,:)) + Hdiff(j,:)'*Hdiff(j,:);
    f(i(j,:)) = f(i(j,:)) -2*alpha(j)*Hdiff(j,:)';
end;

% Compute the Shapley values
factN = factorial(N);
Phi = zeros(1,N);
Gamma = zeros(N,nc);
Z = zeros(nc);
for i=1:N,
    Phi(i) = 1/N*G(2^(i-1));
    Gamma(i,2^(i-1)) = 1/N;
    for j=1:N-1,
        A = combnk(n([1:i-1,i+1:N]),j);
        A = [repmat(i-1,[size(A,1) 1]) A];
        lambda = factorial(N-j-1)*factorial(j)/factN;
        posI = sum(2.^A,2);
        negI = sum(2.^A(:,2:end),2);
        Phi(i) = Phi(i) + sum(lambda*(G(posI)-G(negI)));
        Gamma(i,posI)=lambda;
        Gamma(i,negI)=-lambda;
    end;
end;
Z = Gamma'*Gamma;
