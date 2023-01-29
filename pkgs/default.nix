self: super: {
  #awsume = super.callPackage ./awsume {};
  #php82 = super.pkgs.callPackage ./php82 {};
  #opensearch = super.pkgs.callPackage ./opensearch {};
}
