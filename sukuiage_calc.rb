# 某社勤務時間から某社作業時間割り出し計算機
#
# 両社間で休憩時間が一致せず計算が面倒なため作成。
# 勤務開始時間と終了時間を入力すると開発作業時間が算出されます。
# 
# 27/06/2018
# Masato Miyano

class SukuiageCalc
  require 'active_support'
	require 'active_support/core_ext'

	LUNCH_BREAK = {
		start_time: "12:00",
		end_time: "13:00"
	}

	FIRST_BREAK = {
		start_time: "18:00",
		end_time: "18:30"
	}

	SECOND_BREAK = {
    start_time: "21:30",
		end_time: "22:00"
	}

	def initialize
	end	

	def calc(start_time, end_time)
		work_time = ("#{Date.today} #{end_time}".to_time - "#{Date.today} #{start_time}".to_time) / 3600
		lunch_break_time = ("#{Date.today} #{LUNCH_BREAK[:end_time]}".to_time - "#{Date.today} #{LUNCH_BREAK[:start_time]}".to_time) / 3600
		first_break_time = ("#{Date.today} #{FIRST_BREAK[:end_time]}".to_time - "#{Date.today} #{FIRST_BREAK[:start_time]}".to_time) / 3600
		second_break_timek = ("#{Date.today} #{SECOND_BREAK[:end_time]}".to_time - "#{Date.today} #{SECOND_BREAK[:start_time]}".to_time) / 3600

		total_work_time = work_time

		unless started_work_from_after_lunch_time?(start_time)
			total_work_time -= lunch_break_time
		end

		deduction_time = [SECOND_BREAK, FIRST_BREAK].inject(0) do |z,br|
			if finished_work_after_break?(br, end_time)
				puts 'yes'
				z += (("#{Date.today} #{br[:end_time]}".to_time - "#{Date.today} #{br[:start_time]}".to_time) / 3600)
      end
			z
		end

		total_work_time -= deduction_time


    [SECOND_BREAK, FIRST_BREAK].each do |br|
    	if finished_work_during_break?(br,end_time)
				total_work_time -= (("#{Date.today} #{end_time}".to_time - "#{Date.today} #{br[:start_time]}".to_time) / 3600)
				return total_work_time
			end
		end

		total_work_time
	end	

	def started_work_from_after_lunch_time?(start_time)
		"#{Date.today} #{start_time}".to_time >= "#{Date.today} #{LUNCH_BREAK[:end_time]}".to_time
	end	

	def finished_work_during_break?(br, end_time)
		"#{Date.today} #{br[:end_time]}".to_time > "#{Date.today} #{end_time}".to_time && "#{Date.today} #{br[:start_time]}".to_time < "#{Date.today} #{end_time}".to_time
	end
	
	def finished_work_after_break?(br, end_time)
		"#{Date.today} #{br[:end_time]}".to_time <= "#{Date.today} #{end_time}".to_time 
	end
end	

class Main
	def initialize
	end	

	def self.navigate

		sukuiage = SukuiageCalc.new

		while true do
			print "業務開始時間: "
			start_time = gets
			print "業務終了時間: "
			end_time = gets
			puts "---------------------"
			print "勤務時間: "
			puts sukuiage.calc(start_time,end_time)
			puts "---------------------"
			puts ""
		end	
	end	
end

Main.navigate
