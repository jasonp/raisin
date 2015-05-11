module AccountsHelper

  def create_sample_todo_list_on_permanent_project(project)
    list = List.new(
                    title: "You can make to-do lists on family members",
                    status: "active",
                    project_id: project.id
                    )
    list.save!
    
    # now let's add some to-do items
    
    Item.create(
              title: "Usually these are things ABOUT the family member",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              status: "active"
              )
              
           
           
    Item.create(
              title: "But aren't a project in themselves",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              status: "active"
              )           

    Item.create(
              title: "Like scheduling a hair cut",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              status: "active"
              )

  end
  
  def create_sample_project_for_new_account(account)
    
    # First a new project
    
    project = Project.new(
                          title: "Sample Project: Vacation to Hawaii",
                          description: "A project just to get you started",
                          status: "active",
                          account_id: account.id
    )   
    project.save!
    
    # and add the user
    project.members.create(user_id: current_user.id)
   
    # now a list
    
    list = List.new(
                    title: "Booking Travel",
                    status: "active",
                    project_id: project.id
                    )
    list.save!
    
    # now let's add some to-do items
    
    Item.create(
              title: "Research flight options",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              due: Time.now.utc + 1.week,
              status: "active"
              )
           
           
    Item.create(
              title: "Book flights",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              due: Time.now.utc + 15.days,
              status: "active"
              )           

    Item.create(
              title: "Reserve a rental car or a shuttle to the hotel",
              list_id: list.id,
              user_id: current_user.id,
              created_by: current_user.id,
              due: Time.now.utc + 15.days,
              status: "active"
              )

  end  

end
