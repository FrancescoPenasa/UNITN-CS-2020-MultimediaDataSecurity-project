function [contains, wpsnr_value] = detection_iquartz(original, watermarked, attacked) 
   
    ON_BLOCKS       = true;
    DWT_L2          = true;

    if ON_BLOCKS
        ALPHA   = 1;
    else
        ALPHA   = 1.7;
    end
    W_SIZE = 32;
    
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
        % Original , Level 1
        [cA, cH, cV, cD] = dwt2(I, 'Haar');
		if DWT_L2 	%level 2
			[cA2, cH2, cV2, cD2] = dwt2(cA, 'Haar');
		end
		
        % Watermarked
        [cAw, cHw, cVw, cDw] = dwt2(I_w, 'Haar');
		if DWT_L2 	%level 2
			[cA2w, cH2w, cV2w, cD2w] = dwt2(cAw, 'Haar');
		end
		
        % Perform Block-Based APDCBT on horizontal and vertical sub-bands
        % Original
		
        if DWT_L2 	% if l2 embedding, process H and V comp of level 2
			Yh = blkproc(cH2,[8 8],@apdcbt);
            Yv = blkproc(cV2,[8 8],@apdcbt);
        else 	% H and V comp of level 1
			Yh = blkproc(cH,[8 8],@apdcbt);
            Yv = blkproc(cV,[8 8],@apdcbt);
        end
		
        [dimx,dimy] = size(Yh);
		
        if DWT_L2 	% if l2 embedding, process H and V comp of level 2
			Yh_w = blkproc(cH2w,[8 8],@apdcbt);
            Yv_w = blkproc(cV2w,[8 8],@apdcbt);
        else 	% H and V comp of level 1
			Yh_w = blkproc(cHw,[8 8],@apdcbt);
            Yv_w = blkproc(cVw,[8 8],@apdcbt);
        end

		% Watermark was embedded in highest coefficients of both 
		% vertical and horizontal components, so compute 
		% the average between two extracted watermarks
        
		w1 = zeros(1, W_SIZE * W_SIZE);
		w2 = zeros(1, W_SIZE * W_SIZE);
	    
		% extract one watermark from horizontal component
		Yh_vec = reshape(Yh, 1, dimx*dimy);
		Yh_sgn = sign(Yh_vec);
		Yh_mod = abs(Yh_vec);
		[Yh_sort,Yh_index] = sort(Yh_mod,'descend');
		
		Yh_w_vec = reshape(Yh_w, 1, dimx*dimy);
		Yh_w_mod = abs(Yh_w_vec);
		
		for j = 1: W_SIZE*W_SIZE
		    m = Yh_index(j);
			% additive
		    w1(j) = (Yh_w_mod(m) - Yh_mod(m)) / ALPHA;
			% multiplicative 
			%w1(j) = round((Yh_w_mod(m) - Y_h_mod(m)) / (ALPHA*Y_h_mod(m));
			% if the watermarked inserted was -1/+1, fix: 
            %if w(j) < 0 
            %    w(j) = 0;
            %end
		end
		
        % extract identical watermark from vertical component
		Yv_vec = reshape(Yv, 1, dimx*dimy);
		Yv_sgn = sign(Yv_vec);
		Yv_mod = abs(Yv_vec);
		[Yv_sort,Yv_index] = sort(Yv_mod,'descend');
		
		Yv_w_vec = reshape(Yv_w, 1, dimx*dimy);
		Yv_w_mod = abs(Yv_w_vec);
		
		for j = 1:  W_SIZE*W_SIZE
		    m = Yv_index(j);
			% additive
		    w2(j) =(Yv_w_mod(m) - Yv_mod(m)) / ALPHA;
			% multiplicative 
			%w1(j) = round((Yh_w_mod(m) - Y_h_mod(m)) / (ALPHA*Y_h_mod(m));
			% if the watermarked inserted was -1/+1, fix: 
            %if w(j) < 0 
            %    w(j) = 0;
            %end
		end
		
		% Average the two watermarks
		w = zeros(1, W_SIZE*W_SIZE);
		for j = 1:  W_SIZE*W_SIZE
			val = (w1(j) + w2(j))/2;            
            if val > 0.5
                w(j) = 1;
            else
                w(j) = 0;
            end
        end
	    
        watermark = reshape(w, W_SIZE, W_SIZE);
        		
    end % extract_watermark

    % Load Images
    I       = imread(original);
    I_wat   = imread(watermarked);
    I_att   = imread(attacked);
    
    disp("Detecting watermark in: " + original);
    
    % Calculate the WPSNR between the Watermarked and the Attacked Image
    wpsnr_value = WPSNR(I_wat, I_att);
    
    if wpsnr_value < 35  % return 0
        
        contains = 0;  
        disp("Image is too ruined!");
    else % perform the computations
    
        % Extract Watermarks
        watermark          = extract_watermark(I, I_wat);
        watermark_attacked = extract_watermark(I, I_att);
        
        subplot(1,2,1);
        imshow(watermark);
        subplot(1,2,2);
        imshow(watermark_attacked);
        
        % Reshape Watermarks
        w_vec     = reshape(watermark, 1, W_SIZE*W_SIZE);
        w_att_vec = reshape(watermark_attacked, 1, W_SIZE*W_SIZE);

        % Calculate Similarity between the Original and the Attacked Watermarks
        SIM = w_vec * w_att_vec' / sqrt(w_att_vec * w_att_vec');
		
        %SIM = watermark * watermark_attacked' / sqrt (watermark_attacked * watermark_attacked');

        % Decide if our Watermark is contained in the Attacked image
        if SIM >= T
            contains = 1;
        else
            contains = 0;
        end

        % TODO: remove this, for testing purposes only
        if SIM >= T
            fprintf('Mark has been found. \nSIM = %f\n', SIM);
        else
            fprintf('Mark has been lost. \nSIM = %f\n', SIM);
        end
         % Calculate the WPSNR between the Watermarked and the Attacked Image
        wpsnr_value = WPSNR(I_wat, I_att);
        fprintf('WPSNR watermarked - attacked = +%5.2f dB\n', wpsnr_value);
        % Remove up to here
        
        if wpsnr_value < 35  % return 0
            contains = 0;  
        end
        
    end

end
