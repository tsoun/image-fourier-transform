function one_3_rgb()
    files = dir('*.png');           %φόρτωση όλων των εικόνων στο τρέχον ευρετήριο
    for i = 1:numel(files)
      figure();
      filename = files(i).name;
      ft = find_spectrum(filename);
      reconstruct(ft, 4, 2);
      reconstruct(ft, 8, 3);
    end
end
 
function ft = find_spectrum(im)
    image = imread(im);             %ανάγνωση της εικόνας (o image πίνακας 
                                    %είναι 3-Δ)
    show_image(image, "RGB image (original)", 1, false);
                                    %αντιστοίχηση των καναλιών στους 2-Δ
                                    %πίνακες R,G,B, στη συνέχεια λαμβάνεται
                                    %ο μετασχηματισμός Fourier σε κάθε
                                    %κανάλι (προφανώς 2-Δ FFT)
    R = image(:, :, 1);
    G = image(:, :, 2);
    B = image(:, :, 3);
    fourier_R = fftshift(fft2(R));
    fourier_G = fftshift(fft2(G));
    fourier_B = fftshift(fft2(B)); 
                                    %λογαριθμικός μετασχηματισμός για την
                                    %σωστή και ευκρινέστερη απεικόνιση των
                                    %φασμάτων του κάθε καναλιού
    log_transR = log(1 + abs(fourier_R));
    log_transG = log(1 + abs(fourier_G));
    log_transB = log(1 + abs(fourier_B));
    
    sgtitle("Lowpass filter applied to RGB image", "Color", "red", "FontSize", 20);
    
    show_image(log_transR, "Spectrum (R-channel)", 1, true);
    show_image(log_transG, "Spectrum (G-channel)", 2, true);
    show_image(log_transB, "Spectrum (B-channel)", 3, true);
                                    %η συνάρτηση επιστρέφει έναν 3-Δ πίνακα
                                    %με κάθε Δ να είναι το φάσμα κάθε
                                    %καναλιού RGB
    ft = cat(3, fourier_R, fourier_G, fourier_B);
  end
 

function reconstruct(ft, k, pos)    
                                    %λαμβάνω τα μήκη των πλευρών της
                                    %εικόνας (Ν: ύψος, Μ: πλάτος)
    N = size(ft(:,:,1), 1);
    M = size(ft(:,:,1), 2);
                                    %αρχικοποιώ έναν μηδενικό πίνακα 2-Δ
                                    %και στην συνέχεια γεμίζω ένα
                                    %συμμετρικό ως προς το κέντρο του
                                    %παραλληλόγραμμου (εικόνας) όμοιο
                                    %παραλληλόγραμμο, το οποίο εμπεριέχει
                                    %την αντίστοιχη χ ω ρ ι κ ά πληροφορία
                                    %με το πλήρες φάσμα του κάθε καναλιού
                                    %της αρχικής εικόνας
                                    
                                    %έτσι, ουσιαστικά εφαρμόζω ένα
                                    %χαμηλοπερατό φίλτρο στην εικόνα,
                                    %αποτέλεσμα της συνέλιξης του οποίου,
                                    %στην συχνότητα, είναι οι 2-Δ πίνακες
                                    %new_fR, new_fB, new_fG
                                    
                                    %η recon είναι ένας 3-Δ πίνακας, η τελική
                                    %εικόνα
    new_fR = zeros(N, M);
    new_fG = zeros(N, M);
    new_fB = zeros(N, M);
    new_fR(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),1);
    new_fG(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),2);
    new_fB(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k))) = ft(round(N/2 - N/(2*k)):round(N/2 + N/(2*k)), round(M/2 - M/(2*k)):round(M/2 + M/(2*k)),3);
    recon = abs(ifft2(cat(3, new_fR, new_fG, new_fB)));
   
    show_image(recon, "Reconstructed image after RGB (3-channel) N/" + k + " F.T.", pos, false);
   
end

function show_image(im, tl, r, isFourier)
                                    %η συνάρτηση αυτή εκτελεί τις
                                    %διαδικασίες εκτύπωσης των γραφημάτων
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