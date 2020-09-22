class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stud = self.new
    stud.id = row[0]
    stud.name = row[1]
    stud.grade = row[2]
    stud
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql =  <<-SQL
      SELECT * from students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql =  <<-SQL
      SELECT * from students
      WHERE students.name == name
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    self.all.select { |stud| stud.grade == '9' }
  end

  def self.students_below_12th_grade
    self.all.select { |stud| ('0'...'12').include?(stud.grade) }
  end

  def self.first_X_students_in_grade_10(x)
    self.all.select { |stud| stud.grade == '10' }.first(x)
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    self.all.select { |stud| stud.grade == x.to_s }
  end
end
