class HomePage < SitePrism::Page
  set_url '/'

  element :humidity_monitor_nav_link, 'a[href="/"]'
  element :environment_readings_table, 'table[data-testid="environmentReadingsTable"]'
  elements :environment_reading_row, 'tr[data-testid="environmentReadingRow"]'
end
