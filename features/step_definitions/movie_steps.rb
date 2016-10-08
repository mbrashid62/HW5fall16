# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
end

 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on 'Edit'
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|

  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|

  ratings = 'G PG PG-13 NC-17 R'.split(' ')

  ratings.each do |rating|
    uncheck "ratings_#{rating}"
  end

  arg1.split(', ').each do |rating|
    check "ratings_#{rating}"
  end

  click_button 'ratings_submit'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|

  ratings_selected = arg1.split(', ')
  does_contain_filtered_movie = true

  all('tr').each do |tr|
    ratings_selected.each do |selected_rating|
      if tr.has_content?(selected_rating) == true
        does_contain_filtered_movie = true
        break
      else
        does_contain_filtered_movie = false
      end
    end
  end
  expect(does_contain_filtered_movie).to be_truthy
end

Then /^I should see all of the movies$/ do
  rows = Movie.all
  rows.length.should == page.all('table#movies tr').count - 1
end



