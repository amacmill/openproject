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

module API
  module V3
    module Notifications
      class NotificationEagerLoadingWrapper < API::V3::Utilities::EagerLoading::EagerLoadingWrapper
        class << self
          def wrap(notifications)
            API::V3::Activities::ActivityEagerLoadingWrapper.wrap(notifications.map(&:journal))
            set_resource(notifications)

            super
          end

          private

          # Copy the resource over from the journal.
          # Those two should always be the same.
          # The journable will be loaded within the ActivityEagerLoadingWrapper.
          def set_resource(notifications)
            notifications.select { |n| n.journal.present? }.each do |notification|
              notification.resource = notification.journal.journable
            end
          end
        end
      end
    end
  end
end
