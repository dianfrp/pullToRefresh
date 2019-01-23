//
//  ViewController.m
//  PullToRefresh
//
//  Created by KTW on 11/01/2019.
//  Copyright © 2019 KTW. All rights reserved.
//

#import "ViewController.h"
#import "PullToRefreshManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PullToRefreshManagerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readwrite) NSMutableArray *array;
@property (nonatomic, readwrite) PullToRefreshManager *manager;
@end

@implementation ViewController

- (void)addArrayData
{
    [_array addObject:@"l"];
    [_array addObject:@"m"];
    [_array addObject:@"n"];
    [_array addObject:@"o"];
    [_array addObject:@"p"];
    [_array addObject:@"q"];
    [_array addObject:@"r"];
    [_array addObject:@"s"];
    [_array addObject:@"t"];
    [_array addObject:@"u"];
    [_array addObject:@"v"];
    [_array addObject:@"w"];
    [_array addObject:@"x"];
    [_array addObject:@"y"];
    [_array addObject:@"z"];
    [_array addObject:@"z"];
    
    [_tableView reloadData];
}

- (void)ressetArrayData
{
    NSMutableArray *tArray = [[NSMutableArray alloc] init];
    [tArray addObject:@"a"];
    [tArray addObject:@"b"];
    [tArray addObject:@"c"];
    [tArray addObject:@"d"];
    [tArray addObject:@"e"];
    [tArray addObject:@"f"];
    [tArray addObject:@"g"];
    [tArray addObject:@"h"];
    [tArray addObject:@"i"];
    [tArray addObject:@"j"];
    [tArray addObject:@"k"];
    
    _array = tArray;
    
    [_tableView reloadData];
    [_manager endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array = [[NSMutableArray alloc] init];
    [_array addObject:@"a"];
    [_array addObject:@"b"];
    [_array addObject:@"c"];
    [_array addObject:@"d"];
    [_array addObject:@"e"];
    [_array addObject:@"f"];
    [_array addObject:@"g"];
    [_array addObject:@"h"];
    [_array addObject:@"i"];
    [_array addObject:@"j"];
    [_array addObject:@"k"];
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tableView setRowHeight:UITableViewAutomaticDimension];
    [_tableView setEstimatedRowHeight:50];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [_tableView setSectionHeaderHeight:0.0];
    [_tableView setSectionFooterHeight:0.0];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:_tableView];
    
//    if (@available(iOS 11.0, *)) {
//        [[_tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
//    } else {
//        // Fallback on earlier versions
//        [[_tableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor] setActive:YES];
//    }
    [[_tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    [[_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[_tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.manager = [[PullToRefreshManager alloc] initWithScrollView:self.tableView scrollDelegate:(id<UIScrollViewDelegate>)self];
        [self.manager setDelegate:self];
    });
    
    
}

- (void)doHandleRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [self ressetArrayData];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    [cell.textLabel setText:[_array objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:30 weight:UIFontWeightBold]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottom = scrollView.contentSize.height - scrollView.frame.size.height;
    CGFloat scrollPosition = scrollView.contentOffset.y;
    CGFloat position = bottom - scrollPosition;
    
    if (position <= 200) {
        [self addArrayData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

@end
