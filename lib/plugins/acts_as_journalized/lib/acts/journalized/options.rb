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

#-- encoding: UTF-8

# This file included as part of the acts_as_journalized plugin for
# the redMine project management software; You can redistribute it
# and/or modify it under the terms of the GNU General Public License
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
# The original copyright and license conditions are:
# Copyright (c) 2009 Steve Richert
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Acts::Journalized
  # Provides +journaled+ options conjournal and cleanup.
  module Options
    def self.included(base) # :nodoc:
      base.class_eval do
        extend ClassMethods
      end
    end

    # Class methods that provide preparation of options passed to the +journaled+ method.
    module ClassMethods
      # The +prepare_journaled_options+ method has three purposes:
      # 1. Populate the provided options with default values where needed
      # 2. Prepare options for use with the +has_many+ association
      # 3. Save user-configurable options in a class-level variable
      #
      # Options are given priority in the following order:
      # 1. Those passed directly to the +journaled+ method
      # 2. Those specified in an initializer +configure+ block
      # 3. Default values specified in +prepare_journaled_options+
      def prepare_journaled_options(options)
        class_attribute :aaj_options
        self.aaj_options = options_with_defaults(options)
      end

      private

      # Returns all of the provided options suitable for the
      # has_many :journals
      # association created by aaj
      def has_many_journals_options
        aaj_options
          .slice(*ActiveRecord::Associations::Builder::HasMany
                    .send(:valid_options, { as: :irrelevant }))
      end

      def options_with_defaults(options)
        {
          class_name: Journal.name,
          dependent: :destroy,
          foreign_key: :journable_id,
          timestamp: :updated_at,
          as: :journable
        }.merge(options.symbolize_keys)
      end
    end
  end
end
