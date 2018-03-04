clc;
clear all;
close all;

ticID=tic;

in=imread('C:\Users\HARITHA\Desktop\lena.jpg');
% in=rgb2gray(inp);
imshow(in);title('input plane image');
embe=imread('C:\Users\HARITHA\Desktop\binaryimage.jpg');
emb=rgb2gray(embe);
% [s,t]=size(emb);
emb=im2bw(emb(1:512,1:512));
figure,imshow(emb);title('data to be embedded')

a=1:255;

p=7;
q=37;
n=p*q;
lda=lcm(p-1,q-1);%% gcd(n,(p-1)*(q-1))=1

r=11;
g=16;

%% encryption of pailliers algorithm.
mm=[7001];
for i=1:255
m1=bigmod(g,a(i),n^2);
m2=bigmod(r,n,n^2);
m3=bigmod(m1*m2,1,n^2);
mm=[mm m3];
end

for i=1:size(in,1)
    for j=1:size(in,1)
        k=in(i,j);
        en1(i,j)=mm(k-1);
    end
end

%% data embedding
for i=1:512
    for j=1:512
        if emb(i,j)==1
            en1(i,j)=en1(i,j)+1;
        end
    end
end


%% decryption
mm1=mm;
for i=1:size(en1,1)
    for j=1:size(en1,1)
        for kk=1:256
            if abs(mm(kk)-en1(i,j))==0
                de(i,j)=kk-1;
                demb(i,j)=0;
            elseif abs(mm(kk)-en1(i,j))==1
                de(i,j)=kk;
                demb(i,j)=255;
            end
        end
    end
end

 
% dec=gray2ind(de);
% dembe=gray2ind(demb);
figure, imshow(uint8(de));title('recoverd plane image');
figure, imshow(demb);title('recovered plane image');
ts1=toc(ticID);


[n,m]=size(de); 
row=0;
col=0;
e=double(in)-double(de);
   e=e(row+1:n-row,col+1:m-col);
   me=mean(mean(e.^2));
   PSNR=(10*log10(255^2/me))*10;
   [m,n]=size(e);
  RMSE1=sqrt(sum(e(:).^2)/(m*n));
%   RMSE=RMSE1;

ts2=toc(ticID);

  