defmodule Booklist.AdminTest do
  use Booklist.DataCase

  alias Booklist.Admin

  describe "genres" do
    alias Booklist.Admin.Genre

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Admin.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Admin.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Admin.create_genre(@valid_attrs)
      assert genre.name == "some name"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{} = genre} = Admin.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_genre(genre, @invalid_attrs)
      assert genre == Admin.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Admin.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Admin.change_genre(genre)
    end
  end

  describe "authors" do
    alias Booklist.Admin.Author

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name"}
    @invalid_attrs %{first_name: nil, last_name: nil, middle_name: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Admin.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Admin.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Admin.create_author(@valid_attrs)
      assert author.first_name == "some first_name"
      assert author.last_name == "some last_name"
      assert author.middle_name == "some middle_name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = Admin.update_author(author, @update_attrs)
      assert author.first_name == "some updated first_name"
      assert author.last_name == "some updated last_name"
      assert author.middle_name == "some updated middle_name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_author(author, @invalid_attrs)
      assert author == Admin.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Admin.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Admin.change_author(author)
    end
  end

  describe "books" do
    alias Booklist.Admin.Book

    @valid_attrs %{is_fiction: true, sort_title: "some sort_title", subtitle: "some subtitle", title: "some title"}
    @update_attrs %{is_fiction: false, sort_title: "some updated sort_title", subtitle: "some updated subtitle", title: "some updated title"}
    @invalid_attrs %{is_fiction: nil, sort_title: nil, subtitle: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Admin.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Admin.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = Admin.create_book(@valid_attrs)
      assert book.is_fiction == true
      assert book.sort_title == "some sort_title"
      assert book.subtitle == "some subtitle"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = Admin.update_book(book, @update_attrs)
      assert book.is_fiction == false
      assert book.sort_title == "some updated sort_title"
      assert book.subtitle == "some updated subtitle"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_book(book, @invalid_attrs)
      assert book == Admin.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Admin.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Admin.change_book(book)
    end
  end

  describe "libraries" do
    alias Booklist.Admin.Library

    @valid_attrs %{name: "some name", super_search_key: "some super_search_key", url: "some url"}
    @update_attrs %{name: "some updated name", super_search_key: "some updated super_search_key", url: "some updated url"}
    @invalid_attrs %{name: nil, super_search_key: nil, url: nil}

    def library_fixture(attrs \\ %{}) do
      {:ok, library} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_library()

      library
    end

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Admin.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Admin.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      assert {:ok, %Library{} = library} = Admin.create_library(@valid_attrs)
      assert library.name == "some name"
      assert library.super_search_key == "some super_search_key"
      assert library.url == "some url"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      assert {:ok, %Library{} = library} = Admin.update_library(library, @update_attrs)
      assert library.name == "some updated name"
      assert library.super_search_key == "some updated super_search_key"
      assert library.url == "some updated url"
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_library(library, @invalid_attrs)
      assert library == Admin.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = Admin.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = Admin.change_library(library)
    end
  end

  describe "loans" do
    alias Booklist.Admin.Loan

    @valid_attrs %{due_date: ~D[2010-04-17], item_count: 42}
    @update_attrs %{due_date: ~D[2011-05-18], item_count: 43}
    @invalid_attrs %{due_date: nil, item_count: nil}

    def loan_fixture(attrs \\ %{}) do
      {:ok, loan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_loan()

      loan
    end

    test "list_loans/0 returns all loans" do
      loan = loan_fixture()
      assert Admin.list_loans() == [loan]
    end

    test "get_loan!/1 returns the loan with given id" do
      loan = loan_fixture()
      assert Admin.get_loan!(loan.id) == loan
    end

    test "create_loan/1 with valid data creates a loan" do
      assert {:ok, %Loan{} = loan} = Admin.create_loan(@valid_attrs)
      assert loan.due_date == ~D[2010-04-17]
      assert loan.item_count == 42
    end

    test "create_loan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_loan(@invalid_attrs)
    end

    test "update_loan/2 with valid data updates the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{} = loan} = Admin.update_loan(loan, @update_attrs)
      assert loan.due_date == ~D[2011-05-18]
      assert loan.item_count == 43
    end

    test "update_loan/2 with invalid data returns error changeset" do
      loan = loan_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_loan(loan, @invalid_attrs)
      assert loan == Admin.get_loan!(loan.id)
    end

    test "delete_loan/1 deletes the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{}} = Admin.delete_loan(loan)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_loan!(loan.id) end
    end

    test "change_loan/1 returns a loan changeset" do
      loan = loan_fixture()
      assert %Ecto.Changeset{} = Admin.change_loan(loan)
    end
  end

  describe "locations" do
    alias Booklist.Admin.Location

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Admin.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Admin.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = Admin.create_location(@valid_attrs)
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, %Location{} = location} = Admin.update_location(location, @update_attrs)
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_location(location, @invalid_attrs)
      assert location == Admin.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Admin.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Admin.change_location(location)
    end
  end

  describe "book_locations" do
    alias Booklist.Admin.BookLocation

    @valid_attrs %{call_number: "some call_number"}
    @update_attrs %{call_number: "some updated call_number"}
    @invalid_attrs %{call_number: nil}

    def book_location_fixture(attrs \\ %{}) do
      {:ok, book_location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_book_location()

      book_location
    end

    test "list_book_locations/0 returns all book_locations" do
      book_location = book_location_fixture()
      assert Admin.list_book_locations() == [book_location]
    end

    test "get_book_location!/1 returns the book_location with given id" do
      book_location = book_location_fixture()
      assert Admin.get_book_location!(book_location.id) == book_location
    end

    test "create_book_location/1 with valid data creates a book_location" do
      assert {:ok, %BookLocation{} = book_location} = Admin.create_book_location(@valid_attrs)
      assert book_location.call_number == "some call_number"
    end

    test "create_book_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_book_location(@invalid_attrs)
    end

    test "update_book_location/2 with valid data updates the book_location" do
      book_location = book_location_fixture()
      assert {:ok, %BookLocation{} = book_location} = Admin.update_book_location(book_location, @update_attrs)
      assert book_location.call_number == "some updated call_number"
    end

    test "update_book_location/2 with invalid data returns error changeset" do
      book_location = book_location_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_book_location(book_location, @invalid_attrs)
      assert book_location == Admin.get_book_location!(book_location.id)
    end

    test "delete_book_location/1 deletes the book_location" do
      book_location = book_location_fixture()
      assert {:ok, %BookLocation{}} = Admin.delete_book_location(book_location)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_book_location!(book_location.id) end
    end

    test "change_book_location/1 returns a book_location changeset" do
      book_location = book_location_fixture()
      assert %Ecto.Changeset{} = Admin.change_book_location(book_location)
    end
  end

  describe "ratings" do
    alias Booklist.Admin.Rating

    @valid_attrs %{date_scored: ~D[2010-04-17], score: 42}
    @update_attrs %{date_scored: ~D[2011-05-18], score: 43}
    @invalid_attrs %{date_scored: nil, score: nil}

    def rating_fixture(attrs \\ %{}) do
      {:ok, rating} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_rating()

      rating
    end

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Admin.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Admin.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      assert {:ok, %Rating{} = rating} = Admin.create_rating(@valid_attrs)
      assert rating.date_scored == ~D[2010-04-17]
      assert rating.score == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{} = rating} = Admin.update_rating(rating, @update_attrs)
      assert rating.date_scored == ~D[2011-05-18]
      assert rating.score == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_rating(rating, @invalid_attrs)
      assert rating == Admin.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Admin.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Admin.change_rating(rating)
    end
  end
end
