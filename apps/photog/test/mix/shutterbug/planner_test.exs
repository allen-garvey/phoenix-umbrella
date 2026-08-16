defmodule Photog.Shutterbug.PlannerTest do
  use PhotogWeb.DefaultCase

  alias Photog.Shutterbug.Planner

  test "get_image_master_action_for() without webp option" do
    assert Planner.get_image_master_action_for("test/hello.jpg", false) == :safe_copy
    assert Planner.get_image_master_action_for("test/hello.svg", false) == :safe_copy

    assert Planner.get_image_master_action_for("test/hello.png", false) ==
             :convert_to_webp_lossless

    assert Planner.get_image_master_action_for("test/hello.webp", false) == :safe_copy
    assert Planner.get_image_master_action_for("test/hello.heic", false) == :convert_to_webp_lossy
    assert Planner.get_image_master_action_for("test/hello.tiff", false) == :safe_copy
  end

  test "get_image_master_action_for() using webp option" do
    assert Planner.get_image_master_action_for("test/hello.jpg", true) == :convert_to_webp_lossy
    assert Planner.get_image_master_action_for("test/hello.svg", true) == :safe_copy

    assert Planner.get_image_master_action_for("test/hello.png", true) ==
             :convert_to_webp_lossless

    assert Planner.get_image_master_action_for("test/hello.webp", true) == :safe_copy
    assert Planner.get_image_master_action_for("test/hello.heic", true) == :convert_to_webp_lossy
    assert Planner.get_image_master_action_for("test/hello.tiff", true) == :convert_to_webp_lossy
  end

  test "make_plan_for_images() without webp option" do
    plans =
      [
        "something/image.jpg",
        "image.jpg",
        "test.webp",
        "/a/b/test.webp",
        "something.svg",
        "a/b/iphone.heic",
        "image.png"
      ]
      |> Planner.make_plan_for_images("masters/path", "thumbnails/path", false)

    # IO.inspect(plans)

    assert plans == [
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "something/image.jpg",
                 destination_path: "masters/path/4_image.jpg",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something/image.jpg",
                 destination_path: "thumbnails/path/thumb_4_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something/image.jpg",
                 destination_path: "thumbnails/path/thumb_mini_4_image.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "image.jpg",
                 destination_path: "masters/path/1_image.jpg",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.jpg",
                 destination_path: "thumbnails/path/thumb_1_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.jpg",
                 destination_path: "thumbnails/path/thumb_mini_1_image.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "test.webp",
                 destination_path: "masters/path/1_test.webp",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "test.webp",
                 destination_path: "thumbnails/path/thumb_1_test.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "test.webp",
                 destination_path: "thumbnails/path/thumb_mini_1_test.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "masters/path/2_test.webp",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "thumbnails/path/thumb_2_test.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "thumbnails/path/thumb_mini_2_test.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "something.svg",
                 destination_path: "masters/path/1_something.svg",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something.svg",
                 destination_path: "thumbnails/path/1_something.svg",
                 action: :safe_copy,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something.svg",
                 destination_path: "thumbnails/path/thumb_mini_1_something.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "masters/path/3_iphone.webp",
                 action: :convert_to_webp_lossy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "thumbnails/path/thumb_3_iphone.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "thumbnails/path/thumb_mini_3_iphone.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "image.png",
                 destination_path: "masters/path/1_image.webp",
                 action: :convert_to_webp_lossless
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.png",
                 destination_path: "thumbnails/path/thumb_1_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.png",
                 destination_path: "thumbnails/path/thumb_mini_1_image.webp",
                 action: :resize,
                 size: 300
               }
             }
           ]
  end

  test "make_plan_for_images() using webp option" do
    plans =
      [
        "something/image.jpg",
        "image.jpg",
        "test.webp",
        "/a/b/test.webp",
        "something.svg",
        "a/b/iphone.heic",
        "image.png"
      ]
      |> Planner.make_plan_for_images("masters/path", "thumbnails/path", true)

    # IO.inspect(plans)

    assert plans == [
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "something/image.jpg",
                 destination_path: "masters/path/4_image.webp",
                 action: :convert_to_webp_lossy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something/image.jpg",
                 destination_path: "thumbnails/path/thumb_4_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something/image.jpg",
                 destination_path: "thumbnails/path/thumb_mini_4_image.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "image.jpg",
                 destination_path: "masters/path/1_image.webp",
                 action: :convert_to_webp_lossy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.jpg",
                 destination_path: "thumbnails/path/thumb_1_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.jpg",
                 destination_path: "thumbnails/path/thumb_mini_1_image.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "test.webp",
                 destination_path: "masters/path/1_test.webp",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "test.webp",
                 destination_path: "thumbnails/path/thumb_1_test.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "test.webp",
                 destination_path: "thumbnails/path/thumb_mini_1_test.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "masters/path/2_test.webp",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "thumbnails/path/thumb_2_test.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "/a/b/test.webp",
                 destination_path: "thumbnails/path/thumb_mini_2_test.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "something.svg",
                 destination_path: "masters/path/1_something.svg",
                 action: :safe_copy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something.svg",
                 destination_path: "thumbnails/path/1_something.svg",
                 action: :safe_copy,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "something.svg",
                 destination_path: "thumbnails/path/thumb_mini_1_something.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "masters/path/3_iphone.webp",
                 action: :convert_to_webp_lossy
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "thumbnails/path/thumb_3_iphone.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "a/b/iphone.heic",
                 destination_path: "thumbnails/path/thumb_mini_3_iphone.webp",
                 action: :resize,
                 size: 300
               }
             },
             %Photog.Shutterbug.ImagePlan{
               master_plan: %Photog.Shutterbug.ImageMasterPlan{
                 source_path: "image.png",
                 destination_path: "masters/path/1_image.webp",
                 action: :convert_to_webp_lossless
               },
               thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.png",
                 destination_path: "thumbnails/path/thumb_1_image.webp",
                 action: :resize,
                 size: 768
               },
               mini_thumbnail_plan: %Photog.Shutterbug.ImageThumbnailPlan{
                 source_path: "image.png",
                 destination_path: "thumbnails/path/thumb_mini_1_image.webp",
                 action: :resize,
                 size: 300
               }
             }
           ]
  end

  test "evaluate_plans/1 with valid plans" do
    assert Planner.evaluate_plans([]) == :ok

    assert [
             "something/image.jpg",
             "image.jpg",
             "test.webp",
             "/a/b/test.webp",
             "something.svg",
             "a/b/iphone.heic",
             "image.png"
           ]
           |> Planner.make_plan_for_images("masters/path", "thumbnails/path", false)
           |> Planner.evaluate_plans() == :ok

    assert [
             "something/image.jpg",
             "image.jpg",
             "test.webp",
             "/a/b/test.webp",
             "something.svg",
             "a/b/iphone.heic",
             "image2.png"
           ]
           |> Planner.make_plan_for_images("masters/path", "thumbnails/path", true)
           |> Planner.evaluate_plans() == :ok
  end

  test "evaluate_plans/1 with invalid plans" do
    assert [
             "image.webp",
             "image.heic"
           ]
           |> Planner.make_plan_for_images("masters/path", "thumbnails/path", false)
           |> Planner.evaluate_plans() ==
             {:error, %{"masters/path/1_image.webp" => ["image.webp", "image.heic"]}}

    assert [
             "image.png",
             "image.webp"
           ]
           |> Planner.make_plan_for_images("masters/path", "thumbnails/path", false)
           |> Planner.evaluate_plans() ==
             {:error, %{"masters/path/1_image.webp" => ["image.png", "image.webp"]}}

    assert [
             "image.jpg",
             "image.png",
             "image.webp"
           ]
           |> Planner.make_plan_for_images("masters/path", "thumbnails/path", true)
           |> Planner.evaluate_plans() ==
             {:error, %{"masters/path/1_image.webp" => ["image.jpg", "image.png", "image.webp"]}}
  end

  test "format_evaluate_plans_error/1" do
    {:error, invalid_plans_map} =
      [
        "image.jpg",
        "something/another.jpg",
        "image.png",
        "image.webp",
        "something/another.png"
      ]
      |> Planner.make_plan_for_images("masters/path", "thumbnails/path", true)
      |> Planner.evaluate_plans()

    assert Planner.format_evaluate_plans_error(invalid_plans_map) ==
             "image.jpg, image.png, image.webp ==> masters/path/1_image.webp --- something/another.jpg, something/another.png ==> masters/path/2_another.webp"
  end
end
