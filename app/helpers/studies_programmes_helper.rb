module StudiesProgrammesHelper
  def programme_status(status)
    if status == true
      "<span class='badge badge-success' data-toggle='tooltip' title='#{I18n.t('mongoid.attributes.department.active')}'><i class='fa fa-check'></a></span>".html_safe
    else
      "<span class='badge badge-danger' data-toggle='tooltip' title='#{I18n.t('mongoid.attributes.department.not_active')}'><i class='fa fa-minus-circle'></a></span>".html_safe
    end
  end
end
