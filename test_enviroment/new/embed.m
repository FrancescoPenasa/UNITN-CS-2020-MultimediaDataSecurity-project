% takes as input Y, a matrix of APDCBT (8x8) coefficients, 
% and the watermark in a vectorial form, and returns a new matrix Y with the 
% watermark embedded into the 1024 highest coefficients

function [Y_new] = embed(Y, w, alpha)
    % Sort the coefficients in Yh and Yv, to insert the watermark in
    % both subbands for robustness 
    [dimx, dimy] = size(Y); %size is the same for both subbands
    Y_vec = reshape(Y, 1, dimx*dimy);
    Y_sgn = sign(Y_vec);
    Y_mod = abs(Y_vec);
    [Y_sort,Y_index] = sort(Y_mod,'descend');
    WAT_SIZE =  32;
    
    %Embedding
    Yw_mod = Y_mod;

    for j = 1: WAT_SIZE*WAT_SIZE
        m = Y_index(j);
        Yw_mod(m) = Y_mod(m)*(1+alpha*w(j));
        %Yw_mod(m) = Y_mod(m)+alpha*w(j);
    end

    Y_new_vec = Yw_mod.*Y_sgn;
    Y_new = reshape(Y_new_vec,dimx,dimy);
end
