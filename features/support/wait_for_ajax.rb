module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
    sleep 0.5
  end

  private
  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

World(WaitForAjax)
