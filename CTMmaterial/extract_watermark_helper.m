% Extracts watermark from two images (original - watermarked, but also 
% original - attacked), by using DWT transform on first or second level
% and APDCBT tranform. There are two identical watermarks embedded
% in the image, in horizontal and vertical components. 
% The two watermarks are averaged.

% Returns a 32 x 32 watermark
function watermark = extract_watermark_helper(I, I_w, DWT_L2, W_SIZE,ALPHA)
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
			%w1(j) = round((Yh_w_mod(m) - Y_h_mod(m)) / (alpha*Y_h_mod(m));
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
			%w1(j) = round((Yh_w_mod(m) - Y_h_mod(m)) / (alpha*Y_h_mod(m));
			% if the watermarked inserted was -1/+1, fix: 
            %if w(j) < 0 
            %    w(j) = 0;
            %end
		end
		
		% Average the two watermarks
		w = zeros(1, W_SIZE*W_SIZE);
		for j = 1:  W_SIZE*W_SIZE
			w(j) = round((w1(j) + w2(j))/2);
        end
	    
        watermark = reshape(w, W_SIZE, W_SIZE);
        		
    end % extract_watermark