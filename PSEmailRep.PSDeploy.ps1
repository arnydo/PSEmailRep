Deploy Module {
    By PSGalleryModule {
        FromSource "PSEmailRep\"
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
