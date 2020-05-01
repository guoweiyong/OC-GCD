//
//  ViewController.m
//  多线程
//
//  Created by yunyi on 2020/4/30.
//  Copyright © 2020 yunyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/// 总票数
@property (nonatomic, assign) int sumCount;

/// 锁对象
@property (nonatomic, strong) NSLock *lock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSthread
    //[self creatThread];
    //[self creatThread2];
    //[self exampleThread];
    //[self exampleThread2];
    
    //GCD
    //[self creatserialQueue];
    //[self creatSerialQueue2];
    //[self creatConcurrentQueue];
    //[self creatConcurrentQueue2];
    
    //[self group];
    //[self once];
    //[self after];
    //[self timer];
    //[self barrier];
    
    
    //NSOPeration
    //[self creatBlockOperation];
    //[self invocationOperation];
    //[self creatOperationQueue];
    //[self operationMain];
    [self operationRelpOn2];
}

#pragma mark -- NSOperation
- (void)creatBlockOperation {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation  === current thread======%@",[NSThread currentThread]);
    }];
    
    //添加任务为开辟的新县城
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecution  current thread ======%@",[NSThread currentThread]);
    }];
    //[blockOperation start];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:blockOperation];
}

- (void)creatInvocationOperation {
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation) object:nil];
    [invocationOperation start];
}

- (void)invocationOperation {
    NSLog(@"invocationOperation current thread=======%@",[NSThread currentThread]);
}

- (void)creatOperationQueue {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //添加block操作
    [operationQueue addOperationWithBlock:^{
        NSLog(@"操作1------%@",[NSThread currentThread]);
    }];
    [operationQueue addOperationWithBlock:^{
        NSLog(@"操作2------%@",[NSThread currentThread]);
    }];
    [operationQueue addOperationWithBlock:^{
        NSLog(@"操作3------%@",[NSThread currentThread]);
    }];
}
- (void)operationMain {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //添加block操作
    [operationQueue addOperationWithBlock:^{
        NSLog(@"子线程处理耗时操作------%@",[NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           NSLog(@"主线程更新UI------%@",[NSThread currentThread]);
        }];
    }];
}

- (void)operationRelpOn {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一======");
    }];
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务2-=====");
    }];
    
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation1) object:nil];
    //设置依赖关系
    [invocationOperation addDependency:blockOperation];
    [invocationOperation addDependency:blockOperation2];
    
    [operationQueue addOperation:blockOperation];
    [operationQueue addOperation:blockOperation2];
    [operationQueue addOperation:invocationOperation];
}

- (void)operationRelpOn2 {
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //operationQueue.maxConcurrentOperationCount
    [operationQueue addOperationWithBlock:^{
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
               NSLog(@"任务一======");
           }];
           NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
               NSLog(@"任务2-=====");
           }];
           
           NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation1) object:nil];
           //设置依赖关系
           [invocationOperation addDependency:blockOperation];
           [invocationOperation addDependency:blockOperation2];
           
           [operationQueue addOperations:@[blockOperation,blockOperation2,invocationOperation] waitUntilFinished:YES];
        
        NSLog(@"任务4===========");
    }];
    NSLog(@"====================");
}

- (void)invocationOperation1 {
    NSLog(@"任务3=====");
}

#pragma mark --GCD

/// 创建一个串行队列 + 同步执行函数
- (void)creatserialQueue {
    /**
     @param 参数1 队列的名称
     @param dispatch_queue_attr_t DISPATCH_QUEUE_SERIAL: 串行队列  DISPATCH_QUEUE_CONCURRENT：并发队列
     */
    //创建一个串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    //使用串行队列执行同步函数
    for (int i = 0; i < 10; i++) {
        dispatch_sync(serialQueue, ^{
            NSLog(@"current thread====%@  i=====%d",[NSThread currentThread],i);
        });
    }
}

/// 串行队列 + 异步执行函数
- (void)creatSerialQueue2 {
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++) {
        dispatch_async(serialQueue, ^{
            NSLog(@"current thread====%@  i=====%d",[NSThread currentThread],i);
        });
    }
}

/// 并行队列 + 同步函数
- (void)creatConcurrentQueue {
    /**
    @param 参数1 队列的名称
    @param dispatch_queue_attr_t DISPATCH_QUEUE_SERIAL: 串行队列  DISPATCH_QUEUE_CONCURRENT：并发队列
    */
    //创建一个并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"current thread====%@  i=====%d",[NSThread currentThread],i);
        });
    }
}

/// 并行队列 + 异步函数
- (void)creatConcurrentQueue2 {
    /**
    @param 参数1 队列的名称
    @param dispatch_queue_attr_t DISPATCH_QUEUE_SERIAL: 串行队列  DISPATCH_QUEUE_CONCURRENT：并发队列
    */
    //创建一个并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"current thread====%@  i=====%d",[NSThread currentThread],i);
        });
    }
}

- (void)systemQueue {
    /**
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
     */
    //获取一个默认优先级的全局队列
//    dispatch_queue_t systemQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
}

/// dispatch_group
- (void)group{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"异步队列1====%d",i);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"异步队列2====%d",i);
        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(queue, ^{
        NSLog(@"两个队列都执行完了---");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"可以做操作了---");
        });
    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"两个队列都执行完了---");
//    });
}

- (void)once {
    for (int i = 0; i < 5; i++) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"回执行几次==");
        });
    }
}

- (void)after {
    NSLog(@"------------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"++++++++");
    });
}

