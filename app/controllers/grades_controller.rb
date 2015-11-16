class GradesController < ApplicationController
  load_and_authorize_resource :student
  load_and_authorize_resource :grade, through: :student, shallow: true
end
