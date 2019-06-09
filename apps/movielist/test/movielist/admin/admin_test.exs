defmodule Movielist.AdminTest do
  use Movielist.DataCase

  alias Movielist.Admin

  describe "genres" do
    alias Movielist.Admin.Genre

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

  describe "movies" do
    alias Movielist.Admin.Movie

    @valid_attrs %{home_release_date: ~D[2010-04-17], is_active: true, pre_rating: 42, theater_release_date: ~D[2010-04-17], title: "some title"}
    @update_attrs %{home_release_date: ~D[2011-05-18], is_active: false, pre_rating: 43, theater_release_date: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{home_release_date: nil, is_active: nil, pre_rating: nil, theater_release_date: nil, title: nil}

    def movie_fixture(attrs \\ %{}) do
      {:ok, movie} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_movie()

      movie
    end

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Admin.list_movies() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Admin.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      assert {:ok, %Movie{} = movie} = Admin.create_movie(@valid_attrs)
      assert movie.home_release_date == ~D[2010-04-17]
      assert movie.is_active == true
      assert movie.pre_rating == 42
      assert movie.theater_release_date == ~D[2010-04-17]
      assert movie.title == "some title"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{} = movie} = Admin.update_movie(movie, @update_attrs)
      assert movie.home_release_date == ~D[2011-05-18]
      assert movie.is_active == false
      assert movie.pre_rating == 43
      assert movie.theater_release_date == ~D[2011-05-18]
      assert movie.title == "some updated title"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_movie(movie, @invalid_attrs)
      assert movie == Admin.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Admin.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Admin.change_movie(movie)
    end
  end

  describe "ratings" do
    alias Movielist.Admin.Rating

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
