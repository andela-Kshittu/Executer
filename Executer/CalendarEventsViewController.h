//
//  CalendarEventsViewController.h
//  Executer
//
//  Created by Johnson Ejezie on 9/10/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarEventsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCotntrolBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray* calenderEvents;
@property(nonatomic, strong)NSMutableArray* recentlyBookedEvents;
- (IBAction)segmentControl:(UISegmentedControl *)sender;
@property(strong, nonatomic)  NSDictionary* uberProfile;
- (IBAction)unwindSegue: (UIStoryboardSegue *) sender;

@end
