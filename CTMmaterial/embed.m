% takes as input Y, a matrix of APDCBT (8x8) coefficients, 
% the watermark (in a vectorial form), and the embedding strength ALPHA
% and returns a new matrix Y 
% with the watermark embedded into the 1024 highest coefficients

function [Y_new] = embed(Y, w, ALPHA)
    % Sort the coefficients in Yh and Yv, to insert the watermark in
    % both subbands for robustness 
    WAT_SIZE =  32;
    [dimx, dimy] = size(Y); %size is the same for both subbands
    Y_vec = reshape(Y, 1, dimx*dimy);
    Y_sgn = sign(Y_vec);
    Y_mod = abs(Y_vec);
    [Y_sort,Y_index] = sort(Y_mod,'descend');
    
    %Embedding
    Yw_mod = Y_mod;
    for j = 1: WAT_SIZE*WAT_SIZE
        m = Y_index(j);
        % multiplicative
        Yw_mod(m) = Y_mod(m)*(1+ALPHA*w(j));
        % additive
        %Yw_mod(m) = Y_mod(m)+ALPHA*w(j);
    end

    Y_new_vec = Yw_mod.*Y_sgn;
    Y_new = reshape(Y_new_vec,dimx,dimy);
end
