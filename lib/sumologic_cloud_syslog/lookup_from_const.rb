# Copyright 2016 Acquia, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module SumologicCloudSyslog
  module LookupFromConst
    def setup_constants(dst)
      constants.each do |pri|
        cval = const_get pri

        dst[pri] = cval
        dst[pri.downcase] = cval

        dst[:"LOG_#{pri.to_s}"] = cval
        dst[:"LOG_#{pri.downcase.to_s}"] = cval
        const_set :"LOG_#{pri.to_s}", cval

        dst[pri.to_s] = cval
        dst[pri.downcase.to_s] = cval

        dst[cval] = cval
        dst[cval.to_s] = cval
      end

      self.class.send(:define_method, :keys) do
        dst.keys
      end

      self.class.send(:define_method, :[]) do |key|
        value_none = const_get :NONE
        dst.fetch(key, value_none)
      end

      self.class.send(:define_method, :[]=) do
        raise RuntimeError.new "#{self.class} is read only"
      end
    end
  end
end
