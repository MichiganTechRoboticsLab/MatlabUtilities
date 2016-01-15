function [ X, y ] = gimmedata( name, binary )
% gimmedata - Loads a dataset.
%
% Usage: [ X, y ] = gimmedata( name, binary )
%
% Inputs:
%    name --- A string defining which dataset to load. Valid choices:
%             { 'sonar','dermatology','wine','ionosphere','ecoli','glass' }
%             name defaults to 'sonar'.
%    binary - A number or logical indicating if the data classes should be
%             lumped together to form only two. Valid choices: {0,1}
%             binary defaults to 1.
%
% Outputs:
%    X - Data matrix of size [number_of_objects, number_of_features].
%    y - Class label vector of size [number_of_objects, 1].
%
% Example: 
%    [X, y] = gimmedata()
%    [X, y] = gimmedata('wine', 0)
%
%    Cite the UCI Dataset if data from the following set is used in a
%    publication:
%    { 'sonar','dermatology','wine','ionosphere','ecoli','glass','spectfheart',
%      'bupa','wdbc','haberman','pima','australian'}
%
%    UCI BIBTEX CITATION:
%    @misc{Lichman:2013 ,
%    author = "M. Lichman",
%    year = "2013",
%    title = "{UCI} Machine Learning Repository",
%    url = "http://archive.ics.uci.edu/ml",
%    institution = "University of California, Irvine, School of Information
%                   and Computer Sciences" } 
%
%    Cite the KEEL Dataset if data from the following set is used in a
%    publication:
%    { '' }
%
% Author: Anthony Pinar
% Department of Electrical and Computer Engineering
% Michigan Technological University
% email address: ajpinar@mtu.edu
% Github: https://github.com/MichiganTechRoboticsLab/MatlabUtils
% Website: www.csl.mtu.edu/~ajpinar
% January 2016

all_names = {'sonar','dermatology','wine','ionosphere','ecoli','glass',...
    'spectfheart','bupa','wdbc','haberman','pima','australian','saheart'};

% Set default dataset & binary = 1
if nargin < 1; name = 'sonar'; end;
if nargin < 2; binary = 1; end;

if ~ismember( name, all_names )
    error('Invalid dataset name.');
end

switch name
    case 'sonar'
        
        dataT = load(['sonar.mat']);
        data = dataT.sonar_alldata; clear dataT;
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==1) = -1;  y(y==2) = 1;

    case 'ionosphere'
        
        dataT = load(['ionosphere.mat']);
        data = dataT.ionosphere; clear dataT;
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==0) = -1;
        
    case 'dermatology'
        
        data = load(['dermatology.data']);
        X = data(:,1:(end-1));
        y = data(:,end);
        if binary
            y(y<4) = -1; y(y>3) = 1;
        end
        
    case 'ecoli'
        
        data = load(['ecoli.data']);
        X = data(:,1:(end-1));
        y = data(:,end);
        if binary
            y(y<5) = -1; y(y>4) = 1;
        end
        
    case 'wine'
        
        data = load(['wine.data']);
        X = data(:,1:(end-1));
        y = data(:,end);
        if binary
            y(y==1) = -1; y(y>1) = 1;
        end
        
    case 'glass'
        
        data = load(['glass.data']);
        X = data(:,1:(end-1));
        y = data(:,end);
        if binary
            y(y<4) = -1; y(y>3) = 1;
        end
        
    case 'spectfheart'
        
        data = load('spectfheart.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==0) = -1;
        
    case 'bupa'
        
        data = load('bupa.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==2) = -1;
        
    case 'wdbc'
        
        data = load('wdbc.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        
    case 'haberman'
        
        data = load('haberman.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        
    case 'pima'
        
        data = load('pima.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        
    case 'australian'
        
        data = load('australian.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==0) = -1;
        
    case 'saheart'
        
        data = load('saheart.data');
        X = data(:,1:(end-1));
        y = data(:,end);
        y(y==0) = -1;
        
end