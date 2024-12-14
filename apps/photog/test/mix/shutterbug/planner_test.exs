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
end
