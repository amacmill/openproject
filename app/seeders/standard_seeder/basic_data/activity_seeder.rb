#-- encoding: UTF-8

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++
module StandardSeeder
  module BasicData
    class ActivitySeeder < ::BasicData::ActivitySeeder
      def data
        [
          { name: I18n.t(:default_activity_management),    position: 1, is_default: true  },
          { name: I18n.t(:default_activity_specification), position: 2, is_default: false },
          { name: I18n.t(:default_activity_development),   position: 3, is_default: false },
          { name: I18n.t(:default_activity_testing),       position: 4, is_default: false },
          { name: I18n.t(:default_activity_support),       position: 5, is_default: false },
          { name: I18n.t(:default_activity_other),         position: 6, is_default: false }
        ]
      end
    end
  end
end
