//
//  MenuViewController.m
//  Executer
//
//  Created by Kehinde Shittu on 8/7/15.
//  Copyright (c) 2015 Kehesjay. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
{
//    NSMutableArray *uberTypes;
}
@end

@implementation MenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTable.dataSource = self;
    self.menuTable.delegate = self;
    self.uberTypes =[[NSMutableArray alloc] initWithArray:@[@"UberX",@"UberXL",@"UberPlus/Select",@"UberPOOL",@"UberBLACK"]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.uberTypes.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate menuViewResponse:self didSelectOption:indexPath.row];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(!cell){
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    cell.textLabel.text = self.uberTypes[indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
