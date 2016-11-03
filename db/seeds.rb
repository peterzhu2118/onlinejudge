# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# contest = Contest.create(title: 'Testing', begin_time: DateTime.civil_from_format(:local, 2016, 11, 1, 1, 1, 1), end_time: DateTime.civil_from_format(:local, 2016, 12, 1, 1, 1, 1))

problem = Problem.create(contest_id: 1, title: "Probs", problem: "This is first line.\nSecond line.\n\tTab", runtime: 3, memory: 128, input: "First\nSecond\nThird", output: "Numero 1\nNumero 2\ntree")
