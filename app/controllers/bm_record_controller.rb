class BMRecordController < ApplicationController

  def index
    # list the available versions, accept in check box which to compare
    @versions = BMRubyVersion.all

    if params[:ruby_version].present?
      @result_table = BMRecord.new.compare(params[:ruby_version][:versions])
    end

    _simple_response @versions
  end

  def _simple_response r_obj
    respond_to do |format|
      format.html
      format.json { render json: r_obj }
    end
  end
end

class ResultTablePresenter
  def initialize result_table
    @rt = result_table
  end

  def open_table
    "<table class=\"table table-bordered table-striped\">"
  end

  def headers(versions)
    "".tap do | tmp |
      tmp << "<tr><th>test name</th>"
      versions.each do | version | 
        tmp << "<th>#{version}</th>"
      end
      tmp << "</tr>"
    end
  end

  def results(versions, test_name, row)
    "".tap do | tmp |
      tmp << "<tr><td>#{test_name}</td>"
      versions.each do | version | 
        tmp << "<td>#{'%.5f' % row.results[version]}</td>"
      end
      tmp << "</tr>"
    end
  end

  def present
    @tb = ""
    @tb << open_table
    @tb << headers(@rt.versions)
    @rt.results.each do | test_name, row |
      @tb << results(@rt.versions, test_name, row)
    end

    @tb << "</table>"
    @tb.html_safe
  end
end

