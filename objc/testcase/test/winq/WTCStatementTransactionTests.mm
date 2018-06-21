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

@interface WTCStatementTransactionTests : WTCBaseTestCase

@end

@implementation WTCStatementTransactionTests

- (void)testStatementTransaction
{
    XCTAssertEqual(WCDB::StatementTransaction().getStatementType(), WCDB::Statement::Type::Transaction);
    WINQAssertEqual(WCDB::StatementTransaction().begin(WCDB::StatementTransaction::Mode::Deferred), @"BEGIN DEFERRED");

    WINQAssertEqual(WCDB::StatementTransaction().begin(WCDB::StatementTransaction::Mode::Immediate), @"BEGIN IMMEDIATE");

    WINQAssertEqual(WCDB::StatementTransaction().begin(WCDB::StatementTransaction::Mode::Exclusive), @"BEGIN EXCLUSIVE");

    WINQAssertEqual(WCDB::StatementTransaction().commit(), @"COMMIT");

    WINQAssertEqual(WCDB::StatementTransaction().rollback(), @"ROLLBACK");
}

@end
