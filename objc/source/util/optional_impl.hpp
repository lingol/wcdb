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

#ifndef optional_impl_hpp
#define optional_impl_hpp

#include <WCDB/error.hpp>
#include <WCDB/optional.hpp>

namespace WCDB {

template <typename T>
Optional<T>::OptionalStorage::OptionalStorage(const T &value) : m_value(value)
{
}

template <typename T>
Optional<T>::Optional(const T &value) : m_storage(new OptionalStorage(value))
{
}

template <typename T>
Optional<T>::Optional() : m_storage(nullptr)
{
}

template <typename T>
Optional<T>::operator bool() const
{
    return isValid();
}

template <typename T>
bool Optional<T>::isValid() const
{
    return m_storage != nullptr;
}

template <typename T>
const T &Optional<T>::operator*() const
{
    return value();
}

template <typename T>
T &Optional<T>::operator*()
{
    return value();
}

template <typename T>
const T &Optional<T>::value() const
{
    if (!isValid()) {
        Error::Abort("Unwrap a disengaged value");
    }
    return *m_storage.get();
}

template <typename T>
T &Optional<T>::value()
{
    if (!isValid()) {
        Error::Abort("Unwrap a disengaged value");
    }
    return *m_storage.get();
}

} //namespace WCDB

#endif /* optional_impl_hpp */
