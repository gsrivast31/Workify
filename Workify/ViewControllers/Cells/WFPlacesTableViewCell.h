//
//  WFPlacesTableViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFPlacesTableViewCell : UITableViewCell

- (void)configureCellWithCity:(NSString*)city locationsCount:(NSInteger)count imageName:(NSString*)imageName;

@end
