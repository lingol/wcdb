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

#import <WCDB/WCTConstraintBinding.h>
#import <WCDB/error.hpp>

WCTConstraintBindingBase::WCTConstraintBindingBase(const std::string &n, WCTConstraintBindingType t)
    : name(n)
    , type(t)
{
}

WCTConstraintPrimaryKeyBinding::WCTConstraintPrimaryKeyBinding(const std::string &name)
    : WCTConstraintBindingBase(name, WCTConstraintPrimaryKeyBinding::type)
    , m_conflict(WCTConflictNotSet)
{
}

void WCTConstraintPrimaryKeyBinding::addPrimaryKey(const WCDB::ColumnIndex &index)
{
    m_primaryKeyList.push_back(index);
}

void WCTConstraintPrimaryKeyBinding::setConflict(WCTConflict conflict)
{
    m_conflict = conflict;
}

WCDB::TableConstraint WCTConstraintPrimaryKeyBinding::generateConstraint() const
{
    return WCDB::TableConstraint(name).makePrimary(m_primaryKeyList).onConflict((WCDB::Conflict) m_conflict);
}

WCTConstraintUniqueBinding::WCTConstraintUniqueBinding(const std::string &name)
    : WCTConstraintBindingBase(name, WCTConstraintUniqueBinding::type)
    , m_conflict(WCTConflictNotSet)
{
}

void WCTConstraintUniqueBinding::addUnique(const WCDB::ColumnIndex &index)
{
    m_uniqueList.push_back(index);
}

void WCTConstraintUniqueBinding::setConflict(WCTConflict conflict)
{
    m_conflict = conflict;
}

WCDB::TableConstraint WCTConstraintUniqueBinding::generateConstraint() const
{
    return WCDB::TableConstraint(name).makeUnique(m_uniqueList).onConflict((WCDB::Conflict) m_conflict);
}

WCTConstraintCheckBinding::WCTConstraintCheckBinding(const std::string &name)
    : WCTConstraintBindingBase(name, WCTConstraintCheckBinding::type)
{
}

void WCTConstraintCheckBinding::makeCheck(const WCDB::Expression &expression)
{
    m_check.reset(new WCDB::Expression(expression));
}

WCDB::TableConstraint WCTConstraintCheckBinding::generateConstraint() const
{
    if (m_check == nullptr) {
        WCDB::Error::Abort(("You must set the checking expression for TableConstraint" + name).c_str());
    }
    return WCDB::TableConstraint(name).check(*m_check.get());
}

WCTConstraintForeignKeyBinding::WCTConstraintForeignKeyBinding(const std::string &name)
    : WCTConstraintBindingBase(name, WCTConstraintForeignKeyBinding::type)
{
}

void WCTConstraintForeignKeyBinding::addColumn(const WCDB::Column &column)
{
    m_columnList.push_back(column);
}
void WCTConstraintForeignKeyBinding::setForeignKey(const WCDB::ForeignKey &foreignKey)
{
    m_foreignKey.reset(new WCDB::ForeignKey(foreignKey));
}

WCDB::TableConstraint WCTConstraintForeignKeyBinding::generateConstraint() const
{
    if (m_foreignKey == nullptr) {
        WCDB::Error::Abort(("You must setup the foreign key for TableConstraint " + name).c_str());
    }
    return WCDB::TableConstraint(name).makeForeignKey(m_columnList, *m_foreignKey.get());
}
