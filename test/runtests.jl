module TestTidierStrings

using TidierStrings
using Test
using Documenter

DocMeta.setdocmeta!(TidierStrings, :DocTestSetup, :(using TidierStrings); recursive=true)

doctest(TidierStrings)

end