- (void)timer {
    NSLog(@"==============");
    /*
     第一个参数:source的类型DISPATCH_SOURCE_TYPE_TIMER 表示是定时器
     第二个参数:描述信息,线程ID
     第三个参数:更详细的描述信息
     第四个参数:队列,决定GCD定时器中的任务在哪个线程中执行
     dispatch_source_create(dispatch_source_type_t type,
     uintptr_t handle,
     unsigned long mask,
     dispatch_queue_t _Nullable queue);
     */
   
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //2.设置定时器(起始时间|间隔时间|精准度)
    /*
     第一个参数:定时器对象
     第二个参数:起始时间,DISPATCH_TIME_NOW 从现在开始计时
     第三个参数:间隔时间 2.0 GCD中时间单位为纳秒
     第四个参数:精准度 绝对精准0
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD定时器-----");
        
    });
    dispatch_resume(timer);
    
    
}

- (void)barrier {
    //dispatch_barrier中使用的队列 一定
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"任务1==%d",i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"任务2==%d",i);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"截断，等上面任务完之后再无按成下面的任务");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"任务3==%d",i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"任务4==%d",i);
        }
    });
}

#pragma mark -- NSThread

/// 使用类方法来创建NSThread
- (void)creatThread {
    //1. block方式
    if (@available(iOS 10.0, *)) {
        //这个类创建线程方法  IOS版本 >= 10.0
        [NSThread detachNewThreadWithBlock:^{
            NSLog(@"detachNewThreadWithBlock ==current thread =====%@",[NSThread currentThread]);
        }];
    } else {
        // Fallback on earlier versions
        [NSThread detachNewThreadSelector:@selector(runThread) toTarget:self withObject:nil];
    }
}

/// 使用实例方法来创建NSThread对象
- (void)creatThread2 {
    //如果是实例方法创建的NSThread对象，我们需要手动调用方法[thread start]来启动线程
    if (@available(iOS 10.0, *)) {
        NSThread *thread = [[NSThread alloc] initWithBlock:^{
            NSLog(@"initWithBlock == current thread====%@",[NSThread currentThread]);
        }];
        [thread start];
    }else {
        // Fallback on earlier versions
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
        [thread start];
    }
}

/// @param thread <#thread description#>
- (void)setThreadAttrs:(NSThread *)thread {
    [thread setName:@"设置线程的名称"];
    //设置线程的优先级，由0 到 1 的浮点数来制定，其中1.0是最高优先级。
    [thread setThreadPriority:1];
    //推出当前线程
    [NSThread exit];
    //使当前线程睡眠-> 单位是秒
    [NSThread sleepForTimeInterval:1];
    //使当前线程沉睡直到某个时间
    [NSThread sleepUntilDate:[[NSDate alloc] init]];
    //判断是否在主线程
    [NSThread isMainThread];
}

- (void)runThread{
    NSLog(@"current thread =====%@",[NSThread currentThread]);
}


#pragma mark -- NSThread 的线程同步问题-- 卖票的经典案例实现
- (void)exampleThread {
    //1.首先我们设置总票数
    self.sumCount = 10;
    
    //2。创建两个售票员在卖票
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSThread detachNewThreadWithBlock:^{
//            @synchronized (weakSelf) {
//                while (weakSelf.sumCount > 0) {
//                    [NSThread sleepForTimeInterval:1];
//                    weakSelf.sumCount--;
//                    NSLog(@"还有%d张票",weakSelf.sumCount);
//                }
//            }
            while (true) {
                [NSThread sleepForTimeInterval:1];
                @synchronized (self) {
                    if (weakSelf.sumCount < 1) {
                        break;
                    }
                    self.sumCount --;
                    NSLog(@"还有%d张票",weakSelf.sumCount);
                }
            }
        }];
        
        [NSThread detachNewThreadWithBlock:^{
//            @synchronized (weakSelf) {
//                while (weakSelf.sumCount > 0) {
//                    [NSThread sleepForTimeInterval:1];
//                    weakSelf.sumCount --;
//
//                    NSLog(@"还有%d张票",weakSelf.sumCount);
//                }
//            }
            while (true) {
                [NSThread sleepForTimeInterval:1];
                @synchronized (self) {
                    if (weakSelf.sumCount < 1) {
                        break;
                    }
                    self.sumCount --;
                    NSLog(@"还有%d张票",weakSelf.sumCount);
                }
            }
            
        }];
        
    } else {
        // Fallback on earlier versions
    }
}

/// 使用NSlock来进行加锁操作
- (void)exampleThread2 {
    //1.首先我们设置总票数
    self.sumCount = 10;
    self.lock = [[NSLock alloc] init];
    
    //2。创建两个售票员在卖票
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSThread detachNewThreadWithBlock:^{
            
            while (true) {
                [NSThread sleepForTimeInterval:1];
                [weakSelf.lock lock];
                if (weakSelf.sumCount < 1) {
                    break;
                }
                self.sumCount --;
                NSLog(@"还有%d张票",weakSelf.sumCount);
                [weakSelf.lock unlock];
            }
        }];
        
        [NSThread detachNewThreadWithBlock:^{
            while (true) {
                [NSThread sleepForTimeInterval:1];
                [weakSelf.lock lock];
                if (weakSelf.sumCount < 1) {
                    break;
                }
                self.sumCount --;
                NSLog(@"还有%d张票",weakSelf.sumCount);
                [weakSelf.lock unlock];
            }
        }];
        
    } else {
        // Fallback on earlier versions
    }
}
@end
