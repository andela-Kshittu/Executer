//
//  MenuViewController.h
//  Executer
//
//  Created by Kehinde Shittu on 8/7/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
//func menuViewResponse(controller: MenuViewController,
//                      didDismissPopupView selectedCell: Int)
@protocol menuViewDelegate <NSObject>
-(void)menuViewResponse:(id)controller didSelectOptions:(NSMutableArray *)options;
@end
@interface MenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property(weak, nonatomic) id<menuViewDelegate> delegate;
@property(strong, nonatomic) NSMutableArray* uberTypes;
- (IBAction)saveUberTypes:(id)sender;
@property(strong, nonatomic) NSMutableArray* selectedUberTypes;
@end
