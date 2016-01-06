function model = defimkltrain( training_label_vector,...
    training_instance_matrix, rbf_kernel_gamma_vector, norm_type, lambda)
%defimkltrain - Forms a model to use for DeFIMKL classification.
%
% Usage: model = defimkltrain(training_label_vector,
% training_instance_matrix, rbf_kernel_gamma_vector, norm_type, lambda)
%
% Inputs:
%    training_label_vector ---- Binary class labels for training data -
%                               {-1,1}.
%    training_instance_matrix - Training data matrix. Each row corresponds
%                               to a data point.
%    rbf_kernel_gamma_vector -- Vector of gammas to use in the RBF kernels,
%                               where gamma is used as exp(-gamma*|u-v|^2).
%    norm_type ---------------- Type of norm to use for regularization - 
%                               {[], 1, 2}. (default is [], or no 
%                               regularization).
%    lambda ------------------- Regularization parameter.
%
% Outputs:
%    model -------------------- DeFIMKL model struct to use with
%                               the defimklpredict function.
%
% Example: 
%    model = defimkltrain( y, X, [0.001 0.05 0.1] )
%    model = defimkltrain( y, X, [0.001 0.05 0.07 0.1], 1, 3.2)
%    model = defimkltrain( y, X, [0.001 0.05 0.1 2.9], 2, 2.7 )
%
% Other m-files required: QPmatrices.m
% MEX-files required: svmtrain.mex (<a href="matlab: 
% web('https://www.csie.ntu.edu.tw/~cjlin/libsvm/')">LIBSVM</a>)
%
% For more information regarding the DeFIMKL algorithm, see <a href="matlab: 
% web('http://www.csl.mtu.edu/~ajpinar/papers/Pinar2015c.html')">this paper</a>.
%
% See also: defimklpredict, QPmatrices

% Author: Anthony Pinar
% Department of Electrical and Computer Engineering
% Michigan Technological University
% email address: ajpinar@mtu.edu
% Github: https://github.com/MichiganTechRoboticsLab/MatlabUtils
% Website: www.csl.mtu.edu/~ajpinar
% January 2016
    
if nargin < 4
    norm_type = [];
end

if isempty( norm_type )
    norm_type = 1;
    lambda = 0;
end

y = training_label_vector;
X = training_instance_matrix;

number_of_kernels = length( rbf_kernel_gamma_vector );

N = number_of_kernels * (2 ^( number_of_kernels-1 )- 1); % # of constraints
g = 2^(number_of_kernels)-1; % measure length {g_1,g_2,...,g_12,...g_12..K}

% Get decision values from LIBSVM for each kernel
for k = 1 : number_of_kernels,
    svmmodel{k} = svmtrain(y,X,['-t 2 -g ',num2str(rbf_kernel_gamma_vector(k)),'-q']);
    [~,~,dvtrain(:,k)] = svmpredict(y,X,svmmodel{k},'-q');
end

dvtrain = dvtrain./sqrt(1+dvtrain.^2);

[C,D,f,~,~]=QPmatrices(number_of_kernels,dvtrain,y,[]);

options = optimset('Display','off');

if norm_type == 1
    FM = quadprog(2*D,f+lambda,C,zeros(size(C,1),1),[],[],[zeros(g-1,1); 1],ones(g,1),0*ones(g,1),options);
elseif norm_type == 2
    FM = quadprog((2*D+lambda*eye(g)),f,C,zeros(size(C,1),1),[],[],[zeros(g-1,1); 1],ones(g,1),[],options);
else
    error('Invalid norm type');
end

model.FM = FM;
model.svmmodels = svmmodel;