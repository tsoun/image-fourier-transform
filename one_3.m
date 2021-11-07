function one_3()
    ft = find_spectrum("bogdanos.jpg");
    reconstruct(ft, 4, 8);
end
 
function fourier_image = find_spectrum(im)
    image = imread(im);
    image = rgb2gray(image);
      
    show_image(image, "Grayscale image", 1, false);
    fourier_image = fftshift(fft2(image)); 
    
    log_trans = log(1 + abs(fourier_image));
    show_image(log_trans, "Spectrum", 1, true);

end
 

function reconstruct(ft, k, j)
    N = size(ft, 1);
    M = size(ft, 2);
    
    new_fm = zeros(N, M);
    new_fm(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)): round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)));
    show_image(log(1 + abs(new_fm)), "Logarithmic (N/" + k + ") transform of the image", 2, true); 
    
    new_fm2 = zeros(N, M);
    new_fm2(round(N/2 - N/(2*j)):round(N/2 + N/(2*j)), round(M/2 - M/(2*j)): round(M/2 + M/(2*j))) = ft(round(N/2 - N/(2*j)):round(N/2 + N/(2*j)), round(M/2 - M/(2*j)):round(M/2 + M/(2*j)));
    show_image(log(1 + abs(new_fm2)), "Logarithmic (N/" + j + ") transform of the image", 3, true); 
    
    recon = abs(ifft2(new_fm));
    recon2 = abs(ifft2(new_fm2));
    
    show_image(recon, "Reconstructed image after the N/" + k + " FT", 2, false);
    show_image(recon2, "Reconstructed image after the N/" + j + " FT", 3, false);
end

function show_image(im, tl, r, isFourier)
    if isFourier == false
        subplot(2,3,r);
        imshow(im, []);
        title(tl);   
    else
        subplot(2,3,3+r);
        imshow(im, []);
        title(tl);   
        colorbar
    end
end