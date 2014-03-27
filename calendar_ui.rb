require 'active_record'
require './lib/event'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  input=nil
  until input == 'x'
    puts "++++++++++++++++++++++++++++++++++++"
    puts "#  Welcome to the calendar app     #"
    puts "++++++++++++++++++++++++++++++++++++"
    puts "#  Enter 'c' to create an event    #"
    puts "===================================="
    puts "#  Enter 'l' to list your events   #"
    puts "===================================="
    puts "#  Enter 'e' to edit an event      #"
    puts "===================================="
    puts "#  Enter 'd' to delete an event    #"
    puts "===================================="
    puts "#  Enter 'g' to generic tasklist   #"
    puts "===================================="
    puts "#  Enter 'sd' to see task by day   #"
    puts "===================================="
    puts "#  Enter 'sm' to see task by month #"
    puts "===================================="
    puts "#  Enter 'x' to exit               #"
    puts "===================================="
    main_menu_choice = gets.chomp.downcase

    case main_menu_choice
    when 'c'
      create_event
    when 'l'
      list_events
    when 'e'
      edit_event
    when 'd'
      delete_event
    when 'g'
      generic_list
    when 'sd'
      see_by_day
    when 'sm'
      see_by_month
    when 'x'
      puts 'Exiting, Goodbye'
    else
      puts 'Not a valid option'
      main_menu
    end
  end
end

def see_by_day
 puts "Input the date you want to see the events for!"
 event_date = gets.chomp
 events = Event.where(:start => event_date)
 events.each_with_index do |event, i|
 puts "#{i}: #{event.description}"
  end
end

def see_by_month
  puts "Input the year and month (yyyy/mm) you want to see the events for"
  event_month = gets.chomp
  events = Event.where(start: ())
end

def generic_list
  events = Event.order(start: :desc)
  events.each_with_index do |event, i|
    if Time.now.to_s < event.end.to_s
  puts "#{i}: \n#{event.description}\n#{event.location}"
    end
  end
end

def create_event
  puts "What is the event name?"
  event_description = gets.chomp
  puts "What is #{event_description}'s location?"
  event_location = gets.chomp
  puts "What is #{event_description}'s start date? (yyyy-mm-dddd) format"
  event_start_date = gets.chomp
  puts "What is #{event_description}'s end date?"
  event_end_date = gets.chomp
  Event.create({:description => event_description, :location => event_location, :start => event_start_date, :end => event_end_date})
  puts "#{event_description} has been created."
end

def list_events

  events = Event.order(start: :desc)
  events.each_with_index do |event, i|
    if Time.now.to_s < event.end.to_s
  puts "#{i}: \n#{event.description}\n#{event.location} \nThis event starts on #{event.start}\nThis event ends on #{event.end}"
    end
  end
end

def edit_event
  events = Event.all
  events.each_with_index do |event, i|
    puts "#{i}: #{event.description}\n"
  end
  puts "Type the event that you want to edit?"
  to_edit = gets.chomp
  selected_event = Event.where(:description => to_edit)
  puts "What about #{selected_event.first.description} do you want to change? Type description, location, start date, or end date"
  part_to_edit = gets.chomp
  case part_to_edit
  when 'description'
    puts "What do you want to change your description to?"
    new_description = gets.chomp
    selected_event.first.update(:description => new_description)
  when 'location'
    puts "What do you want to change your location to?"
    new_location = gets.chomp
    selected_event.first.update(:location => new_location)
  when 'start date'
    puts "What do you want to change your start date to?"
    new_start = gets.chomp
    selected_event.first.update(:start => new_start)
  when 'end date'
    puts "What do you want to change your end date to?"
    new_end = gets.chomp
    selected_event.first.update(:end => new_end)
  else puts "That is not a valid option"
    edit_event
  end
end

def delete_event
  puts "Type the event that you want to delete"
  to_delete = gets.chomp
  selected_event = Event.find_by(:description => to_delete)
  selected_event.destroy
  puts "#{to_delete} has been removed!"
end

main_menu
