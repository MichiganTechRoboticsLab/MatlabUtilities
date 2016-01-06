function [predicted_label, accuracy, decision_values] = ...
    defimklpredict(testing_label_vector, testing_instance_matrix, model)
%defimklpredict - Classifies test data using the DeFIMKL algorithm.
%
% Usage: model = defimklpredict(testing_label_vector,
% testing_instance_matrix, model)
%
% Inputs:
%    testing_label_vector ---- Binary class labels for testing data - {-1,1}.
%    testing_instance_matrix - Testing data matrix. Each row corresponds
%                              to a data point.
%    model ------------------- DeFIMKL model struct created with the
%                              defimkltrain function.
%
% Outputs:
%    predicted_label - Predicted binary class labels of the test data. Note
%                      these values are equivalent to sign( decision_values ).
%    accuracy -------- Classification accuracy.
%    decision_values - Resulting decision value after decision aggregation
%                      using the fuzzy Choquet integral.
%
% Example: 
%    model = defimklpredict( ytest, Xtest, model )
%
% Other m-files required: FMFI_ChoquetIntegralv2.m
% MEX-files required: svmtrain.mex (<a href="matlab: 
% web('https://www.csie.ntu.edu.tw/~cjlin/libsvm/')">LIBSVM</a>)
%
% For more information regarding the DeFIMKL algorithm, see <a href="matlab: 
% web('http://www.csl.mtu.edu/~ajpinar/papers/Pinar2015c.html')">this paper</a>.
%
% See also: defimkltrain, FMFI_ChoquetIntegralv2

% Author: Anthony Pinar
% Department of Electrical and Computer Engineering
% Michigan Technological University
% email address: ajpinar@mtu.edu
% Website: www.csl.mtu.edu/~ajpinar
% Github: https://github.com/MichiganTechRoboticsLab/MatlabUtils
% January 2016

ytest = testing_label_vector;
Xtest = testing_instance_matrix;
FM = model.FM;
svmmodel = model.svmmodels;

number_of_kernels = length( model );

for k = 1:number_of_kernels
    [~,~,dvtest(:,k)] = svmpredict(ytest,Xtest,svmmodel{k},'-q');
end

decision_values = FMFI_ChoquetIntegralv2( dvtest, FM' );
predicted_label = sign( decision_values );

accuracy = sum( predicted_label == testing_label_vector )...
    /length(testing_label_vector);

if(accuracy < 0.5)
    accuracy = 1 - accuracy;
end