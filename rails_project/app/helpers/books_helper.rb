module BooksHelper
  def book_a_la_une(title,text,author)

    raw "<div class ='img-une'>
         <h3> #{title} </h3>
         <p> #{author} </p>
         <p> #{text} </p>
         </div>"
  end
end
