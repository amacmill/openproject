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

desc <<~END_DESC
    Send reminders about issues due in the next days.
  #{'  '}
    Available options:
      * days     => number of days to remind about (defaults to 7)
      * type     => id of type (defaults to all type)
      * project  => id or identifier of project (defaults to all projects)
      * users    => comma separated list of user ids who should be reminded
  #{'  '}
    Example:
      rake redmine:send_reminders days=7 users="1,23, 56" RAILS_ENV="production"
END_DESC

namespace :redmine do
  task send_reminders: :environment do
    reminder = OpenProject::Reminders::DueIssuesReminder.new(days: ENV['days'], project_id: ENV['project'],
                                                             type_id: ENV['type'], user_ids: ENV['users'].to_s.split(',').map(&:to_i))
    reminder.remind_users
  end
end
