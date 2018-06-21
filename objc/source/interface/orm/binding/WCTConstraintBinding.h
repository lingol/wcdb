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

#import <WCDB/WCTDeclare.h>
#import <WCDB/abstract.h>
#import <string>

typedef NS_ENUM(int, WCTConstraintBindingType) {
    WCTConstraintBindingPrimaryKey,
    WCTConstraintBindingUnique,
    WCTConstraintBindingCheck,
    WCTConstraintBindingForeignKey,
};

class WCTConstraintBindingBase {
public:
    WCTConstraintBindingBase(const std::string &name,
                             WCTConstraintBindingType type);
    const std::string name;
    const WCTConstraintBindingType type;

    virtual WCDB::TableConstraint generateConstraint() const = 0;
};

class WCTConstraintPrimaryKeyBinding : public WCTConstraintBindingBase {
public:
    static constexpr const WCTConstraintBindingType type =
        WCTConstraintBindingPrimaryKey;
    WCTConstraintPrimaryKeyBinding(const std::string &name);

    void addPrimaryKey(const WCDB::ColumnIndex &index);
    void setConflict(WCTConflict conflict);

    virtual WCDB::TableConstraint generateConstraint() const override;

protected:
    WCTConflict m_conflict;
    WCDB::ColumnIndexList m_primaryKeyList;
};

class WCTConstraintUniqueBinding : public WCTConstraintBindingBase {
public:
    static constexpr const WCTConstraintBindingType type =
        WCTConstraintBindingUnique;
    WCTConstraintUniqueBinding(const std::string &name);

    void addUnique(const WCDB::ColumnIndex &index);
    void setConflict(WCTConflict conflict);

    virtual WCDB::TableConstraint generateConstraint() const override;

protected:
    WCTConflict m_conflict;
    WCDB::ColumnIndexList m_uniqueList;
};

class WCTConstraintCheckBinding : public WCTConstraintBindingBase {
public:
    static constexpr const WCTConstraintBindingType type =
        WCTConstraintBindingCheck;
    WCTConstraintCheckBinding(const std::string &name);

    void makeCheck(const WCDB::Expression &expression);
    virtual WCDB::TableConstraint generateConstraint() const override;

protected:
    std::shared_ptr<WCDB::Expression> m_check;
};

class WCTConstraintForeignKeyBinding : public WCTConstraintBindingBase {
public:
    static constexpr const WCTConstraintBindingType type =
        WCTConstraintBindingForeignKey;
    WCTConstraintForeignKeyBinding(const std::string &name);

    void addColumn(const WCDB::Column &column);
    void setForeignKey(const WCDB::ForeignKey &foreignKey);
    virtual WCDB::TableConstraint generateConstraint() const override;

protected:
    std::shared_ptr<WCDB::ForeignKey> m_foreignKey;
    WCDB::ColumnList m_columnList;
};
