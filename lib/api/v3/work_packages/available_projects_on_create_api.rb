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

require 'api/v3/projects/project_collection_representer'

module API
  module V3
    module WorkPackages
      class AvailableProjectsOnCreateAPI < ::API::OpenProjectAPI
        resource :available_projects do
          after_validation do
            authorize(:add_work_packages, global: true)
          end

          params do
            optional :for_type, type: Integer
          end

          get do
            checked_permissions = Projects::ProjectCollectionRepresenter.checked_permissions
            current_user.preload_projects_allowed_to(checked_permissions)

            available_projects = WorkPackage
                                 .allowed_target_projects_on_create(current_user)
                                 .includes(Projects::ProjectCollectionRepresenter.to_eager_load)

            query = ::Queries::Projects::ProjectQuery.new(user: current_user)
            if params[:for_type]
              query.where('type_id', '=', params[:for_type])
              available_projects = query.results.merge(available_projects)
            end

            self_link = api_v3_paths.available_projects_on_create(params[:for_type])
            Projects::ProjectCollectionRepresenter.new(available_projects,
                                                       self_link: self_link,
                                                       current_user: current_user)
          end
        end
      end
    end
  end
end
