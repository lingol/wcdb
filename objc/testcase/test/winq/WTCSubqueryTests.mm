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

#import "WTCAssert.h"
#import "WTCBaseTestCase.h"

@interface WTCSubqueryTests : WTCBaseTestCase

@end

@implementation WTCSubqueryTests

- (void)testSubquery
{
    //Give
    std::string table1 = "table1";
    WCDB::JoinClause joinClause(table1);
    WCDB::StatementSelect statementSelect = WCDB::StatementSelect().select(1).from(table1);
    std::string alias1 = "alias1";

    //Then
    WINQAssertEqual(WCDB::Subquery(joinClause), @"(table1)");

    WINQAssertEqual(WCDB::Subquery(statementSelect), @"(SELECT 1 FROM table1)");

    WINQAssertEqual(WCDB::Subquery(table1), @"table1");

    WINQAssertEqual(WCDB::Subquery(table1).as(alias1), @"table1 AS alias1");
}

@end
