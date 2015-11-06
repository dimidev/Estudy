module DepartmentsHelper
  def department_status(status)
    if status == true
      "<span class='badge badge-success' data-toggle='tooltip' title='#{I18n.t('enumerize.department.status.active')}'><i class='fa fa-check'></a></span>".html_safe
    else
      "<span class='badge badge-danger' data-toggle='tooltip' title='#{I18n.t('enumerize.department.status.not_active')}'><i class='fa fa-minus-circle'></a></span>".html_safe
    end
  end
end
