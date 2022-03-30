%读取图像 变成灰度图，进行边缘检测
%边缘检测不能使用canny算子，canny算子检测出的二值图像噪音过多
I = imread('test.jpg');
I=rgb2gray(I);
Ie=edge(I,'prewitt');
imshow(Ie);

%设置极坐标极角范围和极径范围
[H,W]=size(Ie);
N=90;
thetaArray=-N:N-1;
rho_max=floor(sqrt(H^2 + W^2)) - 1;
rhoArray=-rho_max:rho_max;

%创建一个累加器 （全0）
hgh=zeros(length(rhoArray),length(thetaArray));

%遍历所有点进行投票
for y=1:H    
    for x=1:W       
        if(Ie(y,x)==1)
            for t=thetaArray
                %%x.cos()+y.sin()=p                
                rho=round(x*cosd(t)+y*sind(t));
                r_index=rho+rho_max+1;
                t_index=t+N+1;                
                hgh(r_index,t_index)=hgh(r_index,t_index)+1;                            
            end
        end
    end
end

%hough变换结果显示
imshow(hgh,[],'XData',thetaArray,'YData',rhoArray,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

%此为改版之后的采用matlab自带的peaks函数。
P  = houghpeaks(hgh,15,'threshold',ceil(0.3*max(hgh(:))));
x = thetaArray(P(:,2)); y = rhoArray(P(:,1));
plot(x,y,'s','color','white');
% Find lines and plot them
lines = houghlines(Ie,thetaArray,rhoArray,P,'FillGap',5,'MinLength',7);
figure, imshow(I),hold on

max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
%改版前绘制直线
%{
%寻找最大值
nOP=5; %-- 最大值数量
peakIndexList=zeros(nOP,2);
peakNumberList=zeros(nOP,1);
for i=1:nOP    
    maximum = max(max(hgh));
    [x_max,y_max]=find(hgh==maximum);
    if(hgh(x_max,y_max)>thold)
        peakIndexList(i,1)=x_max;
        peakIndexList(i,2)=y_max;
        peakNumberList(i)=hgh(x_max,y_max);
        hgh(x_max,y_max)=0;
    end
end
for k=1:nOP  
    xx=peakIndexList(k,1);
    yy=peakIndexList(k,2);
    hgh(xx,yy)=peakNumberList(k);
end


rhoL=zeros(nOP,1); thetaL=zeros(nOP,1); mL=zeros(nOP,1); cL=zeros(nOP,1);
    
figure, imshow(I), hold on
for z=1:nOP
    

    rhoIndex=peakIndexList(z,1);
    thetaIndex=peakIndexList(z,2);    
    rhoL(z)=rhoArray(rhoIndex-1);
    thetaL(z)=thetaArray(thetaIndex);   

    mL(z)=-cotd(thetaL(z));
    cL(z)=rhoL(z)*(1/(sind(thetaL(z))));
    

    x=1:1000;

    plot(x, mL(z)*x+cL(z),'LineWidth',2,'Color','green');
end
%}