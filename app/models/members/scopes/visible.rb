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

module Members::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      # Find all members visible to the inquiring user
      def visible(user)
        if user.admin?
          visible_for_admins
        else
          visible_for_non_admins(user)
        end
      end

      private

      def visible_for_non_admins(user)
        view_members = Project.where(id: Project.allowed_to(user, :view_members))
        manage_members = Project.where(id: Project.allowed_to(user, :manage_members))

        project_scope = view_members.or(manage_members)

        Member.where(project_id: project_scope.select(:id))
      end

      def visible_for_admins
        Member.all
      end
    end
  end
end
