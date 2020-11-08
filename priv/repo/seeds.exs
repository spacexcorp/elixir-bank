# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElixirBank.Repo.insert!(%ElixirBank.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ElixirBank.Accounts.User
alias ElixirBank.Records.{Category, Record}
alias ElixirBank.Repo

collections_category = Repo.insert!(%Category{name: "Collections"})
fastest_category = Repo.insert!(%Category{name: "Fastest"})
highest_category = Repo.insert!(%Category{name: "Highest"})
largest_category = Repo.insert!(%Category{name: "Largest"})
longest_category = Repo.insert!(%Category{name: "Longest"})
marathon_category = Repo.insert!(%Category{name: "Marathon"})
most_category = Repo.insert!(%Category{name: "Most"})
other_category = Repo.insert!(%Category{name: "Other"})
smallest_category = Repo.insert!(%Category{name: "Smallest"})

Repo.insert!(%Record{
  category_id: most_category.id,
  title: "Most functional gadgets in a cosplay suit",
  description:
    "The most functional gadgets in a cosplay suit is 23, in a Batman suit created by Julian Checkley (UK), demonstrated in Galway, Ireland, on 1 November 2015.",
  image_url: "https://guinnessworldrecords.com/assets/1227600?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: fastest_category.id,
  title: "Fastest Any% completion of Monster Hunter: World",
  description:
    "The fastest Any% completion of Monster Hunter: World is 5 hr 18 min 28 sec, and was achieved by mosstkm (Japan) on 10 February 2019, as verified by speedrun.com.",
  image_url: "https://guinnessworldrecords.com/assets/2064235?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: largest_category.id,
  title: "Largest arcade machine",
  description:
    "The largest arcade machine is 4.41 m tall, 1.93 m wide and 1.06 metres deep, and was achieved by Jason Camberis (USA) as verified in Bensenville, Illinois, USA, on 23 March 2014.",
  image_url: "https://guinnessworldrecords.com/assets/2030296?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: highest_category.id,
  title: "Highest margin of victory against computer on 2014 FIFA World Cup Brazil",
  description:
    "The highest margin of victory against computer on 2014 FIFA World Cup Brazil is 321 goals, achieved by Patrick Hadler (Germany), in Rethem, Germany, on 28 May 2014.",
  image_url: "https://guinnessworldrecords.com/assets/890142?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: other_category.id,
  title: "First PlayStation 2 game to support online play",
  description:
    "The earliest Playstation 2 game to allow online play was Tony Hawk’s Pro Skater 3, published by Activision, released in 2001. Unlike later online titles this could be done without the need for an adaptor, by using a standard usB connector and a dial-up connection.",
  image_url: "https://guinnessworldrecords.com/assets/2064228?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: other_category.id,
  title: "First robot table tennis tutor",
  description:
    "In October 2015, Japan’s Omron Corporation introduced its robotic table tennis tutor. Sensors above the table tennis table monitor the position of the ball 80 times per second, enabling the robot to show via a projected image where it will return the ball off its bat and even where it will bounce to. The aim is to help teach the game to human players,with the robot's software capable of assessing all aspects of the ball's motion when bouncing off the table and through the air. Developing the control algorithm required for the robot to position the bat and return the ball took many hours of effort: with timing precision down to one thousandth of a second, the robot is programmed to make an effort to return the ball by extending its arm even in response to a badly played ball by its human pupil that would be impossible to play.",
  image_url: "https://guinnessworldrecords.com/assets/1327617?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: most_category.id,
  title: "Most robots dancing simultaneously",
  description:
    "The most robots dancing simultaneously is 1,372 and was achieved by TIM S.p.A. (Italy) in Rome, Italy, on 1 February 2018.",
  image_url: "https://guinnessworldrecords.com/assets/1677903?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: other_category.id,
  title: "First hypertext browser",
  description:
    "In October 1990 Tim Berners-Lee (UK) started work on a global hypertext browser and WorldWideWeb — was made available on the Internet in the summer of 1991. Berners-Lee had originally proposed a global hypertext project to allow people to combine their knowledge in a web of hypertext documents in 1989.",
  image_url: "https://guinnessworldrecords.com/assets/1433696?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: fastest_category.id,
  title: "Fastest robot to solve a Rubik's Cube",
  description:
    "The fastest robot to solve a Rubik's Cube is “Sub1 Reloaded” with a time of 0.637 seconds, built by Albert Beer (Germany), and demonstrated at the Infineon booth at the electronica trade fair in Munich, Germany, 09 November 2016.",
  image_url: "https://guinnessworldrecords.com/assets/1433717?width=780&height=497"
})

Repo.insert!(%Record{
  category_id: other_category.id,
  title: "First bionic arm fitted on an individual (male)",
  description:
    "Since 1993, Scottish hotel owner Campbell Aird, who had his right arm amputated in 1982 after doctors diagnosed muscular cancer, has been trying out a new  bionic arm created by a team of five bio-engineers at the Margaret Rose Hospital, Edinburgh, UK.   Two other motorised artificial arms have been developed in America, but these were essentially only powered elbows.",
  image_url: "https://guinnessworldrecords.com/assets/1433700?width=780&height=497"
})

Repo.insert!(%User{
  date_of_birth: ~D[2000-01-01],
  email: "jane.doe@email.com",
  name: "Jane Doe",
  pin: "0000",
  system: true
})
