close all
clear,clc;
%% 执行初始化操作
% 仿真顾客总数
Customer_Amount=1000; 

% 到达时间间隔A1均值
Beta_A = 5;
% 服务时间间隔S均值
Beta_S = 4;

% 到达率Lambda
Lamda=1/Beta_A;
% 服务率Miu
Miu=1/Beta_S;

Arrive_Time=zeros(1,Customer_Amount);
Leave_Time=zeros(1,Customer_Amount);

Arrive_Num=zeros(1,Customer_Amount);
Leave_Num=zeros(1,Customer_Amount);

% 到达时间间隔
Arrive_Time_Interval=exprnd(Beta_A,[1,Customer_Amount]);

% 服务时间
Service_Time_Interval=exprnd(Beta_S,[1,Customer_Amount]);

% 顾客到达时间
Arrive_Time(1)=Arrive_Time_Interval(1);

%% 操作事件
Arrive_Num(1)=1;
for i=2:Customer_Amount
    Arrive_Time(i)=Arrive_Time(i-1)+Arrive_Time_Interval(i); 
    Arrive_Num(i)=i;  
end

Leave_Time(1)=Arrive_Time(1)+Service_Time_Interval(1);%顾客离开时间
Leave_Num(1)=1;

for i=2:Customer_Amount
    if Leave_Time(i-1)<Arrive_Time(i)   
        Leave_Time(i)=Arrive_Time(i)+Service_Time_Interval(i);
    else
        Leave_Time(i)=Leave_Time(i-1)+Service_Time_Interval(i);
    end
    Leave_Num(i)=i;
end

% 各顾客在系统中的等待时间
Wait_Time=Leave_Time-Arrive_Time; 
Wait_Time_ave=mean(Wait_Time);% 仿真平均等待时间

% 各顾客在系统中的排队时间
Queue_Time=Wait_Time-Service_Time_Interval;
Queue_Time_ave=mean(Queue_Time);% 仿真平均排队时间

% 系统中顾客数随时间的变化
Time_Stamp=[Arrive_Time,Leave_Time];
Time_Stamp=sort(Time_Stamp);

% 到达时间标志
Arrive_Flag=zeros(size(Time_Stamp));

Customer_Num=zeros(size(Time_Stamp));
temp=2;
Customer_Num(1)=1;

for i=2:length(Time_Stamp)   
    if (temp<=length(Arrive_Time)) && (Time_Stamp(i)==Arrive_Time(temp))
        Customer_Num(i)=Customer_Num(i-1)+1;
        temp=temp+1;
        Arrive_Flag(i)=1;
    else
        Customer_Num(i)=Customer_Num(i-1)-1;
    end
end

% 系统中平均顾客数计算
Time_interval=zeros(size(Time_Stamp));
Time_interval(1)=Arrive_Time(1);

for i=2:length(Time_Stamp)
    Time_interval(i)=Time_Stamp(i)-Time_Stamp(i-1);
end

Customer_Num_fromStart=[0 Customer_Num];
Customer_Num_ave=sum(Customer_Num_fromStart.*[Time_interval 0] )/Time_Stamp(end);% 仿真系统中平均顾客数

% 系统平均等待队长
Queue_Length = zeros(size(Customer_Num));
for i=1:length(Customer_Num)
    if Customer_Num(i)>2
        Queue_Length(i) = Customer_Num(i)-1;
    else
        Queue_Length(i)=0;
    end
end
Queue_Length_ave = sum([0 Queue_Length].*[Time_interval 0])/Time_Stamp(end);% 仿真系统中平均等待队长

%% 结果绘图
figure(1)
title('每个顾客到达时间和离开时间');
stairs([0,Arrive_Num],[0 Arrive_Time],'b','LineWidth',2);
hold on
stairs([0,Leave_Num],[0 Leave_Time],'r','LineWidth',2);
legend('到达服务台时间','完成服务并离开服务台时间');
hold off;
figure(2)
stairs(Time_Stamp,Customer_Num,'b','LineWidth',1);
title('系统等待队长');
xlabel('时间');
ylabel('等待队长');
figure(3);
title('各顾客在系统中的排队时间和等待时间');
stairs([0 Arrive_Num],[0 Queue_Time],'b','LineWidth',1) ;
hold on ;
stairs([0 Leave_Num],[0 Wait_Time],'r','LineWidth',1 );
hold off;
legend('排队时间','等待时间');