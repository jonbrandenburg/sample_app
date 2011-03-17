class User
	attr_accessor :name, :email

	def initialize(attributes = {})
		@name = attributes[:name]
		@email = attributes[:email]
	end

	def formatted_email
		"#{@name} <#{@email}>"
	end
end


# problem 4.1
def string_shuffle(s)
	s.split('').shuffle.join
end

# problem 4.2
class String
	def shuffle
		self.split('').shuffle.join
	end
end


# problem 4.3
def hashes
	person1 = { :first => "James", :last => "Potter" }
	person2 = { :first => "Lily", :last => "Evans" }
	person3 = { :first => "Harry", :last => "Potter" }
	params = {}
	params[:father] = person1
	params[:mother] = person2
	params[:child] = person3

	puts "#{params[:father][:first]} #{params[:father][:last]}"
	puts "#{params[:mother][:first]} #{params[:mother][:last]}"
	puts "#{params[:child][:first]} #{params[:child][:last]}"
end


if __FILE__ == $0
	puts "Problem 4.1"
	puts string_shuffle("Harry Potter")

	puts "Problem 4.2"
	puts "Harry Potter".shuffle

	puts "Problem 4.3"
	hashes

	puts "Problem 4.4"
	puts 'Merge combines two different hash objects together'
	puts '{ :a => "abc" }.merge({ :b => "xyz"}'
end

