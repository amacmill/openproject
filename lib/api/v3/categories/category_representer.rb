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

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Categories
      class CategoryRepresenter < ::API::Decorators::Single
        include ::API::Caching::CachedRepresenter

        cached_representer key_parts: %i(assigned_to project)

        link :self do
          {
            href: api_v3_paths.category(represented.id),
            title: represented.name
          }
        end

        link :project do
          {
            href: api_v3_paths.project(represented.project.id),
            title: represented.project.name
          }
        end

        link :defaultAssignee do
          next unless represented.assigned_to

          {
            href: api_v3_paths.user(represented.assigned_to.id),
            title: represented.assigned_to.name
          }
        end

        property :id, render_nil: true
        property :name, render_nil: true

        def _type
          'Category'
        end
      end
    end
  end
end
