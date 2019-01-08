context("versionNumber Bumping")

test_that(desc="Confirming versionNumberFromXYZ() work correctly", code={

  full <- c(x = 6, y = 5, z = 14)
  expect_equal(versionNumberFromXYZ(full=full), "6.05.014")
  expect_equal(versionNumberFromXYZ(full=full, digs_x=1, digs_y=1, digs_z=1), "6.5.14")
  expect_equal(versionNumberFromXYZ(full=full, digs_x=5, digs_y=1, digs_z=1), "00006.5.14")

  expect_equal(versionNumberFromXYZ(full=full, zeros_to_pad_at_end=18), "6.05.014000000000000000000")
})
