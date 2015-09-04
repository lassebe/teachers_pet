module TeachersPet
  module Actions
    class DeleteRepos < Base
      def read_info
        @repository = self.options[:repository]
        @organization = self.options[:organization]
      end

      def load_files
        @students = self.read_students_file
      end

      def delete
        # delete a repo for each student
        self.init_client

        org_hash = self.client.organization(@organization)
        abort('Organization could not be found') if org_hash.nil?
        puts "Found organization at: #{org_hash[:login]}"

        # Load the teams - there should be one team per student.
        # Repositories are given permissions by teams
        org_teams = self.client.get_teams_by_name(@organization)
        # For each student - delete their repository
        # The repository name is teamName-repository
        puts "\nRemoving assignment repositories for students..."
        @students.keys.sort.each do |student|
          unless org_teams.key?(student)
            puts("  ** ERROR ** - no team for #{student}")
            next
          end
          repo_name = "#{student}-#{@repository}"

          if self.client.repository?(@organization, repo_name)
            puts " --> Removing '#{repo_name}'"
            self.client.delete_repository(@organization+'/'+repo_name)
            next
          else
            puts " --> Already deleted, skipping '#{repo_name}'"
          end
        end
      end

      def run
        self.read_info
        self.load_files
        self.delete
      end
    end
  end
end
