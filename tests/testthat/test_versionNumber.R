context("versionNumber Bumping")

test_that(desc = "Confirming versionNumberFromXYZ() works correctly", code = {

  full <- c(x = 6, y = 5, z = 14)
  expect_equal(
      object = versionNumberFromXYZ(full = full)
    , expected = "6.05.014"
  )

  expect_equal(
      object = versionNumberFromXYZ(full = full, digs_x = 1, digs_y = 1, digs_z = 1)
    , expected = "6.5.14"
  )

  expect_equal(
      object = versionNumberFromXYZ(full = full, digs_x = 5, digs_y = 1, digs_z = 1)
    , expected = "00006.5.14"
  )

  expect_equal(
      object = versionNumberFromXYZ(full = full, zeros_to_pad_at_end = 18)
    , expected = "6.05.014000000000000000000"
  )

})


test_that(desc = "Confirming increment_version() works correctly", code = {
  current_version <- "1.2.3"

  expect_equal(
      object = increment_version(current_version),                 
      expected = "2.00.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "x"),     
      expected = "2.00.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "y"),     
      expected = "1.03.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "z"),     
      expected = "1.02.004"
  )


  expect_equal(
      object = increment_version(current_version,           by = 2), 
      expected = "3.00.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "x", by = 2), 
      expected = "3.00.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "y", by = 2), 
      expected = "1.04.000"
  )

  expect_equal(
      object = increment_version(current_version, what = "z", by = 2), 
      expected = "1.02.005"
  )
})
