module TeachersPet
  class Cli
    option :organization, required: true
    option :repository, required: true
    option :public, type: :boolean, default: false, desc: "Make the repositories public"

    students_option
    common_options

    desc 'delete_repos', "Removes an assignment repository for each student."
    def delete_repos
      TeachersPet::Actions::DeleteRepos.new(options).run
    end
  end
end
