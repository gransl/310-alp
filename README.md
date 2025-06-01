<img src="img/ruby.png" alt="Ruby Icon" style="float: right; width: 24px;" />

# Alternate Language Project - CSB 310
#### Author: Sandra Gran

## 🤔 Which programming language and version did you pick?
Ruby 3.4.4

## 💡 Why Ruby?
Team Magma wrote their wikis on Ruby, and it sparked an interest in the
language. I was curious about its "There's more than one way to do it" (TMTOWTDI) and "Everything is an object" philosophies. I also don't have alot of experience with scripting language in general, so I wanted to try one. 

## 🧬  How does Ruby handle...

Because a core Ruby philosophy is TMTOWDI, there are many routes to handling
things in Ruby. If you browse my code, you'll see I did not adapt one specific
style, but rather tried differnt things in different circumstances. I also
experimented with my IDEs suggestions for making code more compact, which taught
me new operators and formats that I hadn't seen before!

### Object-Oriented Programming
Everything is an Object, there

### File Ingestion

### Conditional Statements

### Assignment Statements

### Loops

### Subprograms

### Unit Testing

### Exception Handling

## 📚 Libraries Used

I did not venture outside of Ruby's core and standard libraries. 

Core: Built into Ruby, no need to import using `require`. (Math)
<br>Standard: Comes with Ruby, but must `require` library to use. (CSV)

### CSV

The CSV library contains methods to read and write from CSVs. It also contains
methods to parse strings into CSVs. The `ingestor` class used this library to
read `cells.csv` then write to a new csv the cleansed data. 

### Math

The Math library is a core library that comes installed with Ruby. I used this
to calculate a square root for my sample standard deviation in my own utility library.

### Util (I wrote my own!)

To experiment with the module object, I wrote my own utility class that
performed some needed calculations:
- `float?`
    - To determine if an object was a float. This was handy for cleaning
      `features_sensors` and `platform_os` data, as these categories were to
      reject data that was only a number. 
- `mean`
    - To calculate the the (arithmetic) mean of an array of numbers. Useful for
      creating aggregate data for `body_size` and `display_size` data.
- `standard_deviation`
    - To calculate the standard deviation of an array of numbers. Useful for the
      same reasons as mean. 

## Answer the following questions (and provide a corresponding screen showing output answering them):
    - What company (oem) has the highest average weight of the phone body?
    - Was there any phones that were announced in one year and released in another? What are they? Give me the oem and models.
    - How many phones have only one feature sensor?
    - What year had the most phones launched in any year later than 1999? 
