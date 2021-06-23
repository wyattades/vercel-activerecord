# vercel ctiverecord

Proof of concept that you can run Rails ActiveRecord in serverless functions hosted by Vercel.

The main difficulty here was generating the required shared libraries for `postgresql` in an `amazonlinux` Docker container and packaging them with the build. I would like to have generated them in the Vercel build process, but I could not get the files to persist.
