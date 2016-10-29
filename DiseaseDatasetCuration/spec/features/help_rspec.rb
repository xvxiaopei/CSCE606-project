require 'rails_helper'


describe "To get help on answering the problems, user" do
    
    it 'can click the button (Help)' do
        visit '/'
        expect(page).to have_link('Help')
        click_link('Help')
        
        #response_headers["Content-Type"].should == "application/pdf"
        #response_headers["Content-Disposition"].should == "attachment; filename=\"Manual_on_Selection.pdf\""
        expect(response_headers["Content-Type"]).to eq("application/pdf")
        expect(response_headers["Content-Disposition"]).to eq("attachment; filename=\"Manual_on_Selection.pdf\"")
    end
end
