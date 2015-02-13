//
//  MessagesViewController.h
//  IMApp
//
//  Created by chen on 14-7-21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHBasicViewController.h"
#import <CoreData/CoreData.h>

@interface MessagesViewController : QHBasicViewController<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}


@end
