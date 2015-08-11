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
    self.selectedUberTypes =[[NSMutableArray alloc] init];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    


//    if ([cell.textLabel.text isEqualToString:@"Save Options"]){
//        
//         [self.delegate menuViewResponse:self didSelectOptions:self.selectedUberTypes];
//         [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
        if(cell.backgroundColor == [UIColor grayColor]){
            cell.backgroundColor = [UIColor clearColor];
            [self.selectedUberTypes removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }else{
            cell.backgroundColor = [UIColor grayColor];
            NSInteger position =  [self.uberTypes indexOfObject:cell.textLabel.text];
            [self.selectedUberTypes addObject:[NSNumber numberWithInteger:position]];
        }
      
        NSLog(@"slected types %@", self.selectedUberTypes);
//    }
 
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(!cell){
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    

//    if(indexPath.row == self.uberTypes.count ){
//      cell.textLabel.text = @"Save Options";
//        cell.backgroundColor = [UIColor blackColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }else{
        cell.textLabel.text = self.uberTypes[indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        NSInteger position =  [self.uberTypes indexOfObject:cell.textLabel.text];
        if([self.selectedUberTypes containsObject:[NSNumber numberWithInteger:position]]){
            cell.backgroundColor = [UIColor grayColor];
        }
     
//    }
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
