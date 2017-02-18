//
//  ViewController.m
//  NSThread_Demo
//
//  Created by Ostrish on 16/7/6.
//  Copyright © 2016年 ZY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    int _leftTickets;
    NSOperationQueue *_queue;
}
@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSCondition *condition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lock = [[NSLock alloc] init];
    self.condition = [[NSCondition alloc] init];
    
    /**
     线程：一个独立执行的代码路径
     进程：一个可执行的程序     可以有多条线程同时执行
     多线程：一个可执行程序（进程）同时拥有多条独立执行的代码路径（线程）    
     
     线程：
     1.主线程：刷新UI 响应用户的触摸事件
     2.分线程：处理耗时任务 -- 下载 大量运算
     */
    
    //获得主线程
    NSLog(@"主线程 --------- %@", [NSThread mainThread]);
    //当前线程
    NSLog(@"当前线程 --------- %@", [NSThread currentThread]);
    //判断当前线程是不是主线程、
    NSLog(@"--------- %d", [NSThread isMainThread]);
    
    //一个NSThread对象，就是一个线程
    //1.创建一个线程  ---- 需要手动开启
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil];
    //2.默认开启
//    [NSThread detachNewThreadSelector:@selector(test) toTarget:self withObject:nil];
    //3.默认开启
//    [self performSelectorInBackground:@selector(test) withObject:nil];
    
    //2.3优缺点
    //优点：简单快捷 缺点：无法给线程设置属性
    
    _leftTickets = 10;
    
    //1.创建一个队列
    _queue = [[NSOperationQueue alloc] init];
    
    //2.添加操作
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self sellTickets];
    }];
    
    [_queue addOperation:operation];
    [_queue addOperation:blockOperation];
    [_queue addOperationWithBlock:^{
        [self sellTickets];
    }];
    
    
//    //创建三个线程
//    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
//    self.thread1.name = @"售票员A";
//    
//    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
//    self.thread2.name = @"售票员B";
//    
//    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
//    self.thread3.name = @"售票员C";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //开启线程
//    [self.thread1 start];
//    [self.thread2 start];
//    [self.thread3 start];
}

- (void)sellTickets {
    /**
     当多条线程同时访问一个数据（一段代码）的时候，会引起数据错乱
     解决方法：线程同步
     线程同步：当多条线程同时访问一个数据（一段代码）的时，让其顺序访问
     实现线程同步三种方式
     1.互斥锁@synchronized
     2.NSLock
     3.NSCondition
     
     */
    while (1) {
        //1.
//        @synchronized (self) {
        //2.
//        [self.lock lock];
        //3.
        [self.condition lock];
            int count = _leftTickets;
            if (count > 0) {
                //让当前线程暂停1秒
                sleep(1);
                
                _leftTickets = count - 1;
                NSLog(@"%@ 买了一张票  %d   %@", [NSThread currentThread].name, _leftTickets, [NSThread currentThread]);
            }else {
                [_queue cancelAllOperations];
                break;
            }
        [self.condition unlock];
//        [self.lock unlock];
//        }
    }
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
