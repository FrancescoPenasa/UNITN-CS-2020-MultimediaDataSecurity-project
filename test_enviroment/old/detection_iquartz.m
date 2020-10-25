function [contains, wpsnr_value] = detection_iquartz(original, watermarked, attacked) 
    ON_BLOCKS       = true;
    SVD_INSERTION   = false;
    SHOW_IMAGES     = true;
    if ON_BLOCKS
        ALPHA   = 30;
    else
        ALPHA   = 1.7;
    end
    W_SIZE = 32;
    %chose DWT component
    %DWT_COMP   = 1; %Top Left, horizontal
    %DWT_COMP   = 2; %Bottom Right, vertical
    DWT_COMP    = 3; %Bottom Left, diagonal
    T = 13.3329;

    function [Y, V] = apdcbt(X)
        % Reference : Embedding Binary Image Watermark in DC Components of All
        % Phase Discrete Cosine Biorthogonal Transform
        % Author : Zabir Al Nazi
        % Email : zabiralnazi@codeassign.com

        [M, N, z] = size(X);
        if(z ~= 1)
            disp('Implemented for single channel image\n');
        end
        if(M ~= N)
            disp('X should be an N by N matrix\n');
        end

        X = double(X);
        Y = zeros(M,N);
        V = zeros(M,N);

        for m = 0:M-1
            for n = 0:N-1
                
                if (n == 0)
                    V(m+1,n+1) = (N-m)/(N^2);
                else
                    V(m+1,n+1) = ((N-m)*cos((m*n*pi)/N) - ...
                        csc((n*pi)/N)*sin((m*n*pi)/N))/(N^2);
                end
                
            end
        end

        Y = V*X*V'; % without optimization
    end % apdcbt

    function watermark = extract_watermark(I, I_w)
        I   = double(I);
        I_w = double(I_w);

        % Perform DWT
        % Original
        [cA, cH, cV, cD]     = dwt2(I, 'Haar');
        % Watermarked
        [cAw, cHw, cVw, cDw] = dwt2(I_w, 'Haar');

        % Perform Block-Based APDCBT on horizontal Sub-band
        % Original
        if DWT_COMP == 2
            Y = blkproc(cV,[8 8],@apdcbt);
        elseif DWT_COMP == 3
            Y = blkproc(cD,[8 8],@apdcbt);
        end
        [dimx,dimy] = size(Y);
        % Watermarked
        if DWT_COMP == 2
            Yw = blkproc(cVw,[8 8],@apdcbt);
        elseif DWT_COMP == 3
            Yw = blkproc(cDw,[8 8],@apdcbt);
        end
        [dimxw,dimyw] = size(Yw);

        % Obtain the DC coefficients matrix M (vector M_vec) ORIGINAL
        % Original
        blocks_x = dimx/8;
        blocks_y = dimy/8;
        M_vec = zeros(1, blocks_x*blocks_y); %32x32 in vector form 1x1024
        mi = 1; 
        if ON_BLOCKS
           for i=1:dimx
               for j=1:dimy
                   if (mod(i,8) == 1) && (mod(j,8) == 1) 
                       M_vec(mi) = Y(i,j);
                       mi = mi+1;
                   end
               end
           end
        end
        % Watermarked
        blocks_x = dimxw/8;
        blocks_y = dimyw/8;
        Mw_vec = zeros(1, blocks_x*blocks_y); %32x32 in vector form 1x1024
        mi = 1; 
        if ON_BLOCKS
           for i=1:dimxw
               for j=1:dimyw
                   if (mod(i,8) == 1) && (mod(j,8) == 1) 
                       Mw_vec(mi) = Yw(i,j);
                       mi = mi+1;
                   end
               end
           end
        end

        % Extract watermark
        w = zeros(1, W_SIZE*W_SIZE);
        for j = 1: W_SIZE*W_SIZE
           % Itw_mod(m) = It_mod(m) + (ALPHA*w_vec(j));
            w(j) = round((Mw_vec(j) - M_vec(j))/ALPHA);
            % The watermarked inserted was -1/+1
            if w(j) < 0 
                w(j) = 0;
            end
        end
        watermark = reshape(w, W_SIZE, W_SIZE);
    end % extract_watermark

    % Load Images
    I       = imread(original,'bmp');
    I_wat   = imread(watermarked,'bmp');
    I_att   = imread(attacked,'bmp');

    % Calculate the WPSNR between the Watermarked and the Attacked Image
    wpsnr_value = WPSNR(I_wat, I_att);
    
    if wpsnr_value < 35  % return 0
        
        contains = 0;  
        
    else % perform the computations
    
        % Extract Watermarks
        watermark          = extract_watermark(I, I_wat);
        watermark_attacked = extract_watermark(I, I_att);

        % Reshape Watermarks
        w_vec     = reshape(watermark, 1, W_SIZE*W_SIZE);
        w_att_vec = reshape(watermark_attacked, 1, W_SIZE*W_SIZE);

        % Calculate Similarity between the Original and the Attacked Watermarks
        SIM = w_vec * w_att_vec' / sqrt(w_att_vec * w_att_vec');

        % Decide if our Watermark is contained in the Attacked image
        if SIM >= T
            contains = 1;
        else
            contains = 0;
        end

        % TODO: remove this, for testing purposes only
        if SIM > T
            fprintf('Mark has been found. \nSIM = %f\n', SIM);
        else
            fprintf('Mark has been lost. \nSIM = %f\n', SIM);
        end
        fprintf('Watermarks WPSNR = +%5.2f dB\n', wpsnr_value);
        % Remove up to here
    end

end
