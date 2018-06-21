/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <WCDB/WCTBinding.h>
#import <WCDB/WCTChainCall+Private.h>
#import <WCDB/WCTCoding.h>
#import <WCDB/WCTColumnBinding.h>
#import <WCDB/WCTCore+Private.h>
#import <WCDB/WCTProperty.h>
#import <WCDB/WCTSelect+Private.h>
#import <WCDB/WCTSelect.h>
#import <WCDB/WCTSelectBase+Private.h>
#import <WCDB/utility.hpp>

@implementation WCTSelect {
    WCTPropertyList _propertyList;
    Class _class;
}

- (instancetype)initWithCore:(const std::shared_ptr<WCDB::CoreBase> &)core andProperties:(const WCTPropertyList &)propertyList fromTable:(NSString *)tableName isDistinct:(BOOL)isDistinct
{
    if (self = [super initWithCore:core]) {
        _propertyList.insert(_propertyList.begin(), propertyList.begin(), propertyList.end());
        _statement.select(_propertyList, isDistinct).from(tableName.UTF8String);
        _class = _propertyList.front().getColumnBinding()->getClass();
    }
    return self;
}

- (NSArray /* <WCTObject*> */ *)allObjects
{
    if ([self lazyPrepare]) {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        WCTObject *object = nil;
        int index = 0;
        while ([self next]) {
            object = [[_class alloc] init];
            index = 0;
            for (const WCTProperty &property : _propertyList) {
                if ([self extractPropertyToObject:object
                                          atIndex:index
                                withColumnBinding:property.getColumnBinding()]) {
                    ++index;
                } else {
                    return nil;
                }
            }
            [objects addObject:object];
        }
        return _error.isOK() ? objects : nil;
    }
    return nil;
}

- (id /* WCTObject* */)nextObject
{
    if ([self lazyPrepare] && [self next]) {
        WCTObject *object = [[_class alloc] init];
        int index = 0;
        for (const WCTProperty &property : _propertyList) {
            if ([self extractPropertyToObject:object
                                      atIndex:index
                            withColumnBinding:property.getColumnBinding()]) {
                ++index;
            } else {
                return nil;
            }
        }
        return object;
    }
    return nil;
}

@end
