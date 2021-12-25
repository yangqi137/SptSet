SetPackageInfo( rec(
  PackageName := "SptSet",
  Subtitle := "Example/Template of a GAP Package",
  Version := "0.1.3",
  Date := "09/07/2020",
  ##  Optional: if the package manual uses GAPDoc, you may duplicate the
  ##  version and the release date as shown below to read them while building
  ##  the manual using GAPDoc facilities to distibute documents across files.
  ##  <#GAPDoc Label="PKGVERSIONDATA">
  ##  <!ENTITY VERSION "4.1.1">
  ##  <!ENTITY RELEASEDATE "18 July 2018">
  ##  <#/GAPDoc>
  PackageDoc := rec(
      BookName  := "SptSet",
      SixFile   := "doc/manual.six",
      Autoload  := true ),
  Dependencies := rec(
      GAP       := "4.10",
      NeededOtherPackages := [ ["GAPDoc", "1.6"], ["HAP", "1.15"] ],
      SuggestedOtherPackages := [ ] ),
  AvailabilityTest := ReturnTrue ) );
