function one_3_rgb()
    ft = find_spectrum("im-4.png");
    reconstruct(ft, 4);
    
    figure(2);
    ft = find_spectrum("im-4.png");
    reconstruct(ft, 8);
end
 
function ft = find_spectrum(im)
    image = imread(im);      
    show_image(image, "RGB image (original)", 1, false);

    R = image(:, :, 1);
    G = image(:, :, 2);
    B = image(:, :, 3);
    fourier_R = fftshift(fft2(R));
    fourier_G = fftshift(fft2(G));
    fourier_B = fftshift(fft2(B)); 
    
    log_transR = log(1 + abs(fourier_R));
    log_transG = log(1 + abs(fourier_G));
    log_transB = log(1 + abs(fourier_B));
    show_image(log_transR, "Spectrum (R-channel)", 1, true);
    show_image(log_transG, "Spectrum (G-channel)", 2, true);
    show_image(log_transB, "Spectrum (B-channel)", 3, true);
    
    ft = cat(3, fourier_R, fourier_G, fourier_B);
  end
 

function reconstruct(ft, k)    
    N = size(ft(:,:,1), 1);
    M = size(ft(:,:,1), 2);
    
    new_fR = zeros(N, M);
    new_fG = zeros(N, M);
    new_fB = zeros(N, M);
    new_fR(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),1);
    new_fG(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),2);
    new_fB(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),3);
    
    recon = abs(ifft2(cat(3, new_fR, new_fG, new_fB)));
   
    show_image(recon, "Reconstructed image after RGB (3-channel) N/" + k + " F.T.", 3, false);
end

function show_image(im, tl, r, isFourier)
    if isFourier == false
        subplot(2,3,r);
        imshow(uint8(im));
        title(tl);   
    else
        subplot(2,3,3+r);
        imagesc(im);
        colormap("jet");
        title(tl);   
        colorbar
    end
end