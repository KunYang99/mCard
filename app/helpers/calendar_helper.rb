module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  class Calendar < Struct.new(:view, :date, :callback)
    HEADER = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "table table-bordered" do
        header + week_rows
      end
    end

    def header
      content_tag :tr, class: "greyheader" do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day), height: "80px", width: "12%"
    end

    def day_classes(day)
      classes = ''
      classes = "warning" if day == Date.today
      classes = "greycell" if day.month != date.month
      return classes
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end
