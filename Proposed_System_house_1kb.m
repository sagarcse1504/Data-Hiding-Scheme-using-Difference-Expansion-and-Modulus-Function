clc
A = imread('D:\Summer 2022\Multimedia Network\sagar proposed system\Pictures and Payload\Pictures\Baboon.tiff');
A = rgb2gray(A);
figure; image(A,'CDataMapping','scaled'); colormap('gray');
title('Input: Image in Grayscale');
TF = dlmread('D:\Summer 2022\Multimedia Network\sagar proposed system\Pictures and Payload\payload\random-binary_20Kb.txt');
b = cast(TF,'int8');
Sagar = reshape (A,1,[]);
SagarT = Sagar(1:length(Sagar)-1); 
Ap = reshape(SagarT,3,[]);
x = ones(1,87381);
y = ones(1,87381);
z = ones(1,87381);
xp = zeros(1,87381);
yp = zeros(1,87381);
zp = zeros(1,87381);
dp1 = zeros(1,length(TF));
dp2 = zeros(1,length(TF));
d1 = zeros(1,length(TF));
d2 = zeros(1,length(TF));
d = zeros(1,length(TF));
App = ones(3,87381);
TRT = ones(3,87381);
stegp = ones(3,87381);
EC = 0;
w = zeros(1,length(b));
counter=1;
for i=1:87381
    x(i) = Ap(1,i);
    y(i) = Ap(2,i);
    z(i) = Ap(3,i);
    d1(i)= y(i)- x(i);
    d2(i)= z(i)- y(i);
    
    if d1(i)>=-2 && d1(i)<= 2
       EC = EC+1;
       if d2(i)>=-2 && d2(i)<= 2
           EC = EC+1;
       end
    end          
    if d1(i)>=-2 && d1(i)<= 2 && counter < length(TF)+1
       dp1(counter)= d1(i)+ b(counter);
       xp(i)=Ap(1,i)+ dp1(counter);
       TRT(1,i)= 0;
       counter = counter +1;
    else
        xp(i)=Ap(1,i);
        TRT(1,i)= 1;
    end
       if d1(i)>=-2 && d1(i)<= 2 && counter < length(TF)+1
          dp1(counter)= d1(i)+ b(counter);
          zp(i)=Ap(3,i)+ dp1(counter);
          TRT(3,i)= 0;
          counter = counter +1;
       else
           zp(i)=Ap(3,i);
           TRT(3,i)= 1;
       end
     
       yp(i)= Ap(2,i);
       TRT(2,i)= 1;
end 
for j = 1:87381
     App(1,j)=xp(j);
     App(2,j)=yp(j);
     App(3,j)=zp(j);
end
Ba = reshape (App,1,[]);
Bb(:,1)= Sagar (length(Sagar));
Bc = [Ba Bb];
Ta = reshape (TRT,1,[]);
Tb(:,1)= 1;
Tc = [Ta Tb];
 B = reshape(Bc,512,512);
 TRTP = reshape(Tc,512,512);
 C = cast(B,'uint8');
 
% Displaying the stego
figure; image(B,'CDataMapping','scaled'); colormap('gray');
title('Output: Stego image');

%Calcultating the PSNR "thePSNR = psnr(testImage, referenceImage);"

thePSNR = psnr(C, A);
disp(thePSNR);
% calculating the BPP(Bit Per Pixel)

[r1,c1]=size(B);
bpp = EC/(r1*c1);
disp(bpp);

% Extracting the secret message

TRTB = reshape(TRTP,1,[]);
c = zeros(1,length(TF));
h=1;
    
for p= 1:26144
    if TRTB(1,p)== 0 && h <length(TF)+1 
       c(h)=TF(h);
       cp = cast(c,'int8');
       h = h+1;
    end
end
% Extracting the cover image
SH = reshape(B,1,[]);
TRTBS = reshape(TRTP,1,[]);
Tbs = TRTBS(1:length(TRTBS)-1); 
SagarhosT = SH(1:length(SH)-1); 
hossein = reshape(SagarhosT,3,[]);
Trace = reshape(Tbs,3,[]);
for p= 1:87381
    if TRTB(1,p)== 0 && h <p+1 
       stegp(1,p)= floor((hossein(1,p)-mod((hossein(1,p)-hossein(2,p)),2)));
       stegp(2,p)= hossein(2,p);
       stegp(3,p)= floor((hossein(3,p)-mod((hossein(3,p)-hossein(2,p)),2)));
       h = h+1;
    else
        stegp(1,p)= hossein(1,p);
        stegp(2,p)= hossein(2,p);
        stegp(3,p)= hossein(3,p);
    end
end
SagarHoss = reshape (stegp,1,[]);
Bb(:,1)= Sagar (length(Sagar));
covr = [SagarHoss Bb];
Original_cover = reshape(covr,512,512);
 
% Displaying the cover
figure; image(Original_cover,'CDataMapping','scaled'); colormap('gray');
title('Output:Original Cover image');